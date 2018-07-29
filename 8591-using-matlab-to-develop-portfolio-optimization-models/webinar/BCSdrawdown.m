%BCSDRAWDOWN BlueChipStock drawdown analysis

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
			A(j) = 0.0;
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
end

MaxDD = maxdrawdown(PortRet');
IDD = maxdrawdown(IndexRet');
IDD = repmat(IDD,1,NumPortfolios);

figure(1);
plot(MaxDD);
hold all
plot(IDD)
set(gca,'ylim',[-1 0]);
ylabel('\bfMaximum Drawdown');
xlabel('\bfPortfolio Number on Efficient Frontier');
title('\bfDrawdown of Portfolio Sequence');	
hold off
