function [sqn]=DIfactor(func,flag)
%% First-Order Degree Linear Differential Equation's Solution
%% (Integration multipler Ig=x^a*y^b)
% 
% Generally total homogeneous differential equations 
% M(x,y)dx + N(x,y)dy = 0 
%
% [Solution]=DIfactor.m([M(x,y),N(x,y)],flag)
% 
% M(x,y): possible a function f(x,y)
% N(x,y): possible a function f(x,y)
% flag  : if flag=1 than perceived all solution application else
%         solution be small. 
%
% In this differential function's integration factor Ig=x^a*y^b
%
% Example: Non-homogeneous differantial euqation be possible
%         [M(x,y)*Ig]*dx + [N(x,y)*Ig]*dy = 0   homogeneous form
%
%         [3*y^3-x*y]dx - [x^2+6*x*y^2]dy = 0 non-homogeneous form
%   
%Inetegration multipler  Ig=x^{-2}*y^{-1} than
%
%         [3*y^3-x*y]*[Ig]*dx - [x^2+6*x*y^2]*[Ig]dy = 0 
%                                              homogeneous form



syms x y a b c real


if isempty(func) 
    error('Differential equation is not selected')
end

squ=x^a*y^b;

%% Differential equation components
% f[] = func1(x,y)*diff(x,1)+func2(x,y)*diff(y,1)=0

fprintf(' ==============TOTAL LINEAR DIFFERENTIAL EQUATION (One order degree) \n ');
fprintf('f[] = func1(x,y)*diff(x,1)+func2(x,y)*diff(y,1)=0 and f[]=0 =>  \n\n');
fprintf(' f[] = ');
disp( func(1)*maple('map','del',x,1)+ ...  %M(x,y)
      func(2)*maple('map','del',y,1))      %N(x,y)
fprintf('  \n\n ');
     
     



%% Main equation's control for probability total differential equation
cont = func(1)*diff(squ,y,1)- ... &[d/dy]M(x,y)-[d/dx]N(x,y)=0
       func(2)*diff(squ,x,1) ;

   
if flag==1
fprintf('==========================TOTAL DIFFERENTIAL EQUATION CONTROL \n');
fprintf(' [d/dy]M(x,y) =  '),disp(diff(func(1),y,1))
fprintf(' [d/dx]N(x,y) =  '),disp(diff(func(2),x,1))
fprintf(' [d/dy]M(x,y)-[d/dx]N(x,y) =  '),disp(factor(diff(func(1),y,1)-diff(func(2),x,1)))
end

if factor(cont)==0
   fprintf(' Differential equation conforming the total diff. \n');
else
   fprintf(' Differential equation non-conforming & selected integral multipler Ig=x^a*y^b ');
end
fprintf('  \n\n\n ');


%% Solution Ix=x^a*y^b (a,b) integral multiplers
%Dq1 = diff(func(1)*x^a*y^b,y,1)
%Dq2 = diff(func(2)*x^a*y^b,x,1)
%Dqn = Dq1-Dq2



A1 = solve(...
     subs(diff(func(1)*x^a*y^b,y,1),{x,y},{0.1,0.2})- ...
     subs(diff(func(2)*x^a*y^b,x,1),{x,y},{0.1,0.2})  ...
     ,a);

B1 = solve(...
     subs(diff(func(1)*x^a*y^b,y,1),{x,y},{0.1,0.2})- ...
     subs(diff(func(2)*x^a*y^b,x,1),{x,y},{0.1,0.2})  ...
     ,b);
 
          %unknown coefficient a
Const = [ solve(subs(diff(func(1)*x^a*y^b,y,1)- ...
                     diff(func(2)*x^a*y^b,x,1),{b},{B1}),a)    
          solve(subs(diff(func(1)*x^a*y^b,y,1)- ...
                     diff(func(2)*x^a*y^b,x,1),{a},{A1}),b) ]; 
          %unknown coefficient b


%Integrate multipler
Ig=x^Const(1)*y^Const(2);

lastcont=factor( ...
                                diff(func(1)*Ig,y,1)- ...
                                diff(func(2)*Ig,x,1) ) ;
                            
if flag==1
fprintf('=======================DIFFERENTIAL EQUATION CONFORMING FORM \n');
fprintf(' Integrate multipler Ig =x^a*y^b=>  ') , disp(simplify(Ig));
fprintf(' [d/dy]M(x,y)*Ig =  ')                 , disp(diff(func(1)*Ig,y,1));
fprintf(' [d/dx]N(x,y)*Ig =  ')                 , disp(diff(func(2)*Ig,x,1));
fprintf(' [d/dy]M(x,y)*Ig-[d/dx]N(x,y)*Ig =  ') , disp(lastcont);
end

if factor(lastcont)==0
if flag==1
    fprintf(' Differential equation conforming the total diff. \n');
end
else
   error(' Differential equation non-conforming this solution method ');
end
fprintf('  \n\n\n ');

fi = factor(func(2)*Ig-diff(int(func(1)*Ig),y,1)) ;

if fi ==0
    In=0;
else
    In=int(fi,y);
end

basicsolution=int(func(1)*Ig)+In;


fprintf('=======================DIFFERENTIAL EQUATION SOLUTION \n');
fprintf(' nU(x,y)= int [M(x,y)*Ig*dx] + Q(y) => \n \n');
fprintf(' [d/dy]nU(x,y)=N(x,y)=> [d/dy].[int [M(x,y)*Ig*dx] + Q(y)]=N(x,y)  \n \n');
if In==0
fprintf(' partial integration solution Q(y)= '),disp(c);
else
fprintf(' partial integration solution Q(y)= '),disp(In);    
end
fprintf(' Solution  = '),disp(simplify(basicsolution)+c);






