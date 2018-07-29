function root = newtzero(f,xr,mx,tol)
%NEWTZERO finds roots of function using unique approach to Newton's Method.
% May find more than one root, even if guess is way off.  The function f 
% should be an inline object or function handle AND capable of taking 
% vector arguments.  The user can also pass in a string function. 
% NEWTZERO takes four arguments. The first argument is the function to be 
% evaluated, the second is an optional initial guess, the third is an 
% optional number of iterations, and the fourth is an absolute tolerance.  
% If the optional arguments are not supplied, the initial guess will be set 
% to 1, the number of iterations will be set to 30, and the tolerance will
% be set to 1e-13.  If the initial guess is a root, no iterations will take
% place.
%
% EXAMPLES:  
%
%         % Use any one of these three equivalent function definitions.
%         f = inline('cos(x+3).^3+(x-1).^2'); % Inline object.
%         f = 'cos(x+3).^3+(x-1).^2'; % String function.
%         f = @(x) cos(x+3).^3+(x-1).^2; % Anonymous function.
%         newtzero(f,900) % A very bad initial guess!        
%
%         fb = @(x) besselj(2,x)
%         rt = newtzero(fb); % Finds roots about the origin.
%         rt = rt(rt>=-100 & rt<=100); % Plot about origin.
%         x = -100:.1:100;
%         plot(x,real(fb(x)),rt,abs(fb(rt)),'*r')
%
%         f = @(x) x.^3 +1; 
%         newtzero(f,1) % Finds the real root;
%         newtzero(f,i) % Finds the real root and two imaginary roots.
%
%         f = @(x) x.^3 + 2*x.^2 + 3*x -exp(x)
%         newtzero(f)  % Finds two roots.
%
%         % Try it with Wilkinson's famous polynomial.
%         g = @(x)prod(bsxfun(@(x,y)(x-y),[1:20]',x.')).'; % For brevity
%         newtzero(g,0)
%         
%
% May work when the initial guess is outside the range of fzero, 
% for example compare:
%
%            fzero(f,900)   % for f as in the above example.
%
% This function may also find complex roots when fzero fails.  For example,
% try to find the roots of the following using NEWTZERO and FZERO:
%             
%            f1 = @(x) x.^(2*cos(x)) -x.^3 - sin(x)+1;            
%            ntz1 = newtzero(f1,[],[],1e-15) % NEWTZERO finds 5 roots
%            fzrt1 = fzero(f1,0) % FZERO aborts.
%
%            f2 = @(x) x.^2 + (2 + .1*i);  % could use 'roots' here.
%            ntz2 = newtzero(f2,1)  % NEWTZERO finds 2 roots
%            fzrt2 = fzero(f2,1) % FZERO fails.
% 
% See also fzero, roots
%
% Author:  Matt Fig
% Contact:  popkenai@yahoo.com

defaults = {1,30,1e-13};% Initial guess, max iterations, tolerance.

switch nargin  % Error checking and default assignments.
    case 1
        [xr,mx,tol] = defaults{:};
    case 2
        [mx,tol] = defaults{2:3};
    case 3
        tol = defaults{3};
end

if isempty(xr)   % User called newtzero(f,[],50,1e-3) for example.
    xr = defaults{1};
end

if isempty(mx)
    mx = 30;
end

if ~isa(xr,'double') 
    error('Only double values allowed.  See help examples.')
end

if tol < 0 || ~isreal(tol)
    error('Tolerance must be greater than zero.')
end

if mx < 1 || ~isreal(mx)
    error('Maximum number of iterations must be real and >0.')
end

[f,err] = fcnchk(f,'vectorized'); % If user passed in a string.

if ~isempty(err)
    error(['Error using NEWTZERO:',err.message])
end

if abs(f(xr))< tol 
    root = xr; % The user supplied a root as the initial guess.
    return  % Initial guess correct.
end  

LGS = logspace(0,3,220); % Can be altered for wider range or denser search.
LNS = 0:1/19:18/19;  % Search very close to initial guess too.
xr = [xr-LGS xr+LGS xr-LNS(2:end) xr+LNS].';  % Make vector of guesses.
iter = 1;  % Initialize the counter for the while loop.
mn1 = .1; % These will store the norms of the converging roots.
mn2 = 1; % See last comment.
sqrteps = sqrt(eps); % Used to make h.  See loop.
warning off MATLAB:divideByZero % WILL BE RESET AT THE END OF WHILE LOOP. 

while iter <= mx && abs(mn2-mn1) > 5*eps
    h = sqrteps*xr; % From numerical recipes, make h = h(xr)
    xr = xr-f(xr)./((f(xr+h)-f(xr-h))./(2*h)); % Newton's method.
    xr(isnan(xr) | isinf(xr)) = []; % No need for these anymore.
    mn1 = mn2; % Store the old value first.
    mn2 = norm(xr,'fro'); % This could make the loop terminate early!
    iter = iter+1;  % Increment the counter.
end

if abs(f(0)) < tol % The above method will tend to send zero root to Inf.
    xr = [xr;0];  % So explicitly check.
end

warning on MATLAB:divideByZero % Reset this guy, as promised.

% Filtering.  We want to filter out certain common results.
idxi = abs(imag(xr)) < 5e-15;  % A very small imag term is zero.
xr(idxi) = real(xr(idxi));  % Discard small imaginary terms.
idxr = abs(real(xr)) < 5e-15;  % A very small real term is zero.
xr(idxr) = complex(0,imag(xr(idxr))); % Discard small real terms.
root = xr(abs(f(xr)) < tol); % Apply the tolerance.

% Next we are going to delete repeat roots.  unique does not work in
% this case because many repeats are very close to each other but not
% equal.  For loops are fast enough here, most root vectors are short(ish).

if ~isempty(root)
    cnt = 1;  % Counter for while loop.
    
    while ~isempty(root)
        vct = abs(root - root(1))<5e-6; % Minimum spacing between roots.
        C = root(vct);  %C has roots grouped close together.
        [idx,idx] = min(abs(f(C)));  % Pick the best root per group.
        rt(cnt) = C(idx);  %#ok<AGROW>  Most root vectors are small.
        root(vct) = []; % Deplete the pool of roots.
        cnt = cnt + 1;  % Increment the counter.
    end
    
    root = sort(rt).';  % return a nice, sorted column vector
end

    















