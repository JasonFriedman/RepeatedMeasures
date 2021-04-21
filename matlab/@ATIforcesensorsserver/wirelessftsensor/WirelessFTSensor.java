/*
 * Copyright 2013
 * ATI Industrial Automation
 */
package wirelessftsensor;

import java.io.IOException;
import java.io.InputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Communicates with the WNET over Telnet.
 *
 * @author Sam Skuce, Chris Collins
 */
public class WirelessFTSensor 
{
    /**
     * Telnet timeout is fairly short. If the user
     * can't send commands pretty much instantly,
     * there's probably a network problem.
     */
    private final int TCP_TIMEOUT = 5000;

    private final int TELNET_PORT = 23; // Reserved port number for TCP connection via Telnet.
    
    /**
     * Default timeout allows up to 5 seconds between
     * each record read.
     */
    private final int UDP_TIMEOUT = 5000;
    
    /**
     * ASCII characters are always used for WNet commands.
     */
    private final String ASCII_CHARSET = "US-ASCII";
    
    /**
     * Default size of network buffers.
     */
    private final int DEFAULT_BUFFER_SIZE = 1024;
    
    /**
     * The socket that sends and receives each data sample.
     */
    private DatagramSocket m_udpSocket = null;
    
    /**
     * The Telnet socket that sends and receives firmware commands.
     */
    private Socket m_telnetSocket = null;
    
    /**
     * Logs handled exceptions and (optionally) reports them to the UI.
     */
    private static final Logger m_logger = Logger.getLogger("wirelessft");
    
    /**
     * The host name or IP address of the WNet.
     */
    private String m_sensorAddress = "";

    /**
     * Null constructor.
     */
    public WirelessFTSensor() 
    {
    }
    
    /**
     * Stops using the TCP and UDP sockets. TCP sockets are
     * set back to 0.0.0.0 addresses when this happens, but
     * the WNet will keep the last-used UDP destination
     * to which records were sent.
     */
    public void endCommunication()
    {
        if (m_udpSocket != null) 
        {
            m_udpSocket.close();
        }
        
        try 
        {
            Thread.sleep(250);
        } 
        catch (InterruptedException ie) 
        {
            // Do nothing.
        }
        
        if (m_telnetSocket != null) 
        {
            try 
            {
                m_telnetSocket.close();
            } 
            catch (IOException e) 
            {
                /* Log the error and move on, since we don't care about this socket anymore anyway. */
                m_logger.log(Level.INFO, "Exception closing Wireless F/T Telnet socket: {0}", e.getMessage());
            }
        }
    }

    /**
     * Constructor that initializes WNet address and network connections.
     *
     * @param hostNameOrIPAddress The host name or IP address of the WNet.
     * @throws IOException If an I/O error occurs creating ports.
     * @throws SecurityException If a security manager exists and its
     * checkConnect method doesn't allow a port operation.
     * @throws UnknownHostException If the host name or IP address is unresolvable.
     */
    public WirelessFTSensor(String hostNameOrIPAddress) throws UnknownHostException, SecurityException, IOException 
    {
        setSensorAddress(hostNameOrIPAddress);
    }

    /**
     * Closes existing sockets and opens new ones to connect to the specified
     * Wireless F/T sensor.
     *
     * @param hostNameOrIPAddress The host name or IP address of the sensor.
     * @throws IOException If an I/O error occurs creating ports.
     * @throws SecurityException If a security manager exists and its
     * checkConnect method doesn't allow a port operation.
     * @throws UnknownHostException If the host name or IP address is
     * unresolvable.
     */
    private void initSockets(String hostNameOrIPAddress) throws UnknownHostException, SecurityException, IOException 
    {
        endCommunication(); // Close existing sockets.
        
        // Set the WNet's address.
        InetAddress sensorAddress = InetAddress.getByName(hostNameOrIPAddress);
        
        /* The telnet socket should automatically bind to the correct local 
         * address, even if we have more than NIC installed locally.  Use this 
         * same local address to bind the UDP socket.
         */
        m_udpSocket = new DatagramSocket(0, InetAddress.getByName("0.0.0.0"));
        m_udpSocket.setSoTimeout(UDP_TIMEOUT);
        
        resetTelnetSocket(); // Make very sure that the telnet socket is available for use.
        
        // Open new ports to this address.
        m_telnetSocket = new Socket(sensorAddress, TELNET_PORT);
        m_telnetSocket.setSoTimeout(TCP_TIMEOUT);
        
        try 
        {
            Thread.sleep(100);
        } 
        catch(InterruptedException ie) 
        {
            // Do nothing.
        }
    }

    /**
     * Gets the IP address or hostname of the
     * currently-connected WNet.
     * 
     * @return the address.
     */
    public String getSensorAddress() 
    {
        return m_sensorAddress;
    }

