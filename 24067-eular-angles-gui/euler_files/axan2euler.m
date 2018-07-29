function an=axan2euler(gamma,delta,alpha)
% from axis angle (gamma,delta,alpha) to Euler angles (phi,theta,psi)

% alpha

if alpha~=0 % if rotation exist

    sg=sin(gamma);
    cg=cos(gamma);

    sd=sin(delta);
    cd=cos(delta);

    sa=sin(alpha);
    ca=cos(alpha);

    pd=sd*cg*(1-ca)-sa*sg; % numerator in psi formula

    psi=atan2(pd,sd*sg*(1-ca)+sa*cg);
    %phi=atan2(sd*cg*(1-ca)+sg*ca,cg*sa-sg*sd+sd*sg*ca); - error in axis_angle_to_euler_angles_2.doc
    phi=atan2(sd*cg*(1-ca)+sg*sa,cg*sa-sg*sd+sd*sg*ca);

    cpp=cos(phi+psi);

    %theta=acos((1+2*ca-cpp)/(cpp+1));
    theta=acos(sd^2+cd^2*ca);
    if xor(pd>0,sin(psi)>0)
        theta=-theta;
    end

    [x,y,z] = sph2cart(gamma,delta,1);

%     [phi,theta,psi]

    an={{phi,theta,psi},[x,y,z]'};
    %an=[phi,theta,psi];
    
else
    [x,y,z] = sph2cart(gamma,delta,1);
    an={{0,0,0},[x,y,z]'};
%     [0,0,0]
end