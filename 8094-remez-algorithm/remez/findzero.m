% By Sherif A. Tawfik, Faculty of Engineering, Cairo University
function y=findzero(fun,x0,x1,varargin)
% fun is the function that we need to compute its root.
% x0 and x1 are two arguments to the function such that the root that we
% seek lie between them and the function has different sign at these two
% points
% varargin are the other arguments of the function

% the value of the function at the first point
f0=feval(fun,x0,varargin{:}); 

%the value of the function at the second point
f1=feval(fun,x1,varargin{:});

% check that the sign of the function at x0 and x1 is different. Otherwise
% report an error
if sign(f0)==sign(f1)
    error('the function at the two endpoints must be of opposite signs');
end

%find a closer point to the root using the method of chords. In the method
%of chords we simply connect the two points (x0, f(x0))  and (x1, f(x1))
%using a straight line and compute the intersection point with this line
%and the horizontal axis. This new point is closer to the desired root
x=x0 - f0 * ((x1-x0)/(f1-f0));

%evaluate the function at this new point
f=feval(fun,x,varargin{:});

% enter this root as long as the difference between the two points that
% sandwitch the desired root is larger than a certain threshold
while abs(f)>2^-52
    % we keep one of the two old points that has a different sign than the
    % new point and we overwrite the other old point with the new point
    if sign(f)==sign(f0)
        x0=x;
        f0=f;
    else
        x1=x;
        f1=f;
    end
    x=x0 - f0 * ((x1-x0)/(f1-f0));
    f=feval(fun,x,varargin{:});
end
% at the end of the loop we reach the root with the desired precision and
% it is given by x
y=x;