    /**
     * Attempts to connect to a given IP address or hostname and
     * sets the current address to it if it was successful.
     * 
     * @param val The IP Address to which sockets will be opened.
     * @throws IOException If an I/O error occurs creating ports.
     * @throws SecurityException If a security manager exists and its
     * checkConnect method doesn't allow a port operation.
     * @throws UnknownHostException If the host name or IP address is
     * unresolvable.
     */
    public final void setSensorAddress(String val) throws IOException, SecurityException, UnknownHostException {
        m_sensorAddress = val;
        initSockets(m_sensorAddress);
    }

    /**
     * Sends the command to start streaming UDP samples.
     *
     * @throws IOException If there is an error sending a request.
     */
    public void startStreamingData() throws IOException 
    {
        WirelessFTSensorSampleCommand.sendStartStreamingCommand(m_udpSocket, m_sensorAddress, 0);
    }

    /**
     * Sends the command to stop streaming UDP samples.
     *
     * @throws IOException If there is an error sending a request.
     */
    public void stopStreamingData() throws IOException 
    {
        WirelessFTSensorSampleCommand.sendStopStreamingCommand(m_udpSocket, m_sensorAddress);
    }

    /**
     * Sends the command to reset the Telnet socket in the WNet.
     *
     * @throws IOException If there is an error sending a request.
     */
    private void resetTelnetSocket() throws IOException 
    {
        for (int i = 0; i < 3; i++) // Send 3 times for radio redundancy
        {
            WirelessFTSensorSampleCommand.sendResetTelnetCommand(m_udpSocket, m_sensorAddress);
            try 
            {
                Thread.sleep(200);         // Give the WNet time to close and reopen the socket.
            } 
            catch(InterruptedException ie) // If we are interrupted during this delay,
            {
                // Do nothing.
            }
        }
    }

    /**
     * Reads a single F/T sample from the UDP socket.
     *
     * @return The sample read.
     * @throws IOException If there is an error reading the sample (e.g. a
     * network timeout).
     */
    public WirelessFTSample readStreamingSample() throws IOException 
    {
        // The data received from the WNet.
        DatagramPacket receivedData = new DatagramPacket(new byte[DEFAULT_BUFFER_SIZE], DEFAULT_BUFFER_SIZE);
        m_udpSocket.receive(receivedData);
        return new WirelessFTSample(receivedData.getData(), receivedData.getLength());
    }
    
    /**
     * Reads multiple samples from the UDP socket.
     *
     * @return The samples read.
     * @throws IOException If there is an error reading the samples (e.g. a
     * network timeout).
     */
    public ArrayList<WirelessFTSample> readStreamingSamples() throws IOException 
    {
        DatagramPacket receivedData = new DatagramPacket(new byte[DEFAULT_BUFFER_SIZE], DEFAULT_BUFFER_SIZE); // Make a new empty UDP packet
        m_udpSocket.receive(receivedData);                                                                    // Get UDP packet from Wnet
        return WirelessFTSample.listOfSamplesFromPacket(receivedData.getData(), receivedData.getLength());    // Split UDP packet into indivual samples
    }
    
    /**
     * Sends a firmware command over the WNet's Telnet socket.
     *
     * @param command The command to send. If the command does not end with
     * carriage return/line feed, it will be automatically appended.
     * @param clearInputBufferFirst Set to true to read and discard all
     * available bytes from the Telnet socket before sending the command.
     * @throws wirelessftsensor.WirelessFTSensor.CommSeveredException if the
     * command cannot be sent for any reason.
     */
    public void sendTelnetCommand(String command, boolean clearInputBufferFirst) throws CommSeveredException 
    {
        if (!command.endsWith("\r\n")) 
        {
            command = command + "\r\n";
        }

        if (command.contains("RESET")) // If this is a RESET command,
        {
            command = "RESET\r";       // send the bare minimum command.
        }

        try 
        {
            if (clearInputBufferFirst) 
            {
                int bytesAvailable = m_telnetSocket.getInputStream().available(); // Get number of bytes available in the input buffer.
                m_telnetSocket.getInputStream().skip(bytesAvailable);             // Skip over and discard those bytes.
            }
            
            testTelnetConnection();
            m_telnetSocket.getOutputStream().write(command.getBytes(ASCII_CHARSET));
            
            if (command.contains("RESET")) // If this is a RESET command,
            {
                endCommunication();
                m_logger.log(Level.INFO, "Communications ended");
            }
        } 
        catch (IOException | InterruptedException e1)  // Command failed, try to "ping" port 23 with "\r\n".
        {
            if (command.contains("RESET")) // If this is a RESET command,
            {
                endCommunication();
                m_logger.log(Level.INFO, "Communications ended catch");
            }
            else
            {
                try 
                {
                    m_logger.log(Level.WARNING, String.format("Connection lost, attempting to re-establish Telnet Write ... "));
                    testTelnetConnection();
                    m_logger.log(Level.INFO, String.format("Connection re-established."));
                    m_telnetSocket.getOutputStream().write(command.getBytes(ASCII_CHARSET));
                } 
                catch (IOException | InterruptedException e2)  // Could not "ping" Telnet.
                {
                    try 
                    {
                        m_telnetSocket.close(); // Reopen the socket with the same address.
                        m_telnetSocket = new Socket(m_telnetSocket.getInetAddress(), TELNET_PORT);
                        m_telnetSocket.setSoTimeout(TCP_TIMEOUT);
                        m_logger.log(Level.INFO, String.format("Connection re-established."));
                        m_telnetSocket.getOutputStream().write(command.getBytes(ASCII_CHARSET));
                    } 
                    catch (IOException e3)  // Could not re-initialize socket.
                    {
                        m_logger.log(Level.SEVERE, String.format("Could not re-establish connection: " + e3.getMessage()));
                        throw new CommSeveredException("Lost Telnet connection.");
                    }
                }
            }
        }
    }
    
