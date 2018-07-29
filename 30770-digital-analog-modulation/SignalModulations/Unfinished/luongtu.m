function luongtu(f)
clc;t=[0:.0099:4];
f=1;
w=2*pi*f;a=2;sig=a*sin(w*t);
ma=[-a:.4:a];
mb=[-(a+.2):.4:(a+.2)];
pre=[0 0.8];

[index,siglt]=quantiz(sig,ma,mb);
sigpcm=dpcmenco(siglt,mb,ma,pre);
sigpcmd=dpcmdeco(sigpcm,mb,pre);

subplot(4,1,1);plot(t,sig,'r','linewidth',1.5);grid on;
%hold on;plot(t,siglt,'g','linewidth',1.5);legend('base signal','quantized signal');
subplot(4,1,2);plot(t,siglt,'g','linewidth',1.5);grid on;legend('Quantized signal');
subplot(4,1,3);plot(t,sigpcm,'m','linewidth',1.5);grid on;legend('PCM encode signal');
subplot(4,1,4);plot(t,sigpcmd,'b','linewidth',1.5);grid on;legend('PCM decode signal');
