function [subplot_handles,LabelsFontSize] = subplotplus(subplot_array,varargin)
% SUBPLOTPLUS Enhanced subplots creation function.
%   
%   [subplot_handles,LabelsFontSize] = subplotplus(subplot_array,varargin)
%   is an enhanced alternative to the inherit subplot() function of
%   MATLAB. Using subplotplus() almost any layout of subplots can be
%   created in a particular figure. The desired subplot layout is described
%   using a complex cell array where each "atomic" cell, within the cell
%   array corresponds to a subplot. The function scans the content of the
%   input cell array and build the desired matching subplot layout in the
%   figure. The size, alignment and font size of the subplots is 
%   automatically adjusted for best appearance. The function is recursive
%   in nature so any level of subplot divisions can be created. The
%   returned arguments are the created subplot handles as well as the
%   optimal label (X and Y) font size that should be used for a specific
%   subplot for best appearance.
%
%   Input arguments:
%   + subplot_array: A cell array that describes the desired subplot
%   layput. For example, a 1x2 subplot layout where the right-end subplot is 
%   further divided down to a column of 3 additional subplots is described 
%   by the following cell expression: {{[]},{{[]};{[]};{[]}}}. A group of
%   subplot cells, sharing the same "parent" cell, can be glued together in order
%   to save figure space using the '-g' option at the cell's content (instead of
%   empty group []). For example, if the 3 columned subplots of the
%   previous example are to be glued together, sharing the same X-axis, the
%   follwing cell expression should be used: 
%   {{[]},{{['...-g...']};{['...-g...']};{['...-g...']}}}.
%   + varargin: only used for function recursion and should not be used by the user.
%
%   Output arguments:
%   + subplot_handles: A list of the created subplot handles by their order
%   of appearnace in the figure, starting from the left-top corner in a
%   clockwise manner.
%   + LabelsFontSize: A matching list of X/Y-axis optimal labels size for further 
%   user work on the subplots.
%
%   Alon Geva
%   $Revision: 1.00 $  $Date: 12/01/2012 18:52:53 $

arraydim =  cell_dimension(subplot_array);

if (nargin == 1)
    clf;
    for i=1:arraydim,
        subplot(prod(arraydim),1,i);
    end
    subplot_handles = get(gcf,'children');
    subplot_location = [0.015 0 1-0.015 1]; %full plot region
    subplot_handles = flipud(subplot_handles);
    original_subplot_handles = subplot_handles;
    LabelsFontSize = zeros(length(original_subplot_handles),2);
else
    subplot_handles = varargin{1};
    subplot_location = varargin{2};
    LabelsFontSize = varargin{3};
    original_subplot_handles = -1;
end

subplotarraysize=size(subplot_array);
%i=1;
glue_FLAG = 0;
if ~iscell(subplot_array{1,1})
    if ischar(subplot_array{1,1})
        glue_FLAG = ~isempty(regexp(subplot_array{1,1},'-g','start'));
    end
elseif ~iscell(subplot_array{1,1}{1,1})
    if ischar(subplot_array{1,1}{1,1})
        glue_FLAG = ~isempty(regexp(subplot_array{1,1}{1,1},'-g','start'));
    end
end
    
if (glue_FLAG == 1)%(strcmp(subplot_array{1,1},'-g')==1)%(~isempty(regexp(subplot_array{1,1},'-g','start')))
    subplot_location(3) = subplot_location(3)*0.8;
    subplot_location(4) = subplot_location(4)*0.8;
    subplot_location(1) = subplot_location(1)+subplot_location(3)*0.1;
    subplot_location(2) = subplot_location(2)+subplot_location(4)*0.1;
end