    /**
     * Reads data from telnet link.
     * 
     * @param blockIfNoAvailableData True to block if no data is currently available.  If false, will return an empty string if data is not currently available.
     * @return The data read from the telnet link.  
     * @throws wirelessftsensor.WirelessFTSensor.CommSeveredException If connection cannot be re-established.
     */
    public String readTelnetData(boolean blockIfNoAvailableData) throws CommSeveredException 
    {
        String telnetData = "";
        try 
        {
            telnetData = parseTelnetResponse(blockIfNoAvailableData);
        } 
        catch (Exception e1)  // Command failed, try to "ping" port 23 with "\r\n".
        {
            try 
            {
                m_logger.log(Level.WARNING, String.format("Connection lost, attempting to re-establish Telnet Read... "));
                testTelnetConnection();
                m_logger.log(Level.INFO, String.format("Connection re-established."));
                parseTelnetResponse(blockIfNoAvailableData);
            } 
            catch (IOException | InterruptedException e2)  // Could not "ping" Telnet.
            {
                try // Reopen the socket with the same address.
                {
                    m_telnetSocket.close();
                    m_telnetSocket = new Socket(m_telnetSocket.getInetAddress(), TELNET_PORT);
                    m_telnetSocket.setSoTimeout(TCP_TIMEOUT);
                    m_logger.log(Level.INFO, String.format("Connection re-established."));
                    telnetData = parseTelnetResponse(blockIfNoAvailableData);
                } 
                catch (Exception e3) // Could not re-initialize socket. 
                {
                    m_logger.log(Level.SEVERE, String.format("Could not re-establish connection: " + e3.getMessage()));
                    throw new CommSeveredException("Lost Telnet connection.");
                }
            }
        }
        
        return telnetData;
    }
    
    /**
     * Tests to see if the Telnet connection is still active
     * by sending a "\r\n" and (ideally) generating a new prompt.
     * 
     * @throws Exception No errors are handled here, as it is a convenience
     * method for the 2 above methods.
     * @see #sendTelnetCommand(java.lang.String, boolean)
     * @see #readTelnetData(boolean)
     */
    private void testTelnetConnection() throws IOException, InterruptedException 
    {
        m_telnetSocket.getOutputStream().write("\r\n".getBytes());
        Thread.sleep(10);                        // Give the port time (10 mS) to populate a response.
        m_telnetSocket.getInputStream ().read(); // Try to read something.
        m_telnetSocket.getInputStream ().skip(m_telnetSocket.getInputStream().available());
        m_telnetSocket.getOutputStream().flush();
    }
    
    /**
     * Attempts to buffer and parse a Telnet response into a String.
     * 
     * @param blockIfNoAvailableData Self-explanatory.
     * @return The response parsed from Telnet.
     * @throws IOException If format is incorrect or for connectivity issues.
     */
    private String parseTelnetResponse(boolean blockIfNoAvailableData) throws IOException 
    {
        /* The telnet data. */
        InputStream inputStream = m_telnetSocket.getInputStream();  /* The telnet input stream. */
        if (blockIfNoAvailableData || (inputStream.available() > 0)) 
        {
            byte[] buffer = new byte[Math.max(DEFAULT_BUFFER_SIZE, inputStream.available())];  /* The input buffer. */
            int    len    = inputStream.read(buffer); /* The length of the received data. */
            return new String(buffer, 0, len, ASCII_CHARSET);
        }
        return "";
    }
    
    /**
     * General communication issue exception used to signal
     * reconnect requests via the main form. This can occur
     * during any of the Telnet commands, so all of them
     * throw a CSE up the stack.
     */
    public class CommSeveredException extends Exception 
    {
        /**
         * Constructor for the exception.
         * @param message The reason for this exception.
         */
        public CommSeveredException(String message) 
        {
            super(message);
        }
    }
}
