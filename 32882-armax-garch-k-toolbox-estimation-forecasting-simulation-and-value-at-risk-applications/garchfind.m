function [parameters, stderrors, LLF, ht, resids, summary] = garchfind(data, models, distributions, ar, ma, p, q, options)
%{
[parameters, stderrors, LLF, ht, resids, summary] = garch(data, model, distr, ar, ma, x, p, q, y,startingvalues, options)
-----------------------------------------------------------------------
 PURPOSE:
 Finds the combination of models and distributions that better fits the 
 data based on a set of criteria (i.e.  largest log likelihood value 
 and the smallest AIC and BIC criteria).
----------------------------------------------------------------------
 USAGE:
 garchfind(data, models, distributions, ar, ma, p, q)

 INPUTS:
 data:          (T x 1) vector of data
 models:        a character vector with models to be estimated
 distributions: a character vector with distributions
 ar:            length of AR
 ma:            length of MA
 p:             length of ARCH
 q:             length of GARCH
 options:       set of options

 OUTPUTS based on the estimation of the best model:
 parameters:   a vector of parameters a0, a1, b0, b1, b2, ...
 stderrors:    standard errors estimated by the inverse Hessian (fmincon)
 LFF:          the value of the Log-Likelihood Function
 ht:           vector of conditional variances
 resids:       vector of residuals
 summary:      summary of results including: 
                -model specification, distribution and statistics
                -optimization options
                -t-statistics
                -robust standard errors: (HESSIAN^-1)*cov(scores)*(HESSIAN^-1)
                -scores: numerical scores for M testing
-----------------------------------------------------------------------
Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date: 08/2011
-----------------------------------------------------------------------
%}
if nargin == 0 
    error('Data, GARCH Models, Distribution, AR, MA, ARCH, GARCH, Options') 
end

if size(data,2) > 1
   error('Data vector should be a column vector')
end

if (length(ar) > 1) | (length(ma) > 1) | ar < 0 | ma < 0
    error('AR and MA should be positive scalars')
end

if (length(p) > 1) | (length(q) > 1) | p < 0 | q < 0
    error('P and Q should be positive scalars')
end


Criteria=[];
index=1;
for i = 1:size(models,1)
    for j = 1:size(distributions,1)
        for a=1:ar
            for b=1:ma
                for c=1:p
                    for d=1:q
                         fprintf('Progress: ARMA(%1.0f,%1.0f,%1.0f)-%s(%1.0f,%1.0f,%1.0f) - %s distribution\n', a, b, 0, strcat(models(i,:)), c, d, 0, strcat(distributions(j,:)))
                         eval(['[parameters, stderrors, LLF_temp] = garch(data,''' strcat(models(i,:)),''',''', strcat(distributions(j,:)), ''',a,b,0,c,d,0,[],options);']);
                         Criteria(index,:) = [LLF_temp, -2*LLF_temp+2*size(parameters,1), -2*LLF_temp+size(parameters,1)*log(size(data,1)), i, j, a, b, c,d];
                         index=index+1;
                    end
                end
            end
        end
    end
end

% This estimates a vector of results as long as the criteria are satisfied
holder=sortrows(Criteria,1);
z=size(holder,1)+1;
fprintf('\n The top models are: \n')
for i = 1:size(holder,1)
    if  find(holder == max(holder(1:z-i,1))) == find(holder == min(holder(1:z-i,2))) - size(holder(1:z-i,1),1) & find(holder == max(holder(1:z-i,1))) == find(holder == min(holder(1:z-i,3))) - 2*size(holder(1:z-i,1),1)
        fprintf('ARMA(%1.0f,%1.0f,%1.0f)-%s(%1.0f,%1.0f,%1.0f) - %s distribution\n', holder(z-i,6), holder(z-i,7), 0, strcat(models(holder(z-i,4),:)), holder(z-i,8), holder(z-i,9), 0, strcat(distributions(holder(z-i,5),:)))
    end
end

% Finds the best model so as to estimate the model
if find(Criteria == max(Criteria(:,1))) == find(Criteria == min(Criteria(:,2))) - size(Criteria,1) & find(Criteria == max(Criteria(:,1))) == find(Criteria == min(Criteria(:,3))) - 2*size(Criteria,1)
[parameters, stderrors, LLF, ht, resids, summary] = garch(data, strcat(models(Criteria(find(Criteria == max(Criteria(:,1))),4),:)), ...
    strcat(distributions(Criteria(find(Criteria == max(Criteria(:,1))),5),:)), ...
    Criteria(find(Criteria == max(Criteria(:,1))),6),...
    Criteria(find(Criteria == max(Criteria(:,1))),7),0, ...
    Criteria(find(Criteria == max(Criteria(:,1))),8), ...
    Criteria(find(Criteria == max(Criteria(:,1))),9),0,[],options);
end 
end