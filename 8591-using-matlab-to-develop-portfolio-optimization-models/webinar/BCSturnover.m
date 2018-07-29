%BCSTURNOVER BlueChipStock turnover analysis

addpath ./source

load BlueChipBacktest0
load BlueChipBacktest

% Total returns
[NumMonths, NumAssets] = size(RetHistory0);
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

Turnover = zeros(NumPortfolios,1);

for k = 1:NumPeriods
	istart = iend;
	iend = istart + Periodicity;
	
	H = PortHistory0{istart};

	if (k > 1)
		for i = 1:NumPortfolios
			T = 0.0;
			for j = 1:NumStocks
				T = T + abs(H(i,j) - H0(i,j));
			end
			Turnover(i) = Turnover(i) + 0.5 * T;
		end
	end	
	H0 = H;
end

Turnover0 = Turnover / NumPeriods;

% Relative returns
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

Turnover = zeros(NumPortfolios,1);

for k = 1:NumPeriods
	istart = iend;
	iend = istart + Periodicity;
	
	H = PortHistory{istart};

	if (k > 1)
		for i = 1:NumPortfolios
			T = 0.0;
			for j = 1:NumStocks
				T = T + abs(H(i,j) - H0(i,j));
			end
			Turnover(i) = Turnover(i) + 0.5 * T;
		end
	end	
	H0 = H;
end

Turnover = Turnover / NumPeriods;

figure(1);
plot(Turnover0,'-ro','MarkerFaceColor',[1 0 0 ],'MarkerSize',3);
hold all
plot(Turnover,'-bo','MarkerFaceColor',[0 0 1 ],'MarkerSize',3);
legend('Absolute','Relative','Location','SouthEast');
ylabel('\bfTurnover (Annual)');
xlabel('\bfPortfolio Sequence');
title('\bfAverage Turnover of Portfolio Sequence Along Efficient Frontier');
hold off
