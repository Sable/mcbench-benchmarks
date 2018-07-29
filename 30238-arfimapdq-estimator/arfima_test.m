% compiling the C/MEX file
c = input('Would you like to compile the MEX source? (1/0)');
switch c
    case(1)
mex durlevML.c
    case(0)
end
%simulating an ARFIMA(1,d,1) process with noise variance 1
Z = ARFIMA_SIM(2000,-0.8,0.4,0.4,[],normrnd(0,1,2000,1));
%estimation with the whittle method 
[whittle] = arfima_estimate(Z,'FWHI',[1 1]);
fprintf('\nWhittle Estimator - estimation output\n')
fprintf('\nEstimated parameters for ARFIMA(1,d,1) process\n with parameters d: 0.4 AR(1) : 0.8 MA(1) : 0.4 \n noise variance: 1\n')
disp('d: ')
whittle.d 
disp('AR1: ')
whittle.AR 
disp('MA1: ')
whittle.MA 
disp('noise variance: ')
whittle.sigma2
disp('Press a key to continue')
pause
%simulating an ARFIMA(2,d,2) process with noise variance 4
Z = ARFIMA_SIM(2500,[-0.5 0.1],[0.4 0.6],0.4,[],normrnd(0,2,2500,1));
Z1 = Z(1:2000); 
% sometimes the algorithm fails to converge or gets stuck in 
% absurd points in the parameter space. However, it works fine
% in most of the cases. It's hard to find a good starting point
% in the general case.
[whittle] = arfima_estimate(Z1,'FWHI',[2 2]);
fprintf('\nWhittle Estimator - estimation output\n')
fprintf('\nEstimated parameters for ARFIMA(2,d,2) process\n with parameters d: 0.4 AR(1 2) : 0.5 -0.1 MA(1 2) : 0.4 0.6 \n noise variance: 4\n')
disp('d: ')
whittle.d 
disp('AR 1 2: ')
whittle.AR 
disp('MA 1 2: ')
whittle.MA 
disp('noise variance: ')
whittle.sigma2
disp('Press a key to continue')
pause
[exact] = arfima_estimate(Z1,'FML',[2 2]); 
fprintf('\nExact Maximum Likelihood - estimation output\n')
fprintf('\nEstimated parameters for ARFIMA(2,d,2) process\n with parameters d: 0.4 AR(1 2) : 0.5 -0.1 MA(1 2) : 0.4 0.6 \n noise variance: 4\n')
disp('d: ')
exact.d 
disp('AR 1 2: ')
exact.AR 
disp('MA 1 2: ')
exact.MA 
disp('noise variance: ')
exact.sigma2
% out-of-the sample forecast 500 periods ahead
[F] = arfima_forecast(Z1,500,exact.d,exact.AR,exact.MA,exact.mean,exact.sigma2);
plot(Z);hold on;plot( [Z1;F],'r' )
disp('End of demo')