function mfig = montagefigures(figurearray,x,y)
% by Nick Sinclair (nws5@pitt.edu)  Jul 08, 2010

% figurearray is row-vector of handles to figures that you'd like
% included in the montage

% x is horizontal number of subplots
% y is vertical number of subplots 

% props array specifies properties that you'd like copied over to the new
% subplots. I did this because copying all of the properties gave me errors
% because I didn't know how to exclude the read-only properties. So for now
% you have to specify each one. Check 'Axes Properties' in help for more
% properties to copy over. 

% The space between subplots can be adjusted with 'spacerx' and 'spacery'

% The axis labels and Ticks are only displayed on the first column and 
% last row. If it's not appropriate, it's easy to change. For example, it's
% particularly ugly if you have an odd number of plots or varying xlim/ylim
% Just set LabelOnlyPerimeter = 0;

% returns handle to new figure mfig


% IMPORTANT ADJUSTABLE PARAMETERS
props ={'XLim','YLim','CLim','Xscale','Yscale', ...
    'YTickLabelMode','XTickLabelMode','View','YDir', ... 
    'XDir','DataAspectRatio','DataAspectRatioMode'}; 
legprops = {'String','FontAngle','FontName','FontSize','FontUnits','FontWeight'}; 
    %properties to copy from legends

left = 0.03;  % margins (add it in if you like, in the same way as left)
top = .98;    %         
bottom = 0.05;% 
spacerx = 1/6; % size of space between subplots compared to subplot width
spacery = 1/4;  %
newfigposition = [.1 .1 .75 .75]; %set size and position of newfig 
LabelOnlyPerimeter = 0;
% END IMPORTANT ADJUSTABLE PARAMETERS



mfig = figure('units', 'normalized', 'outerposition', newfigposition);

j = 1;

count = 0; 

for ii = 1:length(figurearray), 
   fig(ii).axhandles = findobj(get(figurearray(ii),'Children'),'Type','Axes','-not','Tag','Colorbar','-not','Tag','legend');
   count = count+length(fig(ii).axhandles); %count up axes excluding colorbars, incl subplots
end

% disp(['found: ',num2str(count),' plots']);

wxfactor = 1/spacerx;                   % convenience
wyfactor = 1/spacery;
dx = (1-left)/(((wxfactor+1)*x)+1);     %calc so that it all adds up to 1
dy = (top-bottom)/(((wyfactor+1)*y)+1); %
sizex = wxfactor*dx;                    %
sizey = wyfactor*dy;                    %


for i = 1:length(figurearray),
    for subaxis = 1:length(fig(i).axhandles)
        row = floor((j-1)/x) + 1;
        col = mod((j-1),x)+1;
        set(0,'CurrentFigure',mfig); 
        pos(1) = left + col*(dx) + (col-1)*sizex; %set subplot position
        pos(3) = sizex;                           % 
        pos(2) = top - row*dy - (row)*sizey;      %
        pos(4) = sizey;                           %
        s(j) = subplot('Position',pos); %handle to axis j in subplot (target)
%         set(0,'CurrentFigure',i); 
        origaxis = fig(i).axhandles(subaxis);

        %This label complication is because the xlabel property of the axis is
        %only a handle to a child string of the axis. hence
        %get(axishandle,'xlabel') gives you the handle to the label which you
        %can then set properties for. 

        copyobj(get(origaxis,'Children'),s(j)) %send all children to subplot j
        set(get(s(j),'Title'),'String',get(get(origaxis,'Title'),'String'));
        set(get(s(j),'Title'),'FontSize',(0.7*get(get(origaxis,'Title'),'FontSize')));        
        set(s(j),props,get(origaxis,props));    %set the specified properties of axis j    
        if LabelOnlyPerimeter,
            if (col==1),            % if first column set labels/ticks
                set(get(s(j),'ylabel'),'String',get(get(origaxis,'ylabel'),'String'));
                set(get(s(j),'ylabel'),'FontSize',(0.7*get(get(origaxis,'ylabel'),'FontSize')));        
            else
                set(s(j),'YTickLabelMode','manual'); 
                set(s(j),'YTick',[]); 
            end

            if (row == ceil(length(figurearray)/x)), %if last row, labels/ticks
                set(get(s(j),'xlabel'),'String',get(get(origaxis,'xlabel'),'String'));
                set(get(s(j),'xlabel'),'FontSize',(0.7*get(get(origaxis,'xlabel'),'FontSize')));        
            else
                set(s(j),'XTickLabelMode','manual'); 
                set(s(j),'XTick',[]); 
            end
        else
                set(get(s(j),'ylabel'),'String',get(get(origaxis,'ylabel'),'String'));
                set(get(s(j),'ylabel'),'FontSize',(0.7*get(get(origaxis,'ylabel'),'FontSize')));  
                set(get(s(j),'xlabel'),'String',get(get(origaxis,'xlabel'),'String'));
                set(get(s(j),'xlabel'),'FontSize',(0.7*get(get(origaxis,'xlabel'),'FontSize')));                  
        end
        
        if ~isempty(legend(origaxis)),
            legend(s(j),'toggle');
            set(legend(s(j)),legprops,get(legend(origaxis),legprops));
        end
        
        j = j+1;
    end
end



