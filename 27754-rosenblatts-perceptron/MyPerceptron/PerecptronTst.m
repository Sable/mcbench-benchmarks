function e=PerecptronTst(x,y,w,b);
%==========================================
% Testing phase
%==========================================
tic
[l,p]=size(x);
e=0; % number of test errors
for i=1:l          
    xx=x(i,:); % take one row
    ey=xx*w+b; % apply the perceptron classification rule
    if ey>=0.5 
       ey=1;
    else
       ey=0;
    end
    if y(i)~=ey;
       e=e+1;
    end;
end
toc