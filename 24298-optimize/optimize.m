function [sol, fval, exitflag, output] = ...
        optimize(funfcn, x0, lb, ub, A, b, Aeq, beq, nonlcon, ...
                 strictness, options, algorithm, varargin)
%OPTIMIZE        Optimize general constrained problems using Nelder-Mead algorithm
%
% Usage:
% sol = OPTIMIZE(func, x0) 
% sol = OPTIMIZE(..., x0, lb, ub)
% sol = OPTIMIZE(..., ub, A, b) 
% sol = OPTIMIZE(..., b, Aeq, beq) 
% sol = OPTIMIZE(..., beq, nonlcon) 
% sol = OPTIMIZE(..., nonlcon, strictness) 
% sol = OPTIMIZE(..., strictness, options) 
% sol = OPTIMIZE(..., options, algorithm) 
%
% [sol, fval] = OPTIMIZE(func, ...)
% [sol, fval, exitflag] = OPTIMIZE(func, ...)
% [sol, fval, exitflag, output] = OPTIMIZE(func, ...)
%
% INPUT ARGUMENTS:
%
%  fun, x0, options, varargin - see the help for FMINSEARCH.
%
%  lb - (OPTIONAL) lower bound vector or array, must have the same 
%       size as x0.
%
%       If no lower bounds exist for one of the variables, then
%       supply -inf for that variable.
%
%       If no lower bounds exist at all, then [lb] may be left empty.
%
%       Variables may be fixed in value by setting the corresponding
%       lower and upper bounds to exactly the same value.
%
%  ub - (OPTIONAL) upper bound vector or array, must have the same 
%       size as x0.
%
%       If no upper bounds exist for one of the variables, then
%       supply +inf for that variable.
%
%       If no upper bounds at all, then [ub] may be left empty.
%
%       Variables may be fixed in value by setting the corresponding
%       lower and upper bounds to exactly the same value.
%
%  A, b - (OPTIONAL) Linear inequality constraint array and right
%       hand side vector. (Note: these constraints were chosen to
%       be consistent with those of fmincon.)
%
%       This linear constraint forces the solution vector [x] to 
%       satisfy 
%                               A*x <= b
%
%       Note that in case [x] is a matrix (this is true when [x0] is
%       a matrix), the argument [b] must have corresponding size 
%       [size(A,1) x size(x0,2)], since the same equation is used to 
%       evaluate this constraint. 
%
%  Aeq, beq - (OPTIONAL) Linear equality constraint array and right
%       hand side vector. (Note: these constraints were chosen to
%       be consistent with those of fmincon.)
%
%       This linear constraint forces the solution vector [x] to 
%       satisfy 
%
%                               Aeq*x == beq
%
%       Note that in case [x] is a matrix (this is true when [x0] is
%       a matrix), the argument [beq] must have corresponding size 
%       [size(Aeq,1) x size(x0,2)], since the same equation is used to 
%       evaluate this constraint.
%
%  nonlcon - (OPTIONAL) function handle to general nonlinear constraints,
%       inequality and/or equality constraints.
%
%       [nonlcon] must return two vectors, [c] and [ceq], containing the
%       values for the nonlinear inequality constraints [c] and
%       those for the nonlinear equality constraints [ceq] at [x]. (Note: 
%       these constraints were chosen to be consistent with those of 
%       fmincon.)
%
%       These constraints force the solution to satisfy
%
%               ceq(x)  = 0
%                 c(x) <= 0,
%
%       where [c(x)] and [ceq(x)] are general non-linear functions of [x].
%
% strictness - (OPTIONAL) By default, OPTIMIZE will assume the objective 
%       (and constraint) function(s) can be evaluated at ANY point in 
%       RN-space; the initial estimate does not have to lie in the 
%       feasible region, and intermediate solutions are also allowed to step 
%       outside this area. If your function does not permit such behavior, 
%       set this argument to 'strict'. With 'strict' enabled, the linear 
%       constraints will be satisfied strictly, while the nonlinear 
%       constraints will be satisfied within options.TolCon. 
%
%       If this is also not permissible, use 'superstrict' - then all 
%       nonlinear constraints are also satisfied AT ALL TIMES, and the 
%       objective function is NEVER evaluated outside the feasible area. 
%
%       When using 'strict' or 'superstrict', the initial estimate [x0]
%       MUST be feasible. If it is not feasible, an error is produced
%       before the objective function is ever evaluated. 
%
% algorithm - (OPTIONAL) By default, an embedded version of the 
%       Nelder-Mead algorithm is used. This version is slightly more 
%       robust and internally effecient than the one implemented in 
%       FMINSEARCH. The FMINSEARCH algorithm can still be selected, by
%       setting [algorithm] to 'fminsearch'. 
%
%
% OUTPUT ARGUMENTS:
%
% sol, fval - the solution vector and the corresponding function value,
%       respectively. 
%
% exitflag - (See also the help on FMINSEARCH) A flag that specifies the 
%       reason the algorithm terminated. FMINSEARCH uses only the values
%
%           1    fminsearch converged to a solution x
%           0    Max. # of function evaluations or iterations exceeded
%          -1    Algorithm was terminated by the output function.
%
%       Since OPTIMIZE handles constrained problems, the following two
%       values were added:
%
%           2    All elements in [lb] and [ub] were equal - nothing done
%          -2    Problem is infeasible after the optimization (Some or 
%                any of the constraints are violated at the final 
%                solution).
%          -3    INF or NAN encountered during the optimization. 
%
% output - (See also the help on FMINSEARCH) A structure that contains
%       additional details on the optimization. FMINSEARCH returns
%
%           output.algorithm   Algorithm used
%           output.funcCount   Number of function evaluations 
%           output.iterations  Number of iterations 
%           output.message     Exit message
%
%       Since OPTIMIZE handles constrained problems, the following 
%       fields were added:
%
%           output.constrviolation.lin_ineq
%           output.constrviolation.lin_eq
%           output.constrviolation.nonlin_ineq
%           output.constrviolation.nonlin_ineq
%
%       All these fields contain a [M x 2]-cell array. The fist column
%       contains a logical index to the constraints, which is true if the
%       constraint was violated, false if it was satisfied. The second
%       column contains the amount of constraint violation. This amount is
%       equal to zero if the constraint was satisfied within
%       options.TolCon.
%
%
% Notes:
%
%  If options is supplied, then TolX will apply to the transformed
%  variables. All other FMINSEARCH parameters should be unaffected.
%
%  Variables which are constrained by both a lower and an upper
%  bound will use a sin() transformation. Those constrained by
%  only a lower or an upper bound will use a quadratic
%  transformation, and unconstrained variables will be left alone.
%
%  Variables may be fixed by setting their respective bounds equal.
%  In this case, the problem will be reduced in size for FMINSEARCH. 
%
%  If your problem has an EXCLUSIVE (strict) bound constraints which 
%  will not permit evaluation at the bound itself, then you must 
%  provide a slightly offset bound. An example of this is a function 
%  which contains the log of one of its parameters. If you constrain 
%  the variable to have a lower bound of zero, then OPTIMIZE may
%  try to evaluate the function exactly at zero.
%
% EXAMPLES:
%
% rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%
% <<Fully unconstrained problem>>
%
% optimize(rosen, [3 3])
% ans =
%    1.0000    1.0000
%
%
% <<lower bound constrained>>
%
% optimize(rosen,[3 3],[2 2],[])
% ans =
%    2.0000    4.0000
%
%
% <<x(2) fixed at 3>>
%
% optimize(rosen,[3 3],[-inf 3],[inf,3])
% ans =
%    1.7314    3.0000
%
%
% <<simple linear inequality: x(1) + x(2) <= 1>>
%
% optimize(rosen,[0 0],[],[],[1 1], 1)
% 
% ans =
%    0.6187    0.3813
% 
%
% <<nonlinear inequality: sqrt(x(1)^2 + x(2)^2) <= 1>>
% <<nonlinear equality  : x(1)^2 + x(2)^3 = 0.5>>
%
% execute this m-file:
%
%   function test_optimize
%        rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%
%        options = optimset('TolFun', 1e-8, 'TolX', 1e-8);
%
%        optimize(rosen, [3 3], [],[],[],[],[],[],...
%        @nonlcon, [], options)
%
%   end
%   function [c, ceq] = nonlcon(x)
%        c = norm(x) - 1;
%        ceq = x(1)^2 + x(2)^3 - 0.5;
%   end
%
% ans =
%    0.6513    0.4233
%
%
%
% Of course, any combination of the above constraints is
% also possible.
%
%
% See also: fminsearch, fminsearchcon, fminsearchbnd, fmincon.


