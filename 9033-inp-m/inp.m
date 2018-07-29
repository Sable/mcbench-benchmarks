function data = inp(prompt,deflt,form,nsp)
%   INP     Keyboard input with a default value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlled input of data from the keyboard is advantagous for debugging,
% making protocols via function diary, parametric studies when changing
% parameters in dependence on the result of the current iteration, etc.,
% all without editting.{[
% CALLS:
%   inp                             %   display help to the function inp.m
%   data = inp;                     %   the same as input('input')
%   data = inp(prompt);             %   the same as input(prompt)
%   data = inp(prompt,deflt);       %   input with the default value
%   data = inp(prompt,deflt,form);  %   ditto with required format for disp
%   data = inp(prompt,deflt,form,nsp);% ditto with required right shift
% INPUT PARAMETERS:
%   prompt = string of characters
%   deflt  = default value of input data
%               '...'               string
%               {[...]}               cell (numeric only)
%               number | variable   integer or real
%               cx num | cx var     complex
%   form   = format for display of one item; default '%9.4f'
%            format is persistent until new value is given
%   nsp    = number of leading spaces before prompt on screen;
%            default nsp =10 is persistent until a new value
% OUTPUT PARAMETER:
%   data   = either deflt value if accepted by ENTER, or 
%            a new input value(s)
% 
% Examples:
% ~~~~~~~~~
%   p = inp('pressure [MPa]',7.5);  % if no new value is input, p=7.5
%   if strcmp(inp('Continue','yes'),'yes')
%       % True
%   else
%       % False
%   end
%   A = eval(inp('A','[B,x]'));     % A = [B,x] if no new input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Miroslav Balda
%   miroslav AT balda DOT cz
%   1998-06-21  v 1.00  
%       ...            - continuous improvements
%   2005-07-04  v 9.02 - persistent variables to store position and format
%   2009-01-10  v 10.0 - widened function for cell and complex data
%                      - better description

persistent inp_nsp inp_form

if nargin+nargout==0, help inp, return, end %   display help 
if nargin<4, nsp=inp_nsp; 
    if nargin<3, form=inp_form;
        if nargin<2, deflt=[];
            if nargin<1 || isempty(prompt), prompt='input'; end 
        end
    end
end
%
if isempty(nsp), nsp=10; end
if isempty(form), form='%9.4f'; end
inp_nsp  = nsp;
inp_form = form;
%
str = [blanks(nsp), prompt, ' = '];

if isempty(deflt)           %   in case without default value:
    while 1
        data = input(str);
        if ~isempty(data), break, end
    end
else                        %   in case with default value:
    if ischar(deflt)
        data = input([str, deflt, ' => '],'s');
%    elseif iscell(deflt)
%        s = sprintf('%g,',deflt{:}); s(end)='';
%        data = input([str '{' num2str([s]) ... 
%            '}  => '],'s'); %   if deflt = cell
    else
        [md,nd]=size(deflt);
        if md*nd>1
            if isreal(deflt)
                data = input([str sprintf(form,deflt(1,1)) ' ... ' ...
                                  sprintf(form,deflt(md,nd)) ' => ']);
            else
                data = input([str sprintf([form form 'i'], ...
                                real(deflt(1,1)),imag(deflt(1,1))) ...
                          ' ... ' sprintf([form form 'i'], ...
                                real(deflt(md,nd)),imag(deflt(md,nd))) ...
                          ' => ']);
            end
        else
            if isreal(deflt)
                data = input([str sprintf(form,deflt) ' => ']);
            else
                data = input([str sprintf([form form 'i'], ...
                                    real(deflt),imag(deflt)) ' => ']);
            end
        end
    end
    if isempty(data)
        data = deflt;
 %   elseif data(1)=='{'
 %       data = {str2num([data(2:end-1)])};
    end
end
