function lnL = CIRobjective2(Params, Model)
% =========================================================================
% PURPOSE : Log-likelihood objective function (multiplied by -1) for the 
%           CIR process using MATLAB ncx2pdf function.
% =========================================================================
% USAGE   : Model.TimeStep  = Delta t
%           Model.Data      = Time series of interest rates observations
%           Params          = Model Paramsameters (alpha, mu, sigma)
% =========================================================================
% RETURNS : lnL             = Objective function value 
% =========================================================================
% Kamil Kladivko for Technical Computing Prague 2007
% Date: October 2007 
% Questions? kladivko@gmail.com

    Data = Model.Data;
    DataF = Data(2:end);
    DataL = Data(1:end-1);
    TimeStep = Model.TimeStep;
    alpha = Params(1);
    mu = Params(2);
    sigma = Params(3);

    c = 2*alpha/(sigma^2*(1-exp(-alpha*TimeStep)));
    q = 2*alpha*mu/sigma^2-1;
    u = c*exp(-alpha*TimeStep)*DataL;
    v = c*DataF;
    nc = 2*u;
    df = 2*q+2; 
    s = 2*v;
    
    gpdf = ncx2pdf(s, df, nc);
    ppdf = 2*c*gpdf;
    lnL = sum(-log(ppdf));
end

