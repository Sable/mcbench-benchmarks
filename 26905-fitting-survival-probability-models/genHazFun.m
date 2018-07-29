function h = genHazFun(t,b)

% Sample general hazard function; depends on three parameters

h = b(1) + b(2)*(t./b(3)).*exp(-(t./b(3)));
