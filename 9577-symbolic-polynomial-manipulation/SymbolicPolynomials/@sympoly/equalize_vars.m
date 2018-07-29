function varargout = equalize_vars(varargin)
% Ensures that two sympolys both use the same set of variables
% usage: [sp1,sp2] = equalize_vars(sp1,sp2)
% usage: [sp1,sp2,sp3,...] = equalize_vars(sp1,sp2,sp3,...)
%
% Arguments:
%  sp1, sp2, ... - sympoly objects

n = nargin;
if n == 1
  varargout = varargin;
elseif n==2
  % two variables
  sp1 = varargin{1};
  sp2 = varargin{2};
  
  if ~isa(sp1,'sympoly') || ~isa(sp2,'sympoly')
    error 'Equalize_vars operates only on sympoly objects as inputs'
  end

  % union will combine the vars
  allvars = union(sp1.Var,sp2.Var);
  nv = length(allvars);

  % expand the vars in sp1
  nc1 = length(sp1.Coefficient);
  exp1 = zeros(nc1,nv);
  [junk,LOC] = ismember(sp1.Var,allvars);
  exp1(:,LOC) = sp1.Exponent;
  sp1.Var = allvars;
  sp1.Exponent = exp1;

  % and now sp2
  nc2 = length(sp2.Coefficient);
  exp2 = zeros(nc2,nv);
  [junk,LOC] = ismember(sp2.Var,allvars);
  exp2(:,LOC) = sp2.Exponent;
  sp2.Var = allvars;
  sp2.Exponent = exp2;

  varargout = {sp1,sp2};
else
  % or more variables
  allvars = {};
  for i = 1:n
    spi = varargin{i};
    
    if ~isa(spi,'sympoly')
      error 'Equalize_vars operates only on sympoly objects as inputs'
    end
    
    % union will combine the vars
    allvars = union(allvars,spi.Var);
  end
  nv = length(allvars);
  
  varargout = varargin;
  for i = 1:n
    spi = varargin{i};
    
    % expand the vars in spi
    nc = length(spi.Coefficient);
    expi = zeros(nc,nv);
    [junk,LOC] = ismember(spi.Var,allvars);
    expi(:,LOC) = spi.Exponent;
    spi.Var = allvars;
    spi.Exponent = expi;

    varargout{i} = spi;
  end
  
end




