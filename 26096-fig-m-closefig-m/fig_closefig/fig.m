%%
%
% h = fig; 
% h = fig(ID); 
%
% Inputs
%
%   ID (optional) - identifier string. 
%
% Outputs
%   
%   h - figure handle. 
%
% Wraps matlab built-in function FIGURE.  Appends an ID string to the
% figure title for intelligent figure closing. 
%
% See also CLOSEFIG
%
% Sumedh Joshi
% The University of Texas at Austin
% sumedhj@mail.utexas.edu
% 26 May 2009

function varargout = fig(ID)

% Input checking. 
if ~exist('ID')
    ID = '';
end

% Generate the figure; 
h = figure; 

% Append the ID string. 
set(h,'Name',ID); 

switch nargout
    case 0
        varargout = {};
    case 1
        varargout = {h}; 
end

end