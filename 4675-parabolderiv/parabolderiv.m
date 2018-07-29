function dy_dx = parabolderiv( x, y, k, graphics_flag )

% function dy_dx = parabolderiv( x, y, k, graphics_flag )
%
% default: example from Ref. [1], p. 322
%
% or try: parabolderiv( ( -2 : 0.01 : 2 )', exp( -2 : 0.01 : 2 )', 2 )
%         parabolderiv( ( -2 : 0.01 : 2 )', ( exp( -2 : 0.01 : 2 ) + 0.01 * rand( 1, 401 ) )', 25 )
%         parabolderiv( ( ( 0 : 200 * pi ) / 100 )', ( sin( 0 : 0.01 : 2 * pi ) + 0.01 * rand( 1, 629 ) )', 40 )
%           for demonstration of noisy input and edge deviations
%
% graphics_flag = 1: show result in graph (default) 
%                    (includes comparison to 2 other methods)
%                 0: show no graph
%
% This program differentiates an empirical function (an array of evenly
% spaced values), for instance periodically sampled data from an
% experiment.
%
% Method used: basically, a parabola is fit from k points to the left to k
% points to the right of the point where the derivative is required, this
% is then analytically differentiated. These calculations are not actually
% performed, but the method as given by Lanczos in Ref. [1] is used: only
% 1 fit parameter of the parabola is needed, which is calculated directly
% from the data; at the edges a parabola is fit through the first (last)
% 2k points, from which the derivative is calculated directly. Additional
% information (on accuracy, &c.) in Ref. [2]. Noise is handled well. An 
% example from Ref. [1] is included.
%
% The datapoints need to be equidistant. If the graphics_flag is set, the
% result of this method is compared to applying the standard Matlab diff()
% function on the raw data as well as on adjacent averaged filtered data
% (zero phase delay). The example commands given above illustrate this.
%
% References:
%
% [1] Title                    : Applied analysis / by Cornelius Lanczos
%     Author                   : Cornelius Lanczos
%     Edition                  : 3rd print.
%     Publisher                : London : Pitman, 1964
%     Pages                    : 539 p.
%     Bibliographic annotation : 1st print: 1957
%     see pp. 321 - 324
%
% [2] Title                    : Digital filters / by Richard W. Hamming
%     Author                   : Richard W. Hamming
%     Edition                  : 3rd ed.
%     Publisher                : Englewoood Cliffs : Prentice-Hall, 1989
%     Pages                    : XIV, 284 p.
%     Bibliographic annotation : 1st print: 1977
%     ISBN                     : 0-13-212812-8
%     see p. 137
%
% Last update 24-03-2004 by Robert Klein-Douwel
% 
% mail: robertkdkd@yahoo.co.uk, R.J.H.Klein-Douwel@tue.nl
% web:  http://www.sci.kun.nl/mlf/robertkd/

linewidth = 1; % can be changed for plotting purposes

% fill in some default values

if nargin < 4
    graphics_flag = 1;
end

if nargin < 3 % take example from Ref. [1], p. 322
    y = [ 0
          4
         25
         50
         67.4
        124.9
        172.0
        201.4
        288.1
        321.3
        387.1 ];

    x = ( 0 : 1 : length( y ) - 1 )';

    k = 2;
end

% initialise stuff

if length( x ) ~= length( y )
    error( 'x and y vectors have different lengths (RKD)' );
end

n = length( y ); %number of points

if 2 * k + 1 > n
    error( 'k too large or too few datapoints (RKD)' );
end

dy = zeros( n, 1 );

% check equidistancy of x
dx = diff( x );
d2x = diff( dx );

rel_error_d2x = max( abs( d2x ) ) / min( dx );
if rel_error_d2x > 401 * eps
    % vectors like ( -2 : 0.01 : 2 ) are not equidistant, but have a small variation 
    % in dx and d2x; if this is not more than 401 * eps, then it is neglected
    disp( [ 'relative error in d2x = ' num2str( rel_error_d2x ) ] );
    disp( [ 'relative error / eps = ' num2str( rel_error_d2x / eps ) ] );
    disp( [ 'min( d2x ) = ' num2str( min( d2x ) ) ] );
    disp( [ 'max( d2x ) = ' num2str( max( d2x ) ) ] );
    error( 'non-equidistant data points (RKD)' );
