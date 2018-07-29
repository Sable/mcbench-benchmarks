% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2 at cs dot nospam dot sfu dot ca
% $Revision: 1.0$ 10 February 2008

function arcball()

clc, clear, close all;

% draw some dummy data
[x,y,z] = sphere(50);
H = figure;
h = hgtransform;
hg = hggroup('parent', h); % to draw for debug purposes
surf(gca,x,y,z,z,'parent',h);
axis square
axis([-1 1 -1 1 -1 1]);
axis off;
view(2);

% register callbacks ad 
set( H, 'WindowButtonMotionFcn', @motion_callback );
set( H, 'WindowButtonDownFcn', @buttondown_callback );
set( H, 'WindowButtonUpFcn', @buttonup_callback );
mousestatus = 'buttonup';
START = [0,0,0];
M_previous = get( h, 'Matrix' );



%%%%%%%%%%%% CALLBACKS %%%%%%%%%%%%%%

% motion callback, event "every" mouse movement
function motion_callback(src, event)
    % retrieve the current point
    P = get(gcf,'CurrentPoint');
    % retrieve window geometry
    HGEOM = get( src, 'Position');
    % transform in sphere coordinates (3,4) = (WIDTH, HEIGHT)
    P = point_on_sphere( P, HGEOM(3), HGEOM(4) );
    
    % workaround condition (see point_on_sphere)
    if isnan(P)
       return; 
    end
    
    %%%%% ARCBALL COMPUTATION %%%%%
    if strcmp(mousestatus, 'buttondown')
        % compute angle and rotation axis
        rot_dir = cross( START, P ); rot_dir = rot_dir / norm( rot_dir );
        rot_ang = acos( dot( P, START ) );
       
        % convert direction in model coordinate system
        M_tr = inv( M_previous );
        rot_dir = M_tr*[rot_dir,0]';
        rot_dir = rot_dir(1:3);
        rot_dir = rot_dir / norm( rot_dir ); % renormalize
        % construct matrix
        R_matrix = makehgtform('axisrotate',rot_dir,rot_ang);
        % set hgt matrix
        set(h,'Matrix',M_previous*R_matrix);
        % refresh drawing
        drawnow;
    end
end

% only 1 event on click
function buttondown_callback( src, evnt )
    % change status
    mousestatus = 'buttondown';
    % retrieve the current point
    P = get(gcf,'CurrentPoint');
    % retrieve window geometry
    HGEOM = get( src, 'Position');
    % SET START POSITION
    START = point_on_sphere( P, HGEOM(3), HGEOM(4) );
    % SET START MATRIX
    M_previous = get( h, 'Matrix' );    
end
function buttonup_callback( src, evnt )
    % change status
    mousestatus = 'buttonup';
    % reset the start position
    START = [0,0,0];
end

%%%%%%%%%%%% UTILITY FUNCTION %%%%%%%%%%%%%
function P = point_on_sphere( P, width, height )
    P(3) = 0;
    
    % determine radius of the sphere
    R = min(width, height)/2;
    
    % TRANSFORM the point in window coordinate into 
    % the coordinate of a sphere centered in middle window
    ORIGIN = [width/2, height/2, 0];
    P = P - ORIGIN;
    
    % normalize position to [-1:1] WRT unit sphere 
    % centered at the origin of the window
    P = P / R;
    
    % if position is out of sphere, normalize it to  
    % unit length
    L = sqrt( P*P' );
    if L > 1
       % P = nan; % workaround to stop evaluation
       % disp('out of sphere');
       
       P = P / L; 
       P(3) = 0;
    else
       % add the Z coordinate to the scheme
       P(3) = sqrt( 1 - P(1)^2 - P(2)^2 );
    end
end

end %% END OF FUNCTION %%