for m=1:subplotarraysize(1),
    for n=1:subplotarraysize(2),
        %s = size(subplot_array{m,n});
        
        if (iscell(subplot_array{m,n}))
            recursion_FLAG = iscell(subplot_array{m,n}{1,1});
        else
            recursion_FLAG = 0;
        end
        
        if (~recursion_FLAG)%iscell(subplot_array{m,n}{1,1})%(s(1)<=1 && s(2)<=1)% 
            M = subplotarraysize(1);
            N = subplotarraysize(2);
            if (~glue_FLAG)%(strcmp(subplot_array{1,1},'-g')~=1)%(isempty(regexp(subplot_array{1,1},'-g','start')))%
                set(subplot_handles(1),'position',[subplot_location(1)+(2*n-1)*subplot_location(3)/(2*N)-0.5*subplot_location(3)/N/(0.5/0.3347),...
                                                    subplot_location(2)+subplot_location(4)-(2*m-1)*subplot_location(4)/(2*M)-0.5*subplot_location(4)/M/(0.5/0.3412),...
                                                    subplot_location(3)/N/(0.5/0.3347),...
                                                    subplot_location(4)/M/(0.5/0.3412)]);
                Xfontfactor = subplot_location(3)/N/(0.5/0.3347);
                Yfontfactor = subplot_location(4)/M/(0.5/0.3412);
            else               
                set(subplot_handles(1),'position',[subplot_location(1)+(2*n-1)*subplot_location(3)/(2*N)-0.5*subplot_location(3)/N/(0.5/0.5),...
                                                    subplot_location(2)+subplot_location(4)-(2*m-1)*subplot_location(4)/(2*M)-0.5*subplot_location(4)/M/(0.5/0.5),...
                                                    subplot_location(3)/N/(0.5/0.5),...
                                                    subplot_location(4)/M/(0.5/0.5)]);
                Xfontfactor = subplot_location(3)/N/(0.5/0.5);
                Yfontfactor = subplot_location(4)/M/(0.5/0.5);
                                              
                if (m == 1)
                    %set(subplot_handles(1),'XAxis','on');
                    set(subplot_handles(1),'XAxisLocation','top');
                elseif (m == subplotarraysize(1))
                    %set(subplot_handles(1),'XAxis','on');
                    set(subplot_handles(1),'XAxisLocation','bottom');
                else
                    set(subplot_handles(1),'XAxisLocation','bottom');
                end 
                
                if (n == 1)
                    set(subplot_handles(1),'YAxisLocation','left');
                elseif (n == subplotarraysize(2))
                    set(subplot_handles(1),'YAxisLocation','right');
                else
                    set(subplot_handles(1),'YAxisLocation','right');
                end
                
%                 if (subplotarraysize(1) > 1)
%                     ylimmode = get(subplot_handles(1),'YLimMode');
%                     if (strcmp(ylimmode,'auto')==1)
%                         %ytick = get(subplot_handles(1),'YTick');
%                         ylim = get(subplot_handles(1),'YLim');
%                         set(subplot_handles(1),'YLimMode','manual','YLim',[ylim(1)-0.1*diff(ylim) ylim(2)+0.1*diff(ylim)]);
%                         %set(subplot_handles(1),'YTickMode','manual','YTick',ytick);
%                     end
%                 end
%                 
%                 if (subplotarraysize(2) > 1)
%                     xlimmode = get(subplot_handles(1),'XLimMode');
%                     if (strcmp(xlimmode,'auto')==1)
%                         %ytick = get(subplot_handles(1),'YTick');
%                         xlim = get(subplot_handles(1),'XLim');
%                         set(subplot_handles(1),'XLimMode','manual','XLim',[xlim(1)-0.1*diff(xlim) xlim(2)+0.1*diff(xlim)]);
%                         %set(subplot_handles(1),'YTickMode','manual','YTick',ytick);
%                     end
%                 end
                
                    
            end
            
            set(subplot_handles(1),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
            
            fontsize = 10+3*log10(min(Xfontfactor,Yfontfactor));
            if (fontsize > 10)
                fontsize = 10;
            elseif (fontsize < 1)
                fontsize = 1;
            end
            
            LabelsFontSize_tmp = 10+3*log10([Xfontfactor,Yfontfactor]);
            LabelsFontSize_tmp(LabelsFontSize_tmp > 10) = 10;
            LabelsFontSize_tmp(LabelsFontSize_tmp < 1) = 1;
            LabelsFontSize(length(LabelsFontSize)-length(subplot_handles)+1,:) = LabelsFontSize_tmp;
            
            set(subplot_handles(1),'FontSize',fontsize);
            subplot_handles = subplot_handles(2:end);
            %i = i + 1; %advancing subplots handle index 
        else
            [subplot_handles,LabelsFontSize] = subplotplus(subplot_array{m,n},...
                                                        subplot_handles(1:end),...
                                                        [subplot_location(1)+(n-1)*subplot_location(3)/subplotarraysize(2),...
                                                         subplot_location(2)+subplot_location(4)-m*subplot_location(4)/subplotarraysize(1),...
                                                         subplot_location(3)/subplotarraysize(2),...
                                                         subplot_location(4)/subplotarraysize(1)],...
                                                         LabelsFontSize);
        end     
    end    
end

if (original_subplot_handles ~= -1) %root of recurrence
    subplot_handles = original_subplot_handles;
end

%%
function dimension = cell_dimension(C)

cellsize=size(C);
%p=prod(size(cell));
dimension=0;

for m=[1:cellsize(1)],
    for n=[1:cellsize(2)],
        s = size(C{m,n});
        if (s(1)<=1 && s(2)<=1)
            dimension = dimension + 1;
        else
            dimension = dimension + cell_dimension(C{m,n});
        end
    end
end