end
h = dx( 1 ); % stepsize

% start calculations
dy_denominator = 2 * h * sum( ( 1 : k ).^2 );

a = - k : + k;
for i = k + 1 : n - k
    dy( i ) = sum( a .* y( i + a )' );
end

dy = dy / dy_denominator;

% first and last k points:
% fit parabola over first and last 2k points
kk = 2 * k;

% first kk points
p1 = polyfit( x( 1 : kk ), y( 1 : kk ), 2 );
q1 = polyder( p1 ); % take derivative
dy( 1 : k ) = polyval( q1, x( 1 : k ) );

% last kk points
p2 = polyfit( x( n - kk + 1 : n ), y( n - kk + 1 : n ), 2 );
q2 = polyder( p2 ); % take derivative
dy( n - k + 1 : n ) = polyval( q2, x( n - k + 1 : n ) );

if nargout ~= 0 % output
    dy_dx = dy;
end

% end of calculations (everything below is just for making comparisons and nice output)

if graphics_flag == 1 % make some comparisons
    xdiff_range = x( 1 : n - 1 ) + h / 2; % x coordinates for results of diff() function

    % compare with diff()
    dydx_matlab = diff( y ) / h;

    if nargin >=3 % not enough data points in example to apply this filter

        % another test: try first adjacent averaging and then diff()
        % use k points to left and to right
        kkk = 2 * k + 1;
        b = ones( 1, kkk ) / kkk; % k point averaging filter
        y_filt = filtfilt( b, 1, y ); % noncausal filtering, zero phase distortion

        % calculate dy_filt/dx
        dy_filtdx = diff( y_filt ) / h;
    end

    if nargin < 3 % show results of example
        disp( '      x         y         dy' );
        disp( [ x, y, dy ] );
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if graphics_flag == 1
    if nargout == 0
        close all;
    end

    dx_idx_range = k + 1 : n - k;

    % parabolic fits to first (last) kk points
    x1_fit = min( x( 1 : kk ) ) : h / 100 : max( x( 1 : kk ) );
    y1_fit = polyval( p1, x1_fit );

    x2_fit = min( x( n - kk + 1 : n ) ) : h / 100 : max( x( n - kk + 1 : n ) );
    y2_fit = polyval( p2, x2_fit );

    figure;
    hold on;
    plot( x, y, '-ob', 'LineWidth', linewidth );
    plot( x( dx_idx_range ), dy( dx_idx_range ), '-or', 'LineWidth', linewidth );
    plot( x( 1 : k ), dy( 1 : k ), '-sr', 'LineWidth', linewidth );
    plot( x1_fit, y1_fit, '--r', 'LineWidth', linewidth );
    plot( xdiff_range, dydx_matlab, ':sg', 'LineWidth', linewidth );

    if nargin >= 3
        plot( xdiff_range, dy_filtdx, ':dm', 'LineWidth', linewidth );
    end

    legend( 'y', [ 'dy/dx_{Lanczos: {\pm}' num2str( k ) '}' ], ...
        [ 'first/last ' num2str( k ) ' pts' ], ...
        [ 'y_{fit, parabola, ' num2str( kk ) ' pts}' ], 'diff( y )/ dx', ...
        [ 'diff( y_{adj avg ({\pm}' num2str( k ) ')} )/ dx' ], 0 );

    plot( x( n - k + 1 : n ), dy( n - k + 1 : n ), '-sr', 'LineWidth', linewidth );
    plot( x2_fit, y2_fit, '--r', 'LineWidth', linewidth );

    plot( x, dy, '-r', 'LineWidth', linewidth );

    % replot to put these on top again
    plot( x( dx_idx_range ), dy( dx_idx_range ), '-or', 'LineWidth', linewidth );
    plot( x( 1 : k ), dy( 1 : k ), '-sr', 'LineWidth', linewidth );
    hold off;

    xlabel( 'x' );
    ylabel( 'y' );

    title( 'parabolic derivative (Lanczos)' );
end

