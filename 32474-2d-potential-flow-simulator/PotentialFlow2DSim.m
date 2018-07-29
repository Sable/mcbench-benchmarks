function [u,v,un,vn,V]=PotentialFlow2DSim(elmnflow,x,y)

%--------------------------------------------------------------------------
%PotentialFlow2DSim
%Version 1.10
%Created by Stepen (zerocross_raptor@yahoo.com)
%Created 24 November 2010
%Last modofied 3 August 2011
%--------------------------------------------------------------------------
%PotentialFlow2DSim generates the velocity field of a potential flow
%(irrotational, inviscid, and incompressible) from the superposition of
%the given potential elementary flow such as uniform flow, source, sink,
%doublets, and vortex.
%--------------------------------------------------------------------------
%Syntax:
%[u,v,un,vn,V]=PotentialFlow2DSim(elmnflow,x,y)
%Input argument:
%- elmnflow (i x 5 num) specifies the elementary potential flow that
%  contribute to the flow. Each row of elmnflow array specifies one
%  elementary flow. The first column specifies elementary flow's type,
%  where 1 for uniform flow, 2 for source/sinks, 3 for doublets, and 4 for
%  vortex. 
%     For uniform flow, the second and third column specifies the uniform
%     velocity on x and y axis direction. The fourth column is not used but
%     must be assigned to an arbitrary number for array completion.
%     For other flow, the second and third column specifies the x and y
%     axis location of elementary flow center and the fourth column
%     specifies its strength.
%     For doublet flow, the fifth column specifies the rotation of doublet.
%- x (m x n num) specifies the x axis location for velocity vector
%  evaluation.
%- y (m x n num) specifies the y axis location for velocity vector
%  evaluation.
%Output argument
%- u (m x n num) specifies the horizontal velocity component at the
%  corresponding location.
%- v (m x n num) specifies the vertical velocity component at the
%  corresponding location.
%- un (m x n num) specifies the normalized horizontal velocity component of
%  the corresponding location. un output was generated for plotting
%  purpose. Use this output instead of u for velocity quiver plotting.
%- vn (m x n num) specifies the normalized vertical velocity component of
%  the corresponding location. vn output was generated for plotting
%  purpose. Use this output instead of v for velocity quiver plotting.
%- V (m x n num) specifies the total velocity magnitude of the
%  corresponding loation.
%--------------------------------------------------------------------------
%Example:
%[x,y]=meshgrid(-1:0.1:1,-1:0.1:1);
%[u,v,un,vn,V]=PotentialFlow2DSim([1,1,0,0;3,0,0,-10],x,y);
%   generates a combination of uniform flow with doublet centered at 0,0
%   which forms a 2D flow around cylinder. The resulting flow field can be
%   displayed by plotting the normalized vector using quiver(x,y,un,vn)
%   command.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Checking input elmnflow
    size_elmnflow=size(elmnflow);
    if numel(size_elmnflow)~=2
        error('Elementary flow array must have size of i x 5!')
    end
    if size_elmnflow(2)~=5
        error('Elementary flow array must have size of i x 5!')
    end
%Checking input x and y
    size_x=size(x);
    dim_x=numel(size_x);
    size_y=size(y);
    dim_y=numel(size_y);
    if dim_x~=2
        error('Input x must be a 2D array!')
    end
    if dim_y~=2
        error('Input y must be a 2D array!')
    end
    if (size_x(1)~=size_y(1))||(size_x(2)~=size_y(2))
        error('Input x and y do not have the same size!')
    end
%Preallocating array for speed
    u=zeros(size_x);
    v=zeros(size_x);
    un=zeros(size_x);
    vn=zeros(size_x);
    V=zeros(size_x);
%Calculating velocity vector from all elementary flow
    for i=1:1:size_x(1)
        for j=1:1:size_x(2)
            for k=1:1:size_elmnflow(1)
                if elmnflow(k,1)==1
                    utemp=elmnflow(k,2);
                    vtemp=elmnflow(k,3);
                else
                    xc=elmnflow(k,2);
                    yc=elmnflow(k,3);
                    sc=elmnflow(k,4);
                    r=elmnflow(k,5);
                    if elmnflow(k,1)==2
                        [utemp,vtemp]=CalculateVelocityFromSource2D...
                                      (sc,xc,yc,x(i,j),y(i,j));
                    elseif elmnflow(k,1)==3
                        [utemp,vtemp]=CalculateVelocityFromDoublet2D...
                                      (sc,xc,yc,x(i,j),y(i,j),r);
                    elseif elmnflow(k,1)==4
                        [utemp,vtemp]=CalculateVelocityFromVortex2D...
                                      (sc,xc,yc,x(i,j),y(i,j));
                    end
                end
                u(i,j)=u(i,j)+utemp;
                v(i,j)=v(i,j)+vtemp;
                clear utemp
                clear vtemp
                clear xc yc sc r
            end
        end
    end
%Calculating normalized vector
    for i=1:1:size_x(1)
        for j=1:1:size_x(2)
            V(i,j)=norm([u(i,j),v(i,j)]);
            un(i,j)=u(i,j)/V(i,j);
            vn(i,j)=v(i,j)/V(i,j);
        end
    end
%CodeEnd-------------------------------------------------------------------

end