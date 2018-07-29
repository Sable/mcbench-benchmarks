function [bezcurve, intcurveyy] = bezier_(points, numofpbc, intcurvexx, fig)
% function [bezcurve, intcurveyy] = bezier_(points, numofpbc, intcurvexx, fig)
% 
% Creates Bezier curve (output 'bezcurve') from 'points' (1st input argument) and the number of points (2nd input argument) 
%   and creates from it another interpolated curve (whose x-coordinates are in the input 'intcurvexx' and whose y-coordinates 
%   are in the output 'intcurveyy').
% 
% INPUTS:
%   points:   matrix ((n+1) x 2) with the original points in xy plane
%   numofpbc: number of points in the Bezier curve (by default 100)
%   intcurvexx: vector with x-coordinates of the interpolation curve. If this argument does not exist or is empty, 
%               the program generates Bezier curve, but no interpolation curve
%   fig:      any value if you want a figure of points and curve (otherwise, do not enter 4th argument)
%                You can enter here the representing symbol for the points (for instance, 'ks' for black squares).
% 
% OUTPUTS:
%   bezcurve: the Bezier curve, not interpolated, in the format [x y], i.e. a (numofpbc x 2) matrix.
%   intcurveyy: vector with y-coordinates (by non-parametric interpolation from intcurvexx) of the interpolation curve;
%             it has sense only if intcurvexx elements are monotonically increasing.
% 
% Example:    t = (1:100)';
%             x = 0.2*randn(size(t)) - sin(pi*t/100) + 0.5*t/100;
%             points = [t x];
%             bezier_(points, 500, [], 1);  % Creates only the Bezier curve and represents it together with the original points
% Or:         bc = bezier_(points);         % You want the Bezier curve (with 100 points), but no graph nor interpolated curve
% Or:         [bc, intcyy] = bezier_(points, 500, (1:0.1:20)', 1); % You want all the Bezier curve, the interpolation of part of it 
%               and the graph of all.

bezcurve = [];
intcurveyy = [];

if nargin < 1, error('Function bezier_() needs at least 1 argument (the points)'); end
if size(points, 2)~=2, error('Points (1st argument) must be in column format (as a 2 column-matrix [x y]).'); end
n = size(points, 1) - 1;  % number of points is n + 1  (their index goes from 0 to n)
if n > 1000, error('Bézier curve for more than 1000 points is not allowed'); end


if nargin < 2, numofpbc = 100; end
if isempty(numofpbc), numofpbc = 100; end

if nargin < 3, intcurvexx = []; end   % points(:, 1); end
%if isempty(intcurvexx), intcurvexx = points(:, 1); end

vectort = 0:1/(numofpbc-1):1;
bezcurve = zeros(length(vectort), 2);


% In this block we compute each point in the Bezier curve
numpoint = 1;
for t = vectort
  suma = [0 0];
  for i=0:n
    % In next line we add the next point multiplied by the corresponding Bernstein polynomial
    suma = suma + points(i+1, :)*nchoosekJH(n, i)*(t^i)*((1 - t)^(n - i));  
  end
  bezcurve(numpoint, :) = suma;
  numpoint = numpoint + 1;
end


if ~isempty(intcurvexx)    % The user wants interpolation curve
  intcurveyy = interp1(bezcurve(:, 1), bezcurve(:, 2), intcurvexx, 'cubic');  % Makes cubic interpolation from the Bezier curve. Other options: 'linear' or 'spline'
end

if nargin < 4, return; end     % The user does not want any graphics


figure
if ischar(fig)  % If 'fig' is of char type (for instance 'o' or '.'), it is used as plot symbol; otherwise, the program decides
  symbol = fig; % the user has decided the symbol
elseif n < 30  % Few points
  symbol = 'o';
else  % Many points
  symbol = '.';
end  
for j = 1:n
  hPoints = plot(points(:,1), points(:,2), symbol);   % plots the points with 'symbol'
  hold on;
end
hold on, hbc = plot(bezcurve(:, 1), bezcurve(:, 2), 'LineWidth', 3, 'Color', 'r');  % plots the Bezier curve
if ~isempty(intcurvexx)
  hold on, hic = plot(intcurvexx, intcurveyy, 'LineWidth', 2, 'Color', 'g');  % plots the interpolated curve
  %h = legend('Bezier curve', 'interpolated curve');
  %set(h,'Interpreter','none')
  set(get(get(hPoints,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off'); % Exclude line from legend  
  legend([hbc hic], {'Bezier curve', 'interp. curve'}); 
  %legend([hPoints hbc hic],{'points', 'Bezier curve', 'interp. curve'}); 
  title(sprintf('# pts: %d; # pts in Bezier curve: %d; # pts in interp.curve: %d', n+1, numofpbc, length(intcurvexx)))
else  % No interpolation asked for
  %h = legend('Bezier curve');
  %set(h,'Interpreter','none')
  set(get(get(hPoints, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off'); % Exclude line from legend  
  legend([hbc], {'Bezier curve'})
  %legend([hPoints hbc], {'points', 'Bezier curve'})
  title(sprintf('# pts: %d; # pts in Bezier curve: %d', n+1, numofpbc))
end



function res = nchoosekJH(n ,k)   % (faster and less problematic) alternative to nchoosek(n, k)
  if n > 1000, error('Binomial oefficients for n greater than 1000 are not allowed'); end
  if k==0, res = 1; return; end
  if n==0, res = 0; return; end
res = 1;
for i=1:k
  res = res*((n - k + i)/i);
end
