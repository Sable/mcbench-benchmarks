function [xxf zzf ttf ddf] = raytrace(xo,zo, theta0,tt,zz,cc,plotflag)
%% A function to raytrace through a sound speed profile to a given time.
%
% *Val Schmidt
% *Center for Coastal and Ocean Mapping / Joint Hydrographic Center
% *University of New Hampshire
% *2009
%
%
% Arguments:
%   xo:      starting horizontal coordinate of the ray in meters
%   zo:      starting vertical coordinate of the ray in meters
%   theta0:  starting angle of the ray in degrees
%   tt:      max travel time of the ray in seconds
%   zz:      vertical coordinates of the sound speed profile (+ down)
%   cc:      sound speed measurements at zz locations
%   plotflag: Boolean flag for auto plotting result (optional) default is 0.
%
% Output:
%   xxf:       horizontal coordinates of the ray path
%   zzf:       vertical coordinates of the ray path
%   ttf:       actual travel time of the ray in seconds
%   ddf:       distance the ray traveled
%
% Raytrace will trace the path sound will travel through a medium with an
% isotropic horizontal sound speed profile and a vertical sound speed
% profile given by (zz,cc) from a point (xo,zo) and departing at an angle
% theta0 for a time of tt seconds. The path is returned in vectors x and z.
% The actual time of travel is returned in t, which may be slightly greater
% that tt. The sound speed profile should include a measurement at the
% surface (zz = 0). If it does not, the profile will be extended to the
% surface by replicating the first measurement there.
%%
% In addition to the above, raytrace() handles caustics (when rays bend
% through horizontal) and reflections off the surface (z=0) and bottom
% which is taken to be at the maximum depth measurement in the sound speed
% profile. The bottom is assumed to be flat. Reflections up to a maximum
% number (MAXBOUNCES) is supported. MAXBOUNCES is hard-coded into the
% function. Decreasing MAXBOUNCES will reduce the memory required for
% calculations when many reflections are not needed.
%%
% EXAMPLE:
%
% Trace a ray for 120 seconds starting from 0 m depth at a 5 degree down
% angle through a sound speed profile that has a value of 1520 at the
% surface, decreases with a gradient of -0.05 m/s /m to 750 m, and then
% increases with a gradient of 0.014 m/s /m to a maximum depth of 5000 m. 
%
% Setup the sound speed profile
% zz = 0:1:5000;
% cc = 1520 + [zz*-.05];
% cc(751:end) = cc(750) + (zz(751:end)-zz(750))*.014;
% % Conduct the raytrace and plot result
% [x z t d] = raytrace(0,0,5,120,zz,cc,true);

%% Theory: Ray tracking through linear gradients
% Acoustic energy (sound) refracts when passing through media of varying
% sound speed. A simple and common model for this refaction is presented in
% Principles of Underwater Sound and was recently elucidated in a sprint
% 2009 class on underwater acoustics tought at the University of New
% Hampshire by Dr. Tom Weber. In this model, the sound speed variations are
% approximated by piecewise linear gradients. Under this assumption, sound
% travels through the qth layer as an circular arc whose radius is given by

% Rc = -1/g(q) c(q)/cos(theta(q))

%%
% where g(i) is the gradient in the layer, c(i) is the sound speed at the
% entry point of the ray in the layer, and theta(i) is the angle of the ray
% when entering the layer measured with respect to the horizontal. 

%%
%      '  <---acoustic ray path
%         '   
%------------'------------------------------c(q)-------------
% |            '   <-- theta(q)
% |              /'
% dz            /   '           layer of gradient, g = (c(q+1)-c(q) )/dz
% |            /     '
% |          Rc       '
%-------------------------------------------c(q+1)-------------
%           <---dx---->'  <--theta(q+1)
%                       '
%                        '


%%
% Without going into details, the following may be derived from the image
% above:

% dx(q) = Rc( sin(theta(q+1)) - sin(theta(q)))
% dz(q) = Rc( cos(q)) - cos(theta(q+1)))

%%
% Give a vertical step, dz, one may then calculate the exiting angle of the
% ray wrt the horizontal with

% theta(q+1) = acos( cos(theta(q) ) - dz(q)/Rc);

