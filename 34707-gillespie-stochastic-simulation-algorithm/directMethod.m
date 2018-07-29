function [ t, x ] = directMethod( stoich_matrix, propensity_fcn, tspan, x0,...
                                  rate_params, output_fcn, MAX_OUTPUT_LENGTH)
%DIRECTMETHOD Implementation of the Direct Method variant of the Gillespie algorithm
%   Based on: Gillespie, D.T. (1977) Exact Stochastic Simulation of Coupled
%   Chemical Reactions. J Phys Chem, 81:25, 2340-2361.
%
%   Usage:
%       [t, x] = directMethod( stoich_matrix, propensity_fcn, tspan, x0 )
%       [t, x] = directMethod( stoich_matrix, propensity_fcn, tspan, x0, rate_params )
%       [t, x] = directMethod( stoich_matrix, propensity_fcn, tspan, x0, rate_params, output_fcn )
%
%   Returns:
%       t:              time vector          (Nreaction_events x 1)
%       x:              species amounts      (Nreaction_events x Nspecies)    
%
%   Required:
%       tspan:          Initial and final times, [t_initial, t_final].
%       x0:             Initial species values, [S1_0, S2_0, ... ].
%       stoich_matrix:  Matrix of stoichiometries (Nreactions x Nspecies).
%                       Each row gives the stoichiometry of a reaction.
%       prop_fcn:       Function handle to function that calculates
%                       reaction propensities.
%                       Target function should be of the form
%                           ac = f( xc, rate_params ),
%                       where xc is the current state [S1, S2, ...], and
%                       rate_params is the user-defined rate parameters.
%                       The function should return vector ac of 
%                       propensities (Nreactions x 1) in the same order as
%                       the reactions given in stoich_matrix.
%
%	Optional:
%		output_fcn:	    Handle to user-defined function with the form
%							status = f( tc, xc )
%						The output_fcn is called at each time step in the 
%						simulation and is passed the current time and state.
%						It can be used to locate events or monitor progress. 
%						If it returns 0, the simulation terminates.
%
%   Author:  Nezar Abdennur, 2012 <nabdennur@gmail.com>
%   Created: 2012-01-19
%   Dynamical Systems Biology Laboratory, University of Ottawa
%   www.sysbiolab.uottawa.ca
%
%   See also FIRSTREACTIONMETHOD

if ~exist('MAX_OUTPUT_LENGTH','var')
    MAX_OUTPUT_LENGTH = 1000000;
end
if ~exist('output_fcn', 'var')
    output_fcn = [];
end
if ~exist('rate_params', 'var')
    rate_params = [];
end
    
%% Initialize
%num_rxns = size(stoich_matrix, 1);
num_species = size(stoich_matrix, 2);
T = zeros(MAX_OUTPUT_LENGTH, 1);
X = zeros(MAX_OUTPUT_LENGTH, num_species);
T(1)     = tspan(1);
X(1,:)   = x0;
rxn_count = 1;

%% MAIN LOOP
while T(rxn_count) < tspan(2)        
    % Calculate reaction propensities
    a  = propensity_fcn(X(rxn_count,:), rate_params);
    
    % Compute tau and mu using random variates
    a0 = sum(a);
    r = rand(1,2);
    tau = (1/a0)*log(1/r(1));
    mu  = find((cumsum(a) >= r(2)*a0),1,'first');
    % alternatively...
    %mu=1; s=a(1); r0=r(2)*a0;
    %while s < r0
    %   mu = mu + 1;
    %   s = s + a(mu);
    %end

    % Update time and carry out reaction mu
    if rxn_count + 1 > MAX_OUTPUT_LENGTH
        t = T(1:rxn_count);
        x = X(1:rxn_count,:);
        warning('SSA:ExceededCapacity',...
                'Number of reaction events exceeded the number pre-allocated. Simulation terminated prematurely.');
        return;
    end
    
    T(rxn_count+1)   = T(rxn_count)   + tau;
    X(rxn_count+1,:) = X(rxn_count,:) + stoich_matrix(mu,:);    
    rxn_count = rxn_count + 1;
    
    if ~isempty(output_fcn)
        stop_signal = feval(output_fcn, T(rxn_count), X(rxn_count,:)');
        if stop_signal
            t = T(1:rxn_count);
            x = X(1:rxn_count,:);
            warning('SSA:TerminalEvent',...
                    'Simulation was terminated by OutputFcn.');
            return;
        end 
    end
end  

% Record output
t = T(1:rxn_count);
x = X(1:rxn_count,:);
if t(end) > tspan(2)
    t(end) = tspan(2);
    x(end,:) = X(rxn_count-1,:);
end    

end

