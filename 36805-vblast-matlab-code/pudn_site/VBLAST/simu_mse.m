EbN0=0:5:30;
MSE=zeros(1,length(EbN0));
for i=1:length(EbN0)
    SNR=EbN0(i);
    sim('v_blast_t4_r4_8PSK_crrect_MSE');
    MSE(i)=mse;
    save MSE;
end
semilogy(EbN0,MSE)
xlabel('EbN0(dB)')
ylabel('MSE')
grid on



