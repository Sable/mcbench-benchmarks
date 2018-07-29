load('shot.mat');                                                   % loading image
colormap('gray');                                                   % choosing colourmap
image(shot);                                                        % showing image
[py, px] = findcentroidlaserspotusingfourier(shot)                  % calculating centroid
if (isnan(py) == 0) && (isnan(px) == 0)                             % if calculated values are not NaN
    line([px-10; px+10], [py, py], 'color', 'g', 'LineWidth', 1);   % showing haircross
    line([px, px], [py-10, py+10], 'color', 'g', 'LineWidth', 1);
end


