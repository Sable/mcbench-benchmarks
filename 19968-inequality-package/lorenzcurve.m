function h = lorenzcurve(p, w)

% The function plots the Lorenz Curve, where populations from the poorest
% to the richest are on the x-axis and the associated wealth is on the
% y-axis.
% p and w must be vectors of same size, only positive values are allowed
% for p, only non-negative values are allowed for w (with at least one i
% such that w(i) > 0).
% p is the vector of populations and w is the vector of wealth levels.
%
% http://en.wikipedia.org/wiki/Lorenz_curve
% http://en.wikipedia.org/wiki/Gini_coefficient
% http://en.wikipedia.org/wiki/Theil_index
% http://en.wikipedia.org/wiki/Atkinson_index
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% Example: LogNormal logN(0, 1)
% N = 1000;                                           % Number of populations
% p = rand(N, 1);                                     % Population extracted from a Uniform U(0, 1)
% w = exp(randn(N, 1));                               % Wealth extracted from a LogNormal logN(0, 1)
% h = lorenzcurve(p, w);
%
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
%
% Written by
% Francesco Pozzi
% 19 May 2008
%

ctrl = isvector(p) & isnumeric(p) & isreal(p) & isvector(w) & isnumeric(w) & isreal(w);
if ctrl
  p = p(:);
  w = w(:);
  ind = ~isnan(p) & ~isinf(p) & ~isnan(w) & ~isinf(w);
  p = p(ind);
  w = w(ind);
else
  error('Values for either population or wealth or both are incorrect!')
end

ctrl = all(p > 0) & all(w >= 0) & ~all(w == 0);
ctrl = ctrl & (length(p) == length(w));
if ~ctrl
  error('Values for either population or wealth or both are incorrect!')
end

% Normalize total population and total wealth to 1.
p = p ./ sum(p);
w = w ./ sum(w);
% Keep the smallest population, needed to normalize the Gini coefficient
minpop = min(p);

% Store in a single array
pw = [p, w, w ./ p];
% Sort with respect to Wealth Per Capita
pw = sortrows(pw, 3);
pw(:, 3) = [];
pw = [zeros(1, 2); pw];
% Cumulative p & w
pw = cumsum(pw);

% Average bases and height for right trapezoids
height = diff(pw(:, 1));
base = (pw(1:(end - 1), 2) + pw(2:end, 2)) / 2;

% The Gini Coefficient is normalized with respect to its highest possible
% value which is obtained if the smallest population owns all the existing
% wealth.
g = (1 - 2 * height' * base) ./ (1 - minpop);

h = figure('Position', [50 50 700 650]);
fill([pw(:, 1); 0], [pw(:, 2); 0], 'y', 'FaceColor', 'y');              % Gini area
hold on
axis tight
axis square
plot([0, 1], [0, 1], 'r', 'LineWidth', 4);                                  % Perfect Equality Line (45 Degree Slope)
plot((0.01:0.01:1), (0.01:0.01:1) .^ 2, 'g', 'LineWidth', 4);               % Uniform Random Distribution
plot(pw(:, 1), pw(:, 2), 'LineWidth', 4)                                    % Lorenz Curve
xlabel('poorest population (%)', 'FontWeight', 'bold', 'FontSize', 24);
ylabel('wealth (%)', 'FontWeight', 'bold', 'FontSize', 24);

set(gca, 'FontWeight', 'bold', 'FontSize', 24, 'LineWidth', 1, 'Color', 'none', 'Box', 'on');
set(gca, 'Xlim', [0 1], 'Ylim', [0 1], 'XTick', 0:0.1:1, 'YTick', 0:0.1:1)
set(gca, 'XTickLabel', {'0.0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1.0'})
set(gca, 'YTickLabel', {[]; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1.0'})

set(gcf, 'Color', 'none');

h2 = legend(sprintf('Gini area (g = %.6f)', g), 'Perfect equality line (45º degree slope)', 'Uniform random distribution', 'Lorenz curve', 1);
set(h2, 'FontSize', 16, 'Location', 'NorthWest', 'Box', 'off')

set(gca, 'Position', [0.0915 0.1108 0.8832 0.8662])
