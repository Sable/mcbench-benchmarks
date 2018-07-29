% By Sherif A. Tawfik, Faculty of Engineering, Cairo University
function e= err(x,fun, A, first)

% the polynomial coefficients array , make it a column array
A=A(:);  

% the argument array , make it a column array
x=x(:);   

% order of the polynomial is equal to the number of coefficients minus one
order=length(A)-1; 

% the powers out in a row and repeated for each argument to form a matrix
% for example if the order is 2 and we have 3 arguments in x then
%         [0 1 2]
% powers= [0 1 2]
%         [0 1 2] 
powers=ones(length(x),1)*[0:order]; 

% each argument is repeated a number of times equal to the number of
% coefficients to form a row then each element of the resulting row is
% raised with the corresponding power in the powers matrix
temp=((x-first)*ones(1,order+1)).^powers;

% multiply the resulting matrix with the coefficients table in order to
% obtain a column array. Each element of the resulting array is equal to
% the polynomial evaluated at the distance between the corresponding
% argument and the start of the interval
temp=temp*A;

% the error vector is then given as the difference between the function
% evaluated at the argument array and the polynomial evaluated at the
% argument array
e=feval(fun,x)-temp;