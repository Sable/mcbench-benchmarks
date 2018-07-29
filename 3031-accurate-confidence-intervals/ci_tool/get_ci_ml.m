% THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION IS RELEASED "AS IS."  THE U.S. GOVERNMENT MAKES NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, CONCERNING THIS SOFTWARE AND ANY ACCOMPANYING DOCUMENTATION, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT WILL THE U.S. GOVERNMENT BE LIABLE FOR ANY DAMAGES, INCLUDING ANY LOST PROFITS, LOST SAVINGS OR OTHER INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE, OR INABILITY TO USE, THIS SOFTWARE OR ANY ACCOMPANYING DOCUMENTATION, EVEN IF INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.
%
% file: get_ci_ml.m
% computes confidence interval
%  - assumes x is the number of successes in n Bernoulli trials
%  - finds confidence interval around the estimate for p
%  - with confidence level 1 - alpha
%  - method used is based on integrating f(p|x)
%  - finds an interval of minimal length
%
% 010312 tdr created from get_ci_nibp

function ci = get_ci_ml(x,n,alpha)

if nargin < 3, error('Requires three input arguments (x,n,alpha)'); end;

p_hat=x/n;

if ( p_hat == 0 | p_hat == 1)
    ci = interval_est_p(x,n,alpha,'cs1'); % min length is same a "symmetric" when it bumps up against zero or one.
    return;
end;

% the following assumes that 0 < p_hat < 1

y_too_small = 0;
y_too_big = binopdf_01ok(x,n,p_hat);
y_guess = (y_too_small + y_too_big)/2;
continue_search = 1;

%close_enough = alpha/1000;
close_enough = 0.00001;
convergence_limit = 100;
convergence_count = 0;
hit_limit = 0;

p_ll = p_hat/2;
p_ul = (1 + p_hat)/2;

% start search
while (continue_search)
    convergence_count = convergence_count + 1;
    
    % find p lower limit: p_ll
        continue_p_search = 1;
        p_convergence_count = 0;
        hit_p_limit = 0;
        p_close_enough = 0;
        p_limit_too_small = 0; % 0 for ll, p_hat for ul
        p_limit_too_big = p_hat; % p_hat for ll, 1 for ul
        p_limit = (p_limit_too_big + p_limit_too_small) / 2;
        while (continue_p_search)
            p_convergence_count = p_convergence_count + 1;
            p_limit_y_guess = binopdf_01ok(x,n,p_limit);

            if (p_limit_y_guess > y_guess)
                p_limit_too_big = p_limit; % too_big for ll, too_small for ul
            else
                p_limit_too_small = p_limit; % too_small for ll, too_big for ul
            end;
            % stop or adjust p_ll_guess
            if (convergence_limit == p_convergence_count) hit_p_limit = 1; end;
            if ((p_limit_too_big - p_limit_too_small) < (close_enough / (10*n))) p_close_enough = 1; end; %see DNp2454.
            if (p_close_enough | hit_p_limit) 
                continue_p_search = 0; 
            else
                p_limit = (p_limit_too_big + p_limit_too_small) / 2;
            end;
        end;
        p_ll = p_limit; % ll or ul
        if hit_p_limit warning('method ''ml'' convergence limit reached for lower interval value.'); end;
        
    % find p upper limit: p_ul
        continue_p_search = 1;
        p_convergence_count = 0;
        hit_p_limit = 0;
        p_close_enough = 0;
        p_limit_too_small = p_hat; % 0 for ll, p_hat for ul
        p_limit_too_big = 1; % p_hat for ll, 1 for ul
        p_limit = (p_limit_too_big + p_limit_too_small) / 2;
        while (continue_p_search)
            p_convergence_count = p_convergence_count + 1;
            p_limit_y_guess = binopdf_01ok(x,n,p_limit);

            if (p_limit_y_guess > y_guess)
                p_limit_too_small = p_limit; % too_big for ll, too_small for ul
            else
                p_limit_too_big = p_limit; % too_small for ll, too_big for ul
            end;
            % stop or adjust p_ul_guess
            if (convergence_limit == p_convergence_count) hit_p_limit = 1; end;
            if ((p_limit_too_big - p_limit_too_small) < (close_enough / (10*n))) p_close_enough = 1; end; 
            if (p_close_enough | hit_p_limit) 
                continue_p_search = 0; 
            else
                p_limit = (p_limit_too_big + p_limit_too_small) / 2;
            end;
        end;
        p_ul = p_limit; % ll or ul
        if hit_p_limit warning('method ''ml'' convergence limit reached for upper interval value.'); end;
        

    alpha_guess = (n+1)*(integrate_binopdf(x,n,0,p_ll) + integrate_binopdf(x,n,p_ul,1));


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

ci=[p_hat p_ll p_ul];

return;
