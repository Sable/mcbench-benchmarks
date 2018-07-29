%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LMS Algorithm
% Author : Arsal Butt
% Contact information : 
% School of Electrical & Electronic Engineering,
% University of Bradford,
% Bradford, BD7 1DP,
% United Kingdom .
% email : a.butt7@bradford.ac.uk  
% Date    : 03-8-2010
% Version : 1.0.2
% Reference : Statistical and Adaptive Signal Processing By Dimitris G. Manolakis, Vinay K. Ingle & Stephen M. Kogon. 
% Note : The author doesn't take any responsibility for any harm caused by
% the use of this code;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use N iterations of an adapting filter system to identify an unknown
% Mth-order FIR filter.
function lmsalgorithm = lms()
sysorder = input('Enter the System Order? ')
N = input('Enter the number of Itterations? ')
if ((sysorder >= 2) && (N >= 2))
    x  = randn(N,1);     % Input to the filter 
b  = fir1(sysorder-1,0.5);  % FIR system to be identified 
n  = 0.1*randn(N,1); % Uncorrelated noise signal 
d  = filter(b,1,x)+n;  % Desired signal = output of H + Uncorrelated noise signal
w = zeros (sysorder, 1) ; % Initially filter weights are zero
for n = sysorder : N 
	u = x(n:-1:n-sysorder+1) ;
    y(n)= w' * u; % output of the adaptive filter
    e(n) = d(n) - y(n) ; % error signal = desired signal - adaptive filter output
    mu=0.008;
    w = w + mu * u * e(n) ; % filter weights update
end 
hold on
plot(d,'g')
plot(y,'r');
semilogy((abs(e)),'m') ;
title('System output') ;
xlabel('Samples')
ylabel('True and estimated output')
legend('Desired','Output','Error')
axis([0 N -2 2.5])
figure
plot(b', 'k+')
hold on
plot(w, 'r*')
legend('Actual weights','Estimated weights')
title('Comparison of the actual weights and the estimated weights') ;
else ('System Order and numbers of Itterations should be greater than 1')
end

end