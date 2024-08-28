function s = connectToGazepoint(ip_address, port_number)

if nargin<1 || isempty(ip_address)
    ip_address = '127.0.0.1';
end
if nargin < 2 || isempty(port_number)
    port_number = 4242; 
end 

try
    s = tcpclient(ip_address, port_number);
    configureTerminator(s,"CR/LF");
    %fopen(s);
    fprintf('Connected to: %s on port %d\n',ip_address,port_number);
catch m
    m
    s = NaN;
    fprintf('Failed to connect to %s on port %d\n',ip_address,port_number);
    error('Cannot connect to eye tracker!!!!! Make sure GazepointControl is open on host machine.');
end
