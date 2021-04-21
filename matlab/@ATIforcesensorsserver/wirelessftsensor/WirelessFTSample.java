/*
 * Copyright 2013
 * ATI Industrial Automation
 */
package wirelessftsensor;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import wirelessftjavademo.WirelessFTDemoModel;

/**
 * A sample received from the Wireless F/T Sensor.
 * @author Sam Skuce
 */
public class WirelessFTSample 
{
    /**
     * The overhead in a 32-bit sample packet.
     */
    private static final int PACKET_OVERHEAD = 4 + 4 + 4 + 4 + 1 + 1;
    // 4+4+4+4+1+1 = Timestamp, sequence, status code 1, status code 2, battery level, and mask.
    
    /**
     * The size of a 32-bit sensor record within a packet.
     */
    private static final int SENSOR_RECORD_SIZE = WirelessFTDemoModel.NUM_AXES * 4;
    
    private final int  m_timeStamp;    // The time stamp.
    private final long m_sequence;     // The sequence number.
    private final int  m_statusCode1;  // The status code (transducers 1-3).
    private final int  m_statusCode2;  // The status code (transducers 4-6).
    private final byte m_batteryLevel; // The battery level.  
    private final byte m_sensorMask;   // The mask corresponding to the currently active sensors. 
    
    private       int  m_latency;

    private int m_numSensors; // The total number of sensors active.
    /**
     * Keeps track of which sensors are active.
     */
    private boolean[] m_sensorActive = {false, false, false, false, false, false};

    /**
     * The F/T or gage data from the sample.
     */
    private final int[][] m_ftOrGageData = new int[WirelessFTDemoModel.MAX_SENSORS][WirelessFTDemoModel.NUM_AXES];
    
    /**
     * 
     * @return The string representation of this sample.
     */
    @Override
    public String toString()
    {
        return String.format(  "Timestamp: "         + this.m_timeStamp   
                             + "\nSequence number: " + this.m_sequence    
                             + "\nStatus Code 1: "   + this.m_statusCode1 
                             + "\nStatus Code 2: "   + this.m_statusCode2 
                             + "\nBattery Level: "   + this.m_batteryLevel
                             + "\nSensor Mask: "     + this.m_sensorMask);
    }
    
    public static ArrayList<WirelessFTSample> listOfSamplesFromPacket(byte[] udpPacketData, int udpPacketLength)
    {
        ArrayList<WirelessFTSample> samples = new ArrayList<>();
        byte[] singleRecord;
        int    sampleLength;
        int    i;
        
        for (i = 0; i < udpPacketLength; i += sampleLength) // For each sample block in a UDP packet
        {
            WirelessFTSample sample;
            
            singleRecord = Arrays.copyOfRange  (udpPacketData, i, udpPacketLength); // Pick out next sample block
            sample       = new WirelessFTSample(singleRecord,     udpPacketLength); // Decode the sample block
            sampleLength = sample.getNumSensors() * SENSOR_RECORD_SIZE + PACKET_OVERHEAD; // Get length of the sample block
            samples.add(sample);                                                    // Add sample block data to ArrayList
        }
        
        return samples;
    }
    
