function x = lse(A,b,C,d,solverflag,weights)
% solves A*x = b for X in a least squares sense, given C*x = d
% usage: x = lse(A,b,C,d)
% usage: x = lse(A,b,C,d,solverflag)
% usage: x = lse(A,b,C,d,solverflag,weights)
%
% Minimizes norm(A*x - b),
% subject to C*x = d
% 
% If b has multiple columns, then so will x.
%
% arguments: (input)
%  A - nxp array, for the least squares problem
%      A may be a sparse matrix, it need not be
%      of full rank.
%
%  b - nx1 vector (or nxq array) of right hand
%      side(s) for the least squares problem
%
%  C - mxp array for the constraint system. C
%      must be a full matrix (not sparse), but
%      it may be rank deficient.
%
%      C (and d) may be empty, in which case no
%      constraints are applied
%      
%  d - mx1 vector - right hand side for the
%      constraint system.
%
%  solverflag - (OPTIONAL) - character flag -
%      Specifies the basic style of solver used
%      for the least squares problem. Use of the
%      pinv solution will produce a minimum norm
%      solution when A is itself singular.
%
%      solverflag may be any of
%
%      {'\', 'pinv', 'backslash'}
%
%      Capitalization is ignored, and any
%      shortening of the string is allowed,
%      as far as {'\', 'p', 'b'}
%
%      DEFAULT: '\'
%
%  weights - nx1 vector of weights for the
%      regression problem. All weights must be
%      non-negative. A weight of k is equivalent
%      to having replicated that data point by
%      a factor of k times.
%
% 
% arguments: (output)
%  x - px1 vector (or pxq array) of solutions to
%      the least squares problem A*x = b, subject
%      to the linear equality constraint system
%      C*x = d
%
%
% Example usage:
%  A = rand(10,3);
%  b = rand(10,2); % two right hand sides
%  C = [1 1 1;1 -1 0.5];
%  d = [1;0.5];
%
%  X = lse(A,b,C,d)
%  X =
%      0.71593      0.55371
%      0.23864      0.18457
%     0.045427      0.26172
%
%  As a test, we should recover the constraint
%  right hand side d for each solution X.
%
%  C*X
%  ans =
%            1            1
%          0.5          0.5
%  
%
% Example usage:
%  A = rand(10,3);
%  b = rand(10,1);
%
% with a rank deficient constraint system
%  C = [1 1 1;1 1 1];
%  d = [1;1];
%
%  X = lse(A,b,C,d)
%  X =
%       0.5107
%      0.57451
%    -0.085212
%
%  C*X
%  ans =
%            1
%            1
%
%
% Example usage: (where both A and C are rank deficient)
%  A = rand(10,2);
%  A = [A,A];
%  b = rand(10,1);
%
%  C = ones(2,4);
%  d = [1;1];
%
% The \ solution will see the singularity in A
%  X = lse(A,b,C,d,'\')
%  Warning: Rank deficient, rank = 1,  tol =    3.1821e-15.
%  > In lse at 205
%  X =
%      0.17097
%      0.82903
%            0
%            0
%
% The pinv version will survive the singulatity
%  Xp = lse(A,b,C,d,'pinv')
%  Xp =
%     0.085486
%      0.41451
%     0.085486
%      0.41451
%
% Use of pinv will produce the minimum norm solution
%  norm(X)
%  ans =
%      0.84647
%
%  norm(Xp)
%  ans =
%      0.59855
%
%
% Methodology:
%  Both alternative methods offered in lse are effectively subspace
%  methods. That is, the equality constraints are used to reduce the
%  problem to a lower dimensional problem. The '\' method uses a pivoted
%  QR factorization to choose a set of variables to be eliminated. This
%  chooses the best subset of variables for elimination, avoiding small
%  "pivots" where possible, as well as resolving the case where the
%  supplied constraints are rank deficient. Note that when the constraint
%  system is rank deficient, this method will result in one or more of
%  the unknowns to be set to zero. An at length description of the QR
%  based method for linear least squares subject to linear equality
%  constraints is found in:
%
%  http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8553&objectType=FILE
%
%  The 'pinv' method uses a related approach, reducing the problem to
%  a least squares solution in a subspace. This method is chosen to be
%  consistent with pinv as used for unconstrained least squares problems.
%  The reduction to a subspace does not require the selection of specific
%  variables to be eliminated. Instead the reduction is a projection as
%  defined by a singular value decomposition. When the constraint system
%  is rank deficient, the svd allows for a minimum norm solution, much
%  as is done with pinv. This may be preferable for some users.
%
%  Both methods allow the application of weights if supplied. As well,
%  problems with multiple right hand sides (b) are solved in a fully
%  vectorized fashion.
%
%
% See also: slash, lsqlin, lsequal
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 3.0
% Release date: 1/31/07

% check sizes
[n,p] = size(A);
[r,nrhs] = size(b);
[m,ccols] = size(C);
if n~=r
  error 'A and b are incompatible in size (wrong number of rows)'
elseif ~isempty(C) && (p~=ccols)
  error 'A and C must have the same number of columns'
elseif ~isempty(C) && issparse(C)
  error 'C may not be a sparse matrix'
elseif ~isempty(C) && (m~=size(d,1))
  error 'C and d are incompatible in size (wrong number of rows)'
elseif ~isempty(C) && (size(d,2)~=1)
  error 'd must have only one column'
elseif isempty(C) && ~isempty(d)
  error 'C and d are inconsistent with each other (one was empty)'
elseif ~isempty(C) && isempty(d)
  error 'C and d are inconsistent with each other (one was empty)'
end

% default solver is '\'
if (nargin<5) || isempty(solverflag)
  solverflag = '\';
elseif ~ischar(solverflag)
  error 'If supplied, solverflag must be character'
else
  % solverflag was supplied. Make sure it is legal.
  valid = {'\', 'backslash', 'pinv'};
  ind = strmatch(solverflag,valid);
  if (length(ind)==1)
    solverflag = valid{ind};
  else
    error(['Invalid solverflag: ',solverflag])
  end
end

% default for weights = []
if (nargin<6) || isempty(weights)
  weights = [];
else
  weights = weights(:);
  if (length(weights)~=n) || any(weights<0)
    error 'weights should be empty or a non-negative vector of length n'
  elseif all(weights==0)
    error 'At least some of the weights must be non-zero'
  else
    % weights was supplied. scale it to have mean value = 1
    weights = weights./mean(weights);
    % also sqrt the weights for application as an
    % effective replication factor. remember that
    % least squares will minimize the sum of squares.
    weights = sqrt(weights);
  end
end

% tolerance used on the solve
Ctol = 1.e-13;

if (nargin<3) || isempty(C)
  % solve with \ or pinv as desired.
  switch solverflag
    case {'\' 'backslash'}
      % solve with or without weights
      if isempty(weights)
        x = A\b;
      else
        x = (repmat(weights,1,size(A,2)).*A)\ ...
          (repmat(weights,1,nrhs).*b);
      end
      
    case 'pinv'
      % solve with or without weights
      if isempty(weights)
        ptol = Ctol*norm(A,1);
        x = pinv(A,ptol)*b;
      else
        Aw = repmat(weights,1,size(A,2)).*A;
        ptol = Ctol*norm(Aw,1);
        x = pinv(Aw,ptol)*(repmat(weights,1,nrhs).*b);
      end
  end
  
  % no Constraints, so we are done here.
  return
end

% Which solver do we use?
switch solverflag
  case {'\' 'backslash'}
    % allow a rank deficient equality constraint matrix
    % column pivoted qr to eliminate variables
    [Q,R,E]=qr(C,0);
    
    % get the numerical rank of R (and therefore C)
    if m == 1
%      rdiag = R(1,1);
      rdiag = abs(R(1,1));
    else
      rdiag = abs(diag(R));
    end
    crank = sum((rdiag(1)*Ctol) <= rdiag);
    if crank >= p
      error 'Overly constrained problem.'
    end
    
    % check for consistency in the constraints in
    % the event of rank deficiency in the constraint
    % system
    if crank < m
      k = Q(:,(crank+1):end)'*d;
      if any(k > (Ctol*norm(d)));
        error 'The constraint system is deficient and numerically inconsistent'
      end
    end
    
    % only need the first crank columns of Q
    qpd = Q(:,1:crank)'*d;
    
    % which columns of A (variables) will we eliminate?
    j_subs = E(1:crank);
    % those that remain will be estimated
    j_est = E((crank+1):p);
    
    r1 = R(1:crank,1:crank);
    r2 = R(1:crank,(crank+1):p);
    
    A1 = A(:,j_subs);
    qpd = qpd(1:crank,:);
    
    % note that \ is still ok here, even if pinv
    % is used for the main regression.
    bmod = b-A1*(r1\repmat(qpd,1,nrhs));
    Amod = A(:,j_est)-A1*(r1\r2);
    
    % now solve the reduced problem, with or without weights
    if isempty(weights)
      x2 = Amod\bmod;
    else
      x2 = (repmat(weights,1,size(Amod,2)).*Amod)\ ...
        (repmat(weights,1,nrhs).*bmod);
    end
    
    % recover eliminated unknowns
    x1 = r1\(repmat(qpd,1,nrhs)-r2*x2);
    
    % stuff all estimated parameters into final vector
    x = zeros(p,nrhs);
    x(j_est,:) = x2;
    x(j_subs,:) = x1;
    
  case 'pinv'
    % allow a rank deficient equality constraint matrix
    Ctol = 1e-13;
    % use svd to deal with the variables
    [U,S,V] = svd(C,0);
    
    % get the numerical rank of S (and therefore C)
    if m == 1
      sdiag = S(1,1);
    else
      sdiag = diag(S);
    end
    crank = sum((sdiag(1)*Ctol) <= sdiag);
    if crank >= p
      error 'Overly constrained problem.'
    end
    
    % check for consistency in the constraints in
    % the event of rank deficiency in the constraint
    % system
    if crank < m
      k = U(:,(crank+1):end)'*d;
      if any(k > (Ctol*norm(d)));
        error 'The constraint system is deficient and numerically inconsistent'
      end
    end
    
    % only need the first crank columns of U, and the
    % effectively non-zero diagonal elements of S.
    sinv = diag(S);
    sinv = diag(1./sinv(1:crank));
    % we will use a transformation
    %  Z = V'*X = inv(S)*U'*d
    Z = sinv*U(:,1:crank)'*d;
    
    % Rather than explicitly dropping columns of A, we will
    % work in a reduced space as defined by the svd.
    Atrans = A*V;
    
    % thus, solve (A*V)*Z = b, subject to the constraints Z = supd
    % use pinv for the solution here.
    ptol = Ctol*norm(Atrans(:,(crank+1):end),1);
    if isempty(weights)
      Zsolve = pinv(Atrans(:,(crank+1):end),ptol)* ...
        (b - repmat(Atrans(:,1:crank)*Z(1:crank),1,nrhs));
    else
      w = spdiags(weights,0,n,n);
      Zsolve = pinv(w*Atrans(:,(crank+1):end),ptol)* ...
        (w*(b - repmat(Atrans(:,1:crank)*Z(1:crank),1,nrhs)));
    end
    
    % put it back together in the transformed state
    Z = [repmat(Z(1:crank),1,nrhs);Zsolve];
    
    % untransform back to the original variables
    x = V*Z;
    
end
