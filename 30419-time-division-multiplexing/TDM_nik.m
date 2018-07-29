function [y]=TDM_nik(x)
% x contains all the signals to be multiplexed
% y is multiplexed signal
%----------------------------------------
% Example: if you have to mutiplex two signals e.g. x1 and x2 (of course both of same length)
% if length is not same append zeros in smaller one to make it equal to larger on
% then make x(1,:)=x1, x(2,x2)...x(r, xr) (if you have r signals to be multiplexed)
% then simple run y=TDM_nik(x)
%-Do it x1=1:10,  x2=10:-1:1, x3(1:5)=4, x3(6:10)=-4, x(1,:)=x1, x(2,:)=x2,
% x(3,:)=x3 amd y=TDM_nik(x)
%If you have any problem or feedback please contact me @
%%===============================================
% NIKESH BAJAJ
% Asst. Prof., Lovely Professional University, India
% Almameter: Aligarh Muslim University, India
% +919915522564, bajaj.nikkey@gmail.com
%%===============================================
[r c]=size(x);
k=0;
% Multiplexing
for i=1:c
    for j=1:r
    k=k+1;
    y(k)=x(j,i);
    end
end

% Ploting
color='ybrgmkc';
figure(1)
sig='x1';
for i=1:r
    sig(2)=i+48;
    j=mod(i,7)+1;
subplot(r,1,i)
stem(x(i,:),color(j),'linewidth',2)
title(sig)
ylabel('Amplitude')
grid
end
xlabel('Time')

t=1/r:1/r:c;
figure(2)
for i=1:r
  j=mod(i,7)+1;
  stem(t(i:r:r*c),y(i:r:r*c),color(j),'linewidth',2)
  hold on
  grid
end
hold off
title('Time Division Multiplexed Sequence')
xlabel('Time')
ylabel('Amplitude')
