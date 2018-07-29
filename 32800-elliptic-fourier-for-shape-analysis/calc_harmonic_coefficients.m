function output = calc_harmonic_coefficients(ai, n)

% This function will calculate the n-th set of four harmonic coefficients.
% The output is [an bn cn dn]

    %% Maximum length of chain code
    k = size(ai, 2);
    
    %% Traversal time
    t = calc_traversal_time(ai);
        
    %% Basic period of the chain code
    T = t(k);
    
    %% Store this value to make computation faster
    two_n_pi = 2 * n * pi;
    
    %% Compute Harmonic cofficients: an, bn, cn, dn
    sigma_a = 0;
    sigma_b = 0;
    sigma_c = 0;
    sigma_d = 0;
        
    for p = 1 : k
        if (p > 2)
            tp_prev = t(p - 1);            
        else
            tp_prev = 0;
        end
        
        delta_d = calc_traversal_dist(ai(p));
        delta_x = delta_d(:,1);
        delta_y = delta_d(:,2);
        delta_t = calc_traversal_time(ai(p));
        
        q_x = delta_x / delta_t;
        q_y = delta_y / delta_t;
        
        sigma_a = sigma_a + q_x * (cos(two_n_pi * t(p) / T) - cos(two_n_pi * tp_prev / T));
        sigma_b = sigma_b + q_x * (sin(two_n_pi * t(p) / T) - sin(two_n_pi * tp_prev / T));
        sigma_c = sigma_c + q_y * (cos(two_n_pi * t(p) / T) - cos(two_n_pi * tp_prev / T));
        sigma_d = sigma_d + q_y * (sin(two_n_pi * t(p) / T) - sin(two_n_pi * tp_prev / T));   
    end
    
    r = T/(2*n^2*pi^2);
    
    a = r * sigma_a;
    b = r * sigma_b;
    c = r * sigma_c;
    d = r * sigma_d;
    
    %% Assign  to output
    output = [a b c d];
    
end
