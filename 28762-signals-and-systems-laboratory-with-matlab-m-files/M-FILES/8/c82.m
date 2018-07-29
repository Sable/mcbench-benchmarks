% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%    Frequency Response  Graphs 
%                                         
% 
% 
%             8(jw)^2+2jw+20 
%      H(jw)=----------------
%             6(jw)^2-5jw-10 

num=[8 2 20];
den=[6 -5 -10];
w=0:.1:10;
H=freqs(num,den,w);
plot(w,abs(H));
legend('Magnitude of H(\Omega), 0<\Omega<10')
figure
plot(w,angle(H));
legend(' Phase of H(\Omega), 0<\Omega <10')

figure
freqs(num,den,w);

%lenghts of vectors H and w
[H,w]=freqs(num,den);
length(w)
[H,w]=freqs(num,den,722)
length(w)



%             w^3+w^2-5w+1 
%      H(jw)=----------------
%                3w^2-1 


figure
num=[ 1/(j^3) 1/(j^2) -5/j 1];
den=[3/(j^2) 0 -1 ];

w=0:.1:20;
H=freqs(num,den,w);
plot(w,abs(H));
legend( '|H(\Omega)| ' )
figure
plot(w,angle(H));
ylim([-0.5 3.5]);
legend('\angle H(\Omega) ')


%alternative way 
figure
w=0:.1:20;
H=(w.^3+w.^2-5*w+1)./(3*w.^2-1);
plot(w,abs(H));
legend(' |H(\Omega)|')
figure
plot(w,angle(H));
ylim([-0.5 3.5]);
legend('\angle H(\Omega)')


%Various syntaxes
figure
freqs(num,den,w);

figure
plot(w,20*log10(abs(H)));
legend('Magnitude in dB')

figure
semilogx(w,20*log10(abs(H)));
title('Magnitude in dB versus logarithmic scale frequency') 

figure
loglog(w,abs(H));
title('Magnitude in logarithmic scale')

figure
plot(w,angle(H)*180/pi);
ylim([-15 200]);
legend('Phase in degrees')

figure
semilogx(w,angle(H)*180/pi)
ylim([-20 200]);
title('Phase in degrees versus logarithmic scale frequency')

