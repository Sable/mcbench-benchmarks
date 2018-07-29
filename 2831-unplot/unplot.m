function unplot(arg)
%UNPLOT Delete the most recently created graphics object(s).
%
%   UNPLOT removes the most recently created line, surface, patch, or
%   text object created in the current axes. 
%
%   UNPLOT(N) removes the N most recent. 
%
%   UNPLOT SET takes a snapshot of the objects currently in the axes. 
%   UNPLOT REVERT removes any objects drawn since the last SET.
%
%   Note: UNPLOT does not affect objects added through the figure menus
%   and buttons. 

% Copyright 2002-2003 by Toby Driscoll (driscoll@na-net.ornl.gov).
% 17 Mar 2003: Thanks to Norbert Marwan (marwan@agnld.uni-potsdam.de) for
%    the check on length(c).

persistent saved

if nargin < 1
  arg = 1;
end

c = get(gca,'children');
switch lower(arg)
 case 'set'
  saved = c;
 case 'revert'
  delete( setdiff(c,saved) )
 otherwise
  if ~ischar(arg)
    % 2003-03-17 modified by Norbert Marwan (marwan@agnld.uni-potsdam.de)
    delete( c(1:min(arg,length(c))) )
  end
end
