% function [T1 T2] = trmRead(portObject)
% Reads temperature data from a HH506RA omega thermometer.
% e.g. s = serial('COM3','BaudRate',2400,'DataBits',7,'Parity','Even','StopBits',1);
% fopen(s)
% [T1 T2] = trmRead(s)
% 

function [T1 T2] = trmRead(portObject)

readCmd = '#001N';
fprintf(portObject,readCmd)
data = fscanf(portObject);
if strcmp(data,'Err')
    T1 = 'Error';
    T2 = 'Error';
else
    T1 = sscanf(data(2:5),'%x')/10;
    if data(1) == '-'
        T1 = -1*T1;
    end
    
    T2 = sscanf(data(8:11),'%x')/10;
    if data(7) == '-'
        T1 = -1*T1;
    end
end
