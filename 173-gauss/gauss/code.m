function y=code(e,v)
% CODE
% CODE(e,v) creates a new variable coded with different values depending upon 
% which one of a set of logical expressions is true.
% If a row has 0's only, the corresponding element in y is filled by v's last element
% e: NxK matrix of 1's and 0's
% v: (K+1)x1 vector containing the values of the new variable.
% y: Nx1 vector containing the new values
% Example: x=[0;5;10;15;20]; v=[1;2;3]; 
% e1=x>0 & x<=5; e2=x>5 & x<=25
% e=[e1, e2]; e=[0 0; 1 0; 0 1; 0 1; 0 1]
% Output: y=[3;1;2;2;2]
y=[];
[ie je]=size(e);
if sum(e') >= 2;
   error('Vector e has too many ones for CODE');
end
[a b]=find(e==1);
t=sparse(a,1,v(b,1));
y=full(t); 
y(y==0)=v(rows(v),1);
