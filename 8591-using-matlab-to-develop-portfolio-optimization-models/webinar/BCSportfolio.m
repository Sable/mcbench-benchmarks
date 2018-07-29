%BCSPORTFOLIO BlueChipStock portfolio sequence

addpath ./source

load BlueChipBacktest0
load BlueChipBacktest

[NumMonths, NumAssets] = size(RetHistory);
NumStocks = NumAssets - 3;

NumPortfolios = 40;

while 1
	PortNum = input('Pick a portfolio from 1 to 40 (0 to exit) > ');
	if isempty(PortNum) || (PortNum < 1) || (PortNum > NumPortfolios)
		break
	end

	fprintf(1,'\n');
	fprintf(1,'Portfolio Sequence %d along Efficient Frontier\n',PortNum);
	fprintf(1,'Absolute Total Return Portfolio ...\n');

	P = find(PortHistory0{end}(PortNum,:) > 1.0e-4);
	for i = 1:numel(P)
		fprintf(1,'%4s: %5.2f %% ',Asset{P(i)},100.0 * PortHistory0{end}(PortNum,P(i)));
		if mod(i,6) == 0
			fprintf(1,'\n');
		end
	end
	fprintf(1,'\n');

	fprintf(1,'Relative Total Return Portfolio (vs DJIA) ...\n');
	ii = 0;
	P = find(PortHistory{end}(PortNum,:) > 1.0e-4);
	for i = 1:numel(P)
		fprintf(1,'%4s: %5.2f %% ',Asset{P(i)},100.0 * PortHistory{end}(PortNum,P(i)));
		if mod(i,6) == 0
			fprintf(1,'\n');
		end
	end
	fprintf(1,'\n');
end
