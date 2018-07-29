function h = color_line(x, y, c, varargin)
% color_line plots a 2-D "line" with c-data as color
%
%       h = color_line(x, y, c)
%       by default: 'LineStyle','-' and 'Marker','none'
%
%          or
%       h = color_line(x, y, c, mark) 
%          or
%       h = color_line(x, y, c, 'Property','value'...) 
%             with valid 'Property','value' pairs for a surface object
%
%  in:  x      x-data
%       y      y-data
%       c      3rd dimension for colouring
%       mark   for scatter plots with no connecting line
%
% out:  h   handle of the surface object

% (c) Pekka Kumpulainen 
%     www.tut.fi


h = surface(...
  'XData',[x(:) x(:)],...
  'YData',[y(:) y(:)],...
  'ZData',zeros(length(x(:)),2),...
  'CData',[c(:) c(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','none');
  
if nargin ==4
    switch varargin{1}
        case {'+' 'o' '*' '.' 'x' 'square' 'diamond' 'v' '^' '>' '<' 'pentagram' 'p' 'hexagram' 'h'}
            set(h,'LineStyle','none','Marker',varargin{1})
        otherwise
            error(['Invalid marker: ' varargin{1}])
    end

elseif nargin > 4
    set(h,varargin{:})
end
