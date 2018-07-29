% EXAMPLE_TWO_IMAGES Multicmap demo for two images.
%
%   See also MULTICMAP, EXAMPLE_THREE_IMAGES, EXAMPLE_SPEECH.

%   Author: Kamil Wojcicki, UTD, February 2012.

clear all; close all; clc; fprintf('.\n');


    %% Create image data for plotting

    % Read the sample sample images 
    data.earth = load( 'earth' );
    data.penny = load( 'penny' );

    % Get indexed images into meaningful variables
    photo.earth = data.earth.X;
    photo.penny = data.penny.P;

    % Get dimensions of each image
    dims.earth = size( photo.earth );
    dims.penny = size( photo.penny );

    % Define x-points for each image
    x.earth = [ 1:dims.earth(1) ];
    x.penny = [ 1:dims.penny(1) ] + round((dims.earth(1)-dims.penny(1))/2);

    % Define y-points for each image
    y.earth = 1:dims.earth(2);
    y.penny = [ 1:dims.penny(2) ] + round((dims.earth(2)-dims.penny(2))/2);

    % Define colormaps for each image like so:
    maps.earth = data.earth.map;
    maps.penny = hot(64);

    % or one could try other colormaps that come with MATLAB, e.g.,
    % maps.penny = copper(64);
    % maps.penny = jet(64);
    % maps.penny = lines(64);

    % or one could define a simple custom colormap:
    % maps.penny = [ 0 0 0; 0.25 0 0; 0.5 0 0; 1 0 0 ];

    % or one could automate the colormap creation task like so:
    % custom_colormap = @(N,red,green,blue)( [ ones(N,1).*linspace(red(1),red(2),N).' ones(N,1).*linspace(green(1),green(2),N).' ones(N,1).*linspace(blue(1),blue(2),N).' ] );
    % maps.penny = custom_colormap( 32, [0.1 0.9], [0 0.3], [0 0] );

    % Define transparency for visible parts of each image
    alpha.earth = 1;        % fully opaque
    alpha.penny = 0.7;      % 30% transparency

    % Define which parts of the second image are to be fully transparent (invisible)
    AlphaData.penny = ones( size( photo.penny ) ) * alpha.penny;
    AlphaData.penny( photo.penny<5*min(photo.penny(:)) ) = 0;


    %% Plot images with their respective colormaps

    % Create a figure
    hfig = figure( 'Position', [ 400 10 600 600 ], 'PaperPositionMode', 'auto', 'color', 'w' );

    % Make sure both images get retained in the current axes
    hold on;

    % Plot images and retain handles to the image objects
    h.earth = image( x.earth, y.earth, photo.earth );
    h.penny = image( x.penny, y.penny, photo.penny );

    % Apply transparency settings
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
