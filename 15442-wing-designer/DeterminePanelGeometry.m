function [panel, Vol] = DeterminePanelGeometry(inputgeo, figs)
% find coordinates for horseshoe vortices and control points and plot
% Aircraft-Fixed coordinate system:
%       x: forward along fuselage axis
%       y: out starboard wing
%       z: down
% Local Profile coordinate system:
%       x: along chord from leading edge toward trailing edge
%       z: up

plot_on = 1;

%% constants
halfSpan=inputgeo.b/2;     % half wingspan
sweep=inputgeo.sweep;       % wing sweep angle in radians
dihedral=inputgeo.dih;    %dihedral angle in radians
nc=inputgeo.nc;  %number of panels on camber line, upper and lower surfaces
ns = inputgeo.ns; % number of span segments per side
M = inputgeo.M;    %Freestream mach number
beta = sqrt(1-M^2); %Prandtl-Glauert correction


%% Root Airfoil data
y=0;            % span station
chord=inputgeo.c_r;        % chord length
alphaRoot=inputgeo.i_r;    % geometric angle of incidence at root in radians

% call function
[Croot,Troot,Aroot]=NacaCoord(inputgeo.root,y,nc); % Croot = nondimensional camber line, Troot = nondimensional surface;
%Croot coordinates = [x location in fraction chord, y location in fraction
%                       chord, z location in fraction chord]
%Troot coordinates = [x location in fraction chord, y location in fraction
%                       chord, z location in fraction chord]

%% Scale to chord length
Croot(:,1)=chord*Croot(:,1);Croot(:,3)=chord*Croot(:,3);
Troot(:,1)=chord*Troot(:,1);Troot(:,3)=chord*Troot(:,3);
Aroot=Aroot*chord^2;

%Calculate slope of camber line for each panel at the root
%Calculate the chord along each elemental panel
dzdxRoot = zeros(1,nc);
ccRoot = zeros(1,nc);
if nc == 1 %If there is only one chordwise element
    i=1;
    dzdxRoot(i)=-(Croot(i+1,3)-Croot(i,3))/(Croot(i+1,1)-Croot(i,1));
    ccRoot(i)=0.75*(Croot(i+1,1)-Croot(i,1));
else        %if there are more than one chordwise elements
    for i=1:nc
        dzdxRoot(i)=(Croot(i+1,3)-Croot(i,3))/(Croot(i+1,1)-Croot(i,1));
        if i==nc
            ccRoot(i)=0.75*(Croot(i+1,1)-Croot(i,1));
        else
            ccRoot(i)=0.75*(Croot(i+1,1)-Croot(i,1))+0.25*(Croot(i+2,1)-Croot(i+1,1));
        end
    end
end

if plot_on
    axes(figs.root); cla;
    plot(Croot(:,1)*-3.2808,Croot(:,3)*-3.2808,'r') %Convert to feet; plot with z-axis positive up and x-axis to the left
    hold on
    plot(Troot(:,1)*-3.2808,Troot(:,3)*-3.2808,'b')  %Convert to feet; plot with z-axis positive up and x-axis to the left
    axis equal
    title('Root airfoil')
end

%% Tip Airfoil data
y=-halfSpan;     % span station; left wing
chord=inputgeo.taper*inputgeo.c_r;        % chord length
alphaTip=inputgeo.i_r+inputgeo.twist;    % geometric angle of incidence at tip in radians

%call function
[Ctip,Ttip,Atip]=NacaCoord(inputgeo.tip,y,nc);

%% scale to chord length
Ctip(:,1)=chord*Ctip(:,1);Ctip(:,3)=chord*Ctip(:,3);
Ttip(:,1)=chord*Ttip(:,1);Ttip(:,3)=chord*Ttip(:,3);
Atip=Atip*chord^2;

%Calculate slope of camber line for each panel at the tip
%Calculate the chord along each elemental panel
dzdxTip = zeros(1,nc);
ccTip = zeros(1,nc);
if nc == 1 %If there is only one chordwise element
    dzdxTip(i)=-(Ctip(i+1,3)-Ctip(i,3))/(Ctip(i+1,1)-Ctip(i,1));
    ccTip(i)=0.75*(Ctip(i+1,1)-Ctip(i,1));
