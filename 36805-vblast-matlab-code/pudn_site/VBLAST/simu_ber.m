EbN0=0:5:30;
BER=zeros(1,length(EbN0));
for i=1:length(EbN0)
    SNR=EbN0(i);
    sim('v_blast_t4_r4_8PSK_crrect');
    BER(i)=Error(1);
    save v_blast_t4_r4_8PSK_crrect BER;
end
semilogy(EbN0,BER)
xlabel('EbN0(dB)')
ylabel('BER')
grid on




    