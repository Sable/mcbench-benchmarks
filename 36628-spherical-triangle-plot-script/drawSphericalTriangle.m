%
%                    drawSphericalTriangle
%
% Draws a spherical triangle on a unit sphere, given its coordinates. This
% script cat draw all 8 possible spherical triangles: regular, notch, fish,
% star and their respective inverses.
%
% Usage:
% drawSphericalTriangle(P1,P2,P3);
% drawSphericalTriangle(P1,P2,P3,'Option1',value1);
% drawSphericalTriangle(P1,P2,P3,'Option1',value1,'Option2',value2);
%
% Rule on default behaviour: hatched area is equal to the area enclosed by
% as many large rotation angles as large great circle segments. In case of
% the notch (one large great circle segment) this automatically results in
% the smallest area.
%
% Output:
% fig       figure handle
% sh        surface handle sh(1) for sphere sh(2) for patch
% lh        line handles for the tree great circle segments
% st        spherical triangle structure, containing each line and
%           coordinates in Cartesian
% Note that any arbitary number of outputs can be requested request, like
% three: [a,b,c] =...  or one: [a] = ..., in which case as many of the
% above outputs are returned.
%
% Options           Value(s)    Notes
% -------           --------    -----
% FigureHandle      fig         Plots inside a user-supplied figure
% Spherical         true/false* Set to true if input is in spherical
%                               coordinates
% Degrees           true*/false Set to false if input is in radians, has no
%                               effect if coordinates are not spherical.
% Outer             [0 0 1]     Means the arc opposite of P3 is outer arc
%                   [1 1 1]     All outer
%                   [0 0 0]*    All inner
% Inverse           true/false* Take the inner or outer Area, see the rule
%                               on default behaviour for more info
% GridPoints        int         Number of gridpoints on sphere and great
%                               circle arcs. Choose wisely :). Default: 20
% * default setting
%
% Version: 1.0
%
% Changelog:
% Date           Author         Change
% ------------  -------------- --------------------------------------------
% May 09, 2012  Jacco Geul     Covers all 8 cases.
function varargout = drawSphericalTriangle(P1,P2,P3,varargin)
    %some defaults
    fig = []; inputsc = false; inputdeg = true; outer = [0 0 0]; inverse = false;
    n = 20;
    % go through the varargin and change settings accordingly
    if mod(length(varargin),2)
        error('Function must be called with property/value pairs');
    end
    for k=1:2:length(varargin)
        if strcmp(varargin{k},'FigureHandle')
            fig=varargin{k+1};
        elseif strcmp(varargin{k},'Spherical')
            inputsc=varargin{k+1};
        elseif strcmp(varargin{k},'Degrees') || strcmp(varargin{k},'DegreesIn')
            inputdeg=varargin{k+1};
        elseif strcmp(varargin{k},'Radians') || strcmp(varargin{k},'RadiansIn')
            inputdeg=not(varargin{k+1});
        elseif strcmp(varargin{k},'Outer')
            outer=varargin{k+1};   
        elseif strcmp(varargin{k},'Inverse')
            inverse=varargin{k+1};  
        elseif strcmp(varargin{k},'GridPoints')
            n=varargin{k+1};
        end
    end
    m=n*4;
    % if no figure handle is supplied start one
    if isempty(fig)
        fig = figure;
        hold on;
    % else focus on supplied handle
    else
        figure(fig);
    end
    st.p(1).cc = P1;
    st.p(2).cc = P2;
    st.p(3).cc = P3;
    clear P1 P2 P3;
    
    % make sure input is converted to cartesian vectors
    if inputsc
        if inputdeg
            for i=1:3
                st.p(i).cc = deg2rad(st.p(i).cc);
            end
        end
        for i=1:3
            if length(st.p(i).cc)==2
                [x,y,z] = sph2cart(st.p(i).cc(1),st.p(i).cc(2),1);
            elseif length(st.p(i).cc)==3
                [x,y,z] = sph2cart(st.p(i).cc(2),st.p(i).cc(3),st.p(i).cc(1));
            else
                error('Wrong dimension of input, supply either 3 spherical coordinates or 2 if only long/lat in case of unit-sphere.')
            end
            st.p(i).cc = [x y z];
        end
    end

    %Draw unit sphere
    [X,Y,Z]=sphere(n);
    sh(1)=surf(X,Y,Z,ones(n+1,n+1,3)*(0.7+0.3*~inverse));
    grid on;
    
    % Settings on which patches to join for a certain type of Spherical
    % triangle, can be changed, but will cause wrong hatching (probably).
    %          |->   segment       <-||->       offset      <-||-> I/O <-|                 
    tricase(:,:) =     [0        0       0       0        0       0      1   1   1;...
                        0        0       0       0        0       0      0   0   1;...
                        0        0       pi     -pi/4     pi/4   -pi/4   1   1   1;...
                        4*pi     0       0       0        0       0      1   1   1];
 
    %Calculate point-cloud for hatched spherical triangle
    patchmat = zeros(m,n,3);
    cot = zeros(size(st.p(1).cc));
    k = 0;
    for j=1:3
        a = [j,rem(j,3)+1,rem(j+1,3)+1];
        st.ad(j).pos = lineBetweenTwoPoints(st.p(a(1)).cc, st.p(a(2)).cc, m,'Outer',outer(a(3)));
        segment = sum(tricase(sum(outer)+1,1:3).*outer(a));
        offset  = sum(tricase(sum(outer)+1,4:6).*outer(a));
        P_i = lineBetweenTwoPoints(st.p(a(1)).cc, st.p(a(2)).cc, m,'Outer',outer(a(3)),'Segment',segment,'Offset',offset);
        if sum(tricase(sum(outer)+1,7:9).*outer(a)) || sum(tricase(sum(outer)+1,7:9))==3
            for i=1:m
                cheatfactor = 1; % create a patch that is slightly on top, 
                % prevents polygons from cutting trough eachother, but can 
                % cause complex (???) values for very small angles.
                patchmat(i,:,:) = lineBetweenTwoPoints(P_i(i,:)*cheatfactor, st.p(a(3)).cc*cheatfactor, n,'Outer',0);
            end
            sh(2+k) = surf(patchmat(:,:,1),patchmat(:,:,2),patchmat(:,:,3),'FaceColor',(0.7+0.3*inverse)*[1 1 1],'FaceAlpha',0.8,'EdgeColor','none','LineStyle','none');
            k =k +1;
        end
        cot = cot + st.p(a(1)).cc;
    end
    % plot the patch

    %Draw lines on shpere
    for j=1:3
        lh(j) = plot3(st.ad(j).pos(:,1),st.ad(j).pos(:,2),st.ad(j).pos(:,3),'Color',[0 0 0],'linewidth',2);
    end

    % turn camera to face patch
    view(cot/norm(cot));
    daspect([1 1 1])
    % some output processing
    nout = max(nargout,1);
    out = {fig,sh,lh,st};
    varargout = cell(nout,1);
    for k=1:nout
        if k>length(out)
            varargout(k) = {0};
        else
            varargout(k) = out(k);
        end
    end
