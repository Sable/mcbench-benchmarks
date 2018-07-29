function InsertHeader(varargin)
% InsertHeader - Adds a template to the top of current file in editor for documentation.
% 
% Syntax: InsertHeader(varargin)
% varargin - optional input of full file name
%   Example 1:  InsertHeader adds header to top of currently selected file in
%   editor
%   Example 2: InsertHeader('InsertHeader') added the current header information to this
%   file. NOTE:  THIS CANNOT BE UNDONE!  THE FIRST TIME YOU USE THIS, PLEASE
%   HAVE A BACK UP COPY OF THE FILE IN CASE IT MAKES A MISTAKE.
%   Custom defined headers can be created in the subfunction defined at
%   the end of the file.  I wish to express thanks to the authors of tedit.m and
%   newfcn.m which helped me to create this routine.
%  See also:  tedit, newfcn
%
% Subfunctions: EditorCurrentFile, parseForSubFcns, insertHeaderTemplateFile

% AUTHOR    : Dan Kominsky
% Copyright 2011  Prime Photonics, LC.
%%

if nargin==1
	CurrentFile=varargin{1};
else
	% Call subfunction to determine the current file:
	[CurrentFile]=EditorCurrentFile;
end
% Ask to make sure I am going to add the header to the correct file
resp=questdlg(['Add Header to file: ' CurrentFile '?'],'Header Query');
if ~strcmpi(resp,'Yes'),return;end;

if verLessThan('matlab','7.12.0') % Matlab interface changed with 7.12.0
  old_style = true;
% Define the handle for the java commands:
edhandle=com.mathworks.mlservices.MLEditorServices;
% Save the current document so changes aren't lost
edhandle.saveDocument(CurrentFile);
[PATH,FILENAME]=fileparts(CurrentFile);

% Load the existing file
rawText=char(edhandle.builtinGetDocumentText(CurrentFile));
 
else
  old_style = false;
  % Define the handle for the java commands:
  editorObject = matlab.desktop.editor.getActive;
  % Save the current document so changes aren't lost
  editorObject.save;
  % Load the text:
  rawText=editorObject.Text;  
  
  [PATH,FILENAME]=fileparts(CurrentFile);
  
end


% For some reason the previous command replaces (at least on windows) each
% carraige return with a carraige return/line feed combo.  The next line removes
% the double spacing.   It may not be necessary on other platforms!
% In some cases it might use just the char(10), so convert that to char(13);
currentText=regexprep(rawText,[char(13) char(10)],char(13));
currentText=regexprep(currentText,char(10),char(13));

% Check to find the true end of the first line.  If it is a continuation, keep
% going until the function definition is ended.
ellipsisTest=true;
firstLine='';
remainder=currentText;
while ellipsisTest
	[tmpfirstLine,remainder]=strtok(remainder,char(13));
	firstLine=[firstLine,char(13),tmpfirstLine];
	if sum(firstLine(end-4:end)==46)>=3
		ellipsisTest=true;
	else
		ellipsisTest=false;
	end
	pause(0.01)
end

  
  
funcLabel=any(regexp(firstLine,'function'));
syntaxStr={};
inputs={};
outputs={};
count=1;
if funcLabel
	syntaxStr=regexprep(firstLine,'function','');
	hasEquals=any(regexp(syntaxStr,'='));
	if hasEquals
	[beforeEq,afterEq]=strtok(strtrim(syntaxStr),'=');
	else
		beforeEq='';afterEq=strtrim(syntaxStr);
	end
	tmpoutputs=regexp(beforeEq,'(\w+)','tokens');
	for n=1:numel(tmpoutputs)
		outputs{n}=char(tmpoutputs{n});
	end
	tmpinputs=regexp(afterEq,'(\w+)','tokens');
	funcname=char(tmpinputs{1});
	for n=2:numel(tmpinputs)
		inputs{n-1}=char(tmpinputs{n});
	end
end

  subFcnName=parseForSubFcns(CurrentFile);

% insertHeaderTemplateFile contains the text to be added into the file
tmpl=insertHeaderTemplateFile(FILENAME,inputs,outputs,syntaxStr,subFcnName);

% Convert to a string
parseIn = sprintf('%s\n',tmpl{:});


