%% LOWESS- Locally Weighted Scatterplot Smoothing
%% Modifications:
%
% This regression will work on linear and non-linear relationships between
% X and Y.
%
%    12/19/2008 - added upper and lower LOWESS smooths.  These additional
%    smooths show how the distribution of Y varies with X.  These smooths
%    are simply LOWESS applied to the positive and negative residuals
%    separately, then added to the original lowess of the data.  The same
%    smoothing factor is applied to both the upper and lower limits.
%
%    2/21/2009 - added sorting to the function, data no longer need to be
%    sorted.  Also added a routine such that if a user also supplies a
%    second dataset, linear interpolations are done one the lowess and used
%    to predict y-values for the supplied x-values.
%
%    10/22/2009 - modified the second user provided X-data for obtaining
%    predictions.  Matlab function unique sorts by default.  It really was
%    not needed in the section of code to perform linear interpolations of
%    the x-data using the y-predicted LOWESS results.  If the user does not
%    supply a second x-data set, it will assume to use the supplied x-y
%    data set.  Thus there is an output (xy) that maintains the original
%    sequence of the input.  Additionally, the user can now include a
%    sequence index as the first column of input data. This can be a
%    datenum or some other ordering index.  The output will be sequenced
%    using that index.  If a sequence index is provided a second subplot
%    will be created show the predicted Y-values in the order of the
%    included sequence index. I suspect this sequence index most often will
%    be a DateTime (i.e. datenum).  Just to the function generic enough,
%    the X-axis labels are not converted to a nice date format, but the
%    user could easily change that with a datetic attribute in the subplot.
%
%    11/3/2009 - modified charting to include upper and lower line plots on
%    the simulated subplot (i.e. the lower plot).
%
%    6/15/2012 - oddly, when using this routine on data without a time
%    sequence (i.e. a third column), the plotting portions cause an error. 
%    Not sure how I would have missed that but...I think I have it fixed.
%
%    An example dataset (skl1a.mat) is also included in the ZIP file for 
%    convenience. or you can use the below segment as a test that has no time 
%    sequence in the data.
%
%% Create example dataset: (uncomment and paste in the command window)
%    x = 0:0.1:10;
%    noise = normrnd(0,1, [1 length(x)]);
%    y = 10*sin(x) + noise;
%    datain = [x;y]';
%    f = 0.15;
%    wantplot = 1;
%    xdata = x';
%    [dataout lowerLimit upperLimit xy] = lowess(datain,f,0);
%    % A second plot to illustrate what values would be used, and how it
%    % compares to the original function used to generate the data
%    plot(dataout(:,1), dataout(:,2), '.blue',dataout(:,1),dataout(:,3),...
%       '-black', x, 10*sin(x), '--red')
%    grid on
%
%% Description
%
% Using a robust regression like LOWESS allows one the ability to detect a
% trend in data that may otherwise have too much variance resulting in
% non-significance p-values.
%
% Yhat (prediction) is computed from a weghted least squares regression
% whose weights are both a function of distance from X and magnitude
% from of the residual from the previous regression.
%
% The conceptual of these functions and subfunctions follow the USGS
% Kendall.exe routines. Because matlab is 8-byte precision, there are
% some very small differences between FORTRAN compiled and matlab.
% Maybe 64-bit OS's has 16-byte precision in matlab?
%
% There is a very simple subfunction to create a plot of the data and
% regression if the user so choses with a flag in the call to the lowess
% function. BTW-- the png file looks much better than what the figure looks
% like on screen.
%
% There are loops in these routines to keep the memory requirements to a
% minimum, since it is foreseeable that one may have very large datasets to
% work with.
%
% f = a smoothing factor between 0 and 1.  The closer to one, the more
% smoothing done.
%
% Syntax:
%
%   [dataout lowerLimit upperLimit xy] = lowess(datain,f,wantplot,imagefile,xdata)
%
%   datain = n x 2 (or 3 if sequend index is included) matrix
%   dataout = n x 3 matrix
%   wantplot = scaler (optional)
%        if ~= 0 then create plot
%   imagefile = full path and file name where to output the figure to an
%        png file type at 600 dpi. If imagefile not provided, a figure will
%        be displayed but not exported to a graphics file.
%        e.g. imagefile = 'd:\temp\lowess.png';
%   xdata = n x 1 vector. The user can supply a second dataset of x-values
%        that will be used to predict y-values using the lowess regression
%        results.
%   xy = x-values supplied by the user in xdata (or taken from the input 
%        data), and y-predictions using the lowess regression results.  If
%        a sequence index is given this will be included as well and
%        inserted as the first column and the last two columns are the
%        lower and upper simulations using the regression lower and upper
%        restuls.
%
% where:
%
%  *  datain(:,1) = x
%  *  datain(:,2) = y
%  *  f = scaler (0 < f < 1)
%  *  wantplot = scaler
%  *  imagefile = string
%
%  *  dataout(:,1) = x
%  *  dataout(:,2) = y
%  *  dataout(:,3) = y-prediction (aka yhat)
%  *  lowerLimit(:,1) = x with negative residuals
%  *  lowerLimit(:,2) = y-prediction of residuals + original y-prediction
%  *  upperLimit(:,1) = x with positive residuals
%  *  upperLimit(:,2) = y-prediction of residuals + original y-prediction
%
% Requirements:  none
%
% Written by
%
%  Jeff Burkey
%  King County Department of Natural Resources and Parks
%  email: jeff.burkey@kingcounty.gov
%  12/16/2008
% 
% Example syntax:
% [dataout lowerLimit upperLimit xy] = lowess(skl1a,.25,1,'c:\temp\test.png',xdata)

