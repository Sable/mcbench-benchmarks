function [varargout] = styleguide(varargin)
% STYLEGUIDE Open or search the MATLAB Programming Style Guide Wiki
%   STYLEGUIDE by itself opens the MATLAB Programming Style Guide Wiki in
%   the MATLAB web browser.
%
%   STYLEGUIDE SEARCHTERM1 SEARCHTERM2 SEARCHTERM3 ... searches the style
%   guide for any number of provided search terms and opens the search
%   results page in the MATLAB web browser.
% 
%   STYLEGUIDE uses similar syntax to the WEB function with the exception
%   that it does not expect a URL. Rather, any number of search terms may
%   be used. All other inputs and outputs for WEB work for STYLEGUIDE, e.g.
%   [STAT, BROWSER, URL] = STYLEGUIDE(SEARCHTERM,'-NOTOOLBAR','-NEW').
% 
%   To request permission to edit the wiki, use the contact form at
%   http://www.mathworks.com/matlabcentral/fileexchange/authors/contact/101715
%
%   Examples:
%      styleguide naming conventions
%         searches the style guide for "naming+conventions."
%      
%      styleguide -browser
%         opens the style guide in the system web browser
%
%      [stat,h] = styleguide; 
%         opens the style guide. Use close(h) to close the browser window.
% 
%   See also WEB, HELP.

%   Author: Sky Sartorius
%           www.mathworks.com/matlabcentral/fileexchange/authors/101715

validWebArgs = {'-browser' '-display' '-helpbrowser' '-new' ...
    '-notoolbar' '-noaddressbox' '1'};

searchTerms = '';
isaWebArg = false(1,nargin);
for i = 1:nargin
    arg = strtrim(varargin{i});
    isWebArg = strcmpi({arg},validWebArgs);
    if any(isWebArg)
        isaWebArg(i) = true;      
    else
        searchTerms = [searchTerms '+' arg]; %#ok<AGROW>
    end
end
if ~isempty(searchTerms)
    searchTerms(1) = '';
end

link = 'https://sites.google.com/site/matlabstyleguidelines/'; 

if ~isempty(searchTerms)
    searchStr = 'system/app/pages/search?scope=search-site&q=';
    link = [link searchStr searchTerms];
end

jnk = lower(varargin(isaWebArg));
[varargout{1:nargout}] = web(link,jnk{:});

% Revision history
%{
2013-03-13 first version
%}