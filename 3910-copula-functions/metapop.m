function globalExtinctionProb = metapop(tau)
%METAPOP A metapopulation simulation model
%   METAPOP(TAU) runs the metapopulation simulation described in the
%   November 2003 MATLAB News&Notes article, "Monte-Carlo simulation in
%   MATLAB using copulas".

%   Copyright 2009 The MathWorks, Inc.
%   Revision: 1.0  Date: 2003/09/05
%
%   Requires MATLAB® R13, including Statistics Toolbox™.

% The metapopulation model will include 3 subpopulations, and weill run
% over 100 time steps (years).
npops = 3;
nyears = 100;

% In each time step, there's a 3% chance of extinction for each
% subpopulation, and a 25% chance that an active population will recolonize
% a locally extinct one.
probLocalExtinction = .03;
colonizationRate = .25;

% Compute the linear correlation parameter that will be needed for the
% Gaussian copula, as a function of the desired rank correlation in local
% extinctions.  By default, assume zero correlation.
if nargin == 0, tau = 0; end
if (tau < -1/3) || (1 < tau), error('TAU must be between -1/3 and 1.'); end 
rho = sin(tau.*pi./2);

% Assume that the dependence in environmental variability between
% subpopulations is symmetric, i.e., equal correlations in local
% extinctions between all three pairs subpopulations.
R = [1 rho rho; rho 1 rho; rho rho 1];

% Run 10000 Monte-Carlo replicates in parallel.
nreplicates = 10000;

% Save a record of each subpopulation's presence/absence at each time step,
% for all the replicates.
presence = zeros(npops,nyears,nreplicates);
presence(:,1,:) = 1;
for yr = 2:nyears
    % Local extinctions occur at a given site with probability
    % probLocalExtinction, and are dependent between sites.  Model tht
    % dependence with a Gaussian copula.
    u = normcdf(mvnrnd([0 0 0], R, nreplicates));
    u = reshape(u',[npops,1,nreplicates]);
    localExtinction = (u < probLocalExtinction);
    
    % A local population remains active if it was active last year,
    % and it has not gone extinct this year.
    presence(:,yr,:) = presence(:,yr-1,:) .* (1 - localExtinction);
    
    % Count the number of local populations that are still active.
    nActivePops = sum(presence(:,yr,:), 1);
    
    % The probability that an extinct local population is recolonized
    % depends on the number of other local populations that are still
    % active.  Recolonizations are independent.
    probColonization = repmat(1 - (1 - colonizationRate).^nActivePops, [npops,1,1]);
    colonization = (rand(npops,1,nreplicates) < probColonization);
    
    % An extinct local population becomes active again if it is colonized.
    presence(:,yr,:) = presence(:,yr,:) + (1-presence(:,yr,:)).*colonization;
end

% The Monte-Carlo estimate of the probablility of global extinction is
% simply the number of replicates that went extinct diveide by the total
% number of replicates.
globalExtinctionProb = sum(all(presence(:,nyears,:) == 0, 1),3) ./ nreplicates

% Plot the subpopulation presence/absence for the first few replicates.
presence(presence==0) = NaN;
t = 1:nyears;
for i = 1:25
    subplot(5,5,i)
    plot(t,1.*presence(1,:,i),'r.', t,2.*presence(2,:,i),'b.', t,3.*presence(3,:,i),'m.');
end
