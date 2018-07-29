function fsmplaydata(data, speed)
% Play a data set as a sequence of single wavelength images.
%   fsmplaydata(data, speed)
%       data is the data cube (Y, X, Z)
%       speed is frames per second

[y,x,z] = size(data);

for i = 1 : z
    figure = imagesc(data(:, :, i));
    pause(1 / speed);
end;


