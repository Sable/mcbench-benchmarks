function [xf, S, cnt] = LMFsolveOLD(varargin)
% Solve a Set of Overdetermined Nonlinear Equations in Least-Squares Sense.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A solution is obtained by a Fletcher version of the Levenberg-Maquardt 
% algoritm for minimization of a sum of squares of equation residuals. 
%
% [Xf, Ssq, CNT] = LMFsolveOLD(FUN,Xo,Options)
% FUN     is a function handle or a function M-file name that evaluates
%         m-vector of equation residuals,
% Xo      is n-vector of initial guesses of solution,
% Options is an optional set of Name/Value pairs of control parameters 
%         of the algorithm. It may be also preset by calling:
%         Options = LMFsolveOLD('default'), or by a set of Name/Value pairs:
%         Options = LMFsolveOLD('Name',Value, ... ), or updating the Options
%                   set by calling
%         Options = LMFsolveOLD(Options,'Name',Value, ...).
%
%    Name   Values {default}         Description
% 'Display'     integer     Display iteration information
%                            {0}  no display
%                             k   display initial and every k-th iteration;
% 'Jacobian'    handle      Jacobian matrix function handle; {@finjac}
% 'FunTol'      {1e-7}      norm(FUN(x),1) stopping tolerance;
% 'XTol'        {1e-7}      norm(x-xold,1) stopping tolerance;
% 'MaxIter'     {100}       Maximum number of iterations;
% 'ScaleD'                  Scale control:
%               value        D = eye(m)*value;
%               vector       D = diag(vector);
%                {[]}        D(k,k) = JJ(k,k) for JJ(k,k)>0, or
%                                   = 1 otherwise,
%                                     where JJ = J.'*J
% Not defined fields of the Options structure are filled by default values.
%
% Output Arguments:
% Xf        final solution approximation
% Ssq       sum of squares of residuals
% Cnt       >0          count of iterations
%           -MaxIter,   did not converge in MaxIter iterations

