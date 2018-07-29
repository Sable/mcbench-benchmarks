function y=missex(x,e)
% MISSEX  
% MISSEX(x,e) converts values to the missing value code NaN according to the values 
% given in a logical expression.
% x: NxK matrix
% e: NxK matrix of 0's and 1's), the 1's in e correspond to the values in x that are to be
% converted into missing values
y=x.*(~e);
y(y==0)=NaN;

