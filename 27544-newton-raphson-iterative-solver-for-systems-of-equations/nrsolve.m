function x = nrsolve(F,dFdx,xi,tol,max_iter,varargin)
%==========================================================================
%          x = nrsolve( F, dFdx, xi, tol, max_iter, c1, c2.... )
%Newton-Raphson Iterative Solver   nrsolve
%
%Author:  John Fuller
%         703-404-7620
%
%An iterative solver for N equations with N unknown variables, up to N=8.
%Supports built-in Matlab functions defined within F and dFdx.
%--------------------------------------------------------------------------
%Inputs:
%   F  - Nx1 CELL array listing functions to be evaluated,
%        to be formatted as follows:
%                     SYSTEM          NRSOLVE
%       Ex:  F1 =  x + y + 2*z  =  v1 + v2 + 2*v3  = 0
%            F2 =   (x - y)/2   =  (v1 - v2)/2     = 0
%            F3 =     x + z     =     v1 + v3      = 0 
%
%       Translates to F = {'v1+v2+2*v3';'(v1-v2)/2';'v1+v3'}
%       Variables must be named as v1, v2, v3... vN
%       Constants must be named as c1, c2, c3... cM
%
%   dFdx - NxN CELL array listing derivatives of functions to be evaluated,
%          the same way F is defined.  The {m,n} location of the array
%          would define dF_m/dv_n.  IE: The cell in row 2, column 1 would
%          be derivative of F2 w.r.t. var 1.  This is the string
%          equivalent of the sensitivity matrix used in N-R solver.  From
%          the example above, row 2 column 1 would simply be '0.5' or '1/2'
%
%   xi - Nx1 vector of initial guesses for unknown variables v1, v2, v3...
%
%   tol - User-defined precision value at which to discontinue iteration.
%         Defined as the minimum norm of difference vector dx at which to
%         discontinue iteration and obtain solution.
%
%   max_iter - maximum allowable iterations before termination.
%
%   c1...cM - additional constant values that user would like to pass into
%             nrsolve.  See testnrsolve.m Example 5 for more information.
%             These constants may be defined within F and dFdx in the same
%             manner as v1, v2, etc.
%--------------------------------------------------------------------------
%Output:
%   x  - Nx1 vector of solved answers.
%        x will be NaN if solver cannot resolve the equations in 1000
%        iterations, and a warning will be generated.
%
%As with all iterative solvers, care needs to be taken when solving
%non-linear sets of equations.  Particular attention must be dedicated to
%selecting a proper initial guess to avoid iteration failure.
%==========================================================================

%Calculations begin here
%Check inputs for errors.
if size(xi,2)~=1,
    error('xi vector must be an Nx1 vector');
end
N=size(xi,1);
if N<1
    error('xi vector must be an Nx1 vector where N>=1')
end
if tol<0
    error('Precision tolerance may not be negative')
end
%Stop run if vector is larger than 8.
if N>8
    error('NRSOLVE cannot accommodate more than 8 functions')
end
%Make sure cell arrays are properly formatted
if ~iscellstr(F) || size(F,1)~=N || size(F,2)~=1
    error('Input F must be an Nx1 cell array')
end
if ~iscellstr(dFdx) || size(dFdx,1)~=N || size(dFdx,2)~=N
    error('Input dFdx must be an NxN cell array')
end

%Assign variables in varargin to c1, c2, ... cM
M=nargin-5;
if M>0
    for ii=1:M
        if ~isnumeric(varargin{ii})
            error('Invalid input for additional constant values.')
        end
        eval(['c',num2str(ii,'%i'),'=',num2str(varargin{ii}),';']);
    end
end


