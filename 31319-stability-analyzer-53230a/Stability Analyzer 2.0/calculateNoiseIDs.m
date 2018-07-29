function alpha = calculateNoiseIDs(readings,tau,sPeriod)
%this fuction calculates an array of noise types (alpha's) for an input set
%or readings and tau values.

alpha = zeros(1,length(tau));

for i = 1:length(tau)
     temp = calculateAvgArray(tau(i),sPeriod,readings);
      alpha(i) = calculateNoiseType(temp);
 end