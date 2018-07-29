%This code implements the shooting method for solving 1D boundary value problem (abbrev. BVP ODE). 
%It uses the Runge-Kutta method of 4th order for solving ODE and the interval bisection method for finding the alpha parameter. 
%
%The meaning of input and output parameters: 
%x - grid of points where the solution have been found
%y - 2D array, values of function (solution) are in first row, values of
%    1st derivative are in second row
%fun - the function handle, fun contains system of solved differential
%      equations, e.g. let y'' + y = sqrt(x+1) be the solved differential
%      equation, then fun has the shape:
%      function out = fce(x,y)
%         out(1) = y(2);
%         out(2) = sqrt(x+1)-y(1);
%h - the step of the Runge-Kutta method (the step of the grid)            
%zero - the interval bisection method accuracy, it is recommended to set 1e-6 
%a,b - outer points of the interval
%con - values of boundary conditions (2D vector)
%type - to specify type of the boundary condition in the particular point,
%       it is the string consists of 2 char ('f' for function, 'd' for
%       derivative), e.g 'fd' is meant that in a point the condition is
%       related to function and in the b point to derivative
%init - 2D vector of initial alpha parameters, it is not required, the implicit
%       value is [-10 10]
%
%The ploting of the solution:
%The solution (both function and 1st derivative) of BVP ODE is shown graphicaly after enumeration.
%
%The example of using:
%[x y] = shooting_method(fun,0.001,1e-6,0,1,[1 3],'fd')  
%It is meant that will be solved the BVP ODE described in the function fun,
%on the interval (0,1) with boundary conditions y(0) = 1 and y'(1) = 3



function [x y] = shooting_method(fun,h,zero,a,b,con,type,init)  
    tic;
    if (h <= 0) || (zero <= 0) || (a>=b) || (length(con) ~= 2) || (length(type) ~= 2)
        error('Check validity of input parameters - non-negative of accuracy and length of arrays');
    end

    if nargin == 8
        shoot1 = init(1); shoot2 = init(2);
    else
        shoot1 = -10; shoot2 = 10;
    end
    
    if (type(1)=='f')
        a1 = [con(1) shoot1];
        a2 = [con(1) shoot2];
    else
        a1 = [shoot1 con(1)];
        a2 = [shoot2 con(1)];
    end  
    
    
    [~, F1] = RungeKutta(a,b,h,a1,fun); 
    [~, F2] = RungeKutta(a,b,h,a2,fun);         
    
    if (type(2)=='f')
        F1 = F1(1,end) - con(2);
        F2 = F2(1,end) - con(2);
        r = 1;
    else
        F1 = F1(2,end) - con(2); 
        F2 = F2(2,end) - con(2);
        r = 2;
    end    
    
    if (F1*F2 > 0) 
        error('The root of F function does not exist, for selected initialization parameters. Please, change the init array.')
    end
    
    F3 = F1;
    
    while (abs(F3) > zero) 
        
        shoot3 = (shoot1 + shoot2)/2; 
        
        if (type(1)=='f')
           a3 = [con(1) shoot3];            
        else
           a3 = [shoot3 con(1)];            
        end           
        
        [x, F3] = RungeKutta(a,b,h,a3,fun); y = F3; F3 = F3(r,end) - con(2); 
        if (F1*F3 < 0)
            shoot2 = shoot3; F2 = F3;            
        elseif (F1*F2 < 0)
            shoot1 = shoot3; F1 = F3;
        else
            error('Selhani metody puleni intervalu, zmente init');           
        end
    end           
        
    h = plot(x,y(1,:),'k-'); set(h,'linewidth',2);
    hold on;
    h = plot(x,y(2,:),'r-'); set(h,'linewidth',2);  
    xlabel('{\it x}','FontSize',12);
    ylabel('y({\it x }), y^{(1)}({\it x })','FontSize',12);
    title('Solution of 1D Boundary Value Problem by Shooting Method','FontSize',12);    
    set(gca,'FontSize',12);          
    legend('Function','{1^{st}} Derivative','Location','Best');       
    hold off;
    toc;