%Append prefixes and suffixes to input function arrays
F_eval_prefix={'F1=';'F2=';'F3=';'F4=';'F5=';'F6=';'F7=';'F8='};
F_eval_suffix={';';';';';';';';';';';';';';';'};
F_eval_str_array=strcat(F_eval_prefix(1:N),F,F_eval_suffix(1:N));
dF_eval_prefix={'dF1dv1=','dF1dv2=','dF1dv3=','dF1dv4=','dF1dv5=','dF1dv6=','dF1dv7=','dF1dv8=';...
                'dF2dv1=','dF2dv2=','dF2dv3=','dF2dv4=','dF2dv5=','dF2dv6=','dF2dv7=','dF2dv8=';...
                'dF3dv1=','dF3dv2=','dF3dv3=','dF3dv4=','dF3dv5=','dF3dv6=','dF3dv7=','dF3dv8=';...
                'dF4dv1=','dF4dv2=','dF4dv3=','dF4dv4=','dF4dv5=','dF4dv6=','dF4dv7=','dF4dv8=';...
                'dF5dv1=','dF5dv2=','dF5dv3=','dF5dv4=','dF5dv5=','dF5dv6=','dF5dv7=','dF5dv8=';...
                'dF6dv1=','dF6dv2=','dF6dv3=','dF6dv4=','dF6dv5=','dF6dv6=','dF6dv7=','dF6dv8=';...
                'dF7dv1=','dF7dv2=','dF7dv3=','dF7dv4=','dF7dv5=','dF7dv6=','dF7dv7=','dF7dv8=';...
                'dF8dv1=','dF8dv2=','dF8dv3=','dF8dv4=','dF8dv5=','dF8dv6=','dF8dv7=','dF8dv8='};
dF_eval_suffix={';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';';...
                ';',';',';',';',';',';',';',';'};
dF_eval_str_array=strcat(dF_eval_prefix(1:N,1:N),dFdx,dF_eval_suffix(1:N,1:N));

%Build strings for evaluation of functions and derivatives
F_num_eval_str='F_num=[F1;F2;F3;F4;F5;F6;F7;F8];';
F_num_eval_str=[F_num_eval_str(1:6+N*3),F_num_eval_str(end-1:end)];
dF_num_eval_str_full=['dF1dv1,dF1dv2,dF1dv3,dF1dv4,dF1dv5,dF1dv6,dF1dv7,dF1dv8,',...
                      'dF2dv1,dF2dv2,dF2dv3,dF2dv4,dF2dv5,dF2dv6,dF2dv7,dF2dv8,',...
                      'dF3dv1,dF3dv2,dF3dv3,dF3dv4,dF3dv5,dF3dv6,dF3dv7,dF3dv8,',...
                      'dF4dv1,dF4dv2,dF4dv3,dF4dv4,dF4dv5,dF4dv6,dF4dv7,dF4dv8,',...
                      'dF5dv1,dF5dv2,dF5dv3,dF5dv4,dF5dv5,dF5dv6,dF5dv7,dF5dv8,',...
                      'dF6dv1,dF6dv2,dF6dv3,dF6dv4,dF6dv5,dF6dv6,dF6dv7,dF6dv8,',...
                      'dF7dv1,dF7dv2,dF7dv3,dF7dv4,dF7dv5,dF7dv6,dF7dv7,dF7dv8,',...
                      'dF8dv1,dF8dv2,dF8dv3,dF8dv4,dF8dv5,dF8dv6,dF8dv7,dF8dv8,'];

F_eval_str=[];
dF_eval_str=[];
dF_num_eval_str='dFdx_num=[';
for ii=1:N
    F_eval_str=[F_eval_str,F_eval_str_array{ii,1}]; %#ok<AGROW>
    dF_eval_str=[dF_eval_str,dF_eval_str_array{ii,1:N}]; %#ok<AGROW>
    dF_num_eval_str=[dF_num_eval_str,dF_num_eval_str_full(56*(ii-1)+1:56*(ii-1)+7*N-1),';']; %#ok<AGROW>
end
dF_num_eval_str=[dF_num_eval_str(1:end-1),'];'];

%By using eval on each string above, all F functions and derivatives will 
%be calculated per iteration.
dx_norm=tol+1;
x=xi;
update_vars_str='v1=x(1);v2=x(2);v3=x(3);v4=x(4);v5=x(5);v6=x(6);v7=x(7);v8=x(8);';
update_vars_str=update_vars_str(1:N*8);
counter=0;
while dx_norm>tol
    if counter>max_iter
        fprintf('Maximum iteration limit reached. x = NaN.\n');
        break
    end
    %Update variables, solve functions, and derivatives at current x
    eval([update_vars_str,F_eval_str,dF_eval_str,F_num_eval_str,dF_num_eval_str]);
    dx=-dFdx_num\F_num;
    x=x+dx;
    dx_norm=norm(dx);
    counter=counter+1;    
end
x(abs(x)<eps)=0;
x(~isfinite(x))=NaN;

end

