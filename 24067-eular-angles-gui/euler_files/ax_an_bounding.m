function an=ax_an_bounding(gamma,delta,alpha)
% bounding of axis-angle angles
% -pi/2<=gamma<2*pi
% -pi/2<=delta<2*pi
% -pi<=alpha<pi

ifchange=false; % if anles come out from boundaries



if ((-pi/2)<=gamma)&&(gamma<(pi/2))

else
    ifchange=true;
end

if ((-pi/2)<=delta)&&(delta<(pi/2))
   
else
    ifchange=true;
end

gamma=-(mod(gamma*(-1)+pi,2*pi)-pi);
delta=-(mod(delta*(-1)+pi,2*pi)-pi);

if ((-pi/2)<gamma)&&(gamma<=(pi/2))
    g=true;
else
    
    g=false;
end

if ((-pi/2)<delta)&&(delta<=(pi/2))
    d=true;
else
    
    d=false;
end




if ifchange
    [x,y,z] = sph2cart(gamma,delta,1);
    if xor(g,d)
        x=-x;
        y=-y;
        z=-z;
        alpha=-alpha;
    end
    [gamma,delta,tmp] = cart2sph(x,y,z);
end

if ((-pi)<=alpha)&&(alpha<(pi))
    
else
    ifchange=true;
    alpha=-(mod(alpha*(-1)+pi,2*pi)-pi); % -pi<alpha<=pi
end

an=[ifchange gamma delta alpha];
    