%% GSA_GetSy: calculate the Sobol' sensitivity indices
%
% Usage:
%   [S eS pro] = GSA_GetSy(pro, iset, verbose)
%
% Inputs:
%    pro                project structure
%    iset               cell array or array of inputs of the considered set, they can be selected
%                       by index (1,2,3 ...) or by name ('in1','x',..) or
%                       mixed
%    verbose            if not empty, it shows the time (in hours) for
%                       finishing
%
% Output:
%    S                  sensitivity coefficient
%    eS                 error of sensitivity coefficient
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
% 1.0  15-04-2011  Added verbose parameter
% 1.0  15-01-2011  First release.
%%

function [S eS pro] = GSA_GetSy(pro, iset, verbose)


if ~exist('verbose','var')
    verbose = 0;
else
    verbose = ~isempty(verbose) && verbose;
end

index = fnc_SelectInput(pro, iset);

if isempty(index)
    S = 0;
    eS = 0;
else
    S = 0;
    eS = 0;
    n = length(index);
    L = 2^n;
    
    if verbose
        tic
    end
    for i=1:(L-1)
        ii = fnc_GetInputs(i);
        si = fnc_GetIndex(index(ii));
        if isnan(pro.GSA.GSI(si))
            
            %-------
            if isnan(pro.GSA.Di(si))
                
                ixi = fnc_GetInputs(si);
                s = length(ixi);
                l = 2^s - 1;
                
                %======
                if isnan(pro.GSA.Dmi(si))
                    n = length(pro.Inputs.pdfs);
                    N = size(pro.SampleSets.E,1);
                    H = pro.SampleSets.E(:,:);
                    cii = fnc_GetComplementayInputs(si, n);
                    H(:,cii) = pro.SampleSets.T(:,cii);
                    ff = nan(N,1);
                    
                    for j=1:N
                        ff(j) = pro.GSA.fE(j)*(pro.Model.handle(H(j,:))-pro.GSA.mfE);
                    end
                    
                    pro.GSA.Dmi(si)  = nanmean(ff);
                    pro.GSA.eDmi(si) = 0.6745*sqrt((nanmean(ff.^2) - pro.GSA.Dmi(si)^2)/sum(~isnan(ff)));
                end
                %=======
                
                Di = pro.GSA.Dmi(si);
                eDi = pro.GSA.eDmi(si)^2;
                
                for j=1:(l-1)
                    sii = fnc_GetInputs(j);
                    k = fnc_GetIndex(ixi(sii));
                    s_r = s - length(sii);
                    Di = Di + pro.GSA.Dmi(k)*((-1)^s_r);
                    eDi = eDi + pro.GSA.eDmi(k)^2;
                end
                
                pro.GSA.Di(si) = Di + (pro.GSA.f0^2)*((-1)^s);
                pro.GSA.eDi(si) = sqrt(eDi + 2*(pro.GSA.ef0^2));
                
                
            end
            %------
            pro.GSA.GSI(si) = pro.GSA.Di(si)/pro.GSA.D;
            pro.GSA.eGSI(si) = pro.GSA.GSI(si)*pro.GSA.eDi(si)/pro.GSA.D;
        end
        S = S + pro.GSA.GSI(si);
        eS = eS + pro.GSA.eGSI(si);
        
        if verbose
            timelapse = toc;
            disp(timelapse*(L-1-i)/i/60/60);
        end
    end
end
