function sp = sym2sympoly(sim,varlist)
% sym2sympoly: converts a symbolic toolbox polynomial into a sympoly
% usage: sp = sym2sympoly(sim,varlist)
%
% arguments: (input)
%  sim - symbolic toolbox object, which contains the
%        polynomial (or multinomial) to be converted
%        over.
%
%  varlist - cell array of all the (scalar) variables to be
%        found in sim. These may be strings, or symbolic
%        toolbox objects themselves.
%        
%
% arguments: (output)
%  sp  - sympoly object, as converted
%
%
% Example usage:
%  syms x y
%  z = x + 2*y;
%  sp = sym2sympoly(z,{x,y});
% 
% Example usage:
%  syms u v w
%  z = u^2 + u*v*w^2;
%  sp = sym2sympoly(z,{'u', 'v', 'w'});
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 1/31/07

% was a list of variables provided?
if (nargin<2)
  varlist = parsesym(sim);
end

% create sympoly variables from each variable in varlist
nv = length(varlist);
for i = 1:nv
  var = varlist{i};
  if ischar(var)
    % this was a character string, containing a
    % variable name
    sympoly(var)
  else
    % it was a symbolic toolbox object with a variable
    varstruct = struct(var);
    
    % create a sympoly with the same name as the variable
    sympoly(varstruct.s)
  end
end

% unpack the symbolic toolbox struct
simstruct = struct(sim);
str = simstruct.s;

% and create a sympoly to be returned
str = ['sp = ',str,';'];
eval(str)


% =================================================
%   end mainline
% =================================================

% =================================================
%   begin subfunctions
% =================================================
function vars = parsesym(str)
% parsesym: parses out the variable names from a string
% usage: vars = parsesym(str)
%
% arguments: (input)
%  str - character string - contains a symbolicly written expression
%  
% arguments: (output)
%  vars - cell array of strings, each of which is a probable
%      variable name as parsed from the string expression str.
%
% Example usage:
%  str = 'x + 2*y + xy^2 - 3.1415926535*u*v*w'
%  vars = parsym(str);
%  
%  vars will be the cell array {'u' 'v' 'w' 'x' 'xy' 'y'}

vars = {};
if nargin<1
  help parsesym
elseif isempty(str)
  % empty begets empty
  return
elseif isstruct(str)
  % a sym struct
  sstruct = struct(str);
  str = sstruct.s;
elseif ~ischar(str)
  error 's must be a character string or a symbolic TB struct'
end

% drop operators, etc.
D = '+^*./-';
k = ismember(str,D);
str(k) = ' ';

% parse the pieces one at a time
while ~isempty(str)
  % grab the first token from the current string
  [tok,str] = strtok(str,' ');
  
  % does tok start with a numeric character?
  if ~ismember(tok(1),'0123456789')
    vars{end+1} = tok;
  end
  
end

% drop the replicated variable names, sort them too
vars = unique(vars);


