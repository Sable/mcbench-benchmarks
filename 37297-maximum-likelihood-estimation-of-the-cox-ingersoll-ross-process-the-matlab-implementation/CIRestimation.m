function Results = CIRestimation(Model) 
% =========================================================================
% PURPOSE : CIR process maximum likelihood estimation
%            1) OLS initial parameters estimation
%            2) Log-likelihood function optimization
%            3) Printing Results   
% =========================================================================
% USAGE   : Model.Data       = Time series of interest rates observations
%         : Model.TimeStep   = Delta t; recommended: 1/250 for daily data
%                                                    1/12 for monthly data                                                  
%         : Model.Disp       = 'y' | 'n', (default: 'n')
%         : Model.Method     = 'ncx2pdf' | 'besseli' (default: 'besseli')
%         : Model.MatlabDisp = 'off'|'iter'|'notify'|'final' (default: 'off')
% =========================================================================
% RETURNS : Results.Params   = Estimated parameters (alpha, mu, sigma)
%         : Results.Fval     = Objective function value
% =========================================================================
% Kamil Kladivko; Technical Computing Prague 2007
% Date: October 2007 
% Questions? kladivko@gmail.com

    % Initial parameters using OLS
    Nobs = length(Model.Data);
    x = Model.Data(1:end-1);
    dx = diff(Model.Data);           
    dx = dx./x.^0.5;
    regressors = [Model.TimeStep./x.^0.5, Model.TimeStep*x.^0.5];
    drift = regressors\dx;
    res = regressors*drift - dx;
    alpha = -drift(2);
    mu = -drift(1)/drift(2);
    sigma = sqrt(var(res, 1)/Model.TimeStep);
    InitialParams = [alpha mu sigma];
    if ~isfield(Model, 'Disp'), Model.Disp = 'y'; end;
    if strcmp(Model.Disp, 'y')
        fprintf('\n initial alpha = %+3.6f\n initial mu    = %+3.6f\n initial sigma = %+3.6f\n', alpha, mu, sigma);
    end

    % Optimization using fminsearch
    if ~isfield(Model, 'MatlabDisp'), Model.MatlabDisp = 'off'; end;
    options = optimset('LargeScale', 'off', 'MaxIter', 300, 'MaxFunEvals', 300, 'Display', Model.MatlabDisp, 'TolFun', 1e-4, 'TolX', 1e-4, 'TolCon', 1e-4); 
    if ~isfield(Model, 'Method'), Model.Method = 'besseli'; end;
    if strcmp(Model.Method, 'ncx2pdf')
        [Params, Fval, Exitflag] =  fminsearch(@(Params) CIRobjective2(Params, Model), InitialParams, options);   
    else
        [Params, Fval, Exitflag] =  fminsearch(@(Params) CIRobjective1(Params, Model), InitialParams, options);   
    end
    %tol = 1e-6;
    %lb = [ tol,  tol, tol];
    %ub = [ inf,  inf, inf];    
    %[Params, Fval, Exitflag] = fmincon(@(Params) CIRobjective1(Params, Model), InitialParams, [], [], [], [], lb, ub, [], options);

    Results.Params = Params;
    Results.Fval = -Fval/Nobs;
    Results.Exitflag = Exitflag;

    if strcmp(Model.Disp, 'y')
        fprintf('\n alpha = %+3.6f\n mu    = %+3.6f\n sigma = %+3.6f\n', Params(1), Params(2), Params(3));
        fprintf(' log-likelihood = %+3.6f\n', -Fval/Nobs);
    end
end

