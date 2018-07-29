%  Figure 6.44      Feedback Control of Dynamic Systems, 5e
%                   Franklin, Powell, Emami

%   Weighting function in Bode's gain-phase theorem

clear all;
close all;

coth=0*ones(1,101);
u=-6:.02:6;
length(u);
for i=1:1:601,
num=exp(.5*abs(u(i)))-exp(-.5*abs(u(i)));
den=exp(.5*abs(u(i)))+exp(.5*abs(u(i)));
tanhu=num/den;
if i == 301, tanhu=.000001; end   % prevents div by zero error
cothu=1/tanhu;
coth(1,i)=log(cothu);
end;
ii=[1:300 302:601];
plot(u(ii),coth(ii));
grid;
xlabel('u');
ylabel('W(u)');
title('Fig. 6.44 Weighting function in Bode s gain-phase theorem');

