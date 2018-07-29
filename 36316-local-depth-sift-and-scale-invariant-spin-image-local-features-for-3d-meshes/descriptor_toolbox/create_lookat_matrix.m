function [ out ] = create_lookat_matrix( eyevec, center, up )

    zaxis = center - eyevec;
    zaxis = zaxis / norm(zaxis);
    
    xaxis = cross(up, zaxis);
    xaxis = xaxis / norm(xaxis);
    
    yaxis = cross(zaxis, xaxis);
    temp1 = eye(4,4);
    
    temp1(1:3,1) = xaxis;
    temp1(1:3,2) = yaxis;
    temp1(1:3,3) = zaxis;
    
    temp2 = eye(4,4);
    
    temp2(4,1:3) = -eyevec;
    
    out = (temp2 * temp1)';
end