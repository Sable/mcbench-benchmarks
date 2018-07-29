function plot_fourier_approx(ai, n, m, normalized, color, line_width)

% This function will plot the fourier approximation, given a chain code (ai), 
% number of harmonic elements (n), and number of points for reconstruction (m). 
% Normalization can be applied by setting "normalized = 1".

    if (nargin < 5)
        color = 'b';
        line_width = 2;
    end
    
    if (nargin < 6)
        line_width = 2;
    end

    % Do Fourier approximatoin
    k = size(ai, 2);
    x_ = fourier_approx(ai, n, m, normalized);

    % Make it closed contour
    x = [x_; x_(1,1) x_(1,2)];
             
    plot(x(:,1), x(:,2), color, 'linewidth', line_width);

end
