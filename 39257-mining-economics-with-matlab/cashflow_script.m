%% CASH FLOW 
% Imports the production paramaters of the mine & multiplies them by Iron
% Ore Price simulations.

%% Importing Cash Flow Parameters
[data,txt,raw] = xlsread('demomining.xlsm','B3:K31');
prod = data(3,2:end);
grade = data(6,2:end);
rec = data(7,2:end);

%% Calculating Sales
produced = prod.*grade.*rec;
produced2 = repmat(produced,1000,1)';
sales = produced2.*SYear; % Sales = Produced x Iron Ore Price simulations
salesb = produced.*108; % base case of $108 per tonne

%% Histogram of yearly sales
binloc =[0:1e6:20e6];
figure
for i = 1:years
    subplot(years/2,2,i)
    sm = mean(sales(i,:));
    hist(sales(i,:),20)
    hold on
    plot(sm,0,'ro')
    title(['Histogram of ',num2str(NTrials),' of Year: ',num2str(i),' of Iron Ore Cashflow'])
    xlabel('Sales $''000')
end
