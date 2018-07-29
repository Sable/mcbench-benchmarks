function [U P B M S]=LC_nrz(a)
% 'a' is input data sequence
% U = Unipolar, P=Polar, B=Bipolar, M=Mark and S=Space
% Wave formatting
% Example: Take a=[1 0 1 1 0 1 1];
% If you have any problem or feedback please contact me @
%%===============================================
% NIKESH BAJAJ
% Aligarh Muslim University
% +919915522564, bajaj.nikkey@gmail.com
%%===============================================
%Unipolar
U=a;
n= length(a);
%POLAR
P=a;
for k=1:n;
    if a(k)==0
        P(k)=-1;
    end
end
 %Bipolar
 B=a;
 f = -1;
 for k=1:n;
     if B(k)==1;
         if f==-1;
            B(k)=1;
            f=1;
         else
             B(k)=-1;
             f=-1;
         end
     end
 end
 
 %Mark
 M(1)=1;
 for k=1:n;
     M(k+1)=xor(M(k), a(k));
 end
 
 %Space
 S(1)=1;
 for k=1:n
     S(k+1)=not(xor(S(k), a(k)));
 end
%Plotting Waves 
 subplot(5, 1, 1); bpuls(U)
 axis([1 n+2 -2 2])
 title('Unipolar NRZ')
 grid on
 subplot(5, 1, 2); bpuls(P)
 axis([1 n+2 -2 2])
 title('Polar NRZ')
 grid on
 subplot(5, 1, 3); bpuls(B)
 axis([1 n+2 -2 2])
 title('Bipolar NRZ')
 grid on
 subplot(5, 1, 4); bpuls(M)
 axis([1 n+2 -2 2])
 title('NRZ-Mark')
 grid on
 subplot(5, 1, 5); bpuls(S)
 axis([1 n+2 -2 2])
 title('NRZ-Space')
 grid on
 
%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %unipolar 
 yu=fft(U, 512);
 pu=yu.*conj(yu)/512;
 %polar
  yp=fft(P, 512);
 pp=yp.*conj(yp)/512;
 
 %bipolar
  yb=fft(B, 512);
 pb=yb.*conj(yb)/512;
 
 %Mark
  ym=fft(M, 512);
 pm=ym.*conj(ym)/512;
%Space
  ys=fft(S, 512);
 ps=ys.*conj(ys)/512;

 %Power spectra PLOT
 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 plot(f,pp(1:257),'-b','linewidth',2)
 plot(f,pb(1:257),'-g','linewidth',2)
 plot(f,pm(1:257),'-r','linewidth',2)
 plot(f,ps(1:257),'-m','linewidth',2)
 grid on
 
 legend('Unipolar','Polar','Bipoalr','Mark','Space')
 
 hold off
 size(f)

function bpuls(a)
n=length(a);
b=a;
b(n+1)=b(n);    %retaining last value for entire last duration
stairs(b,'linewidth',2)
axis([1 length(b) min(b)-0.5 max(b)+0.5])