%% Primary Function: lowess
% The main engine for this function. 
function [dataout lowerLimit upperLimit xy] = lowess(datain,f,wantplot,imagefile,xdata)
    
    % start timer
    start = tic;
    
    rowcol = size(datain);
    
    if rowcol(2) == 3
        % assume time index for first column
        dte = datain(:,1);
        x_data = datain(:,2);
        y_data = datain(:,3);
    else % assign empty set
        dte = [];
        x_data = datain(:,1);
        y_data = datain(:,2);
    end
    
    if exist('xdata','var') == 0 
        % User didn't provide any x-valures for generating a dataset use
        % supplied set prior to sorting.
        xdata = [dte x_data];
    else
        xdata = [dte xdata];
    end
    
    
    datain = sortrows([x_data y_data]);
    
    if exist('wantplot','var') == 0 || wantplot == 0
        % user didn't provide assume zero (i.e. no plot)
        fprintf('\nNo plot will be created.\n');
        wantplot = 0;
        imagefile = '';
        limits = 1;
        upperLimit = nan;
        lowerLimit = nan;
    else
        limits = 3;
    end
    if exist('imagefile','var') == 0
        % User didn't provide do not export to graphics file
        fprintf('\nNo plot will be exported.\n');
        imagefile = '';
    end
    
    dataout = [];
    
    for nplots=1:limits
        % if limits is turned on, then plot the upper and lower limits of
        % the lowess- set to plot residuals lowess
        row = find(datain(:,1));
        x = datain(row,1);
        y = datain(row,2);
        
        switch nplots
            case 2
                row = lwsResiduals > 0;
                x = dataout(row,1);
                y = lwsResiduals(row);
            case 3
                row = lwsResiduals < 0;
                x = dataout(row,1);
                y = lwsResiduals(row);
        end
        
        n = length(x);
        
        if (f <= 0.0)
            f=0.25; % set to default
        end
        
        m=fix(n*f+0.5);
        window = zeros(n,1);
        yhat = zeros(n,1);
        
        for j=1:n
            % This could be done in a matrix, but need to keep memory footprint
            % small, thus the loop.
            d = abs(x- x(j));
            r1 = ones(n,1);
            d = sort(d);
            
            window(j)=d(m);
            yhat(j)= rwlreg(x,y,n,window(j),r1,x(j));
        end
        
        for it=1:2
            e = abs(y-yhat);
            
            n = length(e);
            s=median(e);
            
            r = e/(6*s);
            r = 1-r.^2;
            r = max(0.d0,r);
            r = r.^2;
            
            for j=1:n
                yhat(j)= rwlreg(x,y,n,window(j),r,x(j));
            end
        end
        
        switch nplots
            case 1
                % calculate residuals otherwise skip
                lwsResiduals = y - yhat;
                dataout = [x y yhat];
            case 2
                ul = [x y yhat];
                [~, ia, ib] = intersect(dataout(:,1),ul(:,1));
                upperLimit = [ul(ib,1) ul(ib,3) + dataout(ia,3)];
                clear ul c ia ib
            case 3
                ll = [x y yhat];
                [~, ia, ib] = intersect(dataout(:,1),ll(:,1));
                lowerLimit = [ll(ib,1) ll(ib,3) + dataout(ia,3)];
                clear ul c ia ib
        end
    end
    
    fprintf('\nCompute time %6.4f seconds.\n',toc(start));
    
    %% Generate predicted XY data
    % Using linear interpolation to estimate y from the lowess regression
    % Any x-values beyond the range given to generate the lowess will be
    % ignorged.  Matlab unique function sorts the data, thus a modified
    % unique function (usunique) was developed to return an unsorted vector.
    %
    % This limiting of the interpolation is done because if there are data
    % beyond the regression range it may not be valid to use a different
    % regression for an extrapolation.  But users choice.
    if ~isempty(xdata)
        xyd = [dataout(:,1) dataout(:,3)];
        xyd = unique(xyd,'rows');
        xd = xdata;
        
        % The below two lines are commented out to allow for extrapolations
        %         xd = xdata(xdata >= min(xyd(:,1)));
        %         xd = xd(xd <= max(xyd(:,1)));
        
        if ~isnan(xyd)
            % Note:  it may be possible to have a few nan's in the data set
            % while the results would still be valid.  I haven't come
            % across a case of this but is possible.  If so, then the user
            % may need to incorporate a threshold of just how many nan's
            % would be acceptable before dumping the whole regression.  But
            % to be conservative, if there are any nan's throw out the
            % whole result dataset.
            %
            % Note: change LINEAR to SPLINE, this will allow for
            % extrapolations, BUT using the SPLINE function now.
            xd = unique(xd,'rows');
            
            % Needed to account for useing including time sequence or not.
            %  modified June 15, 2012
            [~, c] = size(xd);
            if c == 2
                xv = xd(:,2);
            elseif c == 1
                xv = xd;
            end

            yinterp = interp1(xyd(:,1),xyd(:,2),xv,'spline');
            if wantplot ~= 0
                ylow = interp1(lowerLimit(:,1),lowerLimit(:,2),xv,'spline');
                yup =  interp1(upperLimit(:,1),upperLimit(:,2),xv,'spline');
                xy = [dte xv yinterp ylow yup];
            else
                xy = [dte xv yinterp];
            end
            
            
            if length(xd) ~= length(xdata)
                fprintf('\nOne or more x-values were beyond the range supplied to lowess.\nOr there were duplicate values.\nThey will be ignored.\n');
            end
        else
            fprintf('\nThere were NaNs in the lowess results. No plot will be created.\n');
            wantplot = 0;
            xy = nan;
        end
    end
    
    if wantplot ~= 0
        customplot(dataout,upperLimit,lowerLimit,f,[dte x_data y_data],xy,imagefile);
    end
    
