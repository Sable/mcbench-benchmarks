function plot_chain_code(ai, color, line_width)

% Plot chain code with certain color and line width
% Chain code should be written in chain vector

    if (nargin < 2)
        color = 'b';
        line_width = 2;
    end
    
    if (nargin < 3)
        line_width = 2;
    end
    
    % Calculte traversl distance
    x_ = calc_traversal_dist(ai);
    
    % Starting point is assumed from [0 0]
    x = [0 0; x_];
    plot(x(:,1), x(:,2), color, 'linewidth',  line_width); 
    
end
