function cdw(f)
%CDW  Change current working directory with wildcards
%   CDW works as Matlab's built-in CD, but allows for wildcards (*). If
%   many directory names match, the first one is used.
%
%   Examples:
%      CDW mydir*2*
%
%   See also CD, LSW, RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2008/07/28


% History:
% 2008/07/28: v1.00, first version.

error(nargchk(1,1,nargin));
f=rdir(f,'dironly');
if ~isempty(f)
    cd(f{1})
end
