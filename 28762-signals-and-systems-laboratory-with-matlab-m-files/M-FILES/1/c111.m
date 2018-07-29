% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%  	Input/ output commands 



a=input('Insert number ')

A=input('Insert matrix ')

b=input('text ? ' , 's')

disp('The matrix is ')
disp(A)
display(A)

c=num2str(a)
d = 'The number is ';
e=[d c]; 
disp(e)

disp(['The number is ' num2str(a)])

fprintf('%s %f \n','The number is ',a)
