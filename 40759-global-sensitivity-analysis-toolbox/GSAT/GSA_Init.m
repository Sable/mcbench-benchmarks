%% GSA_Init: initialize the variables used in the GSA computation
%
% Usage:
%   pro = GSA_Init(pro)
%
% Inputs:
%    pro                project structure
%
% Output:
%    pro                project structure
%
% ------------------------------------------------------------------------
% See also
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 15-02-2011
%
% History:
% 1.0  15-01-2011  First release.
%%

function pro = GSA_Init(pro)

[E T] = fnc_SampleInputs(pro);

pro.SampleSets.E = E;
pro.SampleSets.T = T;

n = length(pro.Inputs.pdfs);
L = 2^n;
N = pro.N;

pro.GSA.fE = nan(N,1);

for j=1:N
    pro.GSA.fE(j) = pro.Model.handle(pro.SampleSets.E(j,:));
end

p = randperm(N);
third = round(N/3);
pro.GSA.mfE = nanmean(pro.GSA.fE(p(1:third)));

if isnan(pro.GSA.mfE)
    pro.GSA.mfE = 0;
end

pro.GSA.fE = pro.GSA.fE - pro.GSA.mfE;

pro.GSA.f0 = nanmean(pro.GSA.fE);
pro.GSA.D  = nanmean(pro.GSA.fE.^2) - pro.GSA.f0^2;

pro.GSA.ef0 = 0.6745*sqrt(pro.GSA.D/sum(~isnan(pro.GSA.fE)));

pro.GSA.Dmi = nan(1,L-1);
pro.GSA.eDmi = nan(1,L-1);

pro.GSA.Di = nan(1,L-1);
pro.GSA.eDi = nan(1,L-1);

pro.GSA.GSI = nan(1,L-1);
pro.GSA.eGSI = nan(1,L-1);
