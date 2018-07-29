function stop = plotfval(x,optimValues,state)
% OPTIMPLOTFVAL Plot value of the objective function at each iteration.
%
%   STOP = OPTIMPLOTFVAL(X,OPTIMVALUES,STATE) plots OPTIMVALUES.fval.  If
%   the function value is not scalar, a bar plot of the elements at the
%   current iteration is displayed.  If the OPTIMVALUES.fval field does not
%   exist, the OPTIMVALUES.residual field is used.
%
%   Example:
%   Create an options structure that will use OPTIMPLOTFVAL as the plot
%   function
%     options = optimset('PlotFcns',@optimplotfval);
%
%   Pass the options into an optimization problem to view the plot
%     fminbnd(@sin,3,10,options)

%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2006/06/20 20:10:00 $

stop = false;
switch state
    case 'iter'
        if isfield(optimValues,'fval')
            if isscalar(optimValues.fval)
                plotscalar(optimValues.iteration,optimValues.fval);
            else
                plotvector(optimValues.iteration,optimValues.fval);
            end
        else
            plotvector(optimValues.iteration,optimValues.residual);
        end
end

function plotscalar(iteration,fval)
% PLOTSCALAR initializes or updates a line plot of the function value
% at each iteration.

if iteration == 0
    plotfval = plot(iteration,fval,'kd',...
    'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',6,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 0]);
    title(['Current Function Value: ',num2str(fval)],'interp','none');
    xlabel('Iteration','interp','none');
    set(plotfval,'Tag','optimplotfval');
    ylabel('Function value','interp','none')
    grid on; box on;
    set(gcf,'Color',[1 1 1],'Position',[650 40 600 400]);
else
    plotfval = findobj(get(gca,'Children'),'Tag','optimplotfval');
    newX = [get(plotfval,'Xdata') iteration];
    newY = [get(plotfval,'Ydata') fval];
    set(plotfval,'Xdata',newX, 'Ydata',newY);
    set(get(gca,'Title'),'String',['Current Function Value: ',num2str(fval)]);
end



function plotvector(iteration,fval)
% PLOTVECTOR creates or updates a bar plot of the function values or
% residuals at the current iteration.
if iteration == 0
    xlabelText = ['Number of function values: ',num2str(length(fval))];
    % display up to the first 100 values
    if numel(fval) > 100
        xlabelText = {xlabelText,'Showing only the first 100 values'};
        fval = fval(1:100);
    end
    plotfval = bar(fval);
    title('Current Function Values','interp','none');
    set(plotfval,'edgecolor','none')
    set(gca,'xlim',[0,1 + length(fval)])
    xlabel(xlabelText,'interp','none')
    set(plotfval,'Tag','optimplotfval');
    ylabel('Function value','interp','none')
else
    plotfval = findobj(get(gca,'Children'),'Tag','optimplotfval');
    % display up to the first 100 values
    if numel(fval) > 100
        fval = fval(1:100);
    end
    set(plotfval,'Ydata',fval);
end
