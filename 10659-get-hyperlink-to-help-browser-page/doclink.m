function href_text = doclink
%DOCLINK - Provide HREF text for Hyperlink to a Help Page Document
% Grabs the document link from the page currently open in the Help Browser.
% HTML text can be provided in MATLAB help pages for functions.
% This is useful when a specific help page in the MATLAB documentation
% needs to be referenced. The <a href="matlab:doc doc">doc</a> command is only supported (as of R2006a)
% for function names, not general topics.
% However, this function provides text that can be used in a simple HTML
% command in the help text to achieve this goal. For example, here is the
% link to documentation on <a href="matlab:web(['jar:file:'  matlabroot '/help/techdoc/help.jar!/matlab_prog/f4-70115.html'],'-helpbrowser')">Anonymous Functions</a>
%
% HREF = DOCLINK
%
%Input(s):
%  No Inputs... It takes the current page information from the open 
%   <a href="matlab:doc">MATLAB help browser</a>
%
%Output(s):
%  HREF_TEXT - text to be used as part of an HTML hyperlink:
%    <a href="HREF_TEXT">Link Description</a >
%              ^^^^^^^^                     ^ Get rid of this space
%    (An invalid space is used in HTML expression above to prevent the text
%     from be shown as a hyperlink in the help here!)
%
%   Usage: copy the HTML line above to your M-file help, then replace
%    HREF_TEXT with the output of this DOCLINK function, change the
%    Link Description and remove the space in </a >.
%    Be careful that this HTML does not appear as part of the "See also"
%    section of the help, or it will not be properly interpreted.
%    Suggested usage is below the "See also" line, making sure to use a
%    blank comment line to separate it:
%
%%See also
%%
%%Reference page in Help browser
%%    <a href="HREF_TEXT">Link Description</a >
%
%   Note: the entire HTML text must be given on one line... The MATLAB
%   Editor will probably try to wrap the text to multiple lines 
%
%Example:  Test it out by displaying the hyperlink.
% Copy the line of code below to the MATLAB console window.
% ****** Remove the space in </a > (to make it a valid hyperlink):
% disp(['<a href="' doclink '">Documentation Hyperlink</a >'])
%
%See also doc, web, helpview
%
%Reference pages in Help browser
%   <a href="matlab:web(['jar:file:',matlabroot,'/help/techdoc/help.jar!/matlab_env/help23.html'],'-helpbrowser')">Help Functions</a>
%   <a href="matlab:doc matlabcolon">Hyperlinking MATLAB Commands</a>

% Author: Abraham Cohn

% Copyright Philips Medical Systems. April 6, 2006.

%% Get the Doc Page
docPage = char(com.mathworks.mlservices.MLHelpServices.getCurrentLocation);

%% Make URL independent of MATLAB Installation path
% URLs use forward slashes, but matlabroot may not.
% Convert slashes in matlabroot path segment, and convert to matlabroot
% expression.
url = ['[''', strrep(docPage,strrep(matlabroot,filesep,'/'),''',matlabroot,'''), ''']'];

%% Write HMTL matlab command to invoke the helpbrowser to this url
href_text = ['matlab:web(' url ',''-helpbrowser'')'];
