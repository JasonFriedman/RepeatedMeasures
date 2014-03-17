% PARSEACK - parse the ACK response

function message = parseACK(ACK)

PacketStartByte = uint8(2);
%PacketEndByte = uint8(3);

ACKResponse = hex2dec('C8');
NAKResponse = hex2dec('C4');

commands{1+hex2dec('00')} = 'TurnAllOff';
commands{1+hex2dec('01')} = 'KillSeq';
commands{1+hex2dec('02')} = 'Sleep';
 
commands{1+hex2dec('11')} = 'TacOnTime';
commands{1+hex2dec('12')} = 'SetSinFreq1';
commands{1+hex2dec('14')} = 'SetSinFreq2';
commands{1+hex2dec('15')} = 'SetSigSrc';
commands{1+hex2dec('16')} = 'PulseOnTime';

commands{1+hex2dec('1a')} = 'PlaySeq';
commands{1+hex2dec('1b')} = 'SeqStart';
commands{1+hex2dec('1c')} = 'SeqData';
commands{1+hex2dec('1d')} = 'SeqEnd';
commands{1+hex2dec('1e')} = 'ChkSeq';
commands{1+hex2dec('1f')} = 'SeqWait';

commands{1+hex2dec('20')} = 'SetGain';

commands{1+hex2dec('30')} = 'SelfTest';

commands{1+hex2dec('40')} = 'ReadState';
commands{1+hex2dec('42')} = 'ReadFwVer';
 
commands{1+hex2dec('50')} = 'ReadIVals';
 
commands{1+hex2dec('60')} = 'ReadSinVal1';
commands{1+hex2dec('61')} = 'ReadSinVal2';
 
commands{1+hex2dec('80')} = 'SetTactors';

message = [];

if numel(ACK)<1
    message = 'No ACK message!!!!!';
    return
end

if ~ACK(1)== PacketStartByte
    message = 'Packet start byte does not match!!!';
end

if ACK(2)== ACKResponse
    datalength = ACK(3);
    data  =  ACK(4:3+datalength);
    message = [message 'ACK: ' commands{1+data(1)} ' ' num2str(data(2:end))];
        
elseif ACK(2)==NAKResponse
    switch(ACK(4))
        case 1,
            m = 'The ETX value was not found in the expected place';
        case 2,
            m = 'The Checksum value was invalid';
        case 3,
            m = 'Insufficient Data in packet';
        case 4,
            m = 'An invalid command was used';
        case 5,
            m = 'Invaid Data was given with a valid command';
        case 6,
            m = 'Data length exceeds max payload';
        case 7,
            m = 'Invalid Sequence Data';
        otherwise
            m = 'Unknown error';
    end
    message = [message 'NAK:' m];
else
    message = [message 'Unknown second byte (not ACK or NAK)!!!\n'];
end