% the following program calculates the 
% Colebrool-White friction factors at various
% roughess heights for Reynolds numbers
% between 5000 and 500000
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

clear
Re=linspace(5000,500000,200); % set the Reynolds numbers
Dh=0.008;  % set the hydraulic diameter in meters

rough=0.00000075;  % set the 1st EQUIVALENT ROUGHNESS HEIGHT in m

for i=1:200
   miller(i)=0.25/(log10(rough/(3.7*0.009)+5.74/Re(i)^0.9))^2;
   fcw(i)=ffcw(Re(i), Dh, rough);
end

rough=0.000001;  % EQUIVALENT ROUGHNESS HEIGHT 
for i=1:200
%   miller1(i)=0.25/(log10(rough/(3.7*0.009)+5.74/Re(i)^0.9))^2;
   fcw1(i)=ffcw(Re(i), Dh, rough);
end

rough=0.00000125;  % EQUIVALENT ROUGHNESS HEIGHT 
for i=1:200
%   miller2(i)=0.25/(log10(rough/(3.7*0.009)+5.74/Re(i)^0.9))^2;
   fcw2(i)=ffcw(Re(i), Dh, rough);
end

rough=0.0000015;  % EQUIVALENT ROUGHNESS HEIGHT 
for i=1:200
%   miller3(i)=0.25/(log10(rough/(3.7*0.009)+5.74/Re(i)^0.9))^2;
   fcw3(i)=ffcw(Re(i), Dh, rough);
end

rough=0.00000175;  % EQUIVALENT ROUGHNESS HEIGHT 
for i=1:200
%   miller4(i)=0.25/(log10(rough/(3.7*0.009)+5.74/Re(i)^0.9))^2;
   fcw4(i)=ffcw(Re(i), Dh, rough);
end

%plot the figures
figure(1)
orient landscape;
subplot(2,1,1);
plot(Re,fcw,'b',Re,miller,'r--')
legend('f_{cw}','f_{miller}');
grid on;
axis tight;
xlabel('Reynolds number');
ylabel('Friction factor');
title ('Hydraulic Diameter (D_h=8 mm), Eq. Roughness Height (\epsilon = 0.75 \mum)');

subplot(2,1,2);
plot(Re,fcw,'b',Re,fcw1,'r',Re,fcw2,'g',Re,fcw3,'m',Re,fcw4,'k')
legend('\epsilon=0.75 \mum','\epsilon=1.00 \mum','\epsilon=1.25 \mum','\epsilon=1.50 \mum','\epsilon=1.75 \mum');
grid on;
axis tight;
xlabel('Reynolds number');
ylabel('Friction factor');
title ('Colebrook-White Friction Factor (f_{cw})');
