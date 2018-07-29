% -------------------------------------------------------------------------
clear all; close all;

%connection settings
number_of_retries = 1; % set to -1 for infinite
port=2057; % This code use for communication "port" and "port+1"
host='localhost';   
samplingrate=1000; %in ms

while(true)
    data_to_send=['|',regexprep(num2str(randn(1),6),'\.',','),'|',regexprep(num2str(randn(1),6),'\.',',')];
    data_received=exchangeData(port,host,number_of_retries,samplingrate,data_to_send)
    if(numel(data_received)>0 )
        % Do your stuff with the data
    end;
end


