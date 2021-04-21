/*
 * Copyright 2013
 * ATI Industrial Automation
 */
package wirelessftsensor;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.nio.ByteBuffer;

/**
 * Command to start or stop streaming or set sample rate of Wireless FT system.
 *
 * @author Sam Skuce
 */
public class WirelessFTSensorSampleCommand 
{
    /**
     * The wireless F/T system listens on this port.
     */
    static final int UDP_SERVER_PORT = 49152;

    /**
     * Sends a command to start streaming to the Wireless F/T system.
     *
     * @param socket The socket to send the packet from.
     * @param hostNameOrAddress The address of the Wireless F/T system.
     * @param numSamples The number of samples to request. 0 == infinite.
     * @throws IOException If there is an IOException sending the packet.
     */
    public static void sendStartStreamingCommand(DatagramSocket socket, String hostNameOrAddress, int numSamples) throws IOException 
    {
        final short LENGTH = 10;                     /* Length of this command. */
        byte[] packetData = new byte[LENGTH];        /* The command data. */
        ByteBuffer bb = ByteBuffer.wrap(packetData); /* Places fields in data. */
        bb.putShort(LENGTH);                         /* Length. */
        bb.put((byte) 0);                            /* Sequence number / unused. */
        bb.put((byte) 1);                            /* Command.  1 = start streaming. */
        bb.putInt(numSamples);                       /* Number of samples. */
        bb.putShort(crc.crcBuf(packetData, LENGTH - 2));
        socket.send(new DatagramPacket(packetData, LENGTH, InetAddress.getByName(hostNameOrAddress), UDP_SERVER_PORT));
    }

    /**
     * Sends a command to stop streaming to the Wireless F/T system.
     *
     * @param socket The socket to send the packet from.
     * @param hostNameOrAddress The address of the Wireless F/T system.
     * @throws IOException If there is an IOException sending the packet.
     */
    public static void sendStopStreamingCommand(DatagramSocket socket, String hostNameOrAddress) throws IOException 
    {
        final short LENGTH = 6;                      /* Length of this command. */
        byte[] packetData = new byte[LENGTH];        /* The command data. */
        ByteBuffer bb = ByteBuffer.wrap(packetData); /* Places fields in data. */
        bb.putShort(LENGTH);                         /* Length. */
        bb.put((byte) 0);                            /* Sequence number / unused. */
        bb.put((byte) 2);                            /* Command.  2 = stop streaming. */
        bb.putShort(crc.crcBuf(packetData, LENGTH - 2));
        socket.send(new DatagramPacket(packetData, LENGTH, InetAddress.getByName(hostNameOrAddress), UDP_SERVER_PORT));
    }

    /**
     * Sends a command to reset the telnet socket in the Wireless F/T system.
     *
     * @param socket The socket to send the packet from.
     * @param hostNameOrAddress The address of the Wireless F/T system.
     * @throws IOException If there is an IOException sending the packet.
     */
    public static void sendResetTelnetCommand(DatagramSocket socket, String hostNameOrAddress) throws IOException 
    {
        final short LENGTH = 6;                      /* Length of this command. */
        byte[] packetData = new byte[LENGTH];        /* The command data. */
        ByteBuffer bb = ByteBuffer.wrap(packetData); /* Places fields in data. */
        bb.putShort(LENGTH);                         /* Length. */
        bb.put((byte) 0);                            /* Sequence number / unused. */
        bb.put((byte) 5);                            /* Command.  5 = reset telnet. */
        bb.putShort(crc.crcBuf(packetData, LENGTH - 2));
        socket.send(new DatagramPacket(packetData, LENGTH, InetAddress.getByName(hostNameOrAddress), UDP_SERVER_PORT));
    }
}