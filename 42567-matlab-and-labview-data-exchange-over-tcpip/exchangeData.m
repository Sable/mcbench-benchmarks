
function [data_received]=exchangeData(output_port,host,number_of_retries,samplingrate,data_to_send)
%exchangeData - This code allows to exchange data bewteen Matlab and labvie
%over TCP-IP
%
% Syntax:  [data_received]=exchangeData(output_port,host,number_of_retries,samplingrate,data_to_send)
%
% Inputs:
%    output_port - port for communication
%    host - host description (only tested with 'localhost'(
%    number_of_retries - number of retries when communication broke down
%    samplingrate - samplingrate for data exchange
%    data_to_send - data you want to send to MATLAB
%
% Outputs:
%    data_received - Data from MATLAB
%
% Example: 
%  
% 
% 
% %connection settings
% number_of_retries = 1; % set to -1 for infinite
% port=2057; % This code use for communication "port" and "port+1"
% host='localhost';   
% samplingrate=1000; %in ms
% 
% while(true)
%     data_to_send=['|',regexprep(num2str(randn(1),6),'\.',','),'|',regexprep(num2str(randn(1),6),'\.',',')];
%     data_received=exchangeData(port,host,number_of_retries,samplingrate,data_to_send)
%     if(numel(data_received)>0 )
%         % Do your stuff with the data
%     end;
% end
% 
% 

%
% Other m-files required: main_minimal
% Subfunctions: none
% MAT-files required: none
%

% Author: Jan Bischof,
% Institute for combustion and power plant technology, Dept. of Air Quality
% email address: mail@jan-bischof.de 
% 10-July-2012; Last revision: 10-July-2012

%------------- BEGIN CODE --------------

% java import for 
tic
    import java.net.ServerSocket
    import java.io.*
    import java.net.Socket
    server_socket  = [];
    output_socket  = [];

     retry = 0;
        
     while true

        retry = retry + 1;
        message=data_to_send;
        try
            if ((number_of_retries > 0) && (retry > number_of_retries))
                fprintf(1, 'Too many retries\n');
                break;
            end
            if(retry>1)
            fprintf(1, ['Try %d waiting for client to connect to this ' ...
                        'host on port : %d\n'], retry, output_port);
            end;
            % wait for samplingrate for client to connect server socket
            server_socket = ServerSocket(output_port);
            server_socket.setSoTimeout(samplingrate*1);

            output_socket = server_socket.accept;

            %fprintf(1, 'Client connected\n');

            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);

            % output the data over the DataOutputStream
            % Convert to stream of bytes
            %fprintf(1, 'Writing %d bytes\n', length(message))
            d_output_stream.writeBytes(char(message));
            d_output_stream.flush;
            
            % clean up
            server_socket.close;
            output_socket.close;
            break;
            
        catch
            if ~isempty(server_socket)
                server_socket.close
                fprintf(1, 'NO CONNECTION\n');
            end

            if ~isempty(output_socket)
                output_socket.close
                fprintf(1, 'NO CONNECTION\n');
            end
       end
     end
%%------------------------------------------------ 
retry=0;
input_socket = [];
message_in = [];
port=output_port+1;

    while true

        retry = retry + 1;
        if ((number_of_retries > 0) && (retry > number_of_retries))
            fprintf(1, 'Too many retries\n');
            break;
        end
        
        try

            % throws if unable to connect
            input_socket = Socket(host, port);

            % get a buffered data input stream from the socket
            input_stream   = input_socket.getInputStream;
            d_input_stream = DataInputStream(input_stream);

            %fprintf(1, 'Connected to server\n');

            % read data from the socket - wait a short time first
            pause(0.1);
            bytes_available = input_stream.available;
           %fprintf(1, 'Reading %d bytes\n', bytes_available);
            
            message_in = zeros(1, bytes_available, 'uint8');
            for i = 1:bytes_available
                message_in(i) = d_input_stream.readByte;
            end
            
            message_in = char(message_in);
            
            % cleanup
            input_socket.close;
            break;
            
        catch
            if ~isempty(input_socket)
                input_socket.close;
                fprintf(1, 'NO CONNECTION\n');
            end
        end
    end
          

k=strfind(message_in,'|');
data_received=zeros(length(k)-1,1);
for i=1:length(k)-1
   data_received(i)=str2double(regexprep(message_in(k(i)+1:k(i+1)-1),',','.'));
end;
time_needed=toc;
if time_needed<samplingrate/1000
    pause(samplingrate/1000-time_needed)
end;
%fprintf(1, '\n Everything succesfull\n');
end