function [DateHistory, RetHistory, PortHistory, X, Y, Z ] ...
	= DJIAestimate(Asset, Date, Data, Map, Reference)
%DJIAestimate BlueChipStock estimation and analysis for DJIA period

Window = 60;

% Get stock data
StockName = Asset(:,1:end-3);
StockData = Data(:,1:end-3);
StockMap = Map(:,1:end-3);

[NumDates, NumStocks] = size(StockData);
StartPeriod = Window + 94 - 1;		% date offset for DJIA period

% Adjustments for reference (if any)
if isempty(Reference)
	RefName = [];
	RefData = [];
	AdjStockData = StockData;
elseif strcmpi(Reference,'djia')
	RefName = Asset(:,end-2);
	RefData = Data(:,end-2);
	AdjStockData = StockData - repmat(RefData,1,NumStocks);
elseif strcmpi(Reference,'sp500')
	RefName = Asset(:,end-1);
	RefData = Data(:,end-1);
	AdjStockData = StockData - repmat(RefData,1,NumStocks);
end

% Determine cumulative asset universes
StockFullMap = StockMap;
for k = 2:NumDates
	StockFullMap(k,:) = StockFullMap(k - 1,:) | StockMap(k,:);
end

NumPeriods = NumDates - StartPeriod + 1;
NumPortfolios = 40;

X = zeros(NumPeriods,NumPortfolios);	% variables for 3D efficient frontier
Y = zeros(NumPeriods,NumPortfolios);
Z = zeros(NumPeriods,NumPortfolios);

PortHistory = cell(NumPeriods,1);

% Monthly rebalancing with global universe

ii = 0;
for k = StartPeriod:NumDates
	ii = ii + 1;
	SubMap = StockFullMap(k,:);
	P = find(SubMap);
	SubName = StockName(P);
	SubData = AdjStockData(k - Window + 1:k,P);
	SubNum = size(SubData,2);
	for i = SubNum:-1:1
		if sum(isnan(SubData(:,i))) > 24
			SubMap(i) = 0;
			P(i) = [];
			SubData(:,i) = [];
			SubName(i) = [];
		end
	end
	SubNum = size(SubData,2);

	[ Mean, Covar ] = ecmnmle(SubData,[],500);

	ConSet = portcons('Default',SubNum);
	[ PortRisk, PortReturn, PortWts ] = portopt(Mean, Covar, NumPortfolios, [], ConSet);

	% Map weights into universe

	H = zeros(NumPortfolios,NumStocks);
	for i = 1:NumPortfolios
		for j = 1:SubNum
			H(i,P(j)) = PortWts(i,j);
		end
	end
	PortHistory{ii} = H;

	fprintf('%s %d assets\n',datestr(Date(k),1),SubNum);

	X(ii,:) = year(Date(k)) + (month(Date(k))/12) - 1;
	Y(ii,:) = PortRisk;
	Z(ii,:) = PortReturn;
end

Date(1:(StartPeriod - 1),:) = [];
Data(1:(StartPeriod - 1),:) = [];

DateHistory = Date;
RetHistory = Data;