end

%% Modification of check for ten or more non-zero weights
% Hirsch June 1987
%
% Robust weighted least squares regression, bisquare weights by
%         distance on X-axis.
%   x = is the estimation point
%   yy = is the estimate value of y at x
%   dd = is half the width of the window
%   r = is the robustness weight, a bisquare weight of residuals.
function [yy] = rwlreg(x,y,n,d,r,xx)
    dd=d;
    ddmax = abs(x(n) - x(1));
    if dd == 0.0
        error('Regression:lowess','LOWESS window size = 0. Increase f.');
    else
        while dd <= ddmax
            c = 0;
            total = 0.0;
            f = (abs(x-xx)/dd);
            f = 1.0-f.^3;
            w = ((max(0.d0,f)).^3).*r;
            total = sum(w);
            c = sum(w>0);
            if c > 3
                break % out of while loop
            else
                dd=1.28*dd;
                fprintf('\nrobust size of window = %5.0f.\nLowess window size increased to %3.2f\n', c, dd);
            end
        end
    end
    
    w = w/total;
    
    [a b] = wlsq(x,y,w);
    yy=a+b*xx;
end

%% Weighted least squares
% This subfunction does not require any toolboxes in matlab to execute.
function[a b] = wlsq(x,y,w)
    sumw = abs(1-sum(w));
    if sumw > 1e-10
        % The weights, w, must sum to one. Precision assuming type double,
        %    The user may want to adjust this value.
        error('Regression:wlsq','\nThere is an error in the weights.\nWeights do not equal zero (%10.9f).\n',sumw);
    end
    wxx = sum(w.*x.^2);
    wx = sum(w.*x);
    wxy = sum(w.*x.*y);
    wy = sum(w.*y);
    b = (wxy-wy*wx)/(wxx-wx^2);
    a = wy-b*wx;
end

