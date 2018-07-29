function output = calc_traversal_dist(ai)

% This function will generate position coordinates of chain code (ai). Number of 
% harmonic elements (n), and number of points for reconstruction (m) must be 
% specified.  

    x_ = 0;
    y_ = 0;
    
    for i = 1 : size(ai, 2)        
        x_ = x_ + sign(6 - ai(i)) * sign(2 - ai(i));
        y_ = y_ + sign(4 - ai(i)) * sign(ai(i));
        p(i, 1) = x_;
        p(i, 2) = y_;
    end
    
    output = p;
    
end
