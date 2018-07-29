% EXAMPLE_THREE_IMAGES Multicmap demo for two images.
%
%   See also MULTICMAP, EXAMPLE_TWO_IMAGES, EXAMPLE_SPEECH.

%   Author: Kamil Wojcicki, UTD, February 2012.

clear all; close all; clc; fprintf('.\n');


    %% Create image data for plotting

    % Read the sample sample images 
    data.clown = load( 'clown' );
    data.earth = load( 'earth' );
    data.penny = load( 'penny' );

    % Get indexed images into meaningful variables
    photo.clown = data.clown.X;
    photo.earth = data.earth.X(1:2:end,1:2:end);
    photo.penny = data.penny.P(1:2:end,1:2:end);

    % Get dimensions of each image
    dims.clown = size( photo.clown );
    dims.earth = size( photo.earth );
    dims.penny = size( photo.penny );

    % Define x-points for each image
    x.clown = [ 1:dims.clown(1) ];
    x.earth = max(x.clown) - [ dims.earth(1):-1:1 ];
    x.penny = max(x.clown) - [ dims.penny(1):-1:1 ];

    % Define y-points for each image
    y.clown = [ 1:dims.clown(2) ];
    y.earth = max(y.clown) - [ dims.earth(2):-1:1 ];
    y.penny = max(y.clown) - [ dims.penny(2):-1:1 ];

    % Define colormaps for each image like so:
    maps.clown = data.clown.map;
    maps.earth = data.earth.map;
    maps.penny = copper(64);

    % or one could try other colormaps that come with MATLAB, e.g.,
    %maps.clown = bone(11);
    %maps.earth = winter(2);
    %maps.penny = hot(128);

    % or one could define a simple custom colormap:
    % maps.penny = [ 0 0 0; 0.25 0 0; 0.5 0 0; 1 0 0 ];

    % or one could automate the colormap creation task like so:
    % custom_colormap = @(N,red,green,blue)( [ ones(N,1).*linspace(red(1),red(2),N).' ones(N,1).*linspace(green(1),green(2),N).' ones(N,1).*linspace(blue(1),blue(2),N).' ] );
    % maps.penny = custom_colormap( 32, [0.1 0.9], [0 0.3], [0 0] );

    % Define transparency for visible parts of each image
    alpha.clown = 1;      % fully opaque
    alpha.earth = 0.5;    % 50% transparency
    alpha.penny = 0.75;   % 25% transparency

    % Define which parts of the second image are to be fully transparent (invisible)
    AlphaData.penny = ones( size( photo.penny ) ) * alpha.penny;
    AlphaData.penny( photo.penny<5*min(photo.penny(:)) ) = 0;


    %% Plot images with their respective colormaps

    % Create a figure
    hfig = figure( 'Position', [ 400 10 600 600 ], 'PaperPositionMode', 'auto', 'color', 'w' );

    % Make sure both images get retained in the current axes
    hold on;

    % Plot images and retain handles to the image objects
    h.clown = image( x.clown, y.clown, photo.clown );
    h.earth = image( x.earth, y.earth, photo.earth );
    h.penny = image( x.penny, y.penny, photo.penny );

    % Apply transparency settings
	set( h.clown, 'AlphaData', alpha.clown );
    set( h.earth, 'AlphaData', alpha.earth );
    set( h.penny, 'AlphaData', AlphaData.penny );

    % Apply axes limits 
    xlim( [ min(struct2array(x)) max(struct2array(x)) ] );
    ylim( [ min(struct2array(y)) max(struct2array(y)) ] );

    % Make sure our images are not up-side-down
    axis ij square off
    
    % Pause for a few seconds to show default behavior
    title( 'Before multicmap(...) is applied' );
    pause( 2 )
    title( 'After multicmap(...) is applied' );

    % Apply colormaps to their respective image objects
    multicmap( h, maps );

    % Print figure to png file
    print( '-dpng', mfilename );


% EOF
