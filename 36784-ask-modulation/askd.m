function askd(g,f)
%Modulation  ASK
%Example:
%askd([1 0 1 1 0],2)
if nargin > 2
    error('Too many input arguments')
elseif nargin==1
    f=1;
end
 
if f<1;
    error('Frequency must be bigger than 1');
end
 
t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];
 
for n=1:length(g);
    if g(n)==0;
        die=ones(1,100);
        se=zeros(1,100);
    else g(n)==1;
        die=2*ones(1,100);
        se=ones(1,100);
    end
    c=sin(f*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end  
ask=cp.*mod;
subplot(2,1,1);plot(bit,'LineWidth',1.5);grid on;
title('Binary Signal');
axis([0 100*length(g) -2.5 2.5]);
 
subplot(2,1,2);plot(ask,'LineWidth',1.5);grid on;
title('ASK modulation');
axis([0 100*length(g) -2.5 2.5]);