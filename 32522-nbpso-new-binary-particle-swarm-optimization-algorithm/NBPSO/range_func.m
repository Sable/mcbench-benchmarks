function [v_max,x_max,velocity] = range_func(Num_func,N,D)
switch Num_func
    case 1
        x_max = 100 ;
        % x_min=-x_max  (here)
    case 2
        x_max = 10 ;
        % x_min=-x_max  (here)
    case 3
        x_max = 100 ;
        % x_min=-x_max  (here)
    case 4
        x_max = 100 ;
        % x_min=-x_max  (here)
    case 5
        x_max = 30 ;
        % x_min=-x_max  (here)
end
    
v_max = 0.5 * x_max; % it can be tuned
velocity = -v_max + 2*v_max*rand(N,D);
return
