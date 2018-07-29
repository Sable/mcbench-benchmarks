function txtFile = saveWordAsText(docFile,txtFile)
% txtFile = saveWordAsText(docFile)
% txtFile = saveWordAsText(docFile,txtFile)
% 
% Requires that Word be installed on your system.
%
% Author: Matthew Simoneau

% Locate DOC-file.
if ~isempty(dir(fullfile(pwd,docFile)))
    % Relative path.
    docFile = fullfile(pwd,docFile);
elseif ~isempty(dir(docFile))
    % Absolute path.
    docFile = docFile;
elseif ~isempty(which(docFile))
    % On the MATLAB path.
    docFile = which(docFile);
else
    error('Cannot find "%s".',docFile);
end

% Locate TXT-file.
if (nargin < 2)
    txtFile = strrep(docFile,'.doc','.txt');
else
    if ~isempty(dir(fileparts(fullfile(pwd,txtFile))))
        % Relative path.
        txtFile = fullfile(pwd,txtFile);
    end    
end

% Make sure we're not overwriting an existing file.
if ~isempty(dir(txtFile))
    error('"%s" already exists.',txtFile);
end

% Open Word.
wordApplication = actxserver('Word.Application');

% Uncomment this for debugging.
%set(wordApplication,'Visible',1);

% Get a handle to the documents object.
documents = wordApplication.Documents;

% Open the Document.
doc = documents.Open(docFile);

% wdFormatDocument = 0;
% wdFormatTemplate = 1;
wdFormatText = 2;
% wdFormatTextLineBreaks = 3;
% wdFormatDOSText = 4;
% wdFormatDOSTextLineBreaks = 5;
% wdFormatRTF = 6;
% wdFormatUnicodeText = 7;
% wdFormatHTML = 8;

% Save it as plain text.
doc.SaveAs(txtFile,wdFormatText);

% Close the document.
doc.Close;

% Close Word.
wordApplication.Quit;
