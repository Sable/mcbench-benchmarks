function r1 = rOneCalculation(fracFreq)
%method for caculating r1 used in identifying noise type for a giving tau
%value. input argument is array of fractrional frequency values for a given
%tau. 
%r1 = <(Zi - Zavg)*(Zi+1 - Zavg)> / <(Zi - Zavg)^2>
%Z is fractional freq values. Numerator sum is from 1 to N-1 and demonator
%is from 1 to N

avgFF = mean(fracFreq); %get average value 
N = length(fracFreq); %get number of frac freq value in array
n=0; %store numerator of r1
j=0; %store denomenator of r1

%This loop builds the numerator for r1
for i = 1:(N-1)
    if i == 1
        n = (fracFreq(i) - avgFF)*(fracFreq(i+1) - avgFF);
    else
        n = n + (fracFreq(i) - avgFF)*(fracFreq(i+1) - avgFF);
    end
end
%this loop builds the denomentor for r1
for i = 1:N
    if i == 1
        j = (fracFreq(i) - avgFF)^2;
    else
        j = j + (fracFreq(i) - avgFF)^2;
    end
end

%calculate and return r1
r1 = n/j; 
        