function neq = sys_init(params)

global N problem

% Here is a list of the different system information paramters.
% neq = 1  : number of state variables.
% neq = 2  : number of inputs.
% neq = 3  : number of parameters.
% neq = 4  : reserved.
% neq = 5  : reserved.
% neq = 6  : number of objective functions.
% neq = 7  : number of nonlinear trajectory constraints.
% neq = 8  : number of linear trajectory constraints.
% neq = 9  : number of nonlinear endpoint inequality constraints.
% neq = 10 : number of linear endpoint inequality constraints.
% neq = 11 : number of nonlinear endpoint equality constraints.
% neq = 12 : number of linear endpoint equality constraints.
% neq = 13 : 0 => nonlinear, 1 => linear, 2 => LTI, 3 => LQR, 4 => LQR and LTI.

% The default value is 0 for all except neq = 6 which defaults to 1.

% if params == [] then setup neq.  Otherwise the system parameters are
% getting passed.

if isempty(params),
    if problem == 1
        %LTI
        neq = [1, 2*N+1; 2, 1; 3, 4];
    elseif problem == 2
        %LTV
        neq = [1, 2*N+1; 2, 1; 3, 4];
    elseif problem == 3
        %Bang-bang
        neq = [1, 2*N+3; 2, 1; 3, 4; 12 2];
    end
else
    global sys_params
    sys_params = params;
end