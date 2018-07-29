function P=sympoly(varargin)
% sympoly: creator for sympoly objects
% usage: P=sympoly
% usage: P=sympoly(scalar_numeric_variable)
% usage: P=sympoly(array_numeric_variable)
% usage: P=sympoly('variablename')
% usage: sympoly varname1 varname2 varname3 ...
% 
% Arguments:
%  varname - character string that represents a valid Matlab
%          variable name.
%
%          Example variable name: 'x'
%          
%          or
%
%          any scalar constant or array of constants
%
% Examples of use:
%  P=sympoly       -->  creates a constant monomial, P(x) = 0
%
%  P=sympoly('x')  -->  creates a linear monomial, P(x) = x
%
%  P=sympoly(1)    -->  creates a constant monomial == 1, P(x) = 1
%
%  P=sympoly(hilb(3))  -->  creates a 3x3 matrix of constant sympoly
%                       variables, in this case a 3x3 Hilbert matrix.
%
%  sympoly a b x y -->  creates sympoly variables with those names in
%                       the caller workspace. This mode is equivalent
%                       to 4 calls:
%                        sympoly('a')
%                        sympoly('b')
%                        sympoly('x')
%                        sympoly('y')
%
%  Q=sympoly(P)    -->  copies an existing sympoly

% How was sympoly called? There are 5 options.

% sympoly('x') with an output argument --> create a linear
% sympoly variable, then return it in P.
if (nargin == 0)
  % this mode creates a scalar sympoly, as a constant == 0
  P = sympoly(0);
  
elseif (nargin==1)
  % Its only a single input. What kind?
  inp = varargin{1};
  
  if isa(inp,'sympoly')
    % Its already a sympoly. no-op.
    P = inp;
  elseif isstruct(inp) && isfield(inp,'Var') && isfield(inp,'Exponent') && isfield(inp,'Coefficient')
    % it is a struct, that wants desperately to be a sympoly
      % define this as a sympoly
      P=class(inp,'sympoly');
  elseif ischar(inp)
    % A string that contains the name of a new sympoly
    
    if nargout == 0 
      % assign a variable with this name in the caller
      % workspace
      str = [inp,'=sympoly(''',inp,''');'];

      % evalin will put it in place in the caller workspace
      evalin('caller',str)
    else
      % Create a sympoly, to be returned as an output
      P.Var = {inp};
      P.Exponent = 1;
      P.Coefficient = 1;
      
      % define this as a sympoly
      P=class(P,'sympoly');
      
    end
    
  elseif isnumeric(inp) || isa(inp,'logical')
    % A numeric scalar or array
    
    % initialize
    P.Var = {''};
    P.Exponent = 0;
    P.Coefficient = 0;
    
    % replicate
    P = repmat(P,size(inp));
    
    % and stuff the coefficients
    for i = 1:numel(inp)
      P(i).Coefficient = inp(i);
    end

    % define this as a sympoly
    P=class(P,'sympoly');
    
  end
  
else
  % nargin is > 1. nargout must = 0
  if nargout>0
    error 'Mulitple sympolys can only be created as: "sympoly x y z w"'
  end
  
  % just loop over the inputs
  for i = 1:nargin
    % A list of several variables to create
    
    % assign variables with this name in the caller
    % workspace
    inp = varargin{i};
    str = [inp,'=sympoly(''',inp,''');'];
    
    % evalin will put it in place in the caller workspace
    evalin('caller',str)
    
  end
end

% make sure that the appropriate sympoly method is
% used whenever one of the arguments is a sympoly
% and any numeric type as the other argument.
superiorto('double','single','int8','uint8','int16', ...
  'uint16','int32','uint32','int64','uint64','logical')