%%
% The time spent traveling along the ray in the layer is given by
% integrating the path length divided by the sound speed. This can
% be expresses as an integral between incoming and outgoing angles as

% Int(theta(q),theta(q+1)) -Rc / c dtheta 
% or 
%  - Int(theta(q),theta(q+1)) 1/( g * cos(theta) ) dtheta 

%%
% Evaluating this integral gives the following:

% dt = -2/g(q)*( atanh(tan(theta(q+1)/2)) - atanh(tan(theta(q)/2)) );

%%
% The distance traveled along the ray within a layer is simply this time
% times the mean sound speed in that layer.

% d = dt * (cc(q)+g(q)/2)



%% References:
%   *Classs Notes from Underwater Acoustics (Dr. Tom Weber) Spring 2009
%     University of New Hampshire's Center for Coastal and Ocean Mapping
%   *Principles of Underwater Sound, 3rd Edition (Urick, 1983) 


%% Code:
if nargin <=6
    plotflag = 0;
end

arch = computer('arch');

% Extend the sound speed profile to the surface.
if zz(1) ~= 0
    zz = [0 zz(:)'];
    cc = [cc(1) cc(:)'];
end

% Initialize variabls
Ntheta = length(theta0);
xxf = cell(1,Ntheta);
zzf = cell(1,Ntheta);
ddf = cell(1,Ntheta);
ttf = cell(1,Ntheta);
tttf = cell(1,Ntheta);

% If there are multiple angles, raytrace all of them (EXPERIMENTAL)
for m = 1:length(theta0)


%%
% Setup for multiple bounces. 
% Here the sound speed profile is reflected about the bottom, then surface,
% then bottom then surface, etc. up to a maximum of MAXBOUNCE reflections. This
% provides a single profile through which a ray may be traced seamlessly
% handling reflections off each surface.
MAXBOUNCE = 10;
Nsvp = length(zz);
zzend = zz(end);
zzz = zz;           % zzz will be the sound speed profile we refract through
z = zz;             % z will help unraveling the raytrace when we're done.
dz = diff(zz(:));
ccc = cc;
dc = diff(cc(:));
dzo = dz;
mult = -1;
while zzz(end) < MAXBOUNCE*zzend
    if mult==-1
        zzz = [zzz(:); zzz(end)+cumsum(flipud(dz(:)))];
        ccc = [ccc(:); ccc(end)+mult*cumsum(flipud(dc(:)))];
    else
        zzz = [zzz(:); zzz(end)+cumsum(dz(:))];
        ccc = [ccc(:); ccc(end)+mult*cumsum(dc(:))];
    end

    z = [z(:); z(end) + mult* cumsum(dzo)];
    dz = flipud(dz(:));
    dzo = flipud(dzo(:));

    mult = mult * -1;
    
end


%% Start with the standard definitions.
dz = diff(zzz);                    % depth steps
g = diff(ccc)./dz;                 % sound speed gradient

[~, idx ] = min(abs(zzz-zo));
q = idx(1);                        % gradient index (set to depth closes to zo)
qstart = q;

% %% Handle negative angles.
if theta0 < 0 && q > 1
    
    z = [z(q:-1:2)' z']';
    ccc = [ccc(q:-1:2)' ccc']';
    zzz = [zzz(q:-1:2)' zzz']';
    dz = diff(zzz);
    g = diff(ccc)./dz;
    q = 1;
    
     % In this case, the launch angle is negative but the source is already
     % at the surface so we just invert the launch angle. 
elseif theta0 < 0
    theta0 = -theta0;
end


%%
% Initialze values
theta = nan(1,length(dz));
theta(q) = theta0(m) * pi/180;
x = nan(1,length(z));
dx = x;
x(q) = xo;

t = 0;
d = 0;
ttt=t;

while t < tt
    
    % Handle constant 0 gradient (no refraction)
    if g(q) == 0
        theta(q+1) = theta(q);
        if theta(q) == 0
            dx(q) = abs(dz(q));
        else
            dx(q) = dz(q) / tan(theta(q));
        end
        
        dd = sqrt(dx(q)^2 + dz(q)^2);
        dt = dd/ccc(q);
        
    else
        
        % Calculate radius of curvature.
        Rc = -1/g(q) * ccc(q)./cos(theta(q));
        
        % Handle angles above horizontal. 
        if theta(q) > 0   
            theta(q+1) = acos( cos(theta(q)) - dz(q)/Rc);
        else
            theta(q+1) = -acos( cos(theta(q)) - dz(q)/Rc);
        end
        
        % When we go through a caustic we get a complex angle, so we catch
        % and fix this.
        if imag(theta(q+1)) ~= 0
            theta(q+1) = -theta(q);

            % We need to rejig zzz,ccc, dz, z and g
            tmp = find(ccc((q+1):end) == ccc(q));
            if isempty(tmp)
               warning('CCOM:outOfBounds',...
                   'Not enough bounces specified for time requested.',...
                   ' Increase MAXBOUNCES in raytrace.m')
               break
            end
            ccc = [ccc(1:q); ccc((q + tmp(1) ):end)];
            zshift = zzz(q+tmp(1) + 1) - zzz(q);
            zzz = [zzz(1:q); zzz((q + tmp(1) ):end) - zshift];
            z = [z(1:q); z( (q + tmp(1)):end)];
            dz = diff(zzz);
            g = diff(ccc)./dz;
            dx(q) = 0;
            dt = 0;
            dd = 0;
        else
            %% Calculate the dx distance and travel time.
            % The geometry is different if the incident angle is above
            % or below the horizontal. So we catch this and do teh
            % appropriate calculation. 
            if theta(q) > 0
                dx(q) = Rc * ( sin(theta(q+1)) - sin(theta(q)) );
                dt = -2/g(q)* ...
                    ( atanh(tan(theta(q+1)/2)) - atanh(tan(theta(q)/2)) );
            else
                
                dx(q) = abs(Rc * -( sin(theta(q+1)) - sin(theta(q)) ));
                dt = 2/g(q)* ...
                    ( atanh(tan(theta(q+1)/2)) - atanh(tan(theta(q)/2)) );
            end
    
            dd = dt * (ccc(q) + g(q)/2);   % total distance traveled.
        end
        
    end
    
    t = t + dt;             % total travel time.
    ttt(q+1)=t;             % time series of travel time values
    x(q+1) = x(q) + dx(q);  % x coordinte of ray
    d = d + dd;             % distance traveled by ray
    q = q+1;                % increment counter
 
end

% Pull out the data.
x = x(~isnan(x));
z = z(qstart:(qstart+length(x)-1));

% At this point we've gone slightly further then the travel time specified.
% The *correct* way to do this is to incremntally decrease the distance
% traveled in the last layer until the time of travel is within some
% tolerance. This is a hassle as it requires shifting the sound speed
% profile incrementally as you go. As long as the layers are not too big,
% we can approximate the last layer's travel with a straight line. To do
% this we calculate a corrector that is the time from the previous time
% step to the max allowed time over the latest increment. Then this may be
% applied to the final coordiantes.
corrector = (tt - (t-dt))/dt;
x(end) = x(end-1)+(x(end)-x(end-1))* corrector;
z(end) = z(end-1)+(z(end)-z(end-1))* corrector;
t = (t-dt) + dt*corrector; % this just sets t == tt.

xxf{m} = x;
zzf{m} = z;
ddf{m} = d;
ttf{m} = t;
tttf{m} = ttt;
end

%% Plot setup
if plotflag
    f = figure(1);
    if strcmp(arch,'maci')
        set(f,'Position',[10 1500 1300 400])
    else
        set(f,'Position',[10 100 1300 400])
    end
    subplot(1,5,1)
    plot(cc(1:Nsvp),zz);
    axis ij
    grid on
    title('Sound Speed Profile')
    xlabel('Sound Speed, m/s')
    ylabel('Depth, m')
    subplot(1,5,2:5)
end
%% Plot result?
if plotflag
    for m = 1:length(theta0)
    plot(xxf{m},zzf{m})
    hold on
    end
    hold off
    axis ij
    grid on
    title('Ray Trace')
    xlabel('Distance, m')
    ylabel('Depth, m')
end