% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_r_ci_ml.m
% computes confidence interval for a rate estimate using the normal approximation
%  - assumes x is the number of occurrances of an event in area A
%  - finds confidence interval around the estimate for rate R
%  - with confidence level 1 - alpha
%  - method used is based on integrating the Bayesian posterior
%  - finds a symmetrical two-sided interval, unless one side
%    would cross zero or one, in which case the interval is 
%    offset.
%
% This relies upon user routines when using numerical integration method (not recommended):
%  - integrate_poisspdf.m
%  - poisspdf_of_p.m
%  - poisspdf_0ok.m
% and the Stats toolbox (poisspdf.m)
%
% 010315 tdr created from get_r_ci_ibp.m and get_ci_ml.m

function ci = get_r_ci_ml(x,A,alpha)

if nargin < 3, 
    error('Requires three input arguments (x,A,alpha)');
end

lambda_hat = x;

if ( x == 0)
    ci = interval_est_r(x,A,alpha,'cs1'); % min length is same a "symmetric" when it bumps up against zero.
    return;
end;

% the following assumes that x > 0.

y_too_small = 0;
y_too_big = poisspdf_0ok(x,x);
y_guess = (y_too_small + y_too_big)/2;
continue_search = 1;

%close_enough = alpha/1000;
close_enough = 0.00001;
convergence_limit = 100;
convergence_count = 0;
hit_limit = 0;

lambda_ll = lambda_hat/2;
lambda_ul = (1 + lambda_hat)/2;
lambda_max = max(1000, 100*lambda_hat);

while (continue_search)
    convergence_count = convergence_count + 1;
    
    % find lambda lower limit: lambda_ll
        continue_lambda_search = 1;
        lambda_convergence_count = 0;
        hit_lambda_limit = 0;
        lambda_close_enough = 0;
        lambda_limit_too_small = 0; % 0 for ll, lambda_hat for ul
        lambda_limit_too_big = lambda_hat; % lambda_hat for ll, lambda_max for ul
        lambda_limit = (lambda_limit_too_big + lambda_limit_too_small) / 2;
        while (continue_lambda_search)
            lambda_convergence_count = lambda_convergence_count + 1;
            lambda_limit_y_guess = poisspdf_0ok(x,lambda_limit);

            if (lambda_limit_y_guess > y_guess)
                lambda_limit_too_big = lambda_limit; % too_big for ll, too_small for ul
            else
                lambda_limit_too_small = lambda_limit; % too_small for ll, too_big for ul
            end;
            % stop or adjust lambda_ll_guess
            if (convergence_limit == lambda_convergence_count) hit_lambda_limit = 1; end;
            if ((lambda_limit_too_big - lambda_limit_too_small) < (close_enough / 10)) lambda_close_enough = 1; end; %see DNp2454.
            if (lambda_close_enough | hit_lambda_limit) 
                continue_lambda_search = 0; 
            else
                lambda_limit = (lambda_limit_too_big + lambda_limit_too_small) / 2;
            end;
        end;
        lambda_ll = lambda_limit; % ll or ul
        if hit_lambda_limit warning('method ''ml'' convergence limit reached for lower interval value.'); end;
        
    % find lambda upper limit: lambda_ul
        continue_lambda_search = 1;
        lambda_convergence_count = 0;
        hit_lambda_limit = 0;
        lambda_close_enough = 0;
        lambda_limit_too_small = lambda_hat; % 0 for ll, lambda_hat for ul
        lambda_limit_too_big = lambda_max; % lambda_hat for ll, lambda_max for ul
        lambda_limit = (lambda_limit_too_big + lambda_limit_too_small) / 2;
        while (continue_lambda_search)
            lambda_convergence_count = lambda_convergence_count + 1;
            lambda_limit_y_guess = poisspdf_0ok(x,lambda_limit);

            if (lambda_limit_y_guess > y_guess)
                lambda_limit_too_small = lambda_limit; % too_big for ll, too_small for ul
            else
                lambda_limit_too_big = lambda_limit; % too_small for ll, too_big for ul
            end;
            % stop or adjust lambda_ul_guess
            if (convergence_limit == lambda_convergence_count) hit_lambda_limit = 1; end;
            if ((lambda_limit_too_big - lambda_limit_too_small) < (close_enough / 10)) lambda_close_enough = 1; end; %see DNp2454.
            if (lambda_close_enough | hit_lambda_limit) 
                continue_lambda_search = 0; 
            else
                lambda_limit = (lambda_limit_too_big + lambda_limit_too_small) / 2;
            end;
        end;
        lambda_ul = lambda_limit; % ll or ul
        if hit_lambda_limit warning('method ''ml'' convergence limit reached for upper interval value.'); end;
        
    alpha_guess = integrate_poisspdf(x,0,lambda_ll) + integrate_poisspdf(x,lambda_ul,lambda_max);

    % adjust y_too_small, y_too_big
    if (alpha_guess > alpha)
        y_too_big = y_guess;
    else
        y_too_small = y_guess;
    end;
    
    % stop or compute new y_guess
    delta_alpha = abs(alpha - alpha_guess);
    if (convergence_count == convergence_limit) hit_limit = 1; end;
    if ((delta_alpha <= close_enough) | hit_limit) 
        continue_search = 0;
    else
        y_guess = (y_too_big + y_too_small)/2;
    end;
end;

if hit_limit warning('method ''ml'' convergence limit reached - results may not be accurate.'); end;

ci=[x/A lambda_ll/A lambda_ul/A];

return;
