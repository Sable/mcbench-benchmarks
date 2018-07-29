function out_table = getTableFromWeb_mod(url_string, nr_table)
% Syntax:
%   out_table = getTableFromWeb_mod(url_string, nr_table)
% 
%Description:
% 
% Function getTableFromWeb_mod is based on the very very good "pick of the week" from August 20th, 2010 
% (http://www.mathworks.com/matlabcentral/fileexchange/22465-get-html-table-data-into-matlab) by Jeremy Barry.
% It is inspired by the restrictions of the original function and should users help, who had problems with the
% loading time of the requested webpage. So the workaround doesn't use the internal webbrowser by Matlab but
% takes the urlread function to import and analyze the table-webdata.
%
% To get table data, it is necessary to know from which url you want to read in the data and from which
% table. If you have an url but no idea which table with the specified tablenummer has the data use the
% originalfuntion getTableFromWeb
% (http://www.mathworks.com/matlabcentral/fileexchange/22465-get-html-table-data-into-matlab) to check which
% tablenumber with content you are interestred in.
%
% The first example(at the end of description) gets actual departure information by german railways for the
% railwaystation Frankfurt Hbf (coded by ibnr, international railway station number).
% The second example belongs to the orinigal example by Jeremy Barry and gets financial information.
% 
% There are two input arguments:
% url_string  -- is the string of the requested webpage
% nr_table    -- number of table to get and to put in out_table
%
% Ouput argument:
% out_table  -- is a cell array of requested data
%
% Example:
%
% % German Railways-travelling information example
%  ibnr       = 8098105;   % IBNR  railway station: Frankfurt-Hbf   (for more ibnr see: http://www.ibnr.de.vu/)
%  url_string = [ 'http://reiseauskunft.bahn.de/bin/bhftafel.exe/dn?rt=1&ld=10000&evaId=', num2str(ibnr) ,'&boardType=dep&time=actual&productsDefault=1111000000&start=yes'];      % question string fo calling actual departure information for Frankfurt HBF 
%  nr_table   = 2;  % Table with the travelinformation data
%  out_table  = getTableFromWeb_mod(url_string, nr_table)
%
% % Finance example 
% % run getTableDataScript to see, which table is number 7 (Valuation Measures)
% url_string = ('http://finance.yahoo.com/q/ks?s=GOOG');
% nr_table   = 7;
% out_table  = getTableFromWeb_mod(url_string, nr_table)
%
%
% Bugs and suggestions:
%    Please send to Sven Koerner: koerner(underline)sven(add)gmx.de
%
% Modified by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2010/12/06 
%
% License additional conditions:
% 
% Because of Redistribution and binary modification see the following original license:
%
% Copyright (c) 2010, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
%
%  Additional Data:
%%% The original function is getTableFromWeb 
% Inputs - none
% Outputs - data from selected table
%
% Usage:
% * Navigate to a webpage using the MATLAB web browser (note: this will NOT
% work with any other browser)
% * Once at the location of the table you want, execute this function
% (getTableFromWeb)
% * Click on the MATLAB logo next to the table you want to import
%
% This function takes no input arguments.  The varargin is so that when
% getting the data from a table it can identify which table you have
% chosen.
% Copyright 2008 - 2010 The MathWorks, Inc.


%% Modification: do not open the Matlab-Browser 
% % % newBrowser = 0;
% % % activeBrowser = [];
% % % if ~newBrowser
% % %     % User doesn't want a new browser, so find the active browser.
% % %     activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.getActiveBrowser;
% % % end
% % % if isempty(activeBrowser)
% % %     % If there is no active browser, create a new one.
% % %     activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.createBrowser(showToolbar, showAddressBox);
% % % end


%% Modification: read the html content via urlread and not via active browser
%%% Call functionality to update the HTML with MATLAB hooks to grab data
%%% urlText    = activeBrowser.getHtmlText;
%%% newUrlText = updateHTML(urlText);
%%% activeBrowser.setHtmlText(newUrlText);


%% Uncomment to see the requested html-document 
% web (url_string);

%%  begin modified code
urlText         = java.lang.String(urlread(url_string));         % get the urlcontent
[i, newUrlText] = updateHTML(urlText);                           % in i is the number of tables

if i>1 % if there are tables to read
    out_table = getHTMLTable(nr_table, newUrlText); 
else
    % there was no table
    out_table ={'No Table detected.'};
end;


end

%% Modification: get the number of all tables and the modified urltext
function [i, newUrlText] = updateHTML(url)
% Output:   i               --> number of tables in url
%           newUrlText      --> modified output text

%% Setup
%% Modification
% Set the location to the icon
% iconLocation = which('matlab.ico');
% iconLocation = ['file://' regexptranslate('escape', iconLocation)];
%%
% Convert the Java string to a character array for MATLAB
pageString = reshape(url.toCharArray, 1, []);
%% Regular expressions used in replacements
noDataTable = 'replaceMeFirst'; %used for tables with no visible data
%dataTable = ['<a href="matlab:getTableFromWeb(replaceMe)"><img src="' iconLocation '" align="left" name="MLIcon"/></a>'];
% Modification
dataTable = '<a href="matlab:getTableFromWeb_mod(replaceMe)"></a>';

%% Find all tables
tables = regexprep(pageString, '(<table[^>]*>(?:(?>[^<]+)|<(?!table[^>]*>))*?</table)', [noDataTable '$1']);

%%
% Remove the text in front of tables with no data
tables = regexprep(tables, [noDataTable '(<table[^>]*>(?:<[^>]*>\s*)+?)</table[^>]*>'], '$1');

% Add the string for accessing MATLAB in front of tables with data
tables = regexprep(tables, noDataTable, dataTable);

% Find all of the table with data tags and provide them with a unique
% identifier for grabbing the data
dataTableID = regexp(tables, 'replaceMe', 'tokens');
for i = 1:length(dataTableID)
    tables = regexprep(tables, 'replaceMe', num2str(i), 'once');
end
%% output
% Output the new HTML
newUrlText = tables;
end


%% Get the specified table data
function out = getHTMLTable(tableID, pageString)

% Get the HTML text from the browser window and conver to MATLAB character
% array
% Modifaction: get the content without Matlab webbrowser
% % % activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.getActiveBrowser;
% % % pageString = reshape(activeBrowser.getHtmlText.toCharArray, 1, []);

% Pattern for finding MATLAB hooks
%pattern = ['<a href="matlab:getTableFromWeb\(' num2str(tableID) '\)'];

%% Modifction 
pattern = ['<a href="matlab:getTableFromWeb_mod\(' num2str(tableID) '\)'];

% Find data from the table
[s e tok match] = regexp(pageString, [pattern '.*?<table[^>]*>.*?(<tr.*?>).*?</table[^>]*>' ], 'once');
anyData = strtrim(regexprep(match, '<.*?>', ''));

if(isempty(anyData))
    r = regexp(pageString, [pattern '.*?</table><table[^>]*>(.*?)</table'], 'tokens', 'once');
else
    r = regexp(pageString, [pattern '(.*?)</table'], 'tokens');
end

% Convert any data in cell arrays to characters
while(iscell(r))
    r = r{1};
end

%Establish a row index
rowind = 0;

% Build cell aray of table data
try
    rows = regexpi(r, '<tr.*?>(.*?)</tr>', 'tokens');
    for i = 1:numel(rows)
        colind = 0;
        if (isempty(regexprep(rows{i}{1}, '<.*?>', '')))
            continue
        else
            rowind = rowind + 1;
        end
        
        headers = regexpi(rows{i}{1}, '<th.*?>(.*?)</th>', 'tokens');
        if ~isempty(headers)
            for j = 1:numel(headers)
                colind = colind + 1;
                data = regexprep(headers{j}{1}, '<.*?>', '');
                if (~strcmpi(data,'&nbsp;'))
                    out{rowind,colind} = strtrim(data);
                end
            end
            continue
        end
        cols = regexpi(rows{i}{1}, '<td.*?>(.*?)</td>', 'tokens');
        for j = 1:numel(cols)
            if(rowind==1)
                if(isempty(cols{j}{1}))
                    continue
                else
                    colind = colind + 1;
                end
            else
                colind = j;
            end
            data = regexprep(cols{j}{1}, '&nbsp;', ' ');
            data = regexprep(data, '<.*?>', '');
            
            if (~isempty(data))
                out{rowind,colind} = strtrim(data) ;
            end
        end
    end
end
end