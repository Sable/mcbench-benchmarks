function varargout = error_propagation( varargin )
% [mean, std, skew, kurtosis] = error_propagation( func, x1, x2, x3, ..., xn, sx1, sx2, sx3, ...., sn )
% Numerical error propogation for a function of the variables x1, x2, ...
% xn. The uncertainties have standard deviations sx1, sx2, sx2, ... sxn. The arguments are
% assumed to all be real numbers.
%
% func must be vectorizable, (i.e. use a.*b not a*b)
% func can be in-line or a proper m-file.
%
% error_propagation( ..., 'hist') will plot a 
% histogram of the function value.
%
% error_propagation( ...., 'N', N) will use N
% as the sample size for numerical calculations. default value is N=10000.
%
% Note that unlike the standard textbook method involving first-order Taylor
% expansions, this method is accurate.
%
% error_propagation() will run two examples
%
%sak@wpi.edu 2/2013


if nargin == 0 %running examples
    disp( 'simple example using an in-line function, where the standard textbook linearization method fails' )
    disp( '[avg, std_dev, skew, kurtosis] = error_propagation( @(x, y) cos(x+y), 0, 0, .1 .2, ''hist'')' );
    [avg, std_dev, skew, kurtosis] = error_propagation( @(x, y) cos(x+y), 0, 0, .1, .2, 'hist');    
    disp( 'another example where using differentials you would have to go to fourth order' )
    disp( '[avg, std_dev, skew, kurtosis] = error_propagation(  @(x) x.^4, 0, .1, ''hist'')' );
    [avg, std_dev, skew, kurtosis] = error_propagation( @(x) x.^4, 0, .1, 'hist');    
    disp( 'In order for the next exmple to run, define func = @(x) x.^4 in the command window' );
    disp( 'and try' );
    disp( 'error_propagation(  func, 0, .1, ''hist'')' );
    return;
end

find_N = strcmp( varargin, 'N' );
if any( find_N )
    N = varargin{[false, find_N]};
    varargin(find_N) = [];
    varargin(find_N) = [];
else
    N = 10000;
end

find_hist = strncmpi( varargin, 'h', 1 );
if any( find_hist )
    varargin(find_hist) = [];
end

%
args = combine_cells( varargin(2:(end+1)/2), varargin((end+3)/2:end), N);
val = varargin{1}( args{:} );
varargout = {mean(val), std( val)};
varargout{3} = mean((val-varargout{1}).^3)/varargout{2}^3;
varargout{4} = mean((val-varargout{1}).^4)/varargout{2}^4 - 3;

if any( find_hist )
    figure(sum(mfilename));
    set( clf, 'name', char( varargin{1} ) );
    hist( val, min( 100, sqrt(N) ) );
    hold on;
    plot( varargout{1}*[1 1], ylim, '-r', 'linewidth', 2 );
    plot( varargout{1}*[1 1; 1 1]+varargout{2}*[-1 1; -1 1], ([1 1]'*ylim)', '--r', 'linewidth', 2 );
    xlabel( 'function value' );
    ylabel( 'frequency' );
    title( sprintf( 'mean = %g, std = %g, skew = %g, kurtosis = %g', varargout{:} ) );
end
varargout = varargout( 1:nargout );


function cell_out = combine_cells( cell1, cell2, N )
for i=1:numel( cell1 )
    cell_out{i} = cell1{i} + cell2{i}*randn( N, 1);
end
