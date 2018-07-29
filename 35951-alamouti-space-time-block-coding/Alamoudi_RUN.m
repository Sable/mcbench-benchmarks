%This is the main program used to run the  Alamoudi_2T1R and Alamoudi_2T2R functions.
%The outputs are computed only upto 10 dB Signal-to-noise ratio.

%If you havr any problem in running this program, please mail me: souravmondal003@gmail.com

ber=[];
BER=[];
snr=[0:10];

for i=0:10
    ber=[ber Alamoudi_2T1R(i,500)];        %Computing bit error rate for Alamoudi_2T1R
    BER=[BER Alamoudi_2T2R(i,500)];   %Computing bit error rate for Alamoudi_2T2R
end

semilogy(snr,ber,'--*g');
hold on;
semilogy(snr,BER,'--*c');