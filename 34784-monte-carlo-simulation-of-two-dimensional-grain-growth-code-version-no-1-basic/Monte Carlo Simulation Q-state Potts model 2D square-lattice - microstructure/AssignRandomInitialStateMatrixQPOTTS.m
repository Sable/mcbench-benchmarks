function state = AssignRandomInitialStatematrix(x,Q);

state=floor(1+Q*rand(size(x,1),size(x,1)));