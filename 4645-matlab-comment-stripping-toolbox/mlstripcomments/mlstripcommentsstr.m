function ostr = mlstripcommentsstr(istr)
%MLSTRIPCOMMENTSSTR Strip comments from a string with MATLAB code.
%
%   OSTR = MLSTRIPCOMMENTSSTR(ISTR) takes the input string ISTR, assuming it
%   contains MATLAB code, strips all MATLAB comments, and returns the result as
%   the output string OSTR.  The input string must be a row vector or a cell
%   array of row vectors.  Any input string may be a multi-line string, that is
%   a string containing newline characters, for example a string containing the
%   entire contents of an m-file.
%
%   Example:  Read all MATLAB code from an m-file opened for reading on file
%   identifier "fid" and strip all comments:
%
%       str = fread(fid);               % data as numerical column vector
%       str = char(str)';               % data as character row vector
%       str = mlstripcommentsstr(str);  % strip all MATLAB comments
%
%   See also MLSTRIPCOMMENTSFILE, MLSTRIPCOMMENTSFID.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-03-18 08:23:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Regex for removing a comment on a line possibly containing MATLAB code.
   %
   % Use a persistent variable so that the variable is set up only once.
   %
   % Find the part of the line which is not a comment and then replace the
   % whole line with the part that was not a comment.
   %
   % A comment is started by a percent sign, but not all percent signs start a
   % comment.  A percent sign might be embedded in a string, in which case the
   % percent sign obviously does not start a comment.  So we must look for
   % percent signs which are not embedded in strings.  To do this we must find
   % all strings.  Strings are delimited by single quotes, but not all single
   % quotes start strings.  A single quote might also be a tranpose operator.
   % So we must look for single quotes which are not tranpose operators.
   %
   % The MATLAB grammar (syntax and semantics) is not available to the public,
   % but from my knowledge, a single quote is a transpose operator if and only
   % if one of the following criteria is satisfied
   %
   %   1) it follows a right closing delimiter
   %   2) it follows right after a variable name or function name
   %   3) it follows right after a period (as part of the ".'" operator)
   %   4) it follows right after another tranpose operator
   %
   % This can be immediately after a right closing bracket ("]"), right closing
   % parenthesis (")"), right closing brace ("}"), an English letter ("a" to
   % "z" and "A" to "Z", a digit ("0" to "9"), an underline ("_"), a period
   % ("."), or another single quote ("'").

   persistent mainregex

   if isempty(mainregex)

      mainregex = [ ...
         ' (                   ' ... % Grouping parenthesis (content goes to $1).
         '   ( ^ | \n )        ' ... % Beginning of string or beginning of line.
         '   (                 ' ... % Non-capturing grouping parenthesis.
         '                     ' ...
         '' ... % Match anything that is neither a comment nor a string...
         '       (             ' ... % Non-capturing grouping parenthesis.
         '           [\]\)}\w.]' ... % Either a character followed by
         '           ''+       ' ... %    one or more transpose operators
         '         |           ' ... % or else
         '           [^''%]    ' ... %   any character except single quote (which
         '                     ' ... %   starts a string) or a percent sign (which
         '                     ' ... %   starts a comment).
         '       )+            ' ... % Match one or more times.
         '                     ' ...
         '' ...  % ...or...
         '     |               ' ...
         '                     ' ...
         '' ...  % ...match a string.
         '       ''            ' ... % Opening single quote that starts the string.
         '         [^''\n]*    ' ... % Zero or more chars that are neither single
         '                     ' ... %   quotes (special) nor newlines (illegal).
         '         (           ' ... % Non-capturing grouping parenthesis.
         '           ''''      ' ... % An embedded (literal) single quote character.
         '           [^''\n]*  ' ... % Again, zero or more chars that are neither
         '                     ' ... %   single quotes nor newlines.
         '         )*          ' ... % Match zero or more times.
         '       ''            ' ... % Closing single quote that ends the string.
         '                     ' ...
         '   )*                ' ... % Match zero or more times.
         ' )                   ' ...
         ' [^\n]*              ' ... % What remains must be a comment.
                  ];

      % Remove all the blanks from the regex.
      mainregex = mainregex(~isspace(mainregex));

   end

   % Initialize output.
   ostr = istr;

   % If input is a character array, put it into a cell array.  We'll later make
   % sure output is a character array if input is a character array.
   if ischar(ostr)
      ostr = {ostr};
   end

   % Iterate over each element in the cell array.
   for i = 1 : numel(ostr)

      % Get the ith input string.
      str = ostr{i};

      % All character arrays must be row vectors.
      if (ndims(str) > 2) | (any(size(str) > 0) & (size(str, 1) ~= 1))
         error('All character arrays must be row vectors.');
      end

      % Note:  With MATLAB 6.5.1 it seems that the '^' and '$' anchors in the
      % regexes '(^|\n)' and '($|\n)' are not working (bug?), so use a
      % workaround:  prepend and append a newline and remove them later.

      use_workaround = 1;

      if use_workaround
         lf   = sprintf('\n');     % LF = Line feed character
         str = [lf, str, lf];      % prepend and append an LF
      end

      % Remove comment lines.
      str = regexprep(str, '(^|\n)[^\S\n]*%[^\n]*', '$1', 'tokenize');

      % Remove a comment on a line possibly containing MATLAB code.
      str = regexprep(str, mainregex, '$1', 'tokenize');

      % Remove trailing whitespace from each line.
      str = regexprep(str, '[^\S\n]+($|\n)', '$1', 'tokenize');

      % Compress multiple blank lines.
      %str = regexprep(str, '\n\n\n+', sprintf('\n\n'));

      if use_workaround
         str = str(2:end-1);       % remove leading and trailing LF
      end

      % Insert ith string into output cell array.
      ostr{i} = str;

   end

   % If the input was a character array, make sure output is so too.
   if ischar(istr)
      ostr = ostr{1};
   end
