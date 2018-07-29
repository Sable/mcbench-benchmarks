% convolutional encoder with viterbi decoder
function [data_out]=convolution(data_in,rate_id,TxRx)
t=poly2trellis(7, [171 133]);

switch (rate_id)
    case 0                %%% cc coding rate 1/2
        if TxRx==10
          coded_data = convenc(data_in,t); % encodeing
          data_out=coded_data;
       elseif TxRx==01
           decoded_data=vitdec(data_in,t,12,'trunc','hard');% decoding
           data_out=decoded_data;
        end

    case {1,3}               % %% cc coding rate 2/3
        if TxRx==10
           coded_data = convenc(data_in,t);
           coded_data(3:4:end)=[];                         % puncturing the code
           data_out=coded_data;
       elseif TxRx==01
           data_in=-2*data_in+1;
           decoded_data1=zeros(2*2*length(data_in)/3,1);  % generate the decoded length zero vector
           decoded_data1(1:4:end)=data_in(1:3:end);     %  writng the orignal data
           decoded_data1(2:4:end)=data_in(2:3:end);     
           decoded_data1(4:4:end)=data_in(3:3:end);     
           decoded_data=vitdec(decoded_data1,t,32,'trunc','unquant');
           data_out=decoded_data;
        end
       
    case {2,4,6}     %% cc coding rate 5/6
        if TxRx==10
           coded_data = convenc(data_in,t);
           coded_data(3:10:end)=[];                   % puncturing the code
           coded_data(5:9:end)=[];
           coded_data(5:8:end)=[];
           coded_data(7:7:end)=[];  
           data_out=coded_data;
         elseif TxRx==01 
           data_in=-2*data_in+1;
           decoded_data1=zeros(2*5*length(data_in)/6,1);  % generate the decoded length zero vector
           decoded_data1(1:10:end)=data_in(1:6:end);     %  writng the orignal data
           decoded_data1(2:10:end)=data_in(2:6:end); 
           decoded_data1(4:10:end)=data_in(3:6:end); 
           decoded_data1(5:10:end)=data_in(4:6:end); 
           decoded_data1(8:10:end)=data_in(5:6:end); 
           decoded_data1(9:10:end)=data_in(6:6:end); 
           decoded_data=vitdec(decoded_data1,t,40,'trunc','unquant');
           data_out=decoded_data;
        end

    case 5     %% rate 3/4
        if TxRx==10
           coded_data = convenc(data_in,t);
           coded_data(3:3:end)=[];                         % puncturing the code
           data_out=coded_data;
        elseif TxRx==01  
           data_in=-2*data_in+1;
           decoded_data1=zeros(2*3*length(data_in)/4,1);  % generate the decoded length zero vector
           decoded_data1(1:3:end)=data_in(1:2:end);     %  writng the orignal data
           decoded_data1(2:3:end)=data_in(2:2:end);     %
           decoded_data=vitdec(decoded_data1,t,96,'trunc','unquant');
           data_out=decoded_data;
         end
               
    otherwise
       display('error in convolutional encoder decoder give proper rate_id and TxRx')
end