% Example:
% The general Rosenbrock's function has the form
%    f(x) = 100(x(1)-x(2)^2)^2 + (1-x(1))^2
% Optimum solution gives f(x)=0 for x(1)=x(2)=1. Function f(x) can be 
% expressed in the form 
%    f(x) = f1(x)^2 =f2(x)^2,
% where f1(x) = 10(x(1)-x(2)^2) and f2(x) = 1-x(1).
% Values of the functions f1(x) and f2(x) can be used as residuals.
% LMFsolveOLD finds the solution of this problem in 5 iterations. The more 
% complicated problem sounds:
% Find the least squares solution of the Rosenbrock valey inside a circle 
% of the unit diameter centered at the origin. It is necessary to build 
% third function, which is zero inside the circle and increasing outside it. 
% This property has, say, the next function:
%    f3(x) = sqrt(x(1)^2 + x(2)^2) - r, where r is a radius of the circle.
% Its implementation using anonymous functions has the form
%    R  = @(x) sqrt(x'*x)-.5;    %   A distance from the radius r=0.5
%    ros= @(x) [10*(x(2)-x(1)^2); 1-x(1); (R(x)>0)*R(x)*1000];
%    [x,ssq,cnt]=LMFsolveOLD(ros,[-1.2,1],'Display',1,'MaxIter',50)
% Solution: x = [0.4556; 0.2059],  |x| = 0.5000
% sum of squares: ssq = 0.2966,  
% number of iterations: cnt = 18.
%
% Note:   
% Users with older MATLAB versions, which have no anonymous functions
% implemented, have to call LMFsolveOLD with named function for residuals. 
% For above example it is
%
%   [x,ssq,cnt]=LMFsolveOLD('rosen',[-1.2,1]);
%
% where the function rosen.m is of the form
%
%   function r = rosen(x)
%%  Rosenbrock valey with a constraint
%   R = sqrt(x(1)^2+x(2)^2)-.5;
%%  Residuals:
%   r = [ 10*(x(2)-x(1)^2)  %   first part
%         1-x(1)            %   second part
%         (R>0)*R*1000.     %   penalty
%       ];

% Reference:
% Fletcher, R., (1971): A Modified Marquardt Subroutine for Nonlinear Least
% Squares. Rpt. AERE-R 6799, Harwell

% M. Balda, 
% Institute of Thermomechanics, 
% Academy of Sciences of The Czech Republic,
% balda AT cdm DOT cas DOT cz
% 2007-07-02
% 2007-10-08    formal changes, improved description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   OPTIONS
    %%%%%%%
%               Default Options
if nargin==1 && strcmpi('default',varargin(1))
   xf.Display  = 0;         %   no print of iterations
   xf.Jacobian = @finjac;   %   finite difference Jacobian approximation
   xf.MaxIter  = 100;       %   maximum number of iterations allowed
   xf.ScaleD   = [];        %   automatic scaling by D = diag(diag(J'*J))
   xf.FunTol   = 1e-7;      %   tolerace for final function value
   xf.XTol     = 1e-4;      %   tolerance on difference of x-solutions
   return
   
%               Updating Options
elseif isstruct(varargin{1}) % Options=LMFsolveOLD(Options,'Name','Value',...)
    if ~isfield(varargin{1},'Jacobian')
        error('Options Structure not Correct for LMFsolveOLD.')
    end
    xf=varargin{1};          %   Options
    for i=2:2:nargin-1
        name=varargin{i};     %   option to be updated
        if ~ischar(name)
            error('Parameter Names Must be Strings.')
        end
        name=lower(name(isletter(name)));
        value=varargin{i+1};  %   value of the option  
        if strncmp(name,'d',1), xf.Display  = value;
        elseif strncmp(name,'f',1), xf.FunTol   = value(1);
        elseif strncmp(name,'x',1), xf.XTol     = value(1);
        elseif strncmp(name,'j',1), xf.Jacobian = value;
        elseif strncmp(name,'m',1), xf.MaxIter  = value(1);
        elseif strncmp(name,'s',1), xf.ScaleD   = value;
        else   disp(['Unknown Parameter Name --> ' name])
        end
    end
    return
   
%               Pairs of Options     
elseif ischar(varargin{1})  % check for Options=LMFsolveOLD('Name',Value,...)
   Pnames=char('display','funtol','xtol','jacobian','maxiter','scaled');
   if strncmpi(varargin{1},Pnames,length(varargin{1}))
      xf=LMFsolveOLD('default');  % get default values
      xf=LMFsolveOLD(xf,varargin{:});
      return
   end
end

%   LMFSOLVEOLD(FUN,Xo,Options)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

FUN=varargin{1};            %   function handle
if ~(isvarname(FUN) || isa(FUN,'function_handle'))
   error('FUN Must be a Function Handle or M-file Name.')
end

xc=varargin{2};             %   Xo

if nargin>2                 %   OPTIONS
    if isstruct(varargin{3})
        options=varargin{3};
    else
        if ~exist('options','var')
            options = LMFsolveOLD('default');
        end
        for i=3:2:size(varargin,2)-1
            options=LMFsolveOLD(options, varargin{i},varargin{i+1});
        end
    end
else
    if ~exist('options','var')
        options = LMFsolveOLD('default');
    end
end

x=xc(:);
lx=length(x);

r=feval(FUN,x);             % Residuals at starting point
%~~~~~~~~~~~~~~
S=r'*r;
epsx=options.XTol(:);
epsf=options.FunTol(:);
if length(epsx)<lx, epsx=epsx*ones(lx,1); end
J=options.Jacobian(FUN,r,x,epsx);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A=J.'*J;                    % System matrix
v=J.'*r;

D = options.ScaleD;
if isempty(D)
    D=diag(diag(A));        % automatic scaling
    for i=1:lx
        if D(i,i)==0, D(i,i)=1; end
    end
else
    if numel(D)>1
        D=diag(sqrt(abs(D(1:lx)))); % vector of individual scaling
    else
        D=sqrt(abs(D))*eye(lx);     % scalar of unique scaling
    end
end

Rlo=0.25; Rhi=0.75;
l=1;      lc=.75;     is=0;
cnt=0;
ipr=options.Display;
printit(-1);                %   Table header
d=options.XTol;             %   vector for the first cycle
maxit = options.MaxIter;    %   maximum permitted number of iterations

while cnt<maxit && ...      %   MAIN ITERATION CYCLE
    any(abs(d)>=epsx) && ...    %%%%%%%%%%%%%%%%%%%%
    any(abs(r)>=epsf)
    d=(A+l*D)\v;            % negative solution increment
    xd=x-d;
    rd=feval(FUN,xd);
%   ~~~~~~~~~~~~~~~~~    
    Sd=rd.'*rd;
    dS=d.'*(2*v-A*d);       % predicted reduction
    R=(S-Sd)/dS;

    if R>Rhi
        l=l/2;
        if l<lc, l=0; end
    elseif R<Rlo
        nu=(Sd-S)/(d.'*v)+2;
        if nu<2
            nu=2;
        elseif nu>10
            nu=10;
        end
        if l==0
            lc=1/max(abs(diag(inv(A))));
            l=lc;
            nu=nu/2;
        end
        l=nu*l;
    end
    cnt=cnt+1;
    if ipr>0 && (rem(cnt,ipr)==0 || cnt==1)
        printit(cnt,[S,l,R,x(:).'])
        printit(0,[lc,d(:).'])
    end
    if Sd>S && is==0
        is=1;
        St=S; xt=x; rt=r; Jt=J; At=A; vt=v;
    end
    if Sd<S || is>0
        S=Sd; x=xd; r=rd;
        J=options.Jacobian(FUN,r,x,epsx);
%       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        A=J.'*J;   v=J.'*r;
    else
        S=St; x=xt; r=rt; J=Jt; A=At; v=vt;
    end
    if Sd<S, is=0; end
end
xf = x;                         %   finat solution
if cnt==maxit, cnt=-cnt; end    %   maxit reached
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   PRINTIT     Printing of intermediate results
%   %%%%%%%
function printit(cnt,mx)
%        ~~~~~~~~~~~~~~~
%  cnt	=  -1  print out the header
%           0  print out second row of results
%          >0  print out first row of results

if ipr>0
   if cnt<0                 %   table header
      disp('')
      disp(char('*'*ones(1,100)))
      disp(['  cnt   SUM(r^2)        l            R' blanks(21) 'x(i) ...'])
      disp([blanks(24) 'lc' blanks(32) 'dx(i) ...'])
      disp(char('*'*ones(1,100)))
      disp('')
   else                     %   iteration output
      if cnt>0 || rem(cnt,ipr)==0
          f='%12.4e ';
          form=[f f f f '\n' blanks(49)];
          if cnt>0
              fprintf(['%4.0f ' f f f ' x = '],[cnt,mx(1:3)])
              fprintf(form,mx(4:length(mx)))
          else
              fprintf([blanks(18) f blanks(13) 'dx = '], mx(1))
              fprintf(form,mx(2:length(mx)))
          end
          fprintf('\n')
      end
   end
end
end

%   FINJAC       numerical approximation to Jacobi matrix
%   %%%%%%
function J = finjac(FUN,r,x,epsx)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lx=length(x);
J=zeros(length(r),lx);
for k=1:lx
    dx=.25*epsx(k);
    xd=x;
    xd(k)=xd(k)+dx;
    rd=feval(FUN,xd);
%   ~~~~~~~~~~~~~~~~    
    J(:,k)=((rd-r)/dx);
end
end
end