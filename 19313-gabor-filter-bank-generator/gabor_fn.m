function gb=gabor_fn(sigma_x,sigma_y,theta,freq)
% Sigma_x and Sigma_y must be integers
% For fingerprint enhancement, sigma_x and sigma_y should be the half of the wave length
% (1/(2*Freq)
sz_x=6*sigma_x+1;
sz_y=6*sigma_y+1;

[x y]=meshgrid(-fix(sz_x/2):fix(sz_x/2),fix(-sz_y/2):fix(sz_y/2));

% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);

gb=exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi*freq*x_theta);