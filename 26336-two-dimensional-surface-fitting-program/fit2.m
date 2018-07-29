
function [A,zzz]=fit2(a,x,y,z)
% This program performs two dimentional fitting of a function z=f(x,y)to a user 
% fitting function. This user defined fitting function can be defined from
% statment 6 in the m-file "fitfit". ff=f(a,x,y) where a is an array
% representing the free fitting parameters
% The input arguments to the program are 
% 1- a which is an array representing the starting values of the free
%    fitting parmeters ( similar to that when nlinfit is used)
%    The length of a must be equal to the number of parameters used in the user 
%    defined function to be fitted (line 6 in the M-file "fitfit"
% 2- x and y are each a one dimentional array representing the independent
%    variables
% 3- z is the dependent variable matrix whose elements are functions of the
%    meshgrid values of x and y
% The out puts of the program are
% 1- The vales of the best fitted parameter 
% 2- The fitted function matrix zzz
% 3- The values of the percentage residues ( z-zfitted)
% plotss of the orignal data of z (lines) with fitted values (dots)plotted
% against x and y idependently
% The program overcomes the inablity of the standard "nlinfit" tool in matlab to perform two
% dimentional fits. This carried out by converting the matrix form of z to
% a one dimentional vector zz, merging x and y in one vector xx,filling the
% extra needed elements of xx as copared to zz with dummy numbers 999999 to
% make xx and zz suitable to be handeled by nlinfit. after performing the
% fits, the program restructures the fitted values into the matrix form.

[m,n]=size(z);
% convert z to one-D array
zz=reshape(z,1,m*n);
size(zz)
% merge x and y
xx=[x,y];
% complete xx to length(zz)
xx(length(xx)+1:m*n)=999999;
% add to extra elements to a for later use by fitfit to retrive the
% original matrix of z
N=length(a);
a(N+1)=n;
a(N+2)=m;
% perform fitting
a=nlinfit(xx,zz,'fitfit',a);
zzz=fitfit(a,xx);
N=length(a);
a(N-1:N)=[];
A=a;
subplot(2,2,1)
plot(x,z)
hold
zc=vec2mat(zzz,m);
plot(x,zc','.')
subplot(2,2,2)
plot(y,z')
hold
plot(y,zc,'.')
subplot(2,2,3)
psurface(x,y,z)
title('original data')
subplot(2,2,4)
psurface(x,y,zc')
title('fitted data')
    
    
