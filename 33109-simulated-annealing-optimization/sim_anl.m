function [x0,f0]=sim_anl(f,x0,l,u,Mmax,TolFun)
%sim_anl Minimizes a function with the method of simulated annealing (Kirkpatrick et al., 1983) [1]
% 
% 
% INPUTS: 
%        f = a function handle
%        x0 = a ninitial guess for the minimun
%        l = a lower bound for minimun
%        u = a upper bound for minimun
%        Mmax = maximun number of temperatures
%        TolFun = tolerancia de la función
%
%
% OUTPUTS: 
%        x0 = candidate to global minimun founded
%        f0 = value of function on x0
%
%
% Example [2]:
%
%  The six-hump camelback function:
%  camel= @(x)(4-2.1*x(1).^2+x(1).^4/3).*x(1).^2+x(1).*x(2)+4*(x(2).^2-1).*x(2).^2;
%  has a doble minimun at f(-0.0898,0.7126) = f(0.0898,-0.7126) = -1.0316
%  this code works with it as follows:
%  [x0,f0]=sim_anl(camel,[0,0],[-10,-10],[10,10],400)
%  and we get:
%  x0=[-0.0897 0.7126]
%
%  References:
%  [1] Kirkpatrick, S., Gelatt, C.D., & Vecchi, M.P. (1983). Optimization by
%      Simulated Annealing. _Science, 220_, 671-680.
%
%  [2] Joachim Vandekerckhove, General simulated annealing algorithm, Taken on the 30th of September 2011.
%      http://www.mathworks.de/matlabcentral/fileexchange/10548
%
%
%  [3] Won Y. Yang, Wenwu Cao, Tae-Sang Chung, John Morris, "Applied
%      Numerical Methods Using MATLAB", John Whiley & Sons, 2005
%
%
%  [4] 1108 - Troubleshooting Common Floating-Point Arithmetic Problems. Taken on the 3th of October 2011.
%      http://www.mathworks.es/support/tech-notes/1100/1108.html
%
%  [5] Peter N. Saeta, The Metropolis Algorithm. Taken on the 3th of October 2011.
%      http://kossi.physics.hmc.edu/courses/p170/Metropolis.pdf
%
%
%This function was written by :
%                             Héctor Corte
%                             B.Sc. in physics 2010
%                             Battery Research Laboratory
%                             University of Oviedo
%                             Department of Electrical, Computer, and Systems Engineering
%                             Campus de Viesques, Edificio Departamental 3 - Office 3.2.05
%                             PC: 33204, Gijón (Spain)
%                             Phone: (+34) 985 182 559
%                             Fax: (+34) 985 182 138
%                             Email: cortehector@uniovi.es
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<6
   TolFun=1e-4;
   if nargin<5
       Mmax=100;
   end
end
%x0 is the current solution point and f0=f(x0).
%x is the current point and fx=f(x)
%x1 is the test point and fx1=f(x1)
%Our initial current point will be the current solution point
x=x0;fx=feval(f,x);f0=fx;
%Main loop simulates de annealing from a high temperature to zero in Mmax iterations.
for m=0:Mmax
    %We calculate T as the inverse of temperature.
    %Boltzman constant = 1
    T=m/Mmax; 
    mu=10^(T*100);    
    %For each temperature we take 500 test points to simulate reach termal
    %equilibrium.
    for k=0:500        
        %We generate new test point using mu_inv function [3]        
        dx=mu_inv(2*rand(size(x))-1,mu).*(u-l);
        x1=x+dx;
        %Next step is to keep solution within bounds
        x1=(x1 < l).*l+(l <= x1).*(x1 <= u).*x1+(u < x1).*u;
        %We evaluate the function and the change between test point and
        %current point
        fx1=feval(f,x1);df=fx1-fx;
        %If the function variation,df, is <0 we take test point as current
        %point. And if df>0 we use Metropolis [5] condition to accept or
        %reject the test point as current point.
        %We use eps and TolFun to adjust temperature [4].        
        if (df < 0 || rand < exp(-T*df/(abs(fx)+eps)/TolFun))==1
            x=x1;fx=fx1;
        end        
        %If the current point is better than current solution, we take
        %current point as cuyrrent solution.       
        if fx1 < f0 ==1
        x0=x1;f0=fx1;
        end   
    end
end
end

function x=mu_inv(y,mu)
%This function is used to generate new point according to lower and upper
%and a random factor proportional to current point.
x=(((1+mu).^abs(y)-1)/mu).*sign(y);
end