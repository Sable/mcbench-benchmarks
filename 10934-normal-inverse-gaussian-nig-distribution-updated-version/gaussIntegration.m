function [F, partialF, support] = gaussIntegration(f, a, b, nDivisionLevel, nNodes)

%GAUSSINTEGRATION uses Gauss nodes to integrate real-valued function
%   uses a Gauss integration rule on the interval [a, b] 
%   with nNodes (usually 4 nodes) on the corresponding interval
%   nDivisionLevel uses gauss integration recursively

% -------------------------------------------------------------------------
% 
% Allianz, Group Risk Controlling
% Risk Methodology
% Koeniginstr. 28
% D-80802 Muenchen
% Germany
% Internet:    www.allianz.de
% email:       ralf.werner@allianz.de
% 
% Implementation Date:  2006 - 05 - 01
% Author:               Dr. Ralf Werner
%
% -------------------------------------------------------------------------


% default, as so far, nothing else has been implemented
nNodes = 4;

% nodes and weights for the four-point-rule on [-1, 1]
weights = [0.347854845 0.652145155 0.652145155 0.347854845]; 
nodes = [-0.861136312 -0.339981044 0.339981044 0.861136312];

% transform nodes and weights to [0, 1]
weights = weights / 2;
nodes = (nodes + 1)/2;

interpolationPts = 0:1:2^nDivisionLevel;
interpolationPts = interpolationPts / 2^nDivisionLevel;

integrationPts = repmat(interpolationPts', 1, length(nodes));
integrationPts = integrationPts + repmat(nodes, 2^nDivisionLevel + 1, 1)/2^nDivisionLevel;
integrationPts = integrationPts(1:end-1,:);
integrationPts = reshape(integrationPts', numel(integrationPts), 1);

integrationWts = repmat(weights, 2^nDivisionLevel , 1)/2^nDivisionLevel;
integrationWts = reshape(integrationWts', numel(integrationWts), 1);

% transform integraton points and weights to the corresponding interval
transformedNodes = (b - a)*integrationPts + a;
transformedWeights = (b - a)*integrationWts;

% calculate integral
integralF = cumsum(f(transformedNodes) .* transformedWeights);

F = integralF(end);
partialF = integralF(length(nodes)*(1:2^nDivisionLevel));
support = (((1:1:2^nDivisionLevel) / 2^nDivisionLevel)*(b-a)+a)';