% Current version: v3

% Author info
%{
 Author     : Rody P.S. Oldenhuis
   Delft University of Technology
   E-mail   : oldenhuis@dds.nl

 FMINSEARCHBND, FMINSEARCHCON and most of the
 help for OPTIMIZE witten by
            : John D'Errico
   E-mail   : woodchips@rochester.rr.com

 Last edited: 05/August/2009
 Uploaded   : 05/August/2009

 [ Please report bugs to oldenhuis@dds.nl ]
%}

%CHANGELOG
%{
 CHANGELOG

 Aug 6, 2009
 v3: - removed dependency on the OPTIMSET() from the 
       optimization toolbox.
     - Included basic global optimization routine. If
       [x0] is omitted, but [ub] and [lb] are given, 
       a number of initial values will be optimized, 
       which are randomly generated in the boundaries 
       [lb] and [ub].
     - added one exitflag (-3). This is the exitflag
       for when the globalized algorithm has found 
       nothing else than INF or NAN function values.

 Aug 5, 2009
 v2: - Included NelderMead algorithm, a slightly more
       robust and internally efficient method than 
       FMINSEARCH. Of course, FMINSEARCH can still be
       selected through yet another argument...
     - one-dimensional functions could not be 
       optimized because of a bad reference to 
       elements of [lb] and [ub]; problem fixed. 
     - I forgot that [strictness] and [options] can 
       also be empty; included an ISEMPTY() check. 
     - fixed a problem with the outputFcn; this 
       function was still evaluated under the 
       assumption that [x0] is always a vector. 
       Inserted a reshaping operation. 

 Aug 1, 2009
 v1: - x0 can now be a matrix, just as in FMINSEARCH
     - minor bug fixed with the strictness setting: 
       with multiple nonlinear constraints, an ANY()
       was necessary, which was not used. 
       
 May 24, 2009.
 v0: - first release
%}
    
    %% initialize

    % process input
    narg = nargin;
    error(nargchk(2, inf, narg));    
    if (narg < 12)||isempty(algorithm ), algorithm = 'fminsearch'; end   
    if (narg < 11)||isempty(options   ), options = optimset; end   
    if (narg < 10)||isempty(strictness), strictness = 'loose'; end   
    if (narg <  9), nonlcon = []; end        
    if (narg <  8), beq = []; end
    if (narg <  7), Aeq = []; end
    if (narg <  6), b   = []; end
    if (narg <  5), A   = []; end
    if (narg <  4), lb  = []; end
    if (narg <  3), ub  = []; end     
    
    % no x0 given means optimize globally.
    if isempty(x0)
        [sol, fval, exitflag, output] = optimize_globally(varargin{:}); 
        return
    end
    
    % get tolerance on constraints
    try
        % part of optimization toolbox
        tolCon = optimget(options, 'TolCon', 1e-6);
    catch %#ok
        tolCon = 1e-6;
    end
    
    % check for an output function. If there is any, 
    % use wrapper function to call it with untransformed variable
    if ~isempty(options.OutputFcn)
        OutputFcn = options.OutputFcn;
        options.OutputFcn = @OutputFcn_wrapper;
    end
    
    % define number of dimensions
    N = numel(x0); 
    
    % adjust bounds when they are empty
    if isempty(lb), lb = -inf(size(x0)); end
    if isempty(ub), ub = +inf(size(x0)); end
       
    % check the user-provided input with nested function check_input
    check_input;
        
    % resize and reshape all input to be of completely predictable size
    new_x = x0;      ub = ub(:);
    x0 = x0(:);      lb = lb(:);                
    
    % replicate lb or ub when they are scalars, and x0 is not
    if isscalar(lb) && (N ~= 1), lb = repmat(lb, size(x0)); end
    if isscalar(ub) && (N ~= 1), ub = repmat(ub, size(x0)); end    
    
    % determine the type of bounds
    nf_lb   = ~isfinite(lb);               nf_ub   = ~isfinite(ub);    
    lb_only = ~nf_lb &  nf_ub;             ub_only =  nf_lb & ~nf_ub;
    unconst =  nf_lb &  nf_ub;             fix_var =  lb == ub;
    lb_ub   = ~nf_lb & ~nf_ub & ~fix_var;    
    
    % if all variables are fixed, simply return
    if length(lb(fix_var)) == N            
        sol = reshape(lb,size(new_x));   output.iterations = 0;
        output.funcCount = 0;    fval = funfcn(sol);         
        output.message = 'Lower and upper bound were set equal - nothing to do. ';
        exitflag = 2; [output, exitflag] = finalize(lb, output, exitflag);         
        if exitflag ~= -2
            output.message = sprintf(...
                '%s\nFortunately, the solution is feasible using OPTIONS.TolCon of %1.6f.',...
                output.message, tolCon);
        end, return;
    end    
    
    % force the initial estimate inside the given bounds
    x0(x0 < lb) = lb(x0 < lb);  x0(x0 > ub) = ub(x0 > ub);
        
    % transform initial estimate to its unconstrained counterpart
    xin = x0;                                        % fixed and unconstrained variables   
    xin(lb_only) = sqrt(x0(lb_only) - lb(lb_only));  % lower bounds only   
    xin(ub_only) = sqrt(ub(ub_only) - x0(ub_only));  % upper bounds only
    xin(lb_ub)   = real(asin( 2*(x0(lb_ub) - lb(lb_ub))./ ...
                     (ub(lb_ub) - lb(lb_ub)) - 1));  % both upper and lower bounds
                 
    % remove fixed variables from the initial estimate
    xin(fix_var) = [];
        
    % some constant matrices to speed things up (slightly)
    Nzero = zeros(N, 1);    Np1zero = zeros(N, N+1);   exp200 = exp(200);
        
    % define the transformed & penalized function
    funfncT = @(x) funfncP(X(x), varargin{:});
    
    % optimize the problem
    switch lower(algorithm)
        case 'fminsearch'
            % optimize the problem with FMINSEARCH
            [presol, fval, exitflag, output] = fminsearch(funfncT, xin, options, varargin{:});
        case 'neldermead'
            % optimize the problem with embedded, slightly more efficient NelderMead
            [presol, fval, exitflag, output] = NelderMead(funfncT, xin, options, varargin{:});
        otherwise
            error('optimize:invalid_algorithm',...
                  'Invalid algorithm selected. Valid options are ''NelderMead'' and ''FMINSEARCH''.');
    end
    
    % and transform everything back to original (bounded) variables
    sol = new_x;    sol(:) = X(presol);    % with the same size as the original x0
    
    % append constraint violations to the output structure, and change the
    % exitflag accordingly
    [output, exitflag] = finalize(sol, output, exitflag);
    
    %% nested functions (the actual work)
    
    % check user provided input
    function check_input
        
        % dimensions & weird input
        if (numel(lb) ~= N && ~isscalar(lb)) || (numel(ub) ~= N && ~isscalar(ub))
            error('optimize:lb_ub_incompatible_size',...
                'Size of either [lb] or [ub] incompatible with size of [x0].')
        end
        if ~isempty(A) && isempty(b)
            warning('optimize:Aeq_but_not_beq', ...
                ['I received the matrix [A], but you omitted the corresponding vector [b].',...
                '\nI`ll assume a zero-vector for [b]...'])
            b = zeros(size(A,1), size(x0,2));
        end
        if ~isempty(Aeq) && isempty(beq)
            warning('optimize:Aeq_but_not_beq', ...
                ['I received the matrix [Aeq], but you omitted the corresponding vector [beq].',...
                '\nI`ll assume a zero-vector for [beq]...'])
            beq = zeros(size(Aeq,1), size(x0,2));
        end
        if isempty(Aeq) && ~isempty(beq)
            warning('optimize:beq_but_not_Aeq', ...
                ['I received the vector [beq], but you omitted the corresponding matrix [Aeq].',...
                '\nI`ll ignore the given [beq]...'])
            beq = [];
        end
        if isempty(A) && ~isempty(b)
            warning('optimize:b_but_not_A', ...
                ['I received the vector [b], but you omitted the corresponding matrix [A].',...
                '\nI`ll ignore the given [b]...'])
            b = [];
        end
        if ~isempty(A) && ~isempty(b) && size(b,1)~=size(A,1)
            error('optimize:b_incompatible_with_A',...
                'The size of [b] is incompatible with that of [A].')
        end
        if ~isempty(Aeq) && ~isempty(beq) && size(beq,1)~=size(Aeq,1)
            error('optimize:b_incompatible_with_A',...
                'The size of [beq] is incompatible with that of [Aeq].')
        end
        if ~isvector(x0) && ~isempty(A) && (size(A,2) ~= size(x0,1))
            error('optimize:A_incompatible_size',...
                'Linear constraint matrix [A] has incompatible size for given [x0].')
        end
        if ~isvector(x0) && ~isempty(Aeq) && (size(Aeq,2) ~= size(x0,1))
            error('optimize:Aeq_incompatible_size',...
                'Linear constraint matrix [Aeq] has incompatible size for given [x0].')
        end
        if ~isempty(b) && size(b,2)~=size(x0,2)
            error('optimize:x0_vector_but_not_b',...
                  'Given linear constraint vector [b] has incompatible size with given [x0].')
        end
        if ~isempty(beq) && size(beq,2)~=size(x0,2)
            error('optimize:x0_vector_but_not_beq',...
                  'Given linear constraint vector [beq] has incompatible size with given [x0].')
        end                
          
        % functions are not function handles
        if ~isa(funfcn, 'function_handle')
            error('optimize:func_not_a_function',...
                  'Objective function must be given as a function handle.')
        end
        if ~isempty(nonlcon) && ~isa(nonlcon, 'function_handle')
            error('optimize:nonlcon_not_a_function', ...
                 'non-linear constraint function must be a function handle.')
        end
        
        % test the feasibility of the initial solution (when strict or
        % superstrict behavior has been enabled)        
        if strcmpi(strictness, 'strict') || strcmpi(strictness, 'superstrict')
            superstrict = strcmpi(strictness, 'superstrict');           
            if ~isempty(A) && any(any(A*x0 > b))
                error('optimize:x0_doesnt_satisfy_linear_ineq', ...
                    ['Initial estimate does not satisfy linear inequality.', ...
                    '\nPlease provide an initial estimate inside the feasible region.']);
            end
            if ~isempty(Aeq) && any(any(Aeq*x0 ~= beq))
                error('optimize:x0_doesnt_satisfy_linear_eq', ...
                    ['Initial estimate does not satisfy linear equality.', ...
                    '\nPlease provide an initial estimate inside the feasible region.']);
            end
            if ~isempty(nonlcon)                
                [c, ceq] = nonlcon(x0); %#ok
                if ~isempty(c) && any(c(:) > ~superstrict*tolCon) 
                    error('optimize:x0_doesnt_satisfy_nonlinear_ineq', ...
                        ['Initial estimate does not satisfy nonlinear inequality.', ...
                        '\nPlease provide an initial estimate inside the feasible region.']);
                end
                if ~isempty(ceq) && any(abs(ceq(:)) >= ~superstrict*tolCon) 
                    error('optimize:x0_doesnt_satisfy_nonlinear_eq', ...
                        ['Initial estimate does not satisfy nonlinear equality.', ...
                        '\nPlease provide an initial estimate inside the feasible region.']);
                end
            end
        end    
        
    end % check_input
    
    % create transformed variable to conform to upper and lower bounds
    function xx = X(x)
        if (size(x, 2) == 1), xx = Nzero; else xx = Np1zero; end               
        for i = 1:size(x, 2)   
            xx(lb_only, i) = lb(lb_only,:) + x(lb_only(~fix_var), i).^2;
            xx(ub_only, i) = ub(ub_only,:) - x(ub_only(~fix_var), i).^2;
            xx(fix_var, i) = lb(fix_var,:);
            xx(unconst, i) = x(unconst(~fix_var), i);
            xx(lb_ub, i)   = lb(lb_ub,:) + ...
                (ub(lb_ub,:) - lb(lb_ub,:)) .* (sin(x(lb_ub(~fix_var), i)) + 1)/2;
        end
    end % X
    
    % create penalized function. Penalize with linear penalty function if 
    % violation is severe, otherwise, use exponential penalty. If the
    % 'strict' option has been set, check the constraints, and return INF
    % if any of them are violated.
    function P_fval = funfncP(x, varargin)
        
        % initialize function value
        if (size(x, 2) == 1), P_fval = 0; else P_fval = Nzero.'; end        
        
        % initialize x_new array
        x_new = new_x;
        
        % evaluate every vector in x
        for i = 1:size(x, 2)
            
            % reshape x, so it has the same size as the given x0
            x_new(:) = x(:, i);
            
            % initially, we are optimistic
            linear_eq_Penalty   = 0;   nonlin_eq_Penalty   = 0;
            linear_ineq_Penalty = 0;   nonlin_ineq_Penalty = 0;
            
            % Penalize the linear equality constraint violation 
            % required: Aeq*x = beq   
            if ~isempty(Aeq) && ~isempty(beq)                
                lin_eq = abs(Aeq*x_new - beq);     
                sumlin_eq = sum(abs(lin_eq(:)));
                if strcmpi(strictness, 'strict') && any(lin_eq > 0)
                    P_fval = inf; return
                end                    
                if sumlin_eq > 200
                    linear_eq_Penalty = exp(200) - 1 + sumlin_eq;
                else
                    linear_eq_Penalty = exp(sum(lin_eq)) - 1; 
                end
            end
            
            % Penalize the linear inequality constraint violation 
            % required: A*x <= b
            if ~isempty(A) && ~isempty(b)
                lin_ineq = A*x_new - b;                     
                lin_ineq(lin_ineq <= 0) = 0;
                sumlin_ineq = sum(lin_ineq(:)); 
                if strcmpi(strictness, 'strict') && any(lin_ineq > 0)
                    P_fval = inf; return
                end  
                if sumlin_ineq > 200
                    linear_ineq_Penalty = exp(200) - 1 + sumlin_ineq;
                else
                    linear_ineq_Penalty = exp(sumlin_ineq) - 1; 
                end
            end
            
            % Penalize the non-linear constraint violations
            % required: ceq = 0 and c <= 0
            if ~isempty(nonlcon)
                [c, ceq] = nonlcon(x_new); %#ok
                if ~isempty(c)
                    c = c(:); sumc = sum(c(c > 0));
                    if (strcmpi(strictness, 'strict') || strcmpi(strictness, 'superstrict'))...
                        && any(c > ~superstrict*tolCon)
                        P_fval = inf; return
                    end                       
                    if sumc > 200
                        nonlin_ineq_Penalty = exp200 - 1 + sumc;
                    else
                        nonlin_ineq_Penalty = exp(sumc) - 1;
                    end
                end
                if ~isempty(ceq)
                    ceq = abs(ceq(:));  sumceq = sum(ceq(ceq > 0));
                    if (strcmpi(strictness, 'strict') || strcmpi(strictness, 'superstrict'))...
                        && any(ceq >= ~superstrict*tolCon)
                        P_fval = inf; return
                    end                                        
                    if sumceq > 200
                        nonlin_eq_Penalty = exp200 - 1 + sumceq;
                    else
                        nonlin_eq_Penalty = exp(sumceq) - 1;
                    end                    
                end
            end
            
            % evaluate the objective function
            obj_fval = funfcn(x_new, varargin{:});              
            
            % return penalized function value
            P_fval(i) = obj_fval + linear_eq_Penalty + linear_ineq_Penalty + ...
                nonlin_eq_Penalty + nonlin_ineq_Penalty; %#ok
        end
    end % funfncP
    
    % simple wrapper function for output functions; these need to be 
    % evaluated with the untransformed variables
    function stop = OutputFcn_wrapper(x, varargin)
        x_new = new_x;  x_new(:) = X(x);
        stop = OutputFcn(x_new, varargin{:});
    end % OutputFcn_wrapper
    
    % finalize the output
    function [output, exitflag] = finalize(x, output, exitflag)        
        
        % make sure the algorithm is correct
        output.algorithm  = 'Nelder-Mead simplex direct search';
        
        % reshape x so it has the same size as x0
        x_new = new_x; x_new(:) = x;
        
        % finalize the output
        violated1 = false;   violated2 = false;
        violated3 = false;   violated4 = false;
        if ~isempty(A)
            Ax        = A*x_new;       
            violated1 = Ax >= b + tolCon;
            violation = Ax - b;
            violation(~violated1) = 0;
            output.constrviolation.lin_ineq{1} = violated1;
            output.constrviolation.lin_ineq{2} = violation;
        end
        if ~isempty(Aeq)
            Aeqx = Aeq*x_new;   
            violated2 = abs(Aeqx - beq) > tolCon;            
            violation = Aeqx - beq;
            violation(~violated2) = 0;
            output.constrviolation.lin_eq{1} = violated2;
            output.constrviolation.lin_eq{2} = violation;
        end
        if ~isempty(nonlcon)
            [c, ceq] = nonlcon(x_new); %#ok
            if ~isempty(ceq)
                violated3 = abs(ceq) > tolCon;
                ceq(~violated3) = 0;
                output.constrviolation.nonl_eq{1} = violated3;
                output.constrviolation.nonl_eq{2} = ceq;
            end
            if ~isempty(c)
                violated4 = c > tolCon; c(~violated4) = 0;
                output.constrviolation.nonl_ineq{1} = violated4;
                output.constrviolation.nonl_ineq{2} = c;                
            end            
        end
        if exitflag == -3
            output.message = sprintf(...
                ' No finite function values encountered.\n');
        end
        if any([violated1(:); violated2(:); violated3(:); violated4(:)])
            exitflag = -2;
            output.message = sprintf(...
                ['%s\n Unfortunately, the solution is infeasible for the given value ',...
                'of OPTIONS.TolCon of %1.6e'], output.message, tolCon);
        else
            if exitflag == 1
                output.message = sprintf(...
                    ['%s\b\n and all constraints are satisfied using ',...
                     'OPTIONS.TolCon of %1.6e.'], output.message, tolCon);
            end
        end
    end % finalize  
    
    % optimize globally
    function [sol, fval, exitflag, output] = optimize_globally(varargin)
                
        % first perform error checks
        if isempty(ub) || isempty(lb)
            error('optimize:lbub_undefined',...
                  'When optimizing globally ([x0] is empty), both [lb] and [ub] must be defined.')
        end       
        
        % use 25*(number of dimensions) individuals
        popsize = 25*numel(lb);          
        
        % initialize population of random starting points
        population = repmat(lb, [1,1,popsize]) + ...
            rand(size(lb,1), size(lb,2), popsize) .* repmat(ub-lb, [1,1,popsize]);
                
        % reset maximum allowable function evaluations
        maxiters   = optimget(options, 'MaxIter');
        MaxFunEval = floor( optimget(options, 'MaxFunEvals') / popsize);
        options = optimset(options, 'MaxFunEvals', MaxFunEval);    
        
        % slightly loosen options for global method
        global_options = optimset(options, ...
            'TolX'  , 1e2 * options.TolX,...
            'TolFun', 1e2 * options.TolFun);
        
        % initialize loop
        best_fval = inf; iterations = 0; evaluations = 0; new_x = population(:,:,1);
        sol = NaN(size(lb)); fval = inf; exitflag = []; output = struct;
        
        % loop through each individual, and use it as initial value
        for ii = 1:popsize
                        
            % optimize current problem
            [sol_i, fval_i, exitflag_i, output_i] = ...
                optimize(funfcn, population(:,:,ii), lb, ub, A, b, Aeq, beq, nonlcon,...
                strictness, global_options, algorithm, varargin{:});
            
            % add number of evaluations and iterations to total
            evaluations = evaluations + output_i.funcCount;
            iterations  = iterations + output_i.iterations;
            
            % keep track of the best solution found so far
            if fval_i < best_fval              
                % output values                
                fval   = fval_i;   exitflag = exitflag_i;
                sol    = sol_i;    output = output_i;
                % and store the new best
                best_fval = fval_i;
            end
            
            % reset output structure
            output.funcCount = evaluations;
            output.iterations = iterations;
            
            % evaluations has been taken care of, but
            % iterations not yet            
            if iterations >= maxiters
                % finalize solution
                [output, exitflag] = finalize(sol, output, exitflag);
                % and return
                return
            end
            
        end % for   
        
        % check for INF or NaN values
        if ~isfinite(fval)            
            exitflag = -3;            
            % finalize solution
            [output, exitflag] = finalize(sol, output, exitflag);      
            % and return
            return
        end
        
        % perform the final iteration on the best solution found
        if evaluations < options.MaxFunEvals
            % reset max. number of function evaluations
            options = optimset(options, 'MaxFunEvals', options.MaxFunEvals - evaluations);
            % optimize with stricter options
            [sol, fval, exitflag, output_i] = ...
                optimize(funfcn, sol, lb, ub, A, b, Aeq, beq, nonlcon,...
                strictness, options, algorithm, varargin{:});
            % adjust output
            output.funcCount = output.funcCount + output_i.funcCount;
            output.iterations = output.iterations + output_i.iterations;            
        end        
        
    end % optimize_globally
    
    % Embedded Nelder-Mead algorithm
    function [sol, fval, exitflag, output] = NelderMead(funfcn, x0, options, varargin)
                
        % Nelder-Mead algorithm control factors
        alpha = 1;     beta  = 0.5;
        gamma = 2;     delta = 0.5;
        a     = 1/20; % (a) is the size of the initial simplex. 
                      % 1/20 is 5% of the initial values.        
        % constants
        N                         = length(x0);
        VSfactor_reflect          = alpha^(1/N);
        VSfactor_expand           = (alpha*gamma)^(1/N);
        VSfactor_inside_contract  = beta^(1/N);
        VSfactor_outside_contract = (alpha*beta)^(1/N);
        VSfactor_shrink           = delta;        
        
        % check for output functions
        outputfcn = false;
        if ~isempty(options.OutputFcn) 
            outputfcn = true; 
            OutputFcn = options.OutputFcn; 
        end
        
        % initial values
        iterations   = -1; sort_inds = (1:N).';
        operation    = 0;  op        = 'initial simplex';
        volume_ratio = 1;
        stop = false;
        
        % parse options
        if (narg == 2) || isempty(options), options = optimset; end
        reltol_x = optimget(options, 'TolX', 1e-12);
        reltol_f = optimget(options, 'TolFun', 1e-12);
        max_evaluations = optimget(options, 'MaxFunEvals', 200*N);
        max_iterations  = optimget(options, 'MaxIter', 1e4);
        display = optimget(options, 'Display', 'off');
        
        % generate initial simplex
        p = a/N/sqrt(2) * (sqrt(N+1) + N - 1) *  eye(N);
        q = a/N/sqrt(2) * (sqrt(N+1) - 1)     * ~eye(N);
        x = x0(:, ones(1,N));
        x = [x0, x + p + q];             
        
        % function is known to be ``vectorized''
        f = funfcn(x);    evaluations = N+1;        
        
         % first evaluate output function        
        if outputfcn
            optimValues.iteration = iterations;
            optimValues.funcCount = evaluations;
            optimValues.procedure = op;                                
            outputFcn(x, optimValues, 'init', varargin{:});            
        end
        
        % sort and re-label initial simplex
        [f, inds] = sort(f);    x = x(:, inds);
        
        % compute initial centroid
        C = sum(x(:, 1:end-1), 2)/N;
        
        % display header if per-iteration display is selected
        if strcmpi(display, 'iter')
            fprintf(1, ['\n\t\tf(1)\t\tfunc. evals.\toperation\n', ...
                '\t==================================================\n'])
        end
        
        % main loop
        while true
            
            % evaluate output function
            if outputfcn
                optimValues.iteration = iterations;
                optimValues.funcCount = evaluations;
                optimValues.procedure = op;
                outputFcn(x, optimValues, 'iter', varargin{:});
            end
                       
            % increase number of iterations
            iterations = iterations + 1;
            
            % display string for per-iteration display
            if strcmpi(display, 'iter')
                fprintf(1, '\t%+1.6e', f(1));
                fprintf(1, '\t\t%4.0d', evaluations);
                fprintf(1, '\t\t%s\n', op);
            end
            
            % re-sort function values
            x_replaced = x(:, end);
            switch operation
                case 2      % shrink steps
                    [f, inds] = sort(f);   x = x(:, inds);
                otherwise   % non-shrink steps
                    inds = f(end) <= f(1:end-1);
                    f = [f(sort_inds(~inds)), f(end), f(sort_inds(inds))];
                    x = [x(:, sort_inds(~inds)), x_replaced, x(:, sort_inds(inds))];
            end
            
            % update centroid (Singer & Singer are wrong here...
            % shrink & non-shrink steps should be treated the same)
            C = C + (x_replaced -  x(:, end))/N;
            
            % Algorithm termination conditions
            term_f = abs(f(end) - f(1)) / (abs(f(end)) + abs(f(1)))  < reltol_f;
            fail   = (iterations >= max_iterations) || (evaluations >= max_evaluations);
            term_x = volume_ratio < reltol_x;
            if (term_x || term_f || fail), break, end
                        
            % non-shrink steps are taken most of the time. Set this as the
            % default operation.
            operation = 1;
                
            % try to reflect the simplex
            xr = C + alpha*(C - x(:, end));
            fr = funfcn(xr);
            evaluations = evaluations + 1;
            
            % accept the reflection point
            if fr < f(end-1)
                x(:, end) = xr;
                f(end) = fr;
                
                % try to expand the simplex
                if fr < f(1)                    
                    xe = C + gamma*(xr - C);
                    fe = funfcn(xe);
                    evaluations = evaluations + 1;
                    
                    % accept expand
                    if (fe < f(1))
                        op = 'expand';
                        volume_ratio = VSfactor_expand * volume_ratio;
                        x(:, end) = xe;
                        f(end) = fe;
                        continue;
                    end
                end
                
                % otherwise, just continue
                op = 'reflect';
                volume_ratio = VSfactor_reflect * volume_ratio;
                continue;
                
                % otherwise, try to contract the simplex
            else
                                
                % outside contraction
                if fr < f(end)
                    xc = C + beta*(xr - C);
                    insouts = 1;
                    
                    % inside contraction
                else
                    xc = C + beta*(x(:, end) - C);
                    insouts = 2;
                end
                fc = funfcn(xc);
                evaluations = evaluations + 1;
                
                % accept contraction
                if fc < min(fr, f(end))
                    switch insouts
                        case 1
                            op = 'outside contraction';
                            volume_ratio = VSfactor_outside_contract * volume_ratio;
                        case 2
                            op = 'inside contraction';
                            volume_ratio = VSfactor_inside_contract * volume_ratio;
                    end
                    x(:, end) = xc;
                    f(end) = fc;
                    continue;
                    
                % everything else has failed - shrink the simplex towards x1
                else      
                    % first evaluate output function
                    op = 'shrink';
                    if outputfcn
                        optimValues.iteration = iterations;
                        optimValues.funcCount = evaluations;
                        optimValues.procedure = op;                        
                        stop = outputFcn(x, optimValues, 'interrupt', varargin{:});
                        if stop, break, end
                    end
                    % then shrink                    
                    operation = 2;
                    xones = x(:, ones(1, N+1));
                    x = xones + delta*(x - xones);
                    f = funfcn(x);
                    evaluations = evaluations + N + 1;
                    volume_ratio = VSfactor_shrink * volume_ratio;
                end
            end            
        end
        
        % evaluate output function        
        if outputfcn
            optimValues.iteration = iterations;
            optimValues.funcCount = evaluations;
            optimValues.procedure = 'Final simplex.';
            options.OutputFcn(x, optimValues, 'done', varargin{:});            
        end
        
        % end values
        sol  = x(:, 1);
        fval = f(1);        
        
        % exitflag
        if (term_x || term_f), exitflag = 1; end % normal convergence
        if stop, exitflag = -1; end              % stopped by stopfunction
        if fail, exitflag = 0; end               % max. iterations or max. func. eval. exceeded        
        
        % create output structure        
        output.iterations = iterations;
        output.funcCount  = evaluations;
        if exitflag == 1
            output.message = sprintf(['Optimization terminated:\n',...
               ' the current x satisfies the termination criteria using OPTIONS.TolX of %d \n',...
               ' and F(X) satisfies the convergence criteria using OPTIONS.TolFun of %d \n'],...
               reltol_x, reltol_f);
        end
        if exitflag == 0
            if (iterations >= max_iterations)
                output.message = sprintf(['Optimization terminated:\n',...
               ' Maximum amount of iterations exceeded; Increase ''MaxIters'' option.\n']);
            elseif (evaluations >= max_evaluations)
                output.message = sprintf(['Optimization terminated:\n',...
               ' Maximum amount of function evaluations exceeded; Increase ''MaxFunevals'' option.\n']);
            end            
        end
        if exitflag == -1
            output.message = sprintf('Optimization terminated by user-provded output function.\n');
        end
    end % NelderMead
    
end % function
