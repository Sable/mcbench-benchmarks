%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   extr.m      2006-03-03  %   Positions of local extremes in a sequence
%       (c)     M. Balda    %               2006-03-03
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The function serves for fast finding of positions of simple local extreme
%  values in a real vector. In the first stage it finds all positions of both
%  true and false extremes. If required, the function filters out all false
%  extremes. Results are stored in a cell array with two cells containing 
%  logical vectors with positions of maxima and minima respectively.
%
%  Forms of calls:
%  ~~~~~~~~~~~~~~~
%   L = extr(x);            %   Find all true extrems
%       x       a real vector, say, values of a sampled signal
%       L       a cell array [L{1},L{2}] where L{1} and L{2} are logical
%               vectors such that x(L{1}) and x(L{2}) are maxima and minima,
%               respectively.
%   L = extr(x,0);          %   Find all true and false extrems
%
%  Examples:
%  ~~~~~~~~~
%  The function extr.x works very fast. A random sequence of 10 millions
%  of samples analyzed in 6 seconds on a 2GHz PC, Windows 2000 Prof.:
%
%   clear, x=rand(1e7,1)-.5; tic, L=extr(x); toc 
%                           %    Elapsed time is 6.053757 seconds.
%
%  Other examples are solved in the testing program demoXtr.m, the results
%  of which are shown in a file demoXtr.jpg. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function L = extr(x,exact)  %   True extreme positions
%~~~~~~~~~~~~~~~~~~~~~~~~~
if nargin<2
    exact=true;
else
    exact = exact>0;
end

x = single(x(:));           %   measured data don't need be double
if x(1)==x(2)               %   if no-trend signal at the beginning
    if x(1)==0              %   adjust first value of a sequence
        x(1) = x(1)-2e-7;
    else
        if x(1) < x(find(x~=x(1),1))
            x(1) = x(1)-abs(x(1))*2e-7;
        else
            x(1) = x(1)+abs(x(1))*2e-7;
        end
    end
end

K = logical(diff([x(1)+abs(x(1))*2e-7; ...
                  x; x(end)-abs(x(end))*2e-7])<=0);       % out(K','%4g')

                            %   Positions of true and false maxima:
L(1) = {K(2:end) & [K(2); K(2:end-1)~=K(3:end)]};         % out(L','%4g')
                            %   Positions of true and false minima:
L(2) = {K(1:end-1) & [K(1:end-2)~=K(2:end-1); K(end-1)]}; % out(L','%4g')

if ~exact, return, end      %   Shorter solution is sufficient

%            Filter out couples of false extremes:

K = L{1} | L{2};            %   Positions of all extremes
I = int32(1:length(x));     %   Subscripts of all data elements
I = I(K);                   %   Subscripts of true & false extremes
J = find(diff(x(K))==0);    %   Positions of first false extreme
K([I(J),I(J+1)]) = false;   %   scratch pairs of false extremes
L(1) = {K};
L(2) = {K};
                            %   Positions of maxima:
if x(I(2))<x(I(1))
    L{1}(I(2:2:end)) = false;
else
    L{1}(I(1:2:end)) = false;
end
                            %   Positions of minima:
if x(I(2))>x(I(1))
    L{2}(I(2:2:end)) = false;
else
    L{2}(I(1:2:end)) = false;
end
