global I hi

I=imread('smile.png'); % load image

hi=imshow(I,'InitialMagnification',600);
hold on;
tol=2; % tolerance
r=[20;30]; % start point of flood
zz_flood_fill_movie(r,tol); % make flood fill

