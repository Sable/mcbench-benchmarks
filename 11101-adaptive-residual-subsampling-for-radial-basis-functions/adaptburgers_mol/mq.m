function [phi,phi1,phi2,phi3,phi4] = mq(x,xc,c)
% 1-D multiquadric radial basis function
f = @(r,c) sqrt((c*r).^2 + 1);

r = x - xc;
phi = f(r,c);

if nargout > 1
% 1-st derivative    
phi1 = (c^2)*r./phi;
    if nargout > 2
    % 2-nd derivative
    phi2 = (c^2)./(phi.^3);
        if nargout > 3
        % 3-rd derivative    
        phi3 = -3*(c^4)*r./(phi.^5);
            if nargout > 4
            % 4-th derivative        
            phi4 = 12*(c^4)*((c*r).^2-0.25)./(phi.^7);
            end
        end
    end
end