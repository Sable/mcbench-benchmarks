function [ fth ] = figtitle(titlestring,varargin)
% FIGTITLE(titlestring,varargin) creates a title centered at the 
% top of a figure. This may be used to add a title to a figure
% with several subplots.
%
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% INPUTS: 
% 
% titlestring: must be a string. 
% 
% varargin: (optional) Any Text Properties in the following form:
%           'propertyname',propertyvalue  
% 
% h = figtitle('my title'); returns the handle h of the title, 
% which can later be edited by set(h) or removed by delete(h). 
%
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% EXAMPLE 1: 
% 
% x = 1:.01:7; 
% y = sin(x); 
% 
% figure; 
% subplot(2,2,1)
% plot(3*x,y)
% title('Exp. 1') 
% 
% subplot(2,2,2)
% plot(x,2*y+x)
% title('Exp. 2') 
% 
% subplot(2,2,3)
% plot(x,y)
% title('Exp. 3') 
% 
% subplot(2,2,4)
% plot(x,2*y)
% title('Exp. 4') 
% 
% figtitle('My Experimental Results','fontweight','bold');
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% EXAMPLE 2: A prettier example using ntitle: 
% 
% x = 1:.01:7; 
% y = sin(x); 
% 
% figure; 
% subplot(2,2,1)
% plot(3*x,y)
% ntitle('experiment 1','fontsize',12)
% box off
% 
% subplot(2,2,2)
% plot(x,2*y+x)
% ntitle('experiment 2','fontsize',12)
% box off
% 
% subplot(2,2,3)
% plot(x,-y+5*x)
% ntitle('experiment 3','fontsize',12)
% box off
% 
% subplot(2,2,4)
% plot(x,2*y-3*x)
% ntitle('experiment 4','fontsize',12);
% box off
% 
% figtitle(' My Experimental Results')
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% 
% In many cases a figure title may overlap a subplot title 
% To reduce the possibility of a figure title overlapping subplot
% titles, try pairing this function with the ntitle function, which 
% is available on the Mathworks File Exchange here: 
% http://www.mathworks.com/matlabcentral/fileexchange/42114-ntitle
%
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% Written by Chad A. Greene, July 2013. 
%
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * % 
% 
% See also title, text, and ntitle. 


% Get the handle of the current axes and properties:
hca = gca; 
fontsize = get(hca,'fontsize'); 

% Create a new set of axes the size of the entire figure: 
h = axes('position',[0 0 1 1],'units','normalized');

axes('Units','normalized',...
    'Position',[0 0 1 1],...
    'Visible','off',...
    'XTick',[],...
    'YTick',[],...
    'Box','off');

% Make a title: 
fth = text(.5,1,titlestring,...
    'units','normalized',...
    'horizontalalignment','center',...
    'verticalalignment','top',...
    'fontsize',fontsize+2); 

% Set optional inputs: 
for k = 1:2:length(varargin)
    set(fth,varargin{k},varargin{k+1});
end

% Now go back to from where we came: 
delete(h)
axes(hca); 

% Return the title handle only if it is desired: 
if nargout==0
    clear fth; 
end

end

