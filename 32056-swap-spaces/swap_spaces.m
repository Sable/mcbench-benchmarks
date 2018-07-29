function OUTPUT = swap_spaces(STRING, varargin)
%replaces spaces with underscores and vice versa
%SWAP_SPACES replaces spaces with underscores or underscores with spaces
% for desciptions and file names. If there are underscores AND spaces
% present in STRING, either give an option or only underscores will be replaced.
%
%Syntax
%    swap_spaces(textstring [, option])
%
%    Valid options are:
%     * '_' replaces all underscores with spaces
%     * ' ' replaces all spaces with underscores
%
%Example
%    f = swap_spaces('text_text')
%    f =
%        'text text'
%
%    g = swap_spaces('text text')
%    g =
%        'text_text'
%
%    h = swap_spaces('text text_text', '_')
%    h =
%        'text text text'
%See also
%    regexprep, strrep

p	=	inputParser;
validOptions = {'_', ' '};
p.addRequired('STRING',			@(x) all(ischar(x), ~isempty(x)) );
p.addOptional('OPT',	'',		@(x) any(strcmp(x, validOptions)) );
p.parse(STRING, varargin{:});

if isempty(p.Results.OPT)
	if strfind(STRING, '_')
		OUTPUT	=	strrep(STRING, '_', ' ');
	else
		OUTPUT	=	strrep(STRING, ' ', '_');
	end
elseif strcmp(p.Results.OPT, '_')
	OUTPUT	=	strrep(STRING, '_', ' ');
else
	OUTPUT	=	strrep(STRING, ' ', '_');
end

% Copyright 2009-2011 Alexandra Heidsieck <aheidsieck@tum.de>,
%                     IMETUM, Technische Universitaet Muenchen