%% Plotting of data and lowess regression line
% If a sequence vector is included in the data, the figure will contain two
% subplots.  The first one is the LOWESS regression of the data, the second
% plots the time in the original sequence using the first column of input
% data. Example a datenum for when the data were observed would be common.
% The second plot will plot the observed Y-data and the predicted Y-data.
function customplot(lws,uplmt,lwrlmt,f,oldxy,newxy,imgfile)
    figure1 = figure;
    
    try
        rowcol = size(newxy);
        if rowcol(2) == 5 % Users provided a sequence index e.g. Datenum
            % The second subplot id defined first as a matter of
            % readability in the code.  This Conditional segment will not
            % be executed if no sequence index is provided (e.g. datetime).
            subplot(2,2,3:4,'Parent',figure1,...
                'YScale','linear','YMinorTick','off',...
                'XScale','linear','XMinorTick','on',...
                'YMinorGrid','off',...
                'XMinorGrid','on');
            box('on');
            grid('on');
            hold('all');
            
            line(oldxy(:,1),oldxy(:,3),'LineStyle','none', ...
                'Marker','o','MarkerSize',7,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','b',...
                'DisplayName','Observed');
            
            line(newxy(:,1),newxy(:,3),'LineStyle','-', ...
                'LineWidth',2,'Color','r',...
                'DisplayName','Simulated');

            line(newxy(:,1),newxy(:,4),'LineStyle',':', ...
                'LineWidth',2,'Color','m',...
                'DisplayName','Lower');

            h = line(newxy(:,1),newxy(:,5),'LineStyle',':', ...
                'LineWidth',2,'Color','g',...
                'DisplayName','Upper');

            % The below lines are commented out, but for convenience
            % uncomment if one wants to make the upper and lower lines the
            % same color, you can not have duplicate symbols in the legend.
%             hAnnotation = get(h,'Annotation');
%             hLegendEntry = get(hAnnotation','LegendInformation');
%             set(hLegendEntry,'IconDisplayStyle','off');
            
            ylabel('y-Values');
            xlabel('Sequence Index (e.g. datenum)');
            title('Simulated y-Values using LOWESS Regression');
            
            % Create legend - although I'm not overly pleased using the default
            % location of placement.  I want it outside the grid, but the
            % default without manually describing locations this will have to
            % do for now.  Placing them inside the grid yields the most
            % reelestate, but the lenged box possibly could cover up data.
            legend('show','Location','EastOutside');
            
            hold('off');
            
            % This is the primary plot that will be generate either from
            % this conditional statement or in the ELSEIF below. They are
            % exact same except for defining Subplot space as either two
            % plots or one.
            subplot(2,2,1:2,'Parent',figure1,...
                'YScale','linear','YMinorTick','off',...
                'XScale','linear','XMinorTick','on',...
                'YMinorGrid','off',...
                'XMinorGrid','on');
        elseif rowcol(2) == 2
            % No sequence index is given, second plot would be identical to
            % first plot.  Define plot to occupy space of both subplots.
            % This could be revised and not even call it a subplot, but for
            % consistency it is.
            subplot(2,1,1:2,'Parent',figure1,...
                'YScale','linear','YMinorTick','off',...
                'XScale','linear','XMinorTick','on',...
                'YMinorGrid','off',...
                'XMinorGrid','on');
        end
        
        box('on');
        grid('on');
        hold('all');
        
        x = lws(:,1);
        y = lws(:,2);
        yh = lws(:,3);
        
        % Point plot of points of the observed data on the LOWESS plot
        line(x,y,'LineStyle','none', ...
            'Marker','o','MarkerSize',7,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','b',...
            'DisplayName','Observed');
        
        % Line plot of the LOWESS regression
        line(x,yh, 'Color','r', 'LineWidth',2, 'LineStyle','-', ...
            'DisplayName','Regression' ...
            );
        
        
        x = uplmt(:,1);
        yh = uplmt(:,2);
        
        % Line plot of the upper limit LOWESS regression
        line(x,yh, 'Color', 'r', 'LineWidth',2,'LineStyle',':', ...
            'DisplayName','Upper/Lower' ...
            );
        
        x = lwrlmt(:,1);
        yh = lwrlmt(:,2);
        
        % Line plot of the lower limit LOWESS regression
        h = line(x,yh, 'Color', 'r', 'LineWidth',2,'LineStyle',':', ...
            'DisplayName','Lower' ...
            );
        hAnnotation = get(h,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        grid on
        xlabel('x-Values')
        ylabel('y-Values')
        ts = strcat('LOWESS Regression plot f=',num2str(f));
        title(ts)

        % Create legend - although I'm not overly pleased using the default
        % location of placement.  I want it outside the grid, but the
        % default without manually describing locations this will have to
        % do for now.  Placing them inside the grid yields the most
        % real-estate, but the lenged box possibly could cover up data.
        legend('show','Location','EastOutside');

        hold('off');
        
        if ~isempty(imgfile)
            % If a filename is give for the plot, create a PNG file.
            fprintf('\nCreating plot. Give a few tics.\n');
            print('-dpng','-r600', imgfile);
            fprintf('\nFinished...\n');
        end
        
        close(figure1)
    catch ME1
        disp(ME1)
    end
end
