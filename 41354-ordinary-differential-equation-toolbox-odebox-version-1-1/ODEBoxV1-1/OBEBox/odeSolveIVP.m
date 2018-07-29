function [y, x, vals] = odeSolveIVP( cfs, g, iVals , x, ls)
%
% Purpose : This is a tool to solve initial value problems. It uses the
% method proposed by Harker and O'Leary based on matrix algebra. it
% supports both constant coefficient IVPs and variable coefficients where
% the functions in x are defined as strings and converted to inline
% functions.
%
% Use (syntax):
%   [y, x, vals] = odeSolveIVP( cfs, g, iVals , x, ls)
%   [y, x, vals] = odeSolveIVP( cfs, [], iVals , x, ls)
%
% Input Parameters :
%   cfs: two formats are possible:
%       1) an array of constant numerical values, for equations with
%          constant coefficients.
%       2) A cell array of strings, the strings are converted to MATLAB
%       inline functions for evaluation. the inline may only be a function
%       of the independent variable x.
%
%      The coefficients are in the sequence
%       cfs(n) y^{n} ... cfs(0) y.
%
%   g: the forcing function. It can either be a string which can be
%      converted to an infline function in x, or [] which indicates a
%      homogeneous IVP, i.e., the forcing function is zero.
%   iVals: are the initial values. This is a vector of scalars starting
%      with y(0) = iVals(1), \dot{y}(0) = iVals(2), \ddot{y}(0) = iVals(2),
%      etc. Given n coefficients there must be n - 1 initial conditions
%   x: Here also two formats are permitted
%       1) [minX, maxX, noPts]. If x is a 1 times 3 matrix then the three
%       paramaters define the minimum and maximum x values for the solution
%       and the number of points to be used. in this case a set of uniformly 
%       spaced points is generated.
%       2) is x is an n times 1 vector, it is used as the set of points at
%       which the IVP is to be solved.
%
% Return Parameters :
%   y: The solutions to the IVP
%   x: The values of the independent variable for which the equation is
%      solved.
%   vals: a struct with the following fields
%      vals.L
%      vals.g
%      vals.C
%      vals.d
%        the above fields are the vectors and matrices required to defin
%        ethe differential equation:
%           L y = g given C y = d the initial conditions
%      vals.eqn
%        is a string for the differential equation solved.
%
% Description and algorithms:
%
% References : 
%
% Author :  Matther Harker and Paul O'Leary
% Date :    29. Jan 2013
% Version : 1.0
%
% (c) 2013 Matther Harker and Paul O'Leary
% url: www.harkeroleary.org
% email: office@harkeroleary.org
%
% History:
%   Date:           Comment:
%
%------------------------------------------------------------
% Test the input paramaters
%-----------------------------
[nCfs, p1m] = size( cfs );
degree = nCfs - 1;
%
if (p1m ~=1)
    error('The coefficient vector must be a column vector.');
end;
%
inlineCs = iscell( cfs );
%------------------------------
% Test the format of the initial conditions
[iVn, iVm] = size( iVals);
if (iVm ~= 1 )
    error('The vectos of initial values must be a column vector.');
end;
%
if (iVn < degree)
    error('There are insufficient initial conditions.');
end;
%------------------------------
[xn, xm] = size(x);
%
if (xn==1)&&(xm==3)
    xMin = x(1);
    xMax = x(2);
    if xMax <= xMin
        error('The minimum x value must be smaller that the max x value.');
    end;
    noPts = x(3);
    x = linspace(xMin, xMax, noPts)';
elseif (xm==1)
    noPts = xn;
else
    error('The x vector must either be a column vector of a 1 x 3 row vector.');
end;
%------------------------------
if isstr(g)
    gf = inline( g );
    gi = gf(x);
    Eqn = [' = ',g];
elseif isempty( g );
    gi = zeros(noPts,1);
    Eqn = [' = 0'];
else
    gi = g;
    Eqn = [' = g'];
end;
%------------------------------
if nargin == 4
    ls = 9;
end;
%---------------------------------------------------------------
% Document the initial conditions
%
iValStr = num2str(x(1)) ;
initConds = ['\,\, with \,\, y(',iValStr,') = ', num2str(iVals(1)),', '];
for k=2:length(iVals)
    initConds = [initConds,'D^{',int2str(k-1),'}y(',iValStr,') = ',num2str(iVals(1)),', '];
end;
initConds = initConds(1:end-2);
%
%---------------------------------------------------------------
% set up the differentiating matrix
%
D = dopDiffLocal( x, ls, ls );
%
% Now deal with the inlince coefficients or the constant values
%
cfs = flipud( cfs );
d = iVals;
%
C = zeros( noPts, degree );
C(1,1) = 1;
%
if inlineCs
    %-------------------------------------------------------------------
    % Case when inline coefficients are used.
    %
    L =  odeInLineCfs( cfs{1}, x );
    %
    temp = cfs{1};
    temp = strRemoveChars( temp, ' ' );
    if strcmp( temp(1) , '-' );
        Eqn = [cfs{1}, ' y',Eqn]; 
    else
        Eqn = [' + ',cfs{1}, ' y',Eqn];    
    end;
    %
    for k=2:nCfs
        degT = k - 1;
        Dk = D^degT;
        Z = odeInLineCfs( cfs{k}, x );
        L = L + Z * Dk;
        %
        temp = cfs{k};
        temp = strRemoveChars( temp, ' ' );
        if strcmp( temp(1) , '-' );
            Eqn = [cfs{k},' D^{',int2str(degT),'} \, y',Eqn]; 
        else
            Eqn = [' + ',cfs{k},' D^{',int2str(degT),'} \, y',Eqn];   
        end;
        %
        if k <= degree
            C(:,k) = Dk(1,:)';
        end;
    end;
else
    %-------------------------------------------------------------------
    % Case when constant coefficients are used
    %
    L = cfs(1) * eye( noPts );
    Eqn = [' + ',num2str(cfs(1)), ' y ',Eqn];
    %
    for k=2:nCfs
        degT = k - 1;
        Dk = D^degT;
        L = L + cfs(k) * Dk;
        %
        if (cfs(k) < 0)
            Eqn = [' - ',num2str(abs(cfs(k))),' D^{',int2str(degT),'} \, y',Eqn];
        else
            Eqn = [' + ',num2str(abs(cfs(k))),' D^{',int2str(degT),'} \, y',Eqn];
        end;
        %
        if k <= degree
            C(:,k) = Dk(1,:)';
        end;
    end;
end;
%
% Setup the structure for the IVP which is returned for documentation
%
Eqn = ['$$',Eqn(3:end),initConds,'$$' ];
vals.L = L;
vals.g = gi;
vals.C = C;
vals.d = d;
vals.eqn = strRemoveChars( Eqn, '.*' );
%
% Solve the IVP
%
y = odeLSE( L, gi, C, d );