else        %if there are more than one chordwise elements
    for i=1:nc
        dzdxTip(i)=(Ctip(i+1,3)-Ctip(i,3))/(Ctip(i+1,1)-Ctip(i,1));
        if i==nc
            ccTip(i)=0.75*(Ctip(i+1,1)-Ctip(i,1));
        else
            ccTip(i)=0.75*(Ctip(i+1,1)-Ctip(i,1))+0.25*(Ctip(i+2,1)-Ctip(i+1,1));
        end
    end
end

if plot_on
    axes(figs.tip); cla;
    plot(Ctip(:,1)*-3.2808,Ctip(:,3)*-3.2808,'r') %Convert to feet; plot with z-axis positive up and x-axis to the left
    hold on
    plot(Ttip(:,1)*-3.2808,Ttip(:,3)*-3.2808,'b') %Convert to feet; plot with z-axis positive up and x-axis to the left
    axis equal
    title('Tip airfoil')
end

%% Root: Transform to Aircraft-Fixed Coordinate System:
% skin:
%Skin(number of spanwise sections, number of chordwise sections, coordinates in 3 dimensions (x,y,z))
Skin(1,1:2*nc+1,1:3) = Troot*[cos(alphaRoot) 0 sin(alphaRoot); 0 1 0; -sin(alphaRoot) 0 cos(alphaRoot)];

% Mean camber line:
Camber(1,1:nc+1,1:3) = Croot*[cos(alphaRoot) 0 sin(alphaRoot); 0 1 0; -sin(alphaRoot) 0 cos(alphaRoot)];

%% Tip: Transform to Aircraft-Fixed Coordinate System:
% sweep and dihedral
% Negative sign occurs because local axes are opposite to global
xLETip = -halfSpan*(tan(sweep));% x coordinate of Leading Edge at Tip
zLETip = -halfSpan*(tan(dihedral));% z coordinate of Leading Edge at Tip
% Skin:
LETip=ones(2*nc+1,1)*[xLETip 0 zLETip];
Skin(ns+1,1:2*nc+1,1:3) = Ttip*[cos(alphaTip) 0 sin(alphaTip); 0 1 0; -sin(alphaTip) 0 cos(alphaTip)]+LETip;

% Mean camber line
LETip=ones(nc+1,1)*[xLETip 0 zLETip];
Camber(ns+1,1:nc+1,1:3) = Ctip*[cos(alphaTip) 0 sin(alphaTip); 0 1 0; -sin(alphaTip) 0 cos(alphaTip)]+LETip;

%% Intermediate stations
for k=1:ns-1 % k = 0 corresponds to root, k = ns corresponds to tip
    eta=k/ns;
    for i=1:nc+1 % along camber
        Camber(k+1,i,:) = Camber(1,i,:)+eta*(Camber(ns+1,i,:)-Camber(1,i,:));
    end
    for i=1:2*nc+1 %along surface
        Skin(k+1,i,:) = Skin(1,i,:)+eta*(Skin(ns+1,i,:)-Skin(1,i,:));
    end
end

if plot_on
    %Plot wing surface
    axes(figs.fig); cla; hold on; axis equal; 
    for k=1:ns+1
        plot3(Skin(k,:,1)*-3.2808,Skin(k,:,2)*3.2808,Skin(k,:,3)*-3.2808);  %Convert to feet; plot with z-axis positive up and x-axis to the left
        plot3(Skin(k,:,1)*-3.2808,-Skin(k,:,2)*3.2808,Skin(k,:,3)*-3.2808);  %Convert to feet; plot with z-axis positive up and x-axis to the left
        plot3(Camber(k,:,1)*-3.2808,Camber(k,:,2)*3.2808,Camber(k,:,3)*-3.2808,'r')  %Convert to feet; plot with z-axis positive up and x-axis to the left
    end
    for i=1:size(Skin,2)
    plot3(Skin(:,i,1)*-3.2808,Skin(:,i,2)*3.2808,Skin(:,i,3)*-3.2808);
    plot3(Skin(:,i,1)*-3.2808,-Skin(:,i,2)*3.2808,Skin(:,i,3)*-3.2808);
    end
