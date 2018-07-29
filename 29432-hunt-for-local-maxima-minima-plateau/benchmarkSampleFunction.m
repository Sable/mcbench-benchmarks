function trackingY = benchmarkSampleFunction (thresholdInitial_Trial)

% configuring 
%{
% ==== trend test ====
% t = 0:.1:10;
% trend = square(100*t) .* exp(-t.*sin(0.1*t));
% plot(trend);

%}

trackingY = sin(thresholdInitial_Trial);
%{ 
% [buggy with this example]
trackingY = square(0.005*thresholdInitial_Trial)*exp(-thresholdInitial_Trial*sin(0.1*thresholdInitial_Trial)); 
%}
% trackingY = square(100*thresholdInitial_Trial)* exp(-thresholdInitial_Trial*sin(0.1*thresholdInitial_Trial));
% trackingY = square(thresholdInitial_Trial);