% Concatenate the firstline (function definition), header, and body:
concatenatedText=strcat(firstLine,parseIn,remainder);
% Strip any extra leading carraige returns:
while (double(concatenatedText(1)))==13 || (double(concatenatedText(1)))==10
	concatenatedText(1)=[];
end

  if old_style
% Close the file:
edhandle.closeDocument(CurrentFile);
% Open and OVERWRITE the file
fid=fopen(CurrentFile,'wt');
fprintf(fid,'%s\n',concatenatedText);
fclose(fid);
% Reopen the file to the begining.
edhandle.openDocumentToLine(CurrentFile,1);
  else
    editorObject.save;
    fid=fopen(CurrentFile,'wt');
    fprintf(fid,'%s\n',concatenatedText);
    fclose(fid);
    editorObject.reload;
  end
end


% ------------------------
function [CurFile, varargout] = EditorCurrentFile

  if verLessThan('matlab','7.12.0') % Matlab interface changed with 7.12.0
% Define the handle for the set of java commands:
desktopHandle=com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
% Determine the last selected document in the editor:
lastDocument=desktopHandle.getLastDocumentSelectedInGroup('Editor');
% Strip off the '*' which indicates that it has been modified.
CurFile=strtok(char(desktopHandle.getTitle(lastDocument)),'*');

if nargout>1
	varargout{1}=lastDocument;
end
  else
    editorObject = matlab.desktop.editor.getActive;
    CurFile = editorObject.Filename;
  end
  
end

function [functions varargout]=parseForSubFcns(myFunc)
  if exist(myFunc,'file')
    % We have a full path to the file
    str= mlintmex('-calls',myFunc);
  else
    % File is on the path, and we must find it:
    str= mlintmex('-calls',which(myFunc));
  end
  [a,b,c,d,e] = regexp(str,'([NS])\d* (\d+) (\d+) (\w+)\n');
  if isempty(e)
    functions = [];varargout{1}=[];
    return
  end
  if nargout < 1
    sprintf('Sub/Nest\t\tLine#\t\tCol#\t\tName')
    for iFcn = 1:numel(e)
      S=sprintf('%8s\t\t%6s\t\t%6s\t\t%s',e{iFcn}{1:4});
      disp(S)
    end
  else
    functions = [];
    for iFcn = 1:numel(e)
      S=sprintf('%s, ',e{iFcn}{4});
      functions = [functions S];
      cellList{iFcn} = e{iFcn}{4};
    end
    functions(end-1:end) = [];
    if nargout>1
      varargout{1} = cellList;
    end
  end
end

function tmpl=insertHeaderTemplateFile(FILENAME,varargin)
% insertHeaderTemplateFile Contains the header which is automatically inserted
%   tmpl = insertHeaderTemplateFile(FILENAME)
%
%   Example
%   insertHeaderTemplateFile('currentFile.m') returns the cell array of strings
%   which is inserted into file headers.
%
%   See also

% AUTHOR    : Dan Kominsky
  % Copyright 2006 Prime Photonics, LC.
%%
applyComment=@(x)['% ' x ' - Description'];
commaPad=@(x)[x{:}, ', '];

if nargin>1
	inputLines=cellfun(applyComment,varargin{1}','UniformOutput',false);
else
	inputLines='';
end
if nargin>2
	outputLines=cellfun(applyComment,varargin{2}','UniformOutput',false);
else
	outputLines='';
end
if nargin>3
  synt_str_raw = strtrim(varargin{3});
  synt_str_eols = regexprep(synt_str_raw,'\n','\n%');
  synt_str_adj = regexprep(synt_str_eols,'\r','\r%');
	syntaxStr=['% Syntax: ' synt_str_adj];
else
	syntaxStr='';
end
if nargin>4
    subFcns = ['% Subfunctions: ' varargin{4}];
else
	subFcns='% Subfunctions: none';
end
topLines={ ...
	''
  ['% ' FILENAME  ' - One line description of what the function or script performs (H1 line)']
	'% Optional file header info (to give more details about the function than in the H1 line)'};
midLines=[syntaxStr; inputLines;outputLines];
bottomLines={	'%   Example'
	'%  Line 1 of example '
	'%'};
authorLines={...
	'%   See also: '
	''
	'% AUTHOR    : Jebediah Obediah'
	['% Copyright ' datestr(now,'yyyy') '  XYZ Corp.']
	'%%'};

tmpl=[topLines;midLines;bottomLines;subFcns;authorLines];
end
