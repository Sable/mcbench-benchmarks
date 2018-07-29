function varargout = dealcell(varargout)

%DEALCELL Deals cell elements to variables
%   [A1,A2,A3,...] = DEALCELL(X) assigns elements of cell array X to output
%   lists. It is the same as A1=X{1}, A2=X{2}, A3=X{3}, ..., AN=X{N}. There
%   can be any number of variables (up to the total number of elements in
%   X) on the left hand side. If there are fewer LHS variables than the
%   total number of elements in X, then only the first N elements of X are
%   assigned.
%
%   DEALCELL works similarly to DEAL, except that it is specialized for
%   cell array inputs and that the cell array does not have to be passed in
%   as comma-separated lists.
%
%   This is a very short code (0 lines), and for cell array dealing, it is
%   faster than DEAL. See example below.
%
%   The code:
%     function varargout = dealcell(varargout)
%
%   Helpful error messages are sacrificed for efficiency. To enable better
%   error-checking, uncomment the Error Checking section below.
%
%  Example: (speed comparison with DEAL)
%     sys = {'hello'; 'yes'; 'no'; 'goodbye'};
%     tic; % DEALCELL
%     for id = 1:100000
%       [a1,b1,c1,d1] = dealcell(sys);
%     end
%     fprintf('\nDEALCELL: %1.3f sec (%d iterations)\n', toc, id);
%
%     tic; % DEAL
%     for id = 1:100000
%       [a2,b2,c2,d2] = deal(sys{:});
%     end
%     fprintf('DEAL    : %1.3f sec (%d iterations)\n\n', toc, id);
%     isequal({a1,b1,c1,d1},{a2,b2,c2,d2})
%
%   See also DEAL, LISTS, PAREN.

%   VERSIONS:
%     v1.0 - first version
%     v1.1 - remove call to DEAL
%     v1.2 - strip down code to 0 lines
%     v1.2.1 - modify help text
%
% Jiro Doke
% Copyright 2006-2010 The MathWorks, Inc.

%--------------------------------------------------------------------------
% Error Checking
%  Uncomment the lines below to get more helpful error messages. But
%  obviously, without these lines, the function runs much faster.
%--------------------------------------------------------------------------

% if nargin == 0
%   varargout = {};
% else
%   % Verify that input is a cell array
%   if ~iscell(varargout)
%     error('Input must be a cell array.');
%   end
%   
%   % Duplicate entries if cell array has only one element (similar to DEAL)
%   if length(varargout) == 1
%     varargout = varargout(ones(1,max(1,nargout)));
%   end
% end