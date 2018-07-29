function MaxDD = maxdrawdown(Data)
%MAXDRAWDOWN Calculate maximum drawdown for one or more total return price series

[T, N] = size(Data);

MaxDD = zeros(1,N);

for i = (T - 1):-1:1
	for j = 1:N
		DD(j) = (min(Data(i:T,j)) - Data(i,j))/Data(i,j);
	end
	p = find(DD < MaxDD);
	MaxDD(p) = DD(p);
end
