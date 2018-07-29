		% Introducerea nodurilor
x=0:10	
y=[0 2 NaN 2 1 6 9 NaN 3 9 9]
		% Filtrarea celor doi vectori
x1=x(~isnan(y))
y1=y(~isnan(y))