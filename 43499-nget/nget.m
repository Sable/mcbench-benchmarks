function [varargout] = nget(h,varargin)
% [varargout] = nget(h,varargin) returns values using get(h) for any number
% of object properties. 
% 
% EXAMPLE: Reduce the following five lines of code down to one:  
% xlim = get(gca,'xlim'); 
% ylim = get(gca,'ylim'); 
% zlim = get(gca,'zlim'); 
% font = get(gca,'fontname');
% kids = get(gca,'children'); 
% 
% [xlim,ylim,zlim,font,kids] = nget(gca,'xlim','ylim','zlim','fontname','children'); 
% 
% Created by Chad A. Greene
% September 2013. 
% The University of Texas at Austin
% Institute for Geophysics

% Bare-bones error check: 
if nargout ~= length(varargin)
    disp('Number of output arguments must equal number of input arguments.')
    return
end


for k = 1:length(varargin)
    varargout{k} = get(h,varargin{k}); 
end

end

