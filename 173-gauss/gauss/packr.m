function y=packr(x)
% PACKR
% PACKR(x) deletes all the rows of x that contain a MATLAB missing element (NaN)
t=isnan(x);
c=sum(t')'==0;
y=x(c==1,:);