% this demo generates L samples of two normal random variables with mean mu
% and standard deviation sigma. For each sample, it runs two hypothesis
% tests to verify if they come from the same underlying distribution.
% In addition, the rejection rates ares computed.
% The tests performed are the two-sample Kolmogorov-Smirnov test and the
% two-sample Cramer-Von Mises test.
% 
% Author:	Juan Cardelino 
% Web:		http://iie.fing.edu.uy/~juanc
% Date:		2011.11.16
function rejection_rate=comparison_of_two_sample_test()

verbose=1;

mu=[0 0];
sigma=[1 1];
N=[22 22];
n_bins=500;
x_max=1;
x_min=0;
dz=(x_max-x_min)/n_bins;
z=[x_min+dz/2:dz:x_max-dz/2];


L=10000;
rejection_rate=[0 0];

if verbose
	fprintf('--------------------------\n');
end



for j=1:L
	%generate samples
	for i=1:length(mu)
		v{i}=mu(i)+sigma(i)*randn(1,N(i));
	end
	[ks_H,ks_P,ks_stat] = kstest2(v{1},v{2});
	[cm_H,cm_P,cm_stat] = cmtest2(v{1},v{2});
	rejection_rate(1)=rejection_rate(1)+ks_H;
	rejection_rate(2)=rejection_rate(2)+cm_H;
	if verbose
		fprintf('test n: %d\n',j);
		fprintf('H: %d P: %d KSSTAT: %4.3f \n',ks_H,ks_P,ks_stat);
		fprintf('H: %d P: %d CM_stat: %4.3f \n',cm_H,cm_P,cm_stat);
		fprintf('--------------------------\n');
	end
end

rejection_rate=rejection_rate/L*100;

fprintf('rejection rates\n');
fprintf('KS: %4.2f CM: %4.2f\n',rejection_rate(1),rejection_rate(2));
