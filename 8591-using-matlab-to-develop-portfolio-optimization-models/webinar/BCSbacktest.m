%BCSBACKTEST BlueChipStock backtest analysis

addpath ./source

load BlueChipBacktest

RefIndex = 45;

[NumMonths, NumAssets] = size(RetHistory);
NumStocks = NumAssets - 3;

NumPortfolios = 40;
Periodicity = 12;

NumPeriods = floor(NumMonths/Periodicity);
StartIndex = NumMonths - NumPeriods * Periodicity;
if StartIndex < 1
	NumPeriods = NumPeriods - 1;
	StartIndex = StartIndex + Periodicity;
end
EndIndex = NumMonths;

iend = StartIndex;

PortRet = ones(NumPortfolios, NumPeriods);
IndexRet = ones(1,NumPeriods);

MeanPortRet = zeros(NumPortfolios,1);
StdPortRet = zeros(NumPortfolios,1);

MeanIndexRet = 0.0;
StdIndexRet = 0.0;

for k = 1:NumPeriods
	istart = iend;
	iend = istart + Periodicity;
	
	% calculate asset returns at specified periodicity
	
	A = ones(NumAssets,1);
	for i = (istart+1):iend
		for j = 1:NumAssets;
			A(j) = A(j) * (1.0 + RetHistory(i,j));
		end
	end
	
	for j = 1:NumAssets
		if isnan(A(j))
			A(j) = 0.0;		% do this to avoid extra loops below
		end
	end
	
	% calculate portfolio returns at specified periodicity
	
	H = PortHistory{istart};
	P = H * A(1:NumStocks);

	if (k > 1)
		for i = 1:NumPortfolios
			PortRet(i,k) = PortRet(i,k - 1) * P(i);
		end
		IndexRet(k) = IndexRet(k - 1) * A(RefIndex);
	end
	
	for i = 1:NumPortfolios
		MeanPortRet(i) = MeanPortRet(i) + P(i);
		StdPortRet(i) = StdPortRet(i) + P(i)*P(i);
	end
	
	MeanIndexRet = MeanIndexRet + A(RefIndex);
	StdIndexRet = StdIndexRet + A(RefIndex)*A(RefIndex);
end

for i = 1:NumPortfolios
	MeanPortRet(i) = MeanPortRet(i)/NumPeriods;
	StdPortRet(i) = StdPortRet(i)/NumPeriods - MeanPortRet(i)*MeanPortRet(i);
	StdPortRet(i) = sqrt(StdPortRet(i));
	MeanPortRet(i) = MeanPortRet(i) - 1.0;
end

MeanIndexRet = MeanIndexRet/NumPeriods;
StdIndexRet = StdIndexRet/NumPeriods - MeanIndexRet*MeanIndexRet;
StdIndexRet = sqrt(StdIndexRet);
MeanIndexRet = MeanIndexRet - 1.0;

figure(1);
scatter(StdPortRet,MeanPortRet);
hold all
scatter(StdIndexRet,MeanIndexRet,[],'r*');
ylabel('\bfMean of Total Returns (Annualized)');
xlabel('\bfStd. Dev. of Total Returns (Annualized)');
title('\bfRealized Mean-Variance Performance (DJIA Benchmark)');
hold off
