function [sales,salesb] = cashflow(data,NTrials,SYear)

prod = data(3,2:end);
grade = data(6,2:end);
rec = data(7,2:end);
produced = prod.*grade.*rec;

produced2 = repmat(produced,NTrials,1)';
sales = produced2.*SYear; 
salesb = produced.*108;
