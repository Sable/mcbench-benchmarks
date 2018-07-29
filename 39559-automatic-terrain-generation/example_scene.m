%% Example Scene
%
% This script demonstrates using a combination of functions to create
% terrain, add a sky, set some lighting options, and provide the ability to
% rotate around the figure. It uses several of MATLAB's 3D graphics 
% commands, including patches, lighting, camera positioning, and
% projection. If any of these are unfamiliar, the documentation covers them
% well. MATLAB can produce much more than simple plots.
%
% This script is likely to take between 3 and 30 seconds to complete on
% most computers.
%
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

%%
% Create or clear a figure for the rendering.
figure(1);
clf();

%% Land and Sea

% Create the terrain height map.
[~, ~, ~, hm, xm, ym] = generate_terrain(7, 513, 0, 0.1);

% Generate appropriate colors.
cm = generate_terrain_colors(hm);

% Flatten the oceans.
hmp = max(hm, 0);

% Draw the land and calculate its normal vectors.
h_land = patch(surf2patch(xm, ym, hmp, cm));
[nx, ny, nz] = surfnorm(hmp);
land_normals = [nx(:), ny(:), nz(:)];

% Set it's material properties for interpolated colors and appropriate
% lighting.
set(h_land, 'VertexNormals',    land_normals, ...
            'DiffuseStrength',  0.8, ...      % Reacts to light direction
            'SpecularStrength', 0, ...        % Not shiny
            'AmbientStrength',  0.3, ...      % Reacts to ambient light
            'BackFaceLighting', 'unlit');     % Don't illuminate reverse

% Add a black backdrop beneath the land. Sometimes a vertex seems to miss
% its position slightly, and sky colors creep through, and that's weird.
patch('Faces',           [1 2 3 4], ...
      'Vertices',        [-1 -1 -0.01; ...
                           1 -1 -0.01; ...
                           1  1 -0.01; ...
                          -1  1 -0.01], ...
      'FaceVertexCData', 0.25*ones(4, 3));
        
%% Sky
        
% Draw a random time of day between sunrise and sunset. Get the
% corresponding light color. The sky is always the color of the sun at noon
% (and is then affected by the sun color at the current time).
current_time = 0.24 + 0.52 * rand();
sun_color    = sun_tones(current_time);
sky_color    = sun_tones(0.5);

% Create the sky patch by scaling a sphere. Note that the nothing in the
% scene can be rendered outside of [-100, 100] on any axis due to a
% documented rendering bug. Therefore, the sphere will be scaleld up to
% 99, which is plenty far away since the terrain is limited to [-1, 1].
[xs, ys, zs] = sphere(16);
sky_scale = 99;
sky_patch = surf2patch(sky_scale*xs, sky_scale*ys, sky_scale*zs, ...
                       repmat(reshape(sky_color, [1 1 3]), [17 17 1]));
h_sky = patch(sky_patch);

% Set appropriate lighting options for the sky.
set(h_sky, 'DiffuseStrength',  0.3, ...
           'SpecularStrength', 0, ...
           'AmbientStrength',  1, ...
           'BackFaceLighting', 'unlit');

% Vertex normals are the opposite of what I expect. Reverse them.
set(h_sky,  'VertexNormals', -get(h_sky, 'VertexNormals'));

%% Sun

% Create a light for the sun.
h_light = lightangle(90, 360*(current_time - 0.25));

% Set the light's color.
set(h_light, 'Color', sun_color);

% Set the ambient color used in the scene.
set(gca(), 'AmbientLightColor', sun_color);

% Use decent lighting.
lighting gouraud;

%% Axes and Global Settings

% Set axes options.
camera_target   = [0 0 mean(hmp(:)) + 0.5*std(hmp(:))];
camera_position = camera_target + [1.15 0 0.5];
set(gca, 'DataAspectRatio', [1 1 1], ...
         'Visible',         'off', ...
         'Projection',      'Perspective', ...
         'Position',        [0 0 1 1], ...
         'CameraTarget',    camera_target, ...
         'CameraViewAngle', 45, ...
         'CameraUpVector',  [0 0 1], ...
         'CameraPosition',  camera_position, ...
         'XLim',            [-100 100], ...
         'YLim',            [-100 100], ...
         'ZLim',            [-100 100]);
camorbit(360*rand(), 0);

% Patches should have no edges and interpolated face colors.
shading interp;

% Force the drawing.
drawnow();

% Add FigureRotator to allow the user to rotate around the middle of the
% scene and zoom in and out using a mouse. This is available in the extras
% zip file or from File Exchange. Use |unzip terrain_generation_extras.zip|
% in this directory to extract FigureRotator along with an example file.
if exist('FigureRotator', 'class');
    f = FigureRotator(gca());
end
