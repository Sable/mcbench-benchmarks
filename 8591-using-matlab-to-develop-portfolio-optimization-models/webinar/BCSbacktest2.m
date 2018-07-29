%BCSBACKTEST2 BlueChipStock backtest analysis

addpath ./source

load BlueChipBacktest0
load BlueChipBacktest

RefIndex = 45;

% no adjustment
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

PortRet = ones(NumPortfolios, NumPeriods);
IndexRet = ones(1,NumPeriods);
T = zeros(NumPeriods,1);

for k = 1:NumPeriods
	istart = iend;
	iend = istart + Periodicity;

	T(k) = year(DateHistory(iend)) + (month(DateHistory(iend))/12) - 1;
	
	% calculate asset returns at specified periodicity
	
	A = ones(NumAssets,1);
	for i = (istart+1):iend
		for j = 1:NumAssets;
			A(j) = A(j) * (1.0 + RetHistory0(i,j));
		end
	end
	
	for j = 1:NumAssets
		if isnan(A(j))
			A(j) = 0.0;		% do this to avoid extra loops below
		end
	end
	
	% calculate portfolio returns at specified periodicity periodicity
	
	H = PortHistory0{istart};
	
	P = H * A(1:NumStocks);

	if (k > 1)
		for i = 1:NumPortfolios
			PortRet(i,k) = PortRet(i,k - 1) * P(i);
		end
		IndexRet(k) = IndexRet(k - 1) * A(RefIndex);
	end
end

X = zeros(NumPeriods,NumPortfolios);
Y = zeros(NumPeriods,NumPortfolios);
Z = zeros(NumPeriods,NumPortfolios);

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = PortRet(i,k);
	end
end

figure(1);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
hold all
ylabel('\bfPortfolio Sequence');
zlabel('\bfTotal Return Price');
title('\bfRealized Performance of Portfolios along Efficient Frontier (Absolute)');
camlight right;
view(40,40);
hold off

i = input('Continue > ');

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = PortRet(i,k) - IndexRet(k);
	end
end

figure(1);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
hold all
ylabel('\bfPortfolio Sequence');
zlabel('\bfDifference in Cumulative Value');
title('\bfDfference in Realized Performance of Portfolios along Efficient Frontier');
camlight right;
view(40,40);

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = 0.0;
	end
end
surf(X,Y,Z,'FaceColor','b','EdgeColor','none','FaceAlpha',0.3);
hold off

i = input('Continue > ');

% relative

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
T = zeros(NumPeriods,1);

for k = 1:NumPeriods
	istart = iend;
	iend = istart + Periodicity;

	T(k) = year(DateHistory(iend)) + (month(DateHistory(iend))/12) - 1;
	
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
	
	% calculate portfolio returns at specified periodicity periodicity
	
	H = PortHistory{istart};
	
	P = H * A(1:NumStocks);

	if (k > 1)
		for i = 1:NumPortfolios
			PortRet(i,k) = PortRet(i,k - 1) * P(i);
		end
		IndexRet(k) = IndexRet(k - 1) * A(RefIndex);
	end
end

X = zeros(NumPeriods,NumPortfolios);
Y = zeros(NumPeriods,NumPortfolios);
Z = zeros(NumPeriods,NumPortfolios);

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = PortRet(i,k);
	end
end

figure(1);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
hold all
ylabel('\bfPortfolio Sequence');
zlabel('\bfTotal Return Price');
title('\bfRealized Performance of Portfolios along Efficient Frontier (Relative to DJIA)');
camlight right;
view(40,40);
hold off

i = input('Continue > ');

% difference

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = PortRet(i,k) - IndexRet(k);
	end
end

figure(1);
surf(X,Y,Z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
hold all
ylabel('\bfPortfolio Sequence');
zlabel('\bfDifference in Cumulative Value');
title('\bfDfference in Realized Performance of Portfolios along Efficient Frontier');
camlight right;
view(40,40);

for k = 1:NumPeriods
	for i = 1:NumPortfolios
		X(k,i) = T(k);
		Y(k,i) = i;
		Z(k,i) = 0.0;
	end
end

surf(X,Y,Z,'FaceColor','b','EdgeColor','none','FaceAlpha',0.3);
hold off
