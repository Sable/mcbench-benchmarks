function [delta_x] = compute_step_size(Theta,i,y,M_angle)
% Anderson does not give much details about the computation of this step size so
% the following function is how I understood the technique. The obtained
% results are good so I believe this function works well.
tan_max_pos = 0;
tan_max_neg = 0;
for j = 1:401,  % We need to find the maximum value of both tangents, so we need to compute them in the whole vertical line
    tan_pos = abs(tan(Theta+M_angle(j,i)));
    tan_neg = abs(tan(Theta-M_angle(j,i)));
    if (tan_pos > tan_max_pos)
        tan_max_pos = tan_pos;
    end
    if (tan_neg > tan_max_neg)
        tan_max_neg = tan_neg;
    end
end
tan_max = max(tan_max_pos,tan_max_neg);
delta_y = y(2,i) - y(1,i);  % delta_y is constant along the same vertical line (i). 
% The grid transformation geometry imposes this. So it doesnt' matter to
% compute delta_y using y in 2,1 or using it in 21,20 for example, the
% result will be the same.
delta_x = 0.5*(delta_y/tan_max); % Where 0.5 is the Courant number
end