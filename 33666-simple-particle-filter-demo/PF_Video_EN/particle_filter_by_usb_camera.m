%% Parameters

F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

Npop_particles = 4000;

Xstd_rgb = 50;
Xstd_pos = 25;
Xstd_vec = 15;

Xrgb_trgt = [255; 0; 0];

%% Starting Video Camera

vid = videoinput('winvideo', 1, 'RGB24_640x480');

set(vid, 'TriggerRepeat', Inf);
vid.FrameGrabInterval = 1;

Npix_resolution = get(vid, 'VideoResolution');
Nfrm_movie = 300;

%% Object Tracking by Particle Filter

X = create_particles(Npix_resolution, Npop_particles);

start(vid)

for k = 1:Nfrm_movie
    
     % Getting Image
     Y_k = getdata(vid, 1);

     % Forecasting
     X = update_particles(F_update, Xstd_pos, Xstd_vec, X);

    % Calculating Likelihood
    L = calc_log_likelihood(Xstd_rgb, Xrgb_trgt, X(1:2, :), Y_k);
    
    % Resampling
    X = resample_particles(X, L);
    
    % Showing Image
    show_particles(X, Y_k);
 %    show_state_estimated(X, Y_k);
   
    flushdata(vid);

end

%% Stopping Video Camera

stop(vid)
delete(vid)
