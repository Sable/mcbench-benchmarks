function vectline(f,crdaxis,crdrange)
% vectline "vector field line plotter"
% Depending on the dimension of coordinate axis, vectline can plot both 3D
% and 2D vector field line.
%
% Examples:
% >> syms x y
% >> F = [-y, x];
% >> vectline(F,[x,y],[-1,1,-1,1])
%
% or for 3D field
%
% >> syms x y z
% >> F = [x*y^2, x*y, z];
% >> vectline(F,[x,y,z],[-1,1,-2,3,1,3])
%
if max(size(crdaxis))==3
    if max(size(crdrange))==6

        xmin=crdrange(1);
        xmax=crdrange(2);
        ymin=crdrange(3);
        ymax=crdrange(4);
        zmin=crdrange(5);
        zmax=crdrange(6);

        dx=(xmax-xmin)/5;
        dy=(ymax-ymin)/5;
        dz=(zmax-zmin)/5;

        [px,py,pz]=meshgrid(xmin:dx:xmax,ymin:dy:ymax,zmin:dz:zmax);
        junk=subs(f,{crdaxis(1),crdaxis(2),crdaxis(3)},{px,py,pz});

        junksize=size(junk);
        k=junksize(2);

        u=junk(:,1:k/3,:);
        v=junk(:,k/3+1:2*k/3,:);
        w=junk(:,2*k/3+1:k,:);

        quiver3(px,py,pz,u,v,w)
    else
        error('the size of the dimension does not match the range you specified')

    end

elseif max(size(crdaxis))==2
    if max(size(crdrange))==4

        xmin=crdrange(1);
        xmax=crdrange(2);
        ymin=crdrange(3);
        ymax=crdrange(4);

        dx=(xmax-xmin)/5;
        dy=(ymax-ymin)/5;

        [px,py]=meshgrid(xmin:dx:xmax,ymin:dy:ymax);
        junk=subs(f,{crdaxis(1),crdaxis(2)},{px,py});

        junksize=size(junk);
        k=junksize(2);

        u=junk(:,1:k/2);
        v=junk(:,k/2+1:k);

        quiver(px,py,u,v);

    else
        error('the size of the dimension does not match the range you specified')
    end

else
    error('vector field with more than 3 dimensions can not be plotted')
end
