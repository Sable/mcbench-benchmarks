%%
%
% N = closefig(ID);
%
% Inputs
%
%   ID - identifier string. 
%
% Outputs
%
%   N  - number of figures closed. 
%
% Closes all figures tagged with ID string.
%
% See also FIG
%
% Sumedh Joshi
% The University of Texas at Austin
% sumedhj@mail.utexas.edu
% 26 May 2009 

function varargout = closefig(ID)

% Get all figure handles. 
c = get(0,'children');
N = 0; 

% Loop over handles, closing as necessary.
for ii = 1:length(c)
    if strcmp(get(c(ii),'name'),ID)
        close(c(ii));
        N = N + 1; 
    end
end

switch nargout
    case 0 
        varargout = {};
    otherwise
        varargout = {N};
end
        
        

end
