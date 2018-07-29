function zero=newton_raphson(funzione,tolleranza)
% It is a Matlab function that determines the zero of a regular real function.

% zero=newton_raphson(function,error)

% The function has two input variable: 'function' is a string that 
% represents the function of which find the relative zero. It must be 
% expressed with the real variable 'x'. 'error' is the tolerance for the
% algorithm's arrest.
% The function returns the zero point of the real function. It plots, in a
% figure, the function and the tangents used for the search of the zero. 

%% Preliminary Operations
cstring='rgbcmyk';  % Vector for the random choice of color
tol=tolleranza;   % Tolerance to stop the algorithm
err=1000;   
f=inline(funzione);    % Save the input function as inline function
fplot(f,[0 10])     % Function's Plot in a limited interval [0 10]; modify to change the interval
hold on

x(1)=0;     % Initial point to start the algorithm
% Calculates the derivative of the input function. d_f is an inline
% funtion obtained with the matlab function 'diff'. It calculates the 
% difference and approximate derivative of the input. 'char' converts the
% derivative function in a string for the input parameter of matlab
% 'inline' function.
d_f=inline(char(diff(funzione)));      
plot(x(1),'or')
i=2;

%% Newton Raphson algorithm and tangents' plot
while err>tol
   x(i)=x(i-1)-(f(x(i-1))/d_f(x(i-1)));     % Calculating the zero of the approximative function
   plot(x(i),0,'or')        % Plot the point
   ca(i-1)=d_f(x(i-1));     % Calculating the slope of the tangent to the curve
   t=(x(i)-1):.01:(x(i)+1);     % Vector of time (support the tangents' plot)
   tan=f(x(i-1))+ca(i-1)*t-ca(i-1)*x(i-1);      % Calculation of tangent's points
   plot(t,tan,cstring(round(rand(1)*6+1)))      % Tangent's plot in x(i-1)
   err=abs(x(i)-x(i-1));    % Calculates the error
   i=i+1;
end

%% Results
disp('The zero finded is: ');
zero=x(i-1)
plot(x(i-1),0,'*c')