end


%Determine panel properties
twist = zeros(1,ns);
dzdx = zeros(ns,nc);
cc = zeros(ns,nc);
CP = zeros(ns,nc,3);
BV = zeros(ns,nc,3);
BV1 = zeros(ns,nc,3);
BV2 = zeros(ns,nc,3);
BVhalfspan = zeros(ns,nc);
sweep_c4 = zeros(ns,nc);

for k = 1:ns
    %Determine local twist at each panel, dz/dx at control points, and
    %chord along left trailing leg of elemental panel
    eta=k/(ns+1);
    twist(k)=alphaRoot+eta*(alphaTip-alphaRoot);
    dzdx(k,:)=dzdxRoot+eta*(dzdxTip-dzdxRoot);
    cc(k,:)=ccRoot+eta*(ccTip-ccRoot);  %Validated
    %Determine control point coordinates, coordinates to center of bound
    %vortex, half span of bound vortex, and quarter-chord sweep angle
    for i = 1:nc
        CP(k,i,:)=0.5*(Camber(k,i,:)+Camber(k+1,i,:))+0.75*(0.5*(Camber(k,i+1,:)+Camber(k+1,i+1,:))-0.5*(Camber(k,i,:)+Camber(k+1,i,:)));
        BV(k,i,:)=0.5*(Camber(k,i,:)+Camber(k+1,i,:))+0.25*(0.5*(Camber(k,i+1,:)+Camber(k+1,i+1,:))-0.5*(Camber(k,i,:)+Camber(k+1,i,:)));
        BV1(k,i,:)=0.75*Camber(k+1,i,:)+0.25*Camber(k+1,i+1,:);  %Left bound vortex coordinate
        BV2(k,i,:)=0.75*Camber(k,i,:)+0.25*Camber(k,i+1,:);  %Right bound vortex coordinate
        BVhalfspan(k,i)= 0.5*(0.75*norm(shiftdim(Camber(k,i,2:3)-Camber(k+1,i,2:3)))+0.25*norm(shiftdim(Camber(k,i+1,2:3)-Camber(k+1,i+1,2:3))));
        %Only consider [Y,Z] distances due to definition of halfspan in
        %NASA paper; considering X distance as well makes halfspan increase
        %greatly as you increase sweep and invalidates calculations
        %Validated BVhalfspan calculation through (1:ns-1,1:nc)
        sweep_c4(k,i)=atan((Camber(k,i,1)-Camber(k+1,i,1))/(Camber(k,i,2)-Camber(k+1,i,2))); %Validated
    end
end

%Prandtl-Glauert corrections
CPprime = CP(:,:,1)/beta;
BVprime = BV(:,:,1)/beta;
BV1prime = BV1(:,:,1)/beta;
BV2prime = BV2(:,:,1)/beta;
sweep_c4_prime = atan(tan(sweep_c4)/beta);

for k = 1:ns
    for i  = 1:nc
        panel(k,i).CP=shiftdim(CP(k,i,:));  %Removing singleton dimensions
        panel(k,i).BV=shiftdim(BV(k,i,:)); %Removing singleton dimensions
        panel(k,i).BV1=shiftdim(BV1(k,i,:)); %Removing singleton dimensions
        panel(k,i).BV2=shiftdim(BV2(k,i,:)); %Removing singleton dimensions
        panel(k,i).dzdx=dzdx(k,i);
        panel(k,i).twist=twist(k);
        panel(k,i).s=BVhalfspan(k,i);
        panel(k,i).sweep=sweep_c4(k,i);
        panel(k,i).sweepprime=sweep_c4_prime(k,i);
        panel(k,i).CPprime=CPprime(k,i);
        panel(k,i).BVprime=BVprime(k,i);
        panel(k,i).BV1prime=BV1prime(k,i);
        panel(k,i).BV2prime=BV2prime(k,i);
        panel(k,i).cc=cc(k,i);
    end
end

%Determine wing volume
Vol = 1/3*(Aroot +sqrt(Aroot*Atip) + Atip)*inputgeo.b;
