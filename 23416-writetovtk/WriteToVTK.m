function WriteToVTK(matrix, filename)
% WriteToVTK(matrix, filename)
%
% Writes a 3D matrix as a VTK file. View with paraview.
% The matrix must be 3D and is normalised (kind of).
%
% A sligthly old format is used because it is simpler.

% Example VTK file:
% # vtk DataFile Version 2.0
% Volume example
% ASCII
% DATASET STRUCTURED_POINTS
% DIMENSIONS 3 4 6
% ASPECT_RATIO 1 1 1
% ORIGIN 0 0 0
% POINT_DATA 72
% SCALARS volume_scalars char 1
% LOOKUP_TABLE default
% 0 0 0 0 0 0 0 0 0 0 0 0
% 0 5 10 15 20 25 25 20 15 10 5 0
% 0 10 20 30 40 50 50 40 30 20 10 0
% 0 10 20 30 40 50 50 40 30 20 10 0
% 0 5 10 15 20 25 25 20 15 10 5 0
% 0 0 0 0 0 0 0 0 0 0 0 0

% Get the matrix dimensions.
[N M O] = size(matrix);

% Get the maximum value for the normalisation.
mx = max(matrix(:));

% Open the file.
fid = fopen(filename, 'w');
if fid == -1
    error('Cannot open file for writing.');
end

% New line.
nl = sprintf('\n'); % Stupid matlab doesn't interpret \n normally.

% Write the file header.
fwrite(fid, ['# vtk DataFile Version 2.0' nl 'Volume example' nl 'ASCII' nl ...
    'DATASET STRUCTURED_POINTS' nl 'DIMENSIONS ' ...
    num2str(N) ' ' num2str(M) ' ' num2str(O) nl 'ASPECT_RATIO 1 1 1' nl ...
    'ORIGIN 0 0 0' nl 'POINT_DATA ' ...
    num2str(N*M*O) nl 'SCALARS volume_scalars char 1' nl 'LOOKUP_TABLE default' nl]);

for z = 1:O
    % Get this layer.
    v = matrix(:, :, z);
    % Scale it. This assumes there are no negative numbers. I'm not sure
    % this is actually necessary.
    v = round(100 .* v(:) ./ mx);
    % Write the values as text numbers.
    fwrite(fid, num2str(v'));
    % Newline.
    fwrite(fid, nl);
    
    % Display progress.
    disp([num2str(round(100*z/O)) '%']);
end

% Close the file.
fclose(fid);

end