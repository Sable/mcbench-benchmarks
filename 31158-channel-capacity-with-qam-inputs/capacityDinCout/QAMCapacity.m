function InstCap = QAMCapacity(SNR,fading,QAMsize)
%% This fuction calculate the instantenous capacity 
% of discret inputs and continuous outputmemoryless channel 
% BPSK, QPSK, 8PSK, 16-QAM, 64-QAM, 32-QAM
%% Gauss Hermite quadrature rules
%http://www.efunda.com/math/num_integration/findgausshermite.cfm
%http://en.wikipedia.org/wiki/Gauss%E2%80%93Hermite_quadrature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=[
-4.688738939
-3.869447905
-3.176999162
-2.546202158
-1.951787991
-1.380258539
-0.822951449
-0.273481046
0.273481046
0.822951449
1.380258539
1.951787991
2.546202158
3.176999162
3.869447905
4.688738939
];
w=[
2.65E-10
2.32E-07
2.71E-05
0.000932284
0.012880312
0.083810041
0.280647459
0.507929479
0.507929479
0.280647459
0.083810041
0.012880312
0.000932284
2.71E-05
2.32E-07
2.65E-10
];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR affect 
% We assume 2sigma^2=1, i.e., noise power is normalized.
SNRlin= 10^(SNR/10);
SNRaff=abs(fading)*sqrt(SNRlin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (QAMsize==2)||(QAMsize==4)||(QAMsize==16)||...
        (QAMsize==64)||(QAMsize==32) 
    h = modem.qammod('M', QAMsize, 'SymbolOrder', 'Gray','InputType', 'Bit');
elseif (QAMsize==8)
    h = modem.pskmod('M', QAMsize, 'SymbolOrder', 'Gray','InputType', 'Bit');
else
    error('the modulation size %d is not supported!',  QAMsize);
end
NormFactor = sqrt(QAMsize/sum(abs (h.Constellation).^2));
Constellation = NormFactor.*h.Constellation;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C1 = zeros(1,16);  % BPSK Gaussi Hermite
C2 = zeros(16,16); % Two dimensional signals
Capforx = zeros(1,QAMsize);
if (QAMsize==2) % BPSK
    SNRaffBPSK = sqrt(2).*SNRaff;  % see page 363 of Digital Communications 5th A/sigma
    for m=1:16
        C1(m)=1/2*(w(m)*(1/sqrt(pi))*log2(2/(1+exp(-2*(sqrt(2)*x(m)+SNRaffBPSK)*SNRaffBPSK)))+...
                       w(m)*(1/sqrt(pi))*log2(2/(1+exp( 2*(sqrt(2)*x(m)-SNRaffBPSK)*SNRaffBPSK))));
    end
    InstCap = sum(C1);

elseif (QAMsize==4)||(QAMsize==16)||(QAMsize==64)||(QAMsize==8)||(QAMsize==32)
    for xindex = 1:QAMsize
        for m1=1:16
            for m2=1:16
                sumoverxprime = 0;
                for xprimeindex=1:QAMsize
                    sumoverxprime = sumoverxprime + ...
                    exp(-abs(SNRaff.*(Constellation(xindex)-Constellation(xprimeindex))+x(m1)+sqrt(-1).*x(m2)).^2 ...
                    +x(m1).^2+x(m2).^2);
                end
                C2(m1,m2)=1/(pi)*w(m1)*w(m2)*log2(sumoverxprime);
            end
        end
        Capforx(xindex) = sum(sum(C2,1),2);
    end
    InstCap = log2(QAMsize) - 1/QAMsize *sum (Capforx);               
else
    error('the modulation size %d is not supported!',  QAMsize);
end

%GassianCap = log2(1+SNRaff.^2);
