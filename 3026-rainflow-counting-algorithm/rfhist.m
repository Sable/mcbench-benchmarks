function [no,xo] = rfhist(rf,x,rfflag)
% rfhist - histogram for use with rainflow data.
%
% function [no,xo] = rfhist(rf,x,rfflag)
%
% Syntax: rfhist(rf)
%         rfhist(rf,30)
%         rfhist(rf,-55:10:55,'mean')
%         [no,xo]=rfhist(rf,30);
%
% Input: rf     - rainflow data from rainflow function,
%                 see RAINFLOW for more details,
%        x      - when x is a scalar, uses x bins or when
%                 x is a vector, returns the distribution of rf 
%                 among bins with centers specified by x, like in hist(),
%        rfflag - string, data type flag,
%                 'ampl' for amplitude,
%                 'mean' for mean value,
%                 'freq' for frequency and 'period' for time period of
%                 extracted cycles.
%
% Output: no - vector, number of extracted cycles,
%         xo - vector, bin locations.
%
% See also: HIST, RAINFLOW, RFMATRIX.

% By Adam Nies³ony, 10-Aug-2003
% Revised, 10-Nov-2009
% Visit the MATLAB Central File Exchange for latest version

error(nargchk(1,3,nargin))

if nargin<3,
   rfflag='ampl';
   if nargin<2,
      x=10;
   end
end

% description and data definition
if rfflag(1)=='m',
   r=2;
   xl='Histogram of "rainflow" cycles mean value';
elseif rfflag(1)=='f',
   r=5;
   rf(5,:)=rf(5,:).^-1;
   xl='Histogram of "rainflow" cycles frequency';
elseif rfflag(1)=='p',
   r=5;
   xl='Histogram of "rainflow" cycles period';
else
   r=1;
   xl='Histogram of "rainflow" amplitudes';
end

% histogram
halfc=find(rf(3,:)==0.5);      % find half-cycle
[N1 x]=hist(rf(r,:),x);        % for all data
if ~isempty(halfc),
   [N2 x]=hist(rf(r,halfc),x); % only for half-cycle
   N1=N1-0.5*N2;
end

% set the output or plot the results
if nargout == 0,
   bar(x,N1,1);
   xlabel(xl)
   ylabel(['Nr of cycles: ' num2str(sum(N1)) ...
         ' (' num2str(sum(N2)/2) ' from half-cycles)']);
elseif nargout == 1,
   no = N1;
else
   no = N1;
   xo = x;
end