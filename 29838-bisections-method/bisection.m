function p_min=bisection(func,int,iter,tol_x,tol_f)
% It calculates the zero of a regular real function with one variable.
% p_min is the solution and represents the abscissa's value of the zero.
% The input variables are:
% -func: it's a string that represents the function in the variable 'x'.
% -int: it's a vector with two elements. The first is the minor bound, the
%       second is the greater bound.
% -iter: it's the max number of iteration.
% -tol_x: it's the tolerance on the successive steps.
% -tol_f: it's the tolerance on the successive function's values.

%% Initialization
f=inline(func);     % Inline function
a=int(1);           % First bound of the interval
b=int(2);           % Second bound of the interval
tolx=tol_x;         % Successive steps' Tolerance 
MaxIter=iter;       % Number of max iteration
tolfun=tol_f;       % Function's tolerance
sol=zeros(MaxIter,1);   % Matrix Initialization 
fun=zeros(MaxIter,1);   % Matrix Initialization 

%% Initial Interval Definition
funa=f(a);      % Function's value in the first bound
funb=f(b);      % Function's value in the second bound
while funa*funb>0           % It controls if the function, in the two bound, has opposite values
    a=a-(b-a);
    b=b+(b-a);
    funa=f(a);
    funb=f(b);
end

%% Bisection method
c=(a+b)/2;      % Calculates the third point
func=f(c);      % Function in the third point
k=1;
sol(1)=c;
fun(1)=func;
while (k<=MaxIter) & (abs(func)>tolfun) & (abs(b-a)>tolx)
    if funa*func>0
        a=c;
        funa=func;
    else
        b=c;
        funb=func;
    end
    c=(b+a)/2;
    func=f(c); 
    k=k+1;
    sol(k)=c;
    fun(k)=func;
end

%% Plot
figure(1)       % Plot the function's and the solution's trend
subplot(2,1,1)
plot(sol(1:k)), title('Solutions find at the k-th step'), xlabel('x axis'), ylabel('y axis')
subplot(2,1,2)
plot(fun(1:k)), title('Values of the function at the k-th step'), xlabel('x axis'), ylabel('y axis')
p_min=sol(k);   %It's the solution
    
    