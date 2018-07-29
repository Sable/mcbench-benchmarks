function ASK_FSK_PSK(msglen)
%msglen= number of bits to be transmitted
%take msglen=10000, or 20000 for more accuracy
%If you have any problem or feedback please contact me @
%%===============================================
% NIKESH BAJAJ
% Asst. Prof., Lovely Professional University, India
% Almameter: Aligarh Muslim University, India
% +919915522564, bajaj.nikkey@gmail.com
%%===============================================
n=msglen;
b=randint(1,n);
f1=1;f2=2;
t=0:1/30:1-1/30;
%ASK
sa1=sin(2*pi*f1*t);
E1=sum(sa1.^2);
sa1=sa1/sqrt(E1); %unit energy 
sa0=0*sin(2*pi*f1*t);
%FSK
sf0=sin(2*pi*f1*t);
E=sum(sf0.^2);
sf0=sf0/sqrt(E);
sf1=sin(2*pi*f2*t);
E=sum(sf1.^2);
sf1=sf1/sqrt(E);
%PSK
sp0=-sin(2*pi*f1*t)/sqrt(E1);
sp1=sin(2*pi*f1*t)/sqrt(E1);

%MODULATION
ask=[];psk=[];fsk=[];
for i=1:n
    if b(i)==1
        ask=[ask sa1];
        psk=[psk sp1];
        fsk=[fsk sf1];
    else
        ask=[ask sa0];
        psk=[psk sp0];
        fsk=[fsk sf0];
    end
end
figure(1)
subplot(411)
stairs(0:10,[b(1:10) b(10)],'linewidth',1.5)
axis([0 10 -0.5 1.5])
title('Message Bits');grid on
subplot(412)
tb=0:1/30:10-1/30;
plot(tb, ask(1:10*30),'b','linewidth',1.5)
title('ASK Modulation');grid on
subplot(413)
plot(tb, fsk(1:10*30),'r','linewidth',1.5)
title('FSK Modulation');grid on
subplot(414)
plot(tb, psk(1:10*30),'k','linewidth',1.5)
title('PSK Modulation');grid on
xlabel('Time');ylabel('Amplitude')
%AWGN
for snr=0:20
    askn=awgn(ask,snr);
    pskn=awgn(psk,snr);
    fskn=awgn(fsk,snr);

    %DETECTION
    A=[];F=[];P=[];
    for i=1:n
        %ASK Detection
        if sum(sa1.*askn(1+30*(i-1):30*i))>0.5
            A=[A 1];
        else
            A=[A 0];
        end
        %FSK Detection
        if sum(sf1.*fskn(1+30*(i-1):30*i))>0.5
            F=[F 1];
        else
            F=[F 0];
        end
        %PSK Detection
        if sum(sp1.*pskn(1+30*(i-1):30*i))>0
            P=[P 1];
        else
            P=[P 0];
        end
    end

    %BER
    errA=0;errF=0; errP=0;
    for i=1:n
        if A(i)==b(i)
            errA=errA;
        else
            errA=errA+1;
        end
        if F(i)==b(i)
            errF=errF;
        else
            errF=errF+1;
        end
        if P(i)==b(i)
            errP=errP;
        else
            errP=errP+1;
        end
    end
    BER_A(snr+1)=errA/n;
    BER_F(snr+1)=errF/n;
    BER_P(snr+1)=errP/n;
end

figure(2)
subplot(411)
stairs(0:10,[b(1:10) b(10)],'linewidth',1.5)
axis([0 10 -0.5 1.5]);grid on
title('Received signal after AWGN Channel')
subplot(412)
tb=0:1/30:10-1/30;
plot(tb, askn(1:10*30),'b','linewidth',1.5)
title('Received ASK signal');grid on
subplot(413)
plot(tb, fskn(1:10*30),'r','linewidth',1.5)
title('Received FSK signal');grid on
subplot(414)
plot(tb, pskn(1:10*30),'k','linewidth',1.5)
title('Received PSK signal');grid on
figure(3)
semilogy(0:20,BER_A, 'b','linewidth',2)
title('BER Vs SNR')
grid on;
hold on
semilogy(0:20,BER_F,'r','linewidth',2)
semilogy(0:20,BER_P, 'k','linewidth',2)
xlabel('Eo/No(dB)')
ylabel('BER')
hold off
legend('ASK','FSK','PSK');