end
% [X,Y,Z] = lineBetweenTwoPoints(P1, P2, n) returns the 3d coordinates of
% points on a great circle segment between two points. P1 and P2 are
% position vectors and n is the number of elements on the line.
%
% This function is based of work by Tom Davis as posted in the MathWork
% forums: http://www.mathworks.com/matlabcentral/newsreader/view_thread/38761
% Additional programming has been performed by yours truly.
%
% Usage:
% [X,Y,Z] = lineBetweenTwoPoints(P1, P2, n)
% matXYZ  = lineBetweenTwoPoints(P1, P2, n);
%
% Log:
% Date        Programmer     Change
% ----------- -------------- ----------------------------------------------
% May 8, 2012 Jacco Geul     Added outer angles
% May 5, 2012 Roy Bijster    Rewrote parts of the original code by Davis.
%
% Please, do not remove this when you use this code for your own work. 
function varargout = lineBetweenTwoPoints(P1, P2, n,varargin)
    % go through the varargin and change settings accordingly
    outer = false; segment = []; offset = 0;
    if mod(length(varargin),2)
        error('Function must be called with property/value pairs');
    end
    for k=1:2:length(varargin)
        if strcmp(varargin{k},'Outer')
            outer=varargin{k+1};
        elseif strcmp(varargin{k},'Segment')
            segment=varargin{k+1};
            if ~isempty(segment)
                if segment==0
                    segment=[];
                end
            end
        elseif strcmp(varargin{k},'Offset')
            offset=varargin{k+1};
        end
    end
    
    % Calculate normal, binormal, and tangent vectors at P1.
    N   =   P1; 
    BN  =   cross(P1,P2);
    T   =   cross(BN,N); 
    T =   T/norm(T);

    % Angle subtended on a great circle arc between the two points:
    if ~isempty(segment)
        theta = segment;
    else
        theta = acos(dot(P1,P2));
    end

    % Create an array of n angular steps between the two points
    if outer
        t = linspace(theta+offset,2*pi+offset,n)';
    else
        t = linspace(0+offset,theta+offset,n)';
    end
    

    % Create n repeated tiles of the Normal and Tangent vector along the first
    % dimension. 
    N   =   repmat(N,n,1);
    T   =   repmat(T,n,1);

    t   =   repmat(t,1,3);

    % Calculate the locations on a great circle arc
    garc =  N.*cos(t)+T.*sin(t);
    
    % some output processing
    nout = max(nargout,1);
    if nout == 3
        varargout = {garc(:,1),garc(:,2),garc(:,3)};
    elseif nout == 1
        varargout = {garc};
    else
        error('Too many output variables')
    end
end