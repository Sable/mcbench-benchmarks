% This function erases the original colorbar labeling and replaces it with an
% cell array.  This allows one to use the LaTeX interpreter for colobar labels
% and to add units and format strings amongst other things.  Enjoy!
%
% [cb,t]=cbar(varargin)
%
% Input data are in name/parameter value pairs:
%   yl or ylabel followed by a vector, cell array, or character array to be used as labels
%   color        followed by color vector to be used as font color
%   fontsize     followed by fontsize in points
%   fontname     follwoed by Matlab accessible font
%   fontweight   followed by light, normal, demi, or bold
%   format       followed by format string to be used for ylabel numbers
%   tag          followed by string that should follow ALL ylabels (mm/s, \pi, ^o etc.)
%   gap          followed by number of pixels between edged of colorbar labels and figure edge
%   title        followed by a string places a title above the colorbar convenient for 
%
% Outputs
%   cb - colorbar handle
%   t  - handle to the text objects created for the ylabel
%
% To see an example simply type: >> cbar;
%
% Future Improvements:  
%   1) Allow appropriate inputs to be vectors (multiple colors, fonts,formats etc.)
%   2) Add a 'keep' function that retains previous cbar parameters and only
%      makes a change if new input parameter has changed (ie don't use defaults ALL
%      the time)
%   3) Appropriate move around other axes in figure if colorbar gap is large...
%
% DBE 03/01/04 v0.1

function [cb,t]=cbar(varargin)  % Color, Fontsize, FontName, FontWeight
i = 1;
data=[];
if nargin==0
  figure; sphere;
  data.yl=-1:0.2:1;
  data.color=[0 0 1];
  data.fontsize=18;
  data.fontname='Courier';
  data.fontweight='bold';
  data.format='%+2.1f';
  data.tag='^o';
  data.gap=20;
  data.title='Temp (^oC)';
else
  while i <= length(varargin)
    switch lower(varargin{i})
      case {'yl','ylabel'}
        data.yl=varargin{i+1};                          i=i+2;
      case 'color'
        data.color=varargin{i+1};                       i=i+2;
      case 'fontsize'
        data.fontsize=varargin{i+1};                    i=i+2;
      case 'fontname'
        data.fontname=varargin{i+1};                    i=i+2;
      case 'fontweight'
        data.fontweight=varargin{i+1};                  i=i+2;
      case 'format'
        data.format=varargin{i+1};                      i=i+2;
      case 'tag'
        data.tag=varargin{i+1};                         i=i+2;
      case 'gap'
        data.gap=varargin{i+1};                         i=i+2;
      case 'title'
        data.title=varargin{i+1};                       i=i+2;
      case {'auto','autosize'}
        data.autosize=varargin{i+1};                    i=i+2;
      otherwise
        fprintf(['Unknown option: ',varargin{i},'\n']); i=i+1;
    end
  end
end

% Get the various handles and find the colorbar handle
h=gcf;
a=gca;
c=get(h,'children');                                   % Find all children
cb=findobj(h,'Tag','Colorbar');                        % Find the colorbar children
if isempty(cb)
  cb=colorbar;
end

% Set the defaults...
if ~isfield(data,'yl'),          data.yl=[];                           end
if ~isfield(data,'color'),       data.color=get(cb,'YColor');          end
if ~isfield(data,'fontsize'),    data.fontsize=get(cb,'FontSize');     end
if ~isfield(data,'fontname'),    data.fontname=get(cb,'FontName');     end
if ~isfield(data,'fontweight'),  data.fontweight=get(cb,'FontWeight'); end
if ~isfield(data,'format'),      data.format=['%6.2f'];                end
if ~isfield(data,'tag'),         data.tag=[];                          end
if ~isfield(data,'gap'),         data.gap=2;                           end
if ~isfield(data,'title'),       data.title=[];                        end
if ~isfield(data,'autosize'),    data.autosize=0;                      end

% If this function has been called before for the samge figure then erase those objects
cb_yl=findobj(gcf,'tag','cbar_pro_yl'); delete(cb_yl);

set(h,'CurrentAxes',cb);                               % Set the current axis
set(cb,'YTickLabel',[]);                               % Eliminate the original lettering
set(cb,'TickLength',[0 0]);                            % Turn the tick marks off
xlim=get(cb,'XLim');                                   % Get the x-axis limits
ylim=get(cb,'YLim');                                   % Get the y-axis limits

if ~isempty(data.yl)
for k=1:size(data.yl,2)
  if iscell(data.yl)
		yt_pos=linspace(ylim(1),ylim(2),(size(data.yl,2)));    % Determine the text spacing...
    t(k)=text(1.1*xlim(2),yt_pos(k),[data.yl{k},data.tag]);
  elseif ischar(data.yl)
		yt_pos=linspace(ylim(1),ylim(2),(size(data.yl,1)));    % Determine the text spacing...
    t(k)=text(1.1*xlim(2),yt_pos(k),[data.yl(k,:),data.tag]);
  elseif isnumeric(data.yl)
		yt_pos=linspace(ylim(1),ylim(2),(size(data.yl,2)));    % Determine the text spacing...
    ytl_max=length(num2str(max(data.yl),data.format));
    ytl_cur=length(num2str(data.yl(k),data.format));
    t(k)=text(1.1*xlim(2),yt_pos(k),[blanks(ytl_max-ytl_cur) num2str(data.yl(k),data.format),data.tag]);
  end
%   set(t,'tag','cbar_pro_yl');
  set(t(k),'tag','cbar_pro_yl');
  set(t(k),'FontSize',data.fontsize,'FontName',data.fontname,'FontWeight',data.fontweight,'Color',data.color);
end
else
  error('Need to deal with this case');
end

if ~isempty(data.title)
  ti=text(mean(xlim),1.01*ylim(2),data.title);  
    set(ti,'FontSize',data.fontsize,'FontName',data.fontname,'FontWeight',data.fontweight,'Color',data.color);
    set(ti,'tag','cbar_pro_yl','HorizontalAlignment','Center','VerticalAlignment','Bottom');
end

% Determine the size of the ylabels and push the colorbar over and shrink the main axes to fit if neccessary...
h_units=get(h,'units');
  set(h,'units','pixels');
  pos_h=get(h,'position');
a_units=get(a,'units');
yl_units=get(t(1),'units');
for k=1:size(t,2)
  set(t(k),'units','pixels');
  pos_yl(k,:)=get(t(k),'Extent');
end
wyl=max(pos_yl(:,3));
cb_units=get(cb,'units');
set(cb,'units','pixels');
pos_cb=get(cb,'position');
pos_cb_left=pos_h(3)-pos_cb(3)-wyl-data.gap;  % Set position so that there are data.gap pixels between labels and figure edge...
set(cb,'position',[pos_cb_left pos_cb(2) pos_cb(3) pos_cb(4)]);

if data.autosize
  % Push the main axes around...THIS IS UNDERDEVELOPED RIGHT NOW...
  set(a,'units','pixels');
  pos_a=get(a,'position');
  set(a,'position',[data.gap,data.gap,pos_cb(1)-pos_cb(3)-2*data.gap,pos_h(4)-2*data.gap]); % Return units fields to their original values...
  for k=1:size(t,2)
    set(t(k),'units',yl_units);
  end
end

set(cb,'units',cb_units);
set(h,'units',h_units);
set(a,'units',a_units);
set(h,'CurrentAxes',a);                               % Set the current axis back to the original axis

return