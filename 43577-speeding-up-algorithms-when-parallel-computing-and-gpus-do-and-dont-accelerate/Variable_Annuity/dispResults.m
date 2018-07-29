function dispResults(method, payout, fees, probRuin, time)
% A Helper function to conveniently display the result of various methods.
% Call it with the syntax "dispResults('header') to get just the column
% headers.

if strcmp(method, 'header')
    str = sprintf('% 20s % 10s % 10s % 10s % 10s', 'Method:', 'Payout:', 'Fees:', 'P(Ruin):', 'Time:');
else
    str = sprintf('% 20s % 10.2f % 10.2f % 10.2f % 10.1f', method, payout, fees, probRuin, time);
end

disp(str)