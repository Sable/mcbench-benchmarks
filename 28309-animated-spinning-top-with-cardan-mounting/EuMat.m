function [ ret_mat ] = EuMat( phi, theta, psi )
%EUMAT returns a rotation matrix rotating an object by the Cardan angles 
%(phi, theta, psi)

    Dphi = [cos(phi),-sin(phi),0;sin(phi),cos(phi),0;0,0,1];
    Dtheta = [1,0,0;0,cos(theta),-sin(theta);0,sin(theta), cos(theta)];
    Dpsi = [cos(psi),-sin(psi),0;sin(psi),cos(psi),0;0,0,1];

    ret_mat = Dphi*Dtheta*Dpsi;