function [t a prob] = MH_routine(theta,p,proposal_PDF,sample_from_proposal_PDF)
% Metropolis-Hastings algorithm routine:

theta_ast = sample_from_proposal_PDF(theta);        % sampling from the proposal PDF with media the current state
alpha = (p(theta_ast)*proposal_PDF(theta,theta_ast))/...  % Ratio of the density at the
        (p(theta)    *proposal_PDF(theta_ast,theta));     % candidate (theta_ast) and current (theta) points
if rand <= min(alpha,1)
   t    = theta_ast;        % Accept the candidate
   prob = min(alpha,1);     % Accept with probability min(alpha,1)
   a    = 1;                % Note the acceptance
else
   t    = theta;            % Reject the candidate and use the same state
   prob = 1-min(alpha,1);   % The same state with probability 1-min(alpha,1)
   a    = 0;                % Note the rejection
end

return;