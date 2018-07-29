function out = badroute(route,wrongroutes)
out=0;
N=size(wrongroutes,2);
for i=1:size(wrongroutes,1),
	if wrongroutes(i,:)==[route,zeros(1,N-length(route))],
		out=1;
	end;
end;
