%% The Optimal ITAE Transfer Functions for Step Input
% Revisit the optimal ITAE transfer function for step input using numerical
% optimization and digital computer.
%% Introduction
% The Integral of Time miltiply by Absolute Error (ITAE) index is a popular
% performance criterion used for control system design. The index was
% proposed by Graham and Lathrop (1953), who derived a set of normalized  
% transfer function coefficients from 2nd-order to 8th-order to minimize
% the ITAE criterion for a step input. Since then, this set of coefficients
% has been widely used as a System Prototype for control system design to
% minimize the ITAE criterion. The most recent example is the MATLAB File
% Exchange submission by Dr. Duane Hanselman, 
% <http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14104&objectType=FILE System Prototype for ITAE Optimum Step Response>.
% Many authors have adopted the coefficient table as a standard material in
% Control Engineering textbooks, such as "Modern Control Systems" by 
% R.D. Dorf and R.H. Bishop, 9th edition, Prentice-Hall, Inc., 2001.
%
% The orginal coefficients was derived through an analog computer. Hence,
% thier optimality is questionable particularly for large order systems.
% The set of coefficient has been revisited by the author in 1989 and a new set
% of coefficients has been derived using numerical optimization techniques
% in a digital computer. The new coefficients lead to much lower ITAE
% criteria. Unfortunately, the work was published in a Chinese journal. Little
% attention had been drawn since then. 
%
% This submission is inspired by Dr. Hanselman's submission, where the old 
% non-optimal coefficients were used to calculate the prototype systems.
% The function, optimitaestep, reproduces the results obtained about 20
% years ago, using MATLAB Optimization Toolbox.
%
%% References
% 1. D. Graham and R.C. Lathrop, "The Synthesis of Optimum Response: Criteria
%    ans Standard Forms, Part 2", Transactions of the AIEE 72, Nov. 1953, pp. 273-288
%
% 2. Y. Cao, "Correcting the minimum ITAE standard forms of 
%    zero-displaceemnt-error systems", Journal of Zhejiang University 
%    (Natural Science) Vol. 23, N0o.4, pp. 550-559, 1989.
%% The new set of coefficients of the optimal ITAE transfer functions
p=cell(7,1);
p1=cell(7,1);
f=zeros(7,1);
f1=zeros(7,1);
for n=2:8
    [p{n-1},f(n-1),p1{n-1},f1(n-1)]=optimitaestep(n);
end
fprintf('\n\n New ITAE coefficients:\n')
for n=2:8
    fprintf('\n Order = %i, ITAE = %g\n    ',n,f(n-1))
    fprintf('%7.3f  ',p{n-1});
end
fprintf('\n\n Old ITAE coefficients:\n')
for n=2:8
    fprintf('\n Order = %i, ITAE = %g\n    ',n,f1(n-1))
    fprintf('%7.3f  ',p1{n-1});
end
fprintf('\n');
%% Step response comparison
% Using the Davision fast simulation approach developed by
% E.J. Davision, An algorithm for the computer simulation of very large
% dynamic systems, Automatica, 9(6): 665-675, 1973.

dt=0.01;
tf=20;
t=(0:dt:tf)';
N=numel(t);
y=zeros(N,7);
for n=1:7
    A=[zeros(n,1) eye(n);fliplr(-p{n}(2:end))];
    B=[zeros(n,1);1];
    A=expm([A B;zeros(1,n+2)]*dt);
    x=[zeros(n+1,1);1];
    for k=1:N
        x=A*x;
        y(k,n)=x(1);
    end
end
y1=zeros(N,7);
for n=1:7
    A=[zeros(n,1) eye(n);fliplr(-p1{n}(2:end))];
    B=[zeros(n,1);1];
    A=expm([A B;zeros(1,n+2)]*dt);
    x=[zeros(n+1,1);1];
    for k=1:N
        x=A*x;
        y1(k,n)=x(1);
    end
end
subplot(211)
plot(t,y,'Linewidth',2)
grid
title('Step Response of Systems with New Coefficients') 
subplot(212)
plot(t,y1,'Linewidth',2)
grid
title('Step Response of Systems with Old Coefficients') 
