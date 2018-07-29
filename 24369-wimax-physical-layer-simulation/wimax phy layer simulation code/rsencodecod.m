function [data_out] = rsencodecod(data_in,rate_id,TxRx)
%%  Description: The Reed-Solomon encoder is realized according to the standard. %                       
          
if rate_id==0
    if TxRx==10
        data_out=[data_in;0;0;0;0;0;0;0;0]; %RS encoder is by passed for BPSK1/2
    elseif TxRx==01
        data_out=[data_in(1:end-8)];     %remove added zero bit
    end
else
switch (rate_id)
    case 1
         n = 32;                  
         k = 24;     
    case 2  
        n = 40;                  
        k = 36;        
    case 3                                 
        n = 64;                  
        k = 48; 
    case 4
        n = 80;                  
        k = 72; 
    case 5
        n = 108;                  
        k = 96;  
    case 6
        n = 120;                  
        k = 108; 
 end
m = 8;   % Number of bits per symbol
d=n-k;
if TxRx==10
    %  To realize the Reed-Solomon code, the information is needed in decimal.
    data = reshape(data_in,8,length(data_in)/8);
    data = bi2de(data.','left-msb');
    % one bytes are needed with a stuffed zero at the end of the vector:
      data=[data.' 0];   
   % The Galois vector is generated, the generating polynomial of the
   % code. Then the symbols are encoded with Reed-Solomon.
     msg = gf([data],m);   % used polynomial to generate gf field array is same as describe in ieee standrds 
     codeRS = rsenc(msg,n,k);  % here we used primitive polynomial as in bydefault in matlab
     out = codeRS.x ;           % convert codeRS a gf object to uni8 array
     data_out=double(out);     % convert to double array
     data_out=[data_out(end-d+1:end) data_out(1:end-d)];  % extra bits should be send befor the orignal bits
   % decimal to binary conversion for continue
   data_out=de2bi(data_out,'left-msb');
   data_out=reshape(data_out.',length(data_out)*8,1);
 
elseif TxRx==01
    % RS DECODER
    % binary to decimal conversion
    data = reshape(data_in,8,length(data_in)/8);
    data = bi2de(data.','left-msb');
    data=[data.'];
    data=[data(d+1:end) data(1:d)]; % putting the extra bit to last of the array
    %decoding
    msg = gf([data],m); 
    decodeRS = rsdec(msg,n,k);      
    out = decodeRS(1:end-1)';
    out= out.x;
    out = double (out);
    % The binary data to continue working:
    out = de2bi (out,'left-msb');
    out = reshape (out.', 1, length(out)*8);
   data_out=out';
end
end


     
     
     
  
