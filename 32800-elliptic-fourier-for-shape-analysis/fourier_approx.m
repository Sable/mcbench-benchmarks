function output = fourier_approx(ai, n, m, normalized)

% This function will generate position coordinates of fourier approximation of 
% chain code (ai).Number of harmonic elements (n), and number of points for 
% reconstruction (m) must be specified.

    for i = 1 : n
        harmonic_coeff = calc_harmonic_coefficients(ai, i);
        a(i) = harmonic_coeff(1, 1);
        b(i) = harmonic_coeff(1, 2);
        c(i) = harmonic_coeff(1, 3);
        d(i) = harmonic_coeff(1, 4);
    end

    [A0, C0] = calc_dc_components(ai);

    % Normalization procedure
    if (normalized == 1)   
        % Remove DC components
        A0 = 0;
        C0 = 0;
        
        % Compute theta1
        theta1 = 0.5 * atan(2 * (a(1) * b(1) + c(1) * d(1)) / ...
             	 (a(1)^2 + c(1)^2 - b(1)^2 - d(1)^2));
       
        costh1 = cos(theta1);
        sinth1 = sin(theta1);
             	 
        a_star_1 = costh1 * a(1) + sinth1 * b(1);
        b_star_1 = -sinth1 * a(1) + costh1 * b(1);
        c_star_1 = costh1 * c(1) + sinth1 * d(1);
        d_star_1 = -sinth1 * c(1) + costh1 * d(1);
       
        % Compute psi1 
        psi1 = atan(c_star_1 / a_star_1) ;
        
        % Compute E
        E = sqrt(a_star_1^2 + c_star_1^2);
        
        cospsi1 = cos(psi1);
        sinpsi1 = sin(psi1);
        
        for (i = 1 : n)
            normalized = [cospsi1 sinpsi1; -sinpsi1 cospsi1] * [a(i) b(i); c(i) d(i)] * ... 
                        [cos(theta1 * i) -sin(theta1 * i); sin(theta1 * i) cos(theta1 * i)];

                         
            a(i) = normalized(1,1) / E;
            b(i) = normalized(1,2) / E;
            c(i) = normalized(2,1) / E;
            d(i) = normalized(2,2) / E;
        end
        
    end  % end if normalized
       
    for t = 1 : m
        x_ = 0.0;
        y_ = 0.0;
        
        for i = 1 : n
            x_ = x_ + (a(i) * cos(2 * i * pi * t / m) + b(i) * sin(2 * i * pi * t / m));
            y_ = y_ + (c(i) * cos(2 * i * pi * t / m) + d(i) * sin(2 * i * pi * t / m));
        end
        
        output(t,1) = A0 + x_;
        output(t,2) = C0 + y_;
    end

end





