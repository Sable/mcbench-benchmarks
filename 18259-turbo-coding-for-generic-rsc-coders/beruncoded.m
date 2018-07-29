clear;
%EbNovector = 0:8;
EbNovector = 0:0.2:2;
bervector = zeros(length(EbNovector),1);
N=1000000;
%cantrep=10;

%for k=1:cantrep

source = sign(randn(N,1));
assignin('base','source',source);
    
for i = 1:length(EbNovector)
    EbNo =   EbNovector(i);
    assignin('base','EbNo',EbNo);
    Sigma = 1/sqrt(2)*10^(-EbNo/20); % EbNo esta en dB
    n = Sigma*randn(N,1);
    r=source+n;
    %r=awgn(source,EbNo + 3);
    decout = sign(r);
    assignin('base','decout',decout);
    bervector(i) = errors/N;
end

semilogy(EbNovector,bervector)
xlabel('Eb/No [dB]')
ylabel('BER')
title('BER vs Eb/No sin codificación')
hold on