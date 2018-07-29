function pts2annotations(directory)
% pts2annotations(directory)
%
% Converts annotations from pts format to our native .mat format.
%
%                         PARAMETERS
%
% directory Path to directory where the .pts files are stored, 
%           along with the associated images.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

landmark_files = dir(sprintf('%s/*.pts', directory));

app = imread(sprintf('%s/%s', directory, landmark_files(1).name(1:end-4)));

for i=1:numel(landmark_files)
	fid = fopen(sprintf('%s/%s', directory, landmark_files(i).name), 'r');
	
	% First line must be "version: 1"
	data = fgetl(fid);
	assert(strcmp(data, 'version: 1'));
	
	% Second line must be "n_points: <n>"
	num_points = fscanf(fid, 'n_points: %d\n');
	data = fgetl(fid);
	
	% Third line is "{"
	assert(strcmp(data, '{'));
	
	% Read annotation data
	for j=1:num_points
		P = fscanf(fid, '%f', 2);
		shape(j,1) = P(1);
		shape(j,2) = P(2);
	end
	
	% Match end of line
	data = fgetl(fid);
  assert(strcmp(data, ''));
  
  % Last line is "}"
  data = fgetl(fid);
	assert(strcmp(data, '}'));
	
	fclose(fid);
	
	% Convert to cartesian coordinates	
	annotations(:,1) = shape(:,1);
	annotations(:,2) = repmat(size(app, 1), [num_points 1]) - shape(:,2);
	
	save(sprintf('%s/%s.mat', directory, landmark_files(i).name(1:end-4)), 'annotations');
end

