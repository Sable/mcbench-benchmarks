function reply= get_yes_or_no(prompt,default)
%
% get_yes_or_no(prompt,default) displays a prompt and reads a response from
% standard input.  If the response is 'y', 'yes', 'Y', or "yes", a value of
% 1 is returned.  If the response is 'n', 'no', 'N', or 'NO', a value of 0
% is returned.  If the user types 'quit' or 'exit', the program is stopped.
% If the user does not provide input and the optional default argument is
% present, the default value is returned.  If none of these conditions is
% satisfied, an error message is generated and the prompt is displayed
% again.
%
% Dr. Phillip M. Feldman
%
% Revision History
%
% Version 2.1, 6-18-2009: Implemented workaround for Matlab compiler bug
% involving strtrim.  (strtrim dies when the input string is empty).

if (nargin < 1 || nargin > 2)
   error('The number of calling arguments must be either 1 or 2.');
end
if (nargin==2 && default~=0 && default~=1)
   error('The default value must be either 0 or 1.');
end

while (1)

   % Read a line of input and remove leading and trailing whitespace:

   % Version 2.0 of code (compiled version dies when input is null):
   % text= strtrim(input(prompt, 's'));

   % Version 2.1 of code circumvents Matlab compiler bug:
   text= input(prompt, 's');
   if ~isempty(text), text= strtrim(text); end

   % If the input is empty and the function was called with a default
   % value, return the default:

   if (isempty(text) && nargin==2)
      reply= default;
      return;
   end

   if strcmpi(text,'y') || strcmpi(text,'yes') ...
     || strcmp(text,'1') || strcmpi(text,'true')
      reply= true;
      return;
   end

   if strcmpi(text,'n') || strcmpi(text,'no') ...
     || strcmp(text,'0') || strcmpi(text,'false')
      reply= false;
      return;
   end

   if (strcmpi(text,'quit') || strcmp(text,'exit'))
      error('User-requested stop.');
   end

   fprintf ('Type y or n, or type quit to error out of the program.\n');

end
