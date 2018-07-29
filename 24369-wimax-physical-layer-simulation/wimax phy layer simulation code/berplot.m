%% this is a simple program for representing the ber plot in a specific way
function [a]=berplot(SNR,ber,rate_id)
% plot(SNR,ber)
semilogy(SNR,ber)
grid on
axis([-Inf Inf 10^(-4) 1])
xlabel('Signal to noise ratio ')
ylabel('Bit error rate')

switch (rate_id)
    case 0
        title('Bit error rate for BSPK1/2')
    case 1
        title('Bit error rate for QSPK1/2')
    case 2                           
        title('Bit error rate for QSPK3/4')  
    case 3                                 
        title('Bit error rate for 16-QAM1/2')
    case 4
        title('Bit error rate for 16-QAM3/4')
    case 5
        title('Bit error rate for 64-QAM2/3')
    case 6
        title('Bit error rate for 64-QAM3/4')
    otherwise
       display('error in plot give proper rate_id')
end
a='simulation has successfully completed' ;




