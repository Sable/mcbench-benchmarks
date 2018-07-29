%% Render Random Scenes
%
% This script will generate numerous random scenes and save the results in
% the Output directory. This is useful to sample a large number of scene.
% Note that each scene will be saved as an image with a date stamp *and*
% the random number generator seed used to generate the seed. Passing this
% number to |rng| before running |example_scene| will result in the scene
% being recreated exactly. This allows a user to examine numerous scenes,
% select a scene of interest, recreate it, explore it, and potentially
% export it for whatever purpose. In other words, the seed number is all
% that's necessary to completely regenerate a scene. For example, if an
% image is named |scene_2012-12-13-18-38-28_seed_59150.png|, then the
% following completely recreates the scene.
%
% >> rng(59150);
% >> example_scene;
%
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

%% Options
% Number of scenes to create.
n_images = 50;

%% Initialize the Figure
fprintf('Generating %d scenes...\n', n_images);
tic();

% Create or clear a figure for the rendering.
figure(1);
clf();
set(1, 'PaperPositionMode',     'auto', ...
       'WindowButtonDownFcn',   [], ...
       'WindowButtonUpFcn',     [], ...
       'WindowButtonMotionFcn', [], ...
       'WindowScrollWheelFcn',  []);

% Choose the next random number generator seed.
rng_seed = mod(floor(1e8*now()), 2^32);
rng(rng_seed);

%%
% Add an Output directory if one doesn't exist.
if ~exist('Output', 'dir')
    mkdir('Output');
end

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
set(h_sky,  'VertexNormals', -get(h_sky,  'VertexNormals'));

%% Sun

% Create a light for the sun.
h_light = lightangle(90, 360*(current_time - 0.25));

% Set the light's color.
set(h_light, 'Color',             sun_color);

% Set the ambient color used in the scene.
set(gca(),   'AmbientLightColor', sun_color);

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


%% Loop, Updating Image Each Time
image_number = 0;
while true    
    
    % Increase image count.
    image_number = image_number + 1;
    
    % Force a drawing.
    drawnow();
    
    % Capture the image.
    image_name = sprintf('scene_%s_seed_%d.png', ...
                         datestr(now(), 'yyyy-mm-dd-HH-MM-SS'), ...
                         rng_seed);
    print('-dpng', ['Output' filesep image_name]);
    
    % If we've generated enough images, stop.
    if image_number == n_images
        break;
    end
    
    % Choose the next random number generator seed.
    rng_seed = mod(floor(1e8*now()), 2^32);
    rng(rng_seed);
    
    % Generate new terrain.
    [~, ~, ~, hm, xm, ym] = generate_terrain(7, 513, 0, 0.1);
    cm = generate_terrain_colors(hm);
    hmp = max(hm, 0);
    current_time = 0.24 + 0.52 * rand();
    [nx, ny, nz] = surfnorm(hmp);
    land_normals = [nx(:), ny(:), nz(:)];

    % Update the patches, lights, and camera.
    land_patch = surf2patch(xm, ym, hmp, cm);
    set(h_land, 'Vertices',        land_patch.vertices, ...
                'Faces',           land_patch.faces, ...
                'FaceVertexCData', land_patch.facevertexcdata, ...
                'VertexNormals',   land_normals);
    lightangle(h_light, 90, 360*(current_time - 0.25));
    sun_color = sun_tones(current_time);
    set(h_light, 'Color', sun_color);
    camera_target   = [0 0 mean(hmp(:)) + 0.5*std(hmp(:))];
    camera_position = camera_target + [1.15 0 0.5];
    set(gca(), 'AmbientLightColor', sun_color, ...
               'CameraTarget',      camera_target, ...
               'CameraPosition',    camera_position, ...
               'CameraUpVector',    [0 0 1]);
    camorbit(360*rand(), 0);
    
end

fprintf('Done.\n');
toc();
