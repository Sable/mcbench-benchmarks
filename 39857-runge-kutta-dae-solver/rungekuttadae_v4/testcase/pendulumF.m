function [ f ] = pendulumF( y )
%pendulumf Pendulum equations.

    g = 1;
    m = 1;
    l = 1;
    
    f(1,1) = y(3,:);
    f(2,1) = y(4,:);
    f(3,1) = -y(1,:).*y(5,:)/m;
    f(4,1) = (-y(2,:).*y(5,:)-g)/m;
    f(5,1) = y(1,:).*y(3,:) + y(2,:).*y(4,:);

end