    /**
     * Constructs new Wireless F/T sample from received network data.
     * @param packetData The data received from the network.
     * @param length     The length of data in packetData.
     * @throws IllegalArgumentException If length is incorrect or data is invalid.
     * Samples come in at the packet RATE.
     */
    public WirelessFTSample(byte[] packetData, int length)
    {
        ByteBuffer bb = ByteBuffer.wrap(packetData); // Reads fields from data.
        
        m_timeStamp    = bb.getInt(); // Get the packet header information
        m_sequence     = bb.getInt();
        m_statusCode1  = bb.getInt();
        m_statusCode2  = bb.getInt();
        m_batteryLevel = bb.get();
        m_sensorMask   = bb.get();
        
        if (m_sensorMask != 0x00) // If a Transducer mask is given in the packet,
        {
            for (int transducer = 0; transducer < WirelessFTDemoModel.MAX_SENSORS; transducer++) // for each Transducer,
            {
                if ((m_sensorMask & (1 << transducer)) != 0)            // that is active,
                {
                     m_sensorActive[transducer] = true;                 // save an active flag.
                }
            }
        } 
        else // If a sensor mask is NOT given in the data (due to very old Wnet firmware)
        {    // use packet length to determine active transducers.
            if      (length % (0 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {false, false, false, false, false, false}; } 
            else if (length % (1 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  false, false, false, false, false}; } 
            else if (length % (2 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  true,  false, false, false, false}; } 
            else if (length % (3 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  true,  true,  false, false, false}; }
            else if (length % (4 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  true,  true,  true,  false, false}; } 
            else if (length % (5 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  true,  true,  true,  true,  false}; } 
            else if (length % (6 * SENSOR_RECORD_SIZE + PACKET_OVERHEAD) == 0) {m_sensorActive = new boolean[] {true,  true,  true,  true,  true,  true }; }
            else
            {   // This can and does happen when UDP packets contain multiple data packets AND you turn transducers on and off.
                m_sensorActive = new boolean[] {false, false, false, false, false, false};
                //throw new IllegalArgumentException("Invalid packet length.");
            }
        }
           
        m_numSensors = 0;                                                // Count the active transducers.
            
        for (int transducer = 0; transducer < WirelessFTDemoModel.MAX_SENSORS; transducer++) // For each Transducer,
        {
            if (m_sensorActive[transducer])                              // that is active,
            {
                m_numSensors++;                                          // count the active Transducer.
            
                for (int channel = 0; channel < WirelessFTDemoModel.NUM_AXES; channel++)     // For each channel,
                {
                    m_ftOrGageData[transducer][channel] = bb.getInt();   // get the data.
                }
            }
        }
        
        long wnetTime;
        long sysTime;
        long years70 = (70 * 365 + 17) * 24 * 60 * 60;       // 70 years (in seconds)

        wnetTime  = m_timeStamp;                             // Wnet's     number of      seconds since 1/1/1900 00:00 NTP (format 20.12)
        
        sysTime   = System.currentTimeMillis();              // System's   number of milliseconds since 1/1/1970 00:00 UTC (format 64.0)
        sysTime   = sysTime + years70 * 1000;                // Convert to number of milliseconds since 1/1/1900 00:00 (add 70 years)
        sysTime   = (sysTime << 12)   / 1000;                // Convert to number of      seconds since 1/1/1900 00:00 NTP (format 20.12)

        m_latency = (int) (sysTime - wnetTime) & 0xffffffff; // Calculate modulo 32-bits latency (20.12)
        m_latency = m_latency * 1000 >> 12;                  // Convert to mS (32.0)
    }

    /**
     * The time stamp.
     * @return the time stamp
     */
    public int getTimeStamp() {
        return m_timeStamp;
    }

    /**
     * The latency value in mS.
     * @return latency value in mS
     */
    public int getLatency() {
        return m_latency;
    }

    /**
     * The sequence number.
     * @return the sequence
     */
    public long getSequence() {
        return m_sequence;
    }

    /**
     * The status code (transducers 1-3).
     * @return the status code
     */
    public int getStatusCode1() {
        return m_statusCode1;
    }
    
    /**
     * The status code (transducers 4-6).
     * @return the status code
     */
    public int getStatusCode2() {
        return m_statusCode2;
    }

    /**
     * The battery level.
     * @return the battery level
     */
    public byte getBatteryLevel() {
        return m_batteryLevel;
    }
    
    /**
     * The mask corresponding to the currently active sensors. 
     * @return the sensor mask
     */
    public byte getSensorMask() {
        return m_sensorMask;
    }

    /**
     * The F/T or gage data from the sample.
     * @return the F/T or gage data
     */
    public int[][] getFtOrGageData() {
        return m_ftOrGageData;
    }
    
    /**
     * Tells how many sensors are active
     * for the entire WFT.
     * @return 
     */
    public int getNumSensors() {
        return m_numSensors;
    }
    
    /**
     * Tells which sensors are currently in-use.
     * @return 
     */
    public boolean[] getActiveSensors() {
        return m_sensorActive;
    }
}