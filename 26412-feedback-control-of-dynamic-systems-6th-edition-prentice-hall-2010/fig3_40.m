%  Figure 3.40      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.40
fh=@(ki,k) 6+3*k-ki;
ezplot(fh)
hold on;
f=@(ki,k) ki;
ezplot(f);

% add shading
fillvert = [0, -2
	        0,  7
			7, 7
			7, 0];
fcolor = [ .1 .1 .1 .1];
patch(fillvert(:,1)', fillvert(:,2)', fcolor)

xlabel('K_I');
ylabel('K');
title('Allowable region for stability');
nicegrid;
hold off
