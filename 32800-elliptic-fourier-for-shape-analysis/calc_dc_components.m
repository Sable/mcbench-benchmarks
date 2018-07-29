function [A0, C0] = calc_dc_components(ai)

% Calculate DC components.
% A0 and C0 are bias coefficeis, corresponding to a frequency of zero.

    %% Maximum length of chain code
    k = size(ai, 2);
    
    %% Traversal time and distance
    t = calc_traversal_time(ai);
    s = calc_traversal_dist(ai);
    
    %% Basic period of the chain code
    T = t(k);
    
    %% DC Components: A0, C0
    sum_a0 = 0;
    sum_c0 = 0;
    
    for p = 1 : k     

        delta_d = calc_traversal_dist(ai(p));
        delta_x = delta_d(:,1);

        delta_y = delta_d(:,2);
        delta_t = calc_traversal_time(ai(p));

        if (p > 2)       
                zeta = s(p - 1, 1) - delta_x / delta_t * t(p - 1);
                delta = s(p - 1, 2) - delta_y / delta_t * t(p - 1);
        else
                zeta = 0;
                delta = 0;
        end

        if (p > 2)
            sum_a0 = sum_a0 + delta_x / (2 * delta_t) * ((t(p))^2 - (t(p - 1))^2) + zeta * (t(p) - t(p-1));
            sum_c0 = sum_c0 + delta_y / (2 * delta_t) * ((t(p))^2 - (t(p - 1))^2) + delta * (t(p) - t(p-1));
        else
            sum_a0 = sum_a0 + delta_x / (2 * delta_t) * (t(p))^2 + zeta * t(p);
            sum_c0 = sum_c0 + delta_y / (2 * delta_t) * (t(p))^2 + delta * t(p);
        end
          
    end
    
    %% Assign  to output
    A0 = sum_a0 / T;
    C0 = sum_c0 / T;
end
