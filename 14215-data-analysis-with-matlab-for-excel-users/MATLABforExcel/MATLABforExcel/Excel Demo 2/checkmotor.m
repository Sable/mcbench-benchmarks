function result = checkmotor(rpm, motordata)
% This function is used to determine how closely the noise profile of new
% motors matched our benchmark profile.  It also determines whether
% test-to-test differences are significant.
%
% Load exponential model bounds

% Copyright 2006-2009 The MathWorks, Inc.

load bounds.mat

% Plot new motor's noise with benchmark data
plot(rpm,[lowerbound upperbound],':r','LineWidth',1.5); hold on
plot(rpm,motordata,'.-');title('Motor Noise Compared with Benchmark')
xlabel('Motor speed (rpm)');ylabel('Noise (dBA)');ylim([67 72]);

% Determine upper and lower bounds of benchmark model
[a,b] = size(motordata);
upperdelta = repmat(upperbound,1,b) - motordata;
lowerdelta = repmat(lowerbound,1,b) - motordata;

% Determine percentage of measurements that land within 95% confidence
% bounds of motor
count = 0;
for k = 1:b
for i = 1:a
    if (upperdelta(i,k) < 0) || (lowerdelta(i,k) > 0)
        count = count + 1;
    end
end
end
percentage = round([1 - (count/(a*b))]*100);

% Find P-value to determine whether there are test-to-test differences
ind = find(rpm >= 7700);
motorflat = motordata(ind,:);
[pval,table,stats] = anova1(motorflat,{'Test 1';'Test 2';'Test 3';'Test 4'},'off');

result = [num2str(percentage),...
    '% of the measurements are within the 95% confidence range of the benchmark model.  The P-value of the hypothesis that all tests are the same is ', ...
    num2str(pval)];
