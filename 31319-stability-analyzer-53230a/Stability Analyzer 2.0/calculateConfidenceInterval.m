function [maxCI minCI] = calculateConfidenceInterval(tau, sPeriod, rCount,alpha,stabDev)
%This function calculates max and min confidence intervals for the XDEV
%calculation. The method used is found in the NIST Handbook of Frequency
%Stability Analysis page 37 section 5.3.1. tau is the array of tau values
%used in the stability calculation. Sample Period is used to calculate the
%number of values used in a particular tau calculation. rCount is the
%number of total readings at the sample period. alpha is an array of values
%for determine power law noise type. stabDev is the array of XDEV
%calculations.

tCount = length(tau); %get total number of calculations
maxCI = zeros(1,tCount); %initiate arrays
minCI = zeros(1,tCount);

for i = 1:tCount %for number of calculations
    avgCount = tau(i) / sPeriod; %gets count for averaging
    vCount = rCount / avgCount; %get number of loop iterations needed
    vCount = floor(vCount); %convert loopCount to integer in case it is a non int

    %perform confidence interval calculation based on noise type
    if alpha(i) >= 1.5 %dominant noise type is white PM
        temp = .99*(stabDev(i)/sqrt(vCount));
    elseif alpha(i) < 1.5 && alpha(i) >= .5 %dominant noise type is flicker PM
        temp = .99*(stabDev(i)/sqrt(vCount));
    elseif alpha(i) < .5 && alpha(i) >= -.5 %dominant noise type is white FM
        temp = .87*(stabDev(i)/sqrt(vCount));
    elseif alpha(i) < -.5 && alpha(i) >= -1.5 %dominant nosie type is flicker FM
        temp = .77*(stabDev(i)/sqrt(vCount));
    else %dominant noise type is random walk FM
        temp = .75*(stabDev(i)/sqrt(vCount));
    end

    %set min and max confidence limits
    maxCI(i) = stabDev(i) + temp;
    minCI(i) = stabDev(i) - temp;

end