function [X,Y,Z,CAPS] = extrude(varargin)
% EXTRUDE  Extrude a 2D curve along a 3D path to create
% tubes/cylinders/etc (and, optionally, fly though it!)
%
%   [X,Y,Z] = EXTRUDE(base,traj)
%   [X,Y,Z,CAPS] = EXTRUDE(base,traj,cap)
%   [X,Y,Z,CAPS] = EXTRUDE(base,traj,cap,alg)
%   [X,Y,Z,CAPS] = EXTRUDE(base,traj,cap,alg,fly) returns the surface and
%   handle to the surface plot object created by the 2D base curve and 3D
%   trajectory. SURF(X,Y,Z) can be used to display the object. If cap == 2,
%   data for the caps will be sent separately.
%
%   base = [x;y]   A 2-row Matrix defining the 2d base
%   traj = [x;y;z] A 3-row Matrix defining the 3d path
%   cap = Close off the ends of the tube:
%            0 -> No (default)
%            1 -> Yes
%            2 -> Yes but output them separately into the variable CAPS
%           
%   alg = Creation algorithm:
%            1 Creates a natural looking surface with little twist (default)
%            2 More twisty, but preserves orientation vs. direction (which
%              is better for periodicity)
%   fly =  N  Fly through the path generated N times
%
%
%   DEMO: EXTRUDE with no arguments flies through a random periodic path
%         with a star/road/tube cross section using either algorithm
%
%   EXAMPLE 1: Generate a torus:
%
%       q = linspace(0,2*pi,33);
%       base = [cos(q); sin(q)];   % Base curve is a circle (radius = 1)
%       q = linspace(0,2*pi,101);
%       traj = 5*[cos(q); sin(q); 0*q]; %Trajectory is a circle (radius = 5)
%
%       [X,Y,Z] = extrude(base,traj);
%       figure; surf(X,Y,Z); axis equal;
%
%   EXAMPLE 2: Generate half a torus, with nice caps plotted separately:
%
%       q = linspace(0,2*pi,33);
%       base = [cos(q); sin(q)];   % Base curve is a circle (radius = 1)
%       q = linspace(0,pi,101);
%       traj = 5*[cos(q); sin(q); 0*q]; %Trajectory is a semicircle (radius = 5)
%
%       [X,Y,Z,CAPS] = extrude(base,traj,2);    %cap = 2 for separate caps
%       figure; surf(X,Y,Z); axis equal; hold on;
%       surf(CAPS(1).X,CAPS(1).Y,CAPS(1).Z,'linestyle','none');
%       surf(CAPS(2).X,CAPS(2).Y,CAPS(2).Z,'linestyle','none');
%
%
%   EXAMPLE 3: Generate a 3D square tube and fly through it once:
%
%       q = linspace(0,2*pi,5) + pi/4;
%       base = 0.15*[cos(q); sin(q)];   % Base curve is a square
%       t = linspace(0,1,2001);
%       traj = [sin(4*pi*t+1); sin(5*pi*t+2); sin(6*pi*t)];
%
%       [X,Y,Z] = extrude(base,traj,0,[],1);
%       figure; surf(X,Y,Z); axis equal;
%
%   2009-12-25 v3.1     Fixed an error with argument parsing
%   2009-12-18 v3.0     Added an option to close off the ends, and changed
%                       the order of the input arguments.
%   2009-08-20 v2.0     Added a better algorithm that allow for much less
%                       twistiness, a new (simpler) example, and better
%                       error checking.
%   2009-08-20 v1.1     Fixed an error with passing in only 2 arguments and
%                       clearer documentation
%   2009-08-19 v1.0     Initial Creation


%% Process input parameters
if nargin < 2  % Default base = star,   Default path = random
    disp('EXTRUDE DEMO: Fly through a random periodic path.')
    sw =  input('Pick a cross-section: (1)Star (2)Road (3)Tube ? ');
    switch sw
        case 1
            bs = 5; sharp = 0.5; bsize = .1;   %5 pointed star...
            basex = [cos(linspace(0,2*pi,bs+1));
                    sharp*cos(2*pi/2/bs + linspace(0,2*pi,bs+1))]; 
            basey = [sin(linspace(0,2*pi,bs+1));
                    sharp*sin(2*pi/2/bs + linspace(0,2*pi,bs+1))];
            base = bsize*[basex(1:2*bs+1); basey(1:2*bs+1)];
        case 2
            base = [-1 -1 1 1; 0 -.2 -.2 0]/10;
        case 3
            base = .1*[cos(linspace(0,2*pi,12)); sin(linspace(0,2*pi,12))];
        otherwise
            disp('Pick 1, 2, or 3! Try again.'); return;
    end
    
    alg = input('Pick an algorithm: (1) Normal (2) Twisty but orientation preserving ? ');
    if alg ~= 1 && alg ~= 2
        disp('Pick 1 or 2! Try again.'); return;
    end


    C = interpft(randn(10,3),1001)'; %Generate a smooth periodic path
    C = [C(:,end) C]; %close the loop
    C = 1*C./max(abs(C(:))); %normalize it
	fly = Inf;   %Fly through it forever
    cap = 0;    % No caps
    
       
elseif nargin >= 2;
    fly = []; alg = 1; cap = 0;
    C = varargin{2}; 
    base = varargin{1};
    if nargin >= 3 && ~isempty(varargin{3}); cap = varargin{3}; end
    if nargin >= 4 && ~isempty(varargin{4}); alg = varargin{4}; end
    if nargin == 5 && ~isempty(varargin{5}); fly = varargin{5}; end
end

% Check size to make size(C) = 3xN
if size(C,2) == 3 && size(C,1) ~= 3
    C = C';
end

% Check size to make size(base) = 2xN
if size(base,2) == 2 && size(base,1) ~= 2
    base = base';
