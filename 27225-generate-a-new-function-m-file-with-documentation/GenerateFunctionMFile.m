function GenerateFunctionMFile(ask)
%GENERATEFUNCTIONMFILE Generates an m-file suitable for a function,
% with header text.
% 
% GENERATEFUNCTIONMFILE() generates an m-file suitable for a function,
% with header text, saves it in your current directory, and opens it in
% the editor.
% 
% GENERATEFUNCTIONMFILE(ASK) works as above, but prompts for the name of
% the function.

% $Author: rcotton $  $Date: 2010/04/12 10:36:31 $ $Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

persistent fileNameCount

if nargin > 0 && ask
   fnName = input('Enter the name of your function >> ', 's');
   if ~isvarname(fnName)
      error('GenerateFunctionMFile:InvalidFunctionName', ...
         [fnName ' is not a valid function name']);
   end
else
   if isempty(fileNameCount)
      fileNameCount = 1;
   else
      fileNameCount = fileNameCount + 1;
   end
   while exist(['Untitled' num2str(fileNameCount)], 'file') >= 2
      fileNameCount = fileNameCount + 1;
   end
   fnName = ['Untitled' num2str(fileNameCount)];
end

fileName = fullfile(cd, [fnName '.m']);

if exist(fnName, 'file')
   error('GenerateFunctionMFile:FileAlreadyExists', ...
      [fnName '.m already exists in the current directory']);
end

WriteFile(fnName, fileName)
edit(fileName);

end

function WriteFile(fnName, fileName)
% Engine for writing the file.

now = clock;
nl = char(10);

   function PrintCommentLine(fid)
   fprintf(fid, '%% %s', nl);
   end

   function PrintBlankLine(fid)
   fprintf(fid, '%s', nl);
   end

fid = fopen0(fileName, 'w');
c = onCleanup(@() fclose(fid));

fprintf(fid, 'function [outputArgs] = %s(inputArgs)%s', ...
   fnName, nl);
fprintf(fid, '%%%s Summary of this function goes here%s', ...
   upper(fnName), nl);
PrintCommentLine(fid);
fprintf(fid, '%% [OUTPUTARGS] = %s(INPUTARGS) Explain usage here%s', ...
   upper(fnName), nl);
PrintCommentLine(fid);
fprintf(fid, '%% Examples: %s', nl);
PrintCommentLine(fid);
fprintf(fid, '%% Provide sample usage code here%s', nl);
PrintCommentLine(fid);
fprintf(fid, '%% See also: List related files here%s', nl);
fprintf(fid, nl);
% Need to keep $ separate in next line, so CVS doesn't replace values
% Also, this line will not work with GIT, since it messes with the SHA-1
fprintf(fid, '%% %sAuthor: %s $\t%sDate: %s $\t%sRevision: 0.1 $%s', ...
   '$', GetUserLoginName(), '$', ...
   datestr(now, 'yyyy/mm/dd HH:MM:SS'), '$', nl);
fprintf(fid, '%% Copyright: Health and Safety Laboratory %s%s', ...
   datestr(now, 'yyyy'), nl);
PrintBlankLine(fid);
PrintBlankLine(fid);
PrintBlankLine(fid);
fprintf(fid, 'end%s', nl);
end
