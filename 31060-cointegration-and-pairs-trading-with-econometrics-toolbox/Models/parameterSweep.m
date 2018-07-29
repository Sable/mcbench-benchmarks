function [respmax,varmax,resp,var] = parameterSweep(fun,range)
%PARAMETERSWEEP performs a parameters sweep for a given function
%   RESPMAX = PARAMETERSWEEP(FUN,RANGE) takes as input a function handle in
%   FUN and the range of allowable values for inputs in RANGE.
%
%   FUN is a function handle that accepts one input and returns one output,
%   F = FUN(X), where X is an array of size N x M.  N is the number of
%   observations (rows) and M is the number of variables (columns).  F is
%   the response of size N x 1, a column vector;
%
%   RANGE is a cell array of length M that contains a vector of ranges for
%   each variable.
%
%   [RESPMAX,VARMAX,RESP,VAR] = PARAMETERSWEEP(FUN,RANGE) returns the
%   maximum response value in RESPMAX, the location of the maximum value in
%   VARMAX, an N-D array of the response values in RESP, and and N-D array
%   where the size of the N-D array depends upon the values in RANGE.
%   NDGRID is used to generate the arrays.
%
%   Examples:
%   % Example 1: peaks function
%     range = {-3:0.1:3, -3:0.2:3};  % range of x and y variables
%     fun = @(x) deal( peaks(x(:,1),x(:,2)) ); % peaks as a function handle
%     [respmax,varmax,resp,var] = parameterSweep(fun,range);
%     surf(var{1},var{2},resp)
%     hold on, grid on
%     plot3(varmax(1),varmax(2),respmax,...
%         'MarkerFaceColor','k', 'MarkerEdgeColor','k',...
%         'Marker','pentagram', 'LineStyle','none',...
%         'MarkerSize',20, 'Color','k');
%     hold off
%     xlabel('x'),ylabel('y')
%     legend('Surface','Max Value','Location','NorthOutside')
%
%   See also ndgrid

%%
% Copyright 2010, The MathWorks, Inc.
% All rights reserved.

%% Check inputs
if nargin == 0
    example()
else
    %% Generate expression for ndgrid
    N = length(range);
    if N == 1
        var = range;
    else
        var = cell(1,N);
        [var{:}] = ndgrid(range{:});
    end
    %% Perform parameter sweep
    sz = size(var{1});
    for i = 1:N
        var{i} = var{i}(:);
    end
    resp = fun(cell2mat(var));
    
    %% Find maximum value and location
    [respmax,idx]   = max(resp);
    for i = 1:N
        varmax(i) = var{i}(idx);
    end
    
    %% Reshape output only if requested
    if nargout > 2
        resp = reshape(resp,sz);
        for i = 1:N
            var{i} = reshape(var{i},sz);
        end
    end %if
    
end %if

%% Examples
function example()

figure(1), clf
range = {-3:0.1:3, -3:0.2:3};  % range of x and y variables
fun = @(x) deal( peaks(x(:,1),x(:,2)) ); % peaks as a function handle
[respmax,varmax,resp,var] = parameterSweep(fun,range);
surf(var{1},var{2},resp)
hold on, grid on
plot3(varmax(1),varmax(2),respmax,...
    'MarkerFaceColor','k', 'MarkerEdgeColor','k',...
    'Marker','pentagram', 'LineStyle','none',...
    'MarkerSize',20, 'Color','k');
hold off
xlabel('x'),ylabel('y')
legend('Surface','Max Value','Location','NorthOutside')