end

%% Calculate derivatives and allocate matrices 
npt = size(base,2);
base = [base; zeros(1,npt)];

if size(C,2) >= 3 %Use a 2nd order approximation for the derivatives of the trajectory
    dC = [C(:,1:3)*[-3; 4; -1]/2  [C(:,3:end) - C(:,1:end-2)]/2 C(:,end-2:end)*[1; -4; 3]/2];
else
    dC = C(:,[2 2]) - C(:,[1 1]);
end

dC0 = find(sum(abs(dC),1) == 0,1);    %Check for stagnation points
if ~isempty(dC0) 
    warning('Removing stagnation points found in trajectory');
    dCgood = find(sum(abs(dC),1) ~= 0);
    C = C(:,dCgood); % 
    dC = dC(:,dCgood); % 
end

K = size(dC,2);
SUR = nan(3,npt,K);
camtar = zeros(3,K);
camup = zeros(3,K);
camdata = [[0;0;1],[0;1;0]];
%% Generate and plot the surface

dCvec_prev = [0;0;1];

switch alg
    case 1
        %% Natural Looking Tube (default)
        for k = 1:K
            % We want to rotate [0;0;1] 180degrees around an axis 'z' to become dC 

            dCvec = dC(:,k)/norm(dC(:,k));
            z = cross(dCvec_prev,dCvec);

            if norm(z) ~= 0
                z = z/norm(z);
                q = real(acos(dot(dCvec_prev,dCvec)/norm(dCvec_prev)/norm(dCvec)));

                Z = repmat(z,1,npt);
                base = base*cos(q) + cross(Z,base)*sin(q)+Z*(1-cos(q))*diag(dot(Z,base));
                camdata = camdata*cos(q) + cross([z z],camdata)*sin(q)+[z z]*(1-cos(q))*diag(dot([z z],camdata));

                dCvec_prev = dCvec;
            end

            % Data for the camera used in the flying routine
            camtar(:,k) = camdata(:,1);
            camup(:,k) = camdata(:,2);

            SUR(:,:,k) = base + repmat(C(:,k),1,npt);

        end
    case 2
        %% Orientation preserving tube (more twisty but allows for periodicity)
        for k = 1:K
            % We want to rotate [0;0;1] 180degrees around an axis 'z' to become dC 
            dCvec = dC(:,k)/norm(dC(:,k));
            if isequal(dCvec,[0;0;-1]) %Prevents a 0/0 = nan
                z = [0;1;0];
            else
                z = ([0; 0; 1] + dCvec)/2; z = z/norm(z);
            end
            z = repmat(z,1,npt);


            % Data for the camera used in the flying routine
            camtar(:,k) = z(:,1)*z(3)*2 - [0;0;1];
            camup(:,k) = z(:,1)*z(2)*2 - [0;1;0];

            SUR(:,:,k) = z*diag(dot(z,base))*2 - base + repmat(C(:,k),1,npt);

        end
    otherwise, error('Algorthm 1 or 2?');
end

CAPS = [];
if cap == 1; % Add caps
    SUR = cat(3,repmat(C(:,1),1,npt),SUR,repmat(C(:,K),1,npt));
end

X = squeeze(SUR(1,:,:));
Y = squeeze(SUR(2,:,:));
Z = squeeze(SUR(3,:,:));

if cap == 2 % Add separate caps
    SURCAP1 = cat(3,SUR(:,:,1),repmat(C(:,1),1,npt));
    SURCAP2 = cat(3,SUR(:,:,K),repmat(C(:,K),1,npt));
    CAPS(1).X = squeeze(SURCAP1(1,:,:));
    CAPS(1).Y = squeeze(SURCAP1(2,:,:));
    CAPS(1).Z = squeeze(SURCAP1(3,:,:));
    CAPS(2).X = squeeze(SURCAP2(1,:,:));
    CAPS(2).Y = squeeze(SURCAP2(2,:,:));
    CAPS(2).Z = squeeze(SURCAP2(3,:,:));
end

if isempty(fly) || fly <= 0
    return
end

if exist('sw','var') %If in DEMO mode, make two figures
    surf(X,Y,Z);
    axis equal;
end

curfig = figure;
h = surf(X,Y,Z);
axis equal;


%% Fix any NaN's (This should not happen...)
xisnan = find(isnan(X(1,:)), 1);
xnotnan = find(~isnan(X(1,:)));
if ~isempty(xisnan)
    warning('NaN''s found');
    X = X(:,xnotnan);
    Y = Y(:,xnotnan);
    Z = Z(:,xnotnan);
    camup = camup(:,xnotnan);
    camtar = camtar(:,xnotnan);
    C = C(:,xnotnan);
end


%% Fly through it
set(h,'facealpha',0.5,'edgecolor','flat'); colormap(hsv); %Make it look nice
set(gca,'visible','off','projection','perspective');
set(gcf,'color','k');
set(gcf,'closerequestfcn','assignin(''caller'',''stopme'',1); delete(gcbf)'); % Stop the loop when closing the figure
h = gcf;
K = size(C,2);
k = 0;
laps = 1;
stopme = 0;

while laps <= ceil(fly) && gcf == curfig && stopme == 0
    k = 1 + mod(k,K);  %Increment k but loop from K back to 1

    set(gca,'cameraviewangle',150);
    set(gcf,'name',['Lap ' num2str(laps) '/' num2str(fly) '  ' num2str(k) '/' num2str(K) '   Close the figure to stop.']);
    set(gca,'cameraposition',C(:,k),'cameratarget',C(:,k)+camtar(:,k),'cameraupvector',camup(:,k));
    drawnow;

    if k == K; laps=laps+1; end;

end
try close(h); catch; end; % If the figure remains after leaving the while loop 