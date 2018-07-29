function [X,FULLFMT] = saveascii(X,varargin)
%SAVEASCII   Save/display a matrix with specific format for each column.
%
%   SYNTAX:
%                   saveascii(X)                 % Displays
%                   saveascii(X,...,FMT)
%                   saveascii(X,...,DLM)
%                   saveascii(X,FILE,...)        % Saves
%                   saveascii(X,FILE,...,'a')    % Appends
%     [Y,FULLFMT] = saveascii(...); 
%
%   INPUT:
%     X    - 2-dimensional numeric, logical or string array with Ncol
%            columns to be saved/display, with/without NaNs, or a vector of
%            cell of strings.
%     DLM  - One or Ncol-1 strings on a cell specifying the delimiter(s)
%            between every/each pair if columns.
%            DEFAULT: {' '} or {''} (the latter if X is char)
%     FMT  - One or Ncol integers in a vector specifying the PRECISION for
%            every/each column, or One or Ncol strings in a cell specifying
%            its format(s). See NOTE below.
%            DEFAULT: '% 8.7e' or '%c' (the latter if X is char)
%     FILE - File name or identifier specifying the output file.
%            DEFAULT: not used (just displays)
%     'a'  - Appends to the given FILE in text mode. Use 'w -i' to active a
%            OVERWRITE warning. See NOTE below.
%            DEFAULT: 'w' (creates/OVERWRITES! the given FILE in text mode)
%
%   OUTPUT (all optional):
%     Y       - Matrix X converted to a string with specified format(s) and
%               delimiter(s). 
%     FULLFMT - Format used to save/dislay the matrix. If X is a cell of
%               strings, this is also a cell of strings without the End of
%               Line.
%
%   DESCRIPTION:
%     This program saves/displays a matrix array by using SPRINTF/FPRINTF
%     with specific format (FMT) and delimiter (DLM) for every or EACH
%     column in a very handy way, which is the mayor difference with SAVE
%     or DLMWRITE function.
%
%     The point of this program is to allow the user to save/display any
%     numeric or char matrix as easy as posible without messing with the
%     appropiate format ('%...') to do it, only with the precision (if is
%     numerical). See the EXAMPLE below.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * FMT and DLM may be a single string.
%     * When FMT is used as precision integers, negative ones indicates to
%       treat column(s) of X as integers rounded up to those significant
%       digits to the left!
%     * ADDITIONAL NOTES are included inside this file.
%
%   EXAMPLE:
%     x = [    1    2    pi 
%              4  NaN     6 
%           75.4  Inf   8.5 ];
%     % Display with 3 significant decimals.
%       saveascii(x,3)
%         % RETURNS:
%         %  1.000  2.000  3.142
%         %  4.000    NaN  6.000
%         % 75.400    Inf  8.500
%         %
%     % Display with specific significant decimals.
%       saveascii(x,[-1 2 0])
%         % RETURNS:
%         %  0 2.00 3
%         %  0  NaN 6
%         % 80  Inf 9
%         %
%     % Displays with ' hello ' and ' bye ' as delimiter.
%       saveascii(x,{' hello ',' bye '},2)
%         % RETURNS:
%         %  1.00 hello  2.00 bye  3.14
%         %  4.00 hello   NaN bye  6.00
%         % 75.40 hello   Inf bye  8.50
%         %
%     % Saves on 'saveascii_demo.txt' with heading.
%       FILE = 'saveascii_demo.txt';
%       saveascii('% Demo file'                   ,FILE)
%       saveascii(['%  Pi = ' saveascii(pi,3) ';'],FILE,'a')
%       saveascii(x                               ,FILE,'a',0)
%       edit(FILE)
%       demo = load(FILE)
%         % RETURNS:
%         % demo =
%         % 
%         %      4   NaN     6
%         %     75   Inf     9
%         %
%     % NOTE: see how the heading is ignored by the LOAD function.
%        
%   SEE ALSO:
%     SAVE, FPRINTF, SPRINTF, DLMWRITE, CSVWRITE, FOPEN, STR2DOUBLE, 
%     STR2NUM, NUM2STR
%     and
%     READLINE by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   saveascii.m
%   VERSION: 6.2 (Oct 30, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   ADDITIONAL NOTES:
%     * X must be the first input always, and, if used, FILE must be the
%       second one. Afterwards FMT, DLM and 'a' may be given in any order.
%     * By default the program writes with in text mode by append a 't' in
%       the open permission mode ('wt' or 'at') rather than in the default
%       binary mode ('wb' or 'ab'). This allows Windows OS users to read
%       the saved file with any ascii program. See FOPEN for more details.
%     * By default, the program OVERWRITES without warning, to use a
%       warning use the optional input 'w -i' instead of the default 'w'.
%     * To create a NEWLINE the program uses: '\n'. I guess Mac OS users
%       should change the program to use '\r' instead.
%     * The program works faster when a single delimiter and format/
%       precision are used for every column.  
%     * The FMT may be a FULL format, which is a single string with Ncol
%       formats within as the FULLFMT output.

%   REVISIONS:
%   1.0      Released. (Mar 06, 2006)
%   2.0      Allows delimiter and format for each column. (Sep 28, 2006)
%   2.1      English translation from spanish. (Nov 13, 2006)
%   3.0      Now allows input decimals for floating-point. 'wt' and 'at'
%            for Windows users. Output to Command Window and check errors.
%            (Feb 21, 2007)
%   3.1      Now accepts zero and negative decimals. (Feb 26, 2007)
%   3.1.1    Bug fixed with row vectors (thanks to Emilio Velazquez). (Mar
%            01, 2007) 
%   3.1.2    Bug fixed on get_digits subfunction. Used SUM of logicals
%            instead of ANY. (Mar 02, 2007)
%   4.0      Cleaner and rewritten code (cells). Reduced running time and
%            memmory usage. Fixed bugs. Accounts Inf and NaN's. Changed
%            default delimiter '\t' to ' '. Changed beginner char '@' to
%            '<'. Added ending option. Optionaly format string output. (Mar
%            11, 2008)
%   4.0.1    Fix little bug with INTEGER type. (Mar 13, 2008)
%   4.0.2    Fixed bug with not numeric elements (NAN's, Inf's and -Inf's).
%            (Mar 13, 2008)
%   4.0.3    Fixed bug when the whole column is no finite (NaN, Inf, or
%            -Inf's). (May 06, 2008)
%   5.0      Rewritten help and code. Fixed minor bugs related with empty
%            X. No more reversed outputs. No more Begginig and Ending
%            string optional inputs allowed. No more inputs separated by
%            commas for DLM, FMT or precision FMT are allowed, instead cell
%            of strings or a vector of integers must be used. DLM optional
%            input is forced to be a cell of strings. New overwrite warning
%            added. (Jun 08, 2009)
%   5.0.1    When FMT is numeric (precision) now the program rounds up to
%            it before saving. This eliminates any negative zero output
%            like '-0.00'. (Jun 19, 2009)
%   6.0      Now save a cell of strings. Again accepts a single delimiter
%            as string. (Sep 30, 2009)
%   6.1      Ignores optional empty inputs. Added some title comments (Oct
%            03, 2009)
%   6.2      Fixed small bug with parse inputs. Now creates file directory
%            if not exist. (Oct 30, 2009)

%   DISCLAIMER:
%   saveascii.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2004,2006,2007,2008,2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Checks number of inputs and outputs.
if     nargin<1
 error('CVARGAS:saveascii:notEnoughInputs',...
  'At least 1 input is required.')
elseif nargin>5
 error('CVARGAS:saveascii:tooManyInputs',...
  'At most 5 inputs are allowed.')
elseif nargout>2
 error('CVARGAS:saveascii:tooManyOutputs',...
  'At most 2 outputs are allowed.')
end

% Sets defaults:
FILE = [];          % Function mode:
                    %              [] : display
                    %    filename/fid : save
PER  = 'w';         % Open permission:
                    %    'w' : OVERWRITES without warning
                    %    'a' : ppends
TOB  = 't';         % Write mode: 
                    %    't' : text 
                    %    'b' : binary (FOPEN default)
WAR  = false;       % Overwrite warning:
                    %    false : do not warns
                    %    true  : do warns
if ischar(X) ||...  % String matrix
  iscellstr(X)      % or cell of strings input:
 FMT = {'%c'};      %    Format string for each (every) column.
 DLM = {''};        %    If just text, nothing between chars.
else                % Numeric (real) or logical matrix input:
 FMT = {'% 8.7e'};  %    Ugly, but MATLAB seems to like it, do you?
 DLM = {' '};       %    Single space. Try '\t' (tab).
end                 %
BOEL  = '';         % String at the Begining of Each line.
EOEL  = '\n';       % String at the End Of Each Line
                    %    '\n' : for Windows and Unix OS users
                    %    '\r' : for Mac OS users (I guess, not tested)
PRE  = [];          % Not used by default.
WID  = [];          % Not used by default.
SPC  = 'f';         % Floating-point specifier.


% CHECKS X ================================================================
% Checks X size.
Nrow = size(X);
if length(Nrow)>2
 error('CVARGAS:saveascii:incorrectXDimension',...
  'X must be a 2-dimensional matrix array.')
else
 Ncol = Nrow(2);
 Nrow = Nrow(1);
end
% Checks X empty, type and complex.
Xemp  = isempty(X);
Xnum  = false;
Xcell = false;
if ~Xemp && (isnumeric(X) || islogical(X)) % Fixed BUG (May 07, 2009)
 if ~isreal(X)
  warning('CVARGAS:saveacii:complexInput',...
  'Imaginary parts on X were ignored.')
  X = real(X);
 end
 Xnum = true;
elseif ischar(X) 
 % continue
elseif iscellstr(X)
 Xcell = true;
 if Ncol>1
  if Nrow~=1
   error('CVARGAS:saveascii:incorrectXCellSize',...
    'X must be a vector of cell of strings, not a matrix.')
  end
  Nrow = Ncol;
  Ncol = 1;
 end
 X = X(:);
 Ncolcell = cellfun(@length,X);
 if Nrow==1
  % Cell of length 1?
  X     = X{1};
  Xcell = false;
 end
elseif ~Xemp
 error('CVARGAS:saveascii:incorrectXType',...
  'X must be numerical, logical, string or cell of strings type.')
end

% CHECKS VARARGIN =========================================================
% Checks number of optional inputs by type. 
% Fixed bug with empty inputs. Oct 2009
Nopt   = length(varargin);
inum   = false(1,Nopt);
ichar  = inum;
icell  = inum;
iempty = inum;
for k = 1:Nopt
 if     isempty(varargin{k})
  iempty(k) = true;
 elseif ischar(varargin{k})
  ichar(k)  = true;
 elseif iscellstr(varargin{k})
  icell(k)  = true; % Fixed bug, Oct 2009
 elseif isnumeric(varargin{k})
  inum(k)   = true;  % Fixed bug, Oct 2009
 else
  error('CVARGAS:saveascii:incorrectTypeInput',...
  'Optional inputs must be numerical, char or cell of strings type.')
 end
end

% Checks numeric inputs.
[newFILE,PRE] = get_num(PRE,Ncol,varargin(inum),find(inum),find(iempty));
clear inum iempty

% Gets format.
newFMT = [];
if Xnum
 % Checks PRE.
 % Avoids a subfunction to optimize memory usage.
 if ~isempty(PRE)
  
  % Rounds down to positive PRE and up to negative PRE. 
  ind = (PRE<0);
  if any(ind)
   % Negative PRE.
   if length(PRE)==1
    temp = 10^PRE;
    X    = round(X*temp)/temp;
   else
    temp     = repmat(10.^PRE(ind),Nrow,1);
    X(:,ind) = round(X(:,ind).*temp)./temp;
   end
   clear temp
   PRE(ind) = 0;
  end
  if any(~ind) % (Fixed BUG, Jun 19 2009)
   % Positive PRE.
   if length(PRE)==1
    temp = 10^PRE;
    X    = round(X*temp)/temp;
   else
    temp      = repmat(10.^PRE(~ind),Nrow,1);
    X(:,~ind) = round(X(:,~ind).*temp)./temp;
   end
   clear temp
  end
  X(X==0) = 0; % Forces positive zeros.
  
  % Generate format from precision.
  % First, creates a short matrix x3 to get the width and helps to save
  % memory, with only 3 rows: 
  % 1. Maximum of X columns (ignoring Inf's)
  % 2. Flags if columns of X has: NaN->1; Inf->1; -Inf->-1; otherwise->0
  % 3. Minimum of X columns (ignoring -Inf's)
  iinf  = ~isfinite(X);          %  1's if NaN, Inf or -Inf, 0 otherwise.
  iinfn = find(iinf);            %  To get the -Inf indexes:
  iinfn(isnan(X(iinfn)) ) = [];  % ... deletes the NaN's. Bug fixed mar08
  iinfn(      X(iinfn)>0) = [];  % ... deletes the Inf's
  iinf = double(iinf);           % Turns them to double values
  iinf(iinfn) = -1;              % Put -Inf flags as -1.
  x3 = [maxinf(X,[],1); any(iinf,1)-2*any(iinf<0,1); mininf(X,[],1)];
  clear iinf iinfn
  % Creates the format string from precision options.
  newFMT = pre2fmt(PRE,WID,SPC,Ncol,x3);
  clear x3
 end
else
 if ~isempty(PRE)
  error('CVARGAS:saveascii:incorrectFmtNumericalInput',...
   'FMT cannot be numerical because X is not numeric.')
 end
end

% Checks cell inputs:
[newDLM,newFMT,EOEL,full1] = ...
                         get_cell([],newFMT,EOEL,Ncol,varargin(icell));
clear icell
 
% Checks string inputs.
% Fixed bug to work with char DELIMITERS besides of cells. Sep 2009.
[newFILE,PER,TOB,WAR,newDLM,newFMT,EOEL,full2] = get_char(newFILE,PER,...
              TOB,WAR,newDLM,newFMT,EOEL,Ncol,varargin(ichar),find(ichar));
clear ichar varargin

% CHECKS FORMAT ===========================================================
% Given FMT?:
if ~isempty(newFMT)
 if ~Xnum
  warning('CVARGAS:saveascii:incorrectFmtCharInput',...
   'Ignored specific format because X is char.')
 else
  FMT = newFMT;
 end
end

% Given DLM:
if ~isempty(newDLM)
 if full1 || full2
  warning('CVARGAS:saveascii:ignoredDlmInput',...
   'DLM ignored because FMT is a full format.')
  DLM = {''};
 else
  DLM = newDLM;
 end
end

% Generates full format:
if ~Xemp
 if ~Xcell
  FULLFMT = [BOEL get_strform(DLM,FMT,Ncol) EOEL];
 else
  FULLFMT = cell(Nrow,1);
  eoel = EOEL;
  if ~isempty(EOEL)
   for k = 1:2
    if     strcmp(eoel(end-1:end),'\n') 
     eoel(end-1:end) = []; 
    elseif strcmp(eoel(end-1:end),'\r')
     eoel(end-1:end) = []; 
    end
    if isempty(eoel), break, end
   end
  elseif length(FMT)>1
   for k = 1:2
    if isempty(FMT), break, end
    if     strcmp(FMT(end-1:end),'\n')
     EOEL = FMT(end-1:end);
     FMT(end-1:end) = []; 
    elseif strcmp(FMT(end-1:end),'\r')
     EOEL = FMT(end-1:end);
     FMT(end-1:end) = []; 
    end
   end
  end
  for k = 1:Nrow
   FULLFMT{k}    = [BOEL get_strform(DLM,FMT,Ncolcell(k))    eoel];
  end
 end
else
 % Empty array.
 X       = '';   % Fixed BUG (May 07, 2009)
 FULLFMT = '';
end
clear BOEL WID FMT DLM SPC Ncol

% CHECKS FILE =============================================================
% Given FILE?:
if ~isempty(newFILE)
 FILE = newFILE;
 % Warning for the file id used. To check that FILE is a fid and not a
 % precision.
 if isempty(PRE) && isempty(newFMT) && isnumeric(FILE)
  if ~isempty(fopen(FILE))
   warning('CVARGAS:saveascii:usedFileNumericalInput',...
    'Filename used was ''%s'' with file identifier %.0f.',fopen(FILE),FILE)
   % To ignore this warning use
   % >> warning('off','CVARGAS:saveascii:usedFileNumericalInput')
   % before calling this program.
  else
   error('CVARGAS:saveascii:invalidNumericalSecondInput',...
    ['Numerical second input must be a valid File Identifier. If it is '...
     'PRECISION, give an empty, [], as second input.'])
  end
 end
end
if ~isempty(FILE) && isnumeric(FILE)
 % File id:
 fid  = FILE;
 [FILE,per] = fopen(fid);
 if ~ismember(per(1),'aAwW')
  error('CVARGAS:saveascii:noWrittingPermission',...
    ['Filename ''%s'' with file identifier %.0f does not have writting ' ...
     'permision. See FOPEN for details.'],fopen(FILE),FILE)
 end
 if Xcell && ~ismember(per(1),'aA')
  error('CVARGAS:saveascii:noAppendPermission',...
    ['Filename ''%s'' with file identifier %.0f does not have append ' ...
     'permision. Elements of cell X will overwrite the file each time.']...
     ,fopen(FILE),FILE)
 end
else
 fid = [];
end
Femp = isempty(FILE);
if (~Femp && WAR) && ((isempty(fileparts(FILE)) && ...
  (exist(fullfile(pwd,FILE),'file')==2)) || (exist(FILE,'file')==2))
 % Overwrite warning.
 h = questdlg({'Is it OK to overwrite the file:'; [FILE '?']},...
               'saveascii.m','Yes','Cancel','Cancel');
 if isempty(h) || ~strcmp(h,'Yes')
  if nargout==0
   clear X
   return
  end
  Femp = true;
 end
end
clear newFILE
clear newFMT


% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% SAVES IN FILE ===========================================================
if ~Femp
 % Saves the matrix to the ascii file using FPRINTF.
 if ~isempty(fid)
  if ~Xcell
   fprintf(fid,FULLFMT,X.');
  else
   for k = 1:Nrow
    fprintf(fid,FULLFMT{k},X{k}.');
   end
  end
 else
  % Fixed bug. Oct 2009
  [DIR FILE EXT] = fileparts(FILE);
  if ~isempty(DIR)
   if ~(exist(DIR,'dir')==7)
    [flag,temp] = mkdir(DIR);
    if ~flag
     error('CVARGAS:saveascii:invalidDirectoryName',...
      'Unable to create the output directory ''%s''.',DIR)
    end
   end
  end
  FILE = fullfile(DIR,[FILE EXT]);
  fid  = fopen(FILE,[PER TOB]);      % 1.
  if fid<0
   error('CVARGAS:incorrectFileStringInput',...
    ['FILE was not a valid file name. If it is a DELIMITER put it ' ...
    'between brackets, {}, or put an empty, [], in the second input.'])
  end
  if ~Xcell
   fprintf(fid,FULLFMT,X.');         % 2.
   fclose(fid);                      % 3. lines of the SAVEASCII v1.0
  else
   % Writes first element and then appends the others.
   fprintf(fid,[FULLFMT{1} EOEL],X{1}.');
   fclose(fid);
   fid = fopen(FILE,['a' TOB]);
   for k = 2:Nrow
    fprintf(fid,[FULLFMT{k} EOEL],X{k}.');
   end
   fclose(fid);
  end
 end
 if (nargout==0)
  clear X
  return
 end
end

% DISPLAYS IN COMMAND WINDOW ==============================================
if nargout==0
 if ~Xcell
  % Display string matrix.
  if ~Xnum && (Xemp || isempty(newDLM))         % Fixed BUG (May 07, 2009)
   disp(X)
   clear X
   return
  end
  X = sprintf(FULLFMT,X.');
  if isempty(X)
   % Incorrect FULLFMT.
   error('CVARGAS:saveascii:incorrectFormat',...
    'Incorrect format.')
  end
  Ncol2 = numel(X)/Nrow;
  if isnatural(Ncol2) % Reshapes it into a string matrix.
   Y  = reshape(X,Ncol2,Nrow);
   Yn = double(Y(end,1));
   if all(Yn==double(sprintf(FULLFMT(end-1:end))))
    Y = Y(1:end-1,:)';
    X = Y;
   else
    warning('CVARGAS:saveascii:matrixNotSquare',...
    ['The displayed string matrix is a vector because the array ' ...
     'cannot be squared with this format.'])
   % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
   %       vector string, to a matrix string but fails, probably due to an
   %       incorrect format row.
   end
  elseif ~isempty(X)
   warning('CVARGAS:saveascii:matrixNotSquare',...
    ['The displayed string matrix is a vector because the array ' ...
     'cannot be squared with this format.'])
   % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
   %       vector string, to a matrix string but fails, probably due to an
   %       incorrect format row.
  end
  disp(X)
 else
  for k = 1:Nrow
   fprintf(1,[FULLFMT{k} EOEL],X{k}.')
  end
 end
 clear X
 return
end

% OUTPUTS VARIABLE ========================================================
% Output or displays the result.
% Displays the result matrix string on the Command Window or as an output
% argument using SPRINTF and DISP.

% Fixed BUG (May 07, 2009).
if ~Xnum && (Xemp || (isempty(newDLM) && ~Xcell)) 
 return
end

% Output string matrix.
if ~Xcell
 X     = sprintf(FULLFMT,X.'); 
 Ncol2 = numel(X)/Nrow;
 if isnatural(Ncol2) % Reshapes it into a string matrix.
  Y  = reshape(X,Ncol2,Nrow);
  Yn = double(Y(end,1));
  if all(Yn==double(sprintf(FULLFMT(end-1:end))))
   Y = Y(1:end-1,:)';
   X = Y;
  else
   warning('CVARGAS:saveascii:matrixNotSquare',...
   ['The displayed string matrix is a vector because the array ' ...
    'cannot be squared with this format.'])
  % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
  %       vector string, to a matrix string but fails, probably due to an
  %       incorrect format row.
  end
 elseif ~isempty(X)
  warning('CVARGAS:saveascii:matrixNotSquare',...
   ['The output string matrix is a vector because the array ' ...
    'cannot be squared with this format.'])
  % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
  %       vector string, to a matrix string but fails, probably due to an
  %       incorrect format row.
 end
else
 Y = cell(Nrow,1);
 for k = 1:Nrow
  Y{k} = sprintf(FULLFMT{k},X{1}.');
  X(1) = [];
 end
 Mcolcell = cellfun(@length,Y);
 X = repmat(' ',Nrow,max(Mcolcell));
 for k = 1:Nrow
  X(k,1:Mcolcell(k)) = Y{1};
  Y(1) = [];
 end
end


% =========================================================================
% SUBFUNCTIONS
% -------------------------------------------------------------------------

function [fid,PRE] = get_num(PRE,Ncol,numopt,inum,iempty) 
% Extract precision from options in a vector array.
% New input "iempty". Oct 2009.

% Forces row PRE:
PRE = round(PRE(:).');
fid = [];

% Checks no input.
if isempty(numopt)
 return
end

% Checks FILE id input.
% Fixed bug to accept 1 and 2 file identifiers. Oct 2009.
if isempty(iempty) && inum(1)==1 && (numel(numopt{1})==1) && ...
  (numopt{1}>0) && isnatural(numopt{1}) && ~isempty(fopen(numopt{1}))
 fid       = numopt{1};
 numopt(1) = [];
 if isempty(numopt)
  return
 end
end

% Checks X empty:
if Ncol==0
 return
end

% Checks many inputs.
if length(numopt)>1
 error('CVARGAS:saveascii:tooManyFmtInput',...
  'More than one FMT precision given.')
end
% Checks values:
if any(~isfinite(numopt{1}))
 error('CVARGAS:saveascii:notFiniteFmtInput',...
  'Precision FMT must be all finite.')
end
% Checks size:
nPRE = numel(numopt{1});
if (nPRE~=1) && (nPRE~=Ncol)
 error('CVARGAS:saveascii:incorrectFmtLongInput',...
  'Precision FMT vector must have 1 or Ncol integers.')
end
% Checks integer:
if any(~isnatural(numopt{1}))
 error('CVARGAS:saveascii:notIntegerFmtInput',...
  'Precision FMT must be integers.')
end
% Forces integers and row vector:
PRE = numopt{1}(:).';

function FMT = pre2fmt(PRE,WID,SPC,Ncol,x3)
% Calculates the width for each column and creates the format string for
% each column with that width, precision and delimiter.

% Reduce the size of x3 if a single precision is given.
if length(PRE)==1
 x3 = [max(x3(1,:)); any(x3(2,:),2)-2*any(x3(2,:)<0,2); min(x3(3,:))];
end
if isempty(WID)
 WID = get_wid(PRE,x3([1 3],:));
 % Check at least 3 digits when NaN's or INF's:
 isbad = logical(x3(2,:));
 isbad(isbad) = (WID(isbad)<=3);
 WID(isbad) = 3 + any(x3(2,isbad)<0,1);
 % Converst from numeric format to format string:
end
FMT = pre2fmtcol(PRE,WID,SPC,Ncol);

function FMT = pre2fmtcol(PRE,WID,SPC,Ncol)
% Creates the format string for each (or every) column from precision,
% width and specifier. 

% Added to reduce running time by reducing the usage of INT2STR. Feb 2008
[w,w,iw] = unique(WID);
[p,p,ip] = unique(PRE);
Nw = length(w);
Np = length(p);
Sw = cell(1,Nw);
Sp = cell(1,Np);
for k = 1:Nw
 Sw{k} = int2str(WID(w(k)));
end
for k = 1:Np
 Sp{k} = int2str(PRE(p(k)));
end
% Checks flag on specifier:
if length(SPC)==2
 flag = SPC(1);
 SPC(1) = [];
else
 flag = '';
end
% Writes the format strings:
FMT = cell(1,1+(Ncol-1)*(Nw*Np~=1));
FMT{1} = ['%' flag Sw{iw(1)} '.' Sp{ip(1)} SPC];
if Nw*Np~=1
 for k = 2:Ncol
  FMT{k} = [ '%' flag Sw{iw(k)} '.' Sp{ip(k)} SPC];
 end
end

function WID = get_wid(PRE,x)
% Calculates the maximum number of digits for each (or every) column of x.

M      = get_order(x);
M(M<0) = 0;                       % M=0 if 0<x<1
M      = M+1;                     % Adds the first digit.
M      = M+(x<0);                 % Adds the negative character.
% Get the maximum number of characters in each column:
WID = max(M,[],1);              % Max of digits to the right of the dot.
% Adds the precision and the dot characters:
WID = WID + (PRE+1).*(PRE>0);
% If NaN, InF or -Inf sets at least 3, 3 or 4 digits respectively.
isbad        = any(~isfinite(x),1);
isbad(isbad) = (WID(isbad)<=3) | ~isfinite(WID(isbad));
WID(isbad)   = 3 + any(x(:,isbad)<0,1);

function [DLM,FMT,EOEL,full] = get_cell(DLM,FMT,EOEL,Ncol,cellopt)
% Reads cell optional inputs.

% Initializes.
nDLM = 0;
nFMT = double(~isempty(FMT));
full = false;

while ~isempty(cellopt)
 n   = length(cellopt{1});
 ind = regexp([' ' cellopt{1}{1} ' '],'[^%]%[^%]');
 m   = length(ind);
 if     (n==1   ) && ((m~=0) && (((m==1) || (m==Ncol)) || (Ncol==0)))
  % FMT for every column.
  FMT = cellopt{1};  nFMT = nFMT+1;
  full = (m==Ncol);
 elseif (m==1) && ((n~=0) && ((n==Ncol) || (Ncol==0)))
  % FMT for each column.
  for k = 2:Ncol
   % Checks if all of them are formats.
   ind = regexp([' ' cellopt{1}{k} ' '],'[^%]%[^%]');
   if length(ind)~=1
    error('CVARGAS:saveascii:incorrectFmtCellInput',...
     'Incorrect FMT cell of strings input.')
   end
  end
  FMT = cellopt{1};  nFMT = nFMT+1;
 elseif (n==1) && (m==0)
  % DLM for every column.
  DLM = cellopt{1};  nDLM = nDLM+1;
 elseif (m==0) && ((n==(Ncol-1)) || (Ncol==0))
  % DLM for each column.
  DLM = cellopt{1};  nDLM = nDLM+1;
 else
  if m==0
   error('CVARGAS:saveascii:incorrectCellLengthInput',...
    'DLM cell of string must be of length 1 or Ncol-1.')
  else
   error('CVARGAS:saveascii:incorrectFmtLengthInput',...
    'FMT cell of string must be of length 1 or Ncol.')
  end
 end
 cellopt(1) = [];
end

% Checks for errors:
if nDLM>1
 error('CVARGAS:saveascii:tooManyDlmInput',...
  'More than one DLM given.')
end
if nFMT>1
 error('CVARGAS:saveascii:tooManyFmtInput',...
  'More than one FMT given.')
end

% Checks ending of full format:
if full && (length(FMT{1})>1) && (strcmp(FMT{1}(end-1:end),'\n') || ...
  strcmp(FMT{1}(end-1:end),'\r'))
 EOEL = '';
end

function [FILE,PER,TOB,WAR,DLM,FMT,EOEL,full] = ...
                  get_char(FILE,PER,TOB,WAR,DLM,FMT,EOEL,Ncol,stropt,ichar)
% Reads string optional inputs.

% Initializes.
nFILE = double(~isempty(FILE));
nPER  = 0;
nDLM  = ~isempty(DLM);
nFMT  = double(~isempty(FMT));
full  = false;

% Checks strings inputs
while ~isempty(stropt) 
 % Looks for '%' chars.
 ind = regexp([' ' stropt{1} ' '],'[^%]%[^%]');
 m   = length(ind);
 if m~=0 && (((m==1) || (m==Ncol)) || (Ncol==0))
  % Sets FMT:
  FMT  = stropt(1);  nFMT  = nFMT+1;
  full = (m==Ncol);
 else
  % Looks for PER or FILE:
  switch stropt{1}
   case {'w','a'}
    PER  = stropt{1};     nPER  = nPER+1;
   case {'wt','at','wb','ab'}
    PER  = stropt{1}(1);  nPER  = nPER+1;
    TOB  = stropt{1}(2);
   case {'w -i'}
    PER  = stropt{1}(1);  nPER  = nPER+1;
    WAR  = true;
   case {'wt -i','wb -i'}
    PER  = stropt{1}(1);  nPER  = nPER+1;
    TOB  = stropt{1}(2);
    WAR  = true;
   otherwise
    if ichar(1)==1
     FILE = stropt{1};     nFILE = nFILE+1;
    else
     if nDLM
      error('CVARGAS:saveascii:incorrectCharInput', ...
       ['Incorrect char input. \n\n' ...
        'Must be a valid OPEN MODE (''a'',''w'') or a valid FILE NAME ' ...
        '(as second input). '])
     end
     DLM = {stropt{1}};
    end
  end
 end 
 stropt(1) = [];
 ichar(1)  = [];
end

% Checks for errors:
if nFILE>1
 error('CVARGAS:saveascii:tooManyFileInput',...
  'More than one FILE given.')
end
if nPER>1
 error('CVARGAS:saveascii:tooManyPermissionsInput',...
  'More than one open file permission given.')
end
if nFMT>1
 error('CVARGAS:saveascii:tooManyFmtInput',...
  'More than one FMT given.')
end
if (nPER==1) && (nFILE==0)
 warning('CVARGAS:saveascii:ignoredPermissionInput',...
  'Ignored Permission input because no FILE given.')
end

% Checks ending of full format:
if full && (length(FMT{1})>1) && (strcmp(FMT{1}(end-1:end),'\n') || ...
  strcmp(FMT{1}(end-1:end),'\r'))
 EOEL = '';
end
 
function FULLFMT = get_strform(DLM,FMT,Ncol)
% Generates the whole format string from the options or defaults.

FULLFMT = '';
Nf = length(FMT);
% a) Super format:
if Nf==1 
 Nf = numel(strfind(FMT{1},'%')); 
 if Nf==Ncol
  FULLFMT = FMT{1};
 elseif Nf~=1       % Error in the full format string option.
  error('CVARGAS:saveascii:invalidStrOptionsSize',...
   'Number of format strings must be 0, 1 or Ncol.')
 end
end
% b) Piecewise format:
if isempty(FULLFMT)
 FULLFMT = FMT{1};
 Nd = length(DLM);
 if Nd==1           % Single delimiter?
  if Nf==1          %  + single format?
   FULLFMT = [FULLFMT repmat([DLM{1} FMT{1}],1,Ncol-1)];
  else              %  + Ncol formats? 
   for k = 2:Ncol
    FULLFMT = [FULLFMT DLM{1} FMT{k}];
   end
  end
 elseif Nd==(Ncol-1)  % Ncol-1 delimiters?
  if Nf==1            %   + single format?
   for k = 2:Ncol
    FULLFMT = [FULLFMT DLM{k-1} FMT{1}];
   end
  else              %   + Ncol formats?
   for k = 2:Ncol
    FULLFMT = [FULLFMT DLM{k-1} FMT{k}];
   end
  end
 else               %   No delimiters (all failed)
  if Nf==1          %   + single format?
   FULLFMT = repmat(FULLFMT,1,Ncol);
  else              %   + Ncol formats?
   for k = 2:Ncol
    FULLFMT = [FULLFMT FMT{k}];
   end
  end
 end
end

function M = get_order(x)
% Gets the order of magnitud in 10 base, i.e., in scientific notation:
%   M = get_order(y)   =>   y = X.XXXXXX x 10^M

if isinteger(x) % Allows integer input: uint8, etc. 
 x = double(x); % bug fixed Mar 08
end
temp = warning('off','MATLAB:log:logOfZero');
M = floor(log10(abs(x)));       % In cientific notation x = XXX x 10^M.
M(x==0) = 0; % M=0 if x=0. (Bug fixed 10/jan/2008) (bug fixed 05/may/2008)
warning(temp.state,'MATLAB:log:logOfZero')

function y = maxinf(x,varargin)
%MAXINF   Largest component ignoring INF's as posible.
%
%    Y = MAXINF(X) is equivalent to MAX but ignoring INF's. If there is no
%    finite elements, then the INF or -INF value is returned; NaN's are
%    return if all the elements are NaN's.

y = max(x,varargin{:});
iinf = isinf(y);
if any(iinf(:))
 xinf = y(iinf);
 x(~isfinite(x)) = NaN;
 y = max(x,varargin{:});
 inan = isnan(y(iinf));
 if any(inan(:))
  y(iinf(inan)) = xinf(inan);
 end
end

function y = mininf(x,varargin)
%MININF   Smallest component ignoring -INF's as posible.
%
%    Y = MININF(X) is equivalent to MIN but ignoring -INF's. If there is no
%    finite elements, then the INF or -INF value is returned; NaN's are
%    return if all the elements are NaN's.

y = min(x,varargin{:});
iinf = isinf(y);
if any(iinf(:))
 xinf = y(iinf);
 x(~isfinite(x)) = NaN;
 y = min(x,varargin{:});
 inan = isnan(y(iinf));
 if any(inan(:))
  y(iinf(inan)) = xinf(inan);
 end
end

function n = isnatural(n)
%ISNATURAL   Checks if an array has natural numbers.
%   Y = ISNATURAL(X) returns a logical array of the same size as X with
%   ones in the elements of X that are natural numbers
%   (...-2,-1,0,1,2,...), and zeros where not.

%   Written by
%   M.S. Carlos Adrián Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, November 2006
% 
%   nubeobscura@hotmail.com

n = (n==floor(n)) & isreal(n)  & isnumeric(n) & isfinite(n);


% [EOF]   saveascii.m