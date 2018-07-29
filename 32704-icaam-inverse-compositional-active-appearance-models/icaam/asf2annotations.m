function asf2annotations(directory)
% asf2annotations(directory)
%
% Converts annotations from asf format (used by the IMM database) to 
% our native .mat format.
%
%                         PARAMETERS
%
% directory Path to directory where the .asf files are stored, 
%           along with the associated images.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

landmark_files = dir(sprintf('%s/*.asf', directory));

for i=1:numel(landmark_files)
	asf_path = sprintf('%s/%s', directory, landmark_files(i).name);
	asf_fid = fopen(asf_path, 'r');
	
	% Determine the number of annotations in the asf file
	while 1
		data = fgetl(asf_fid);
		% Check for end of file
		if ~ischar(data)
			error('unexpected end of file');
		% Skip comments
		elseif size(data,2) > 0 && data(1) ~= '#'
			% First number must be the number of annotations stored
			np = sscanf(data, '%d');
			break;
		end
	end
	
	annotations = [];
	
	% Read annotation data
	while size(annotations, 1) < np
		data = fgetl(asf_fid);
		% Check for end of file
		if ~ischar(data)
			error('unexpected end of file');
		% Skip comments
		elseif size(data,2) > 0 && data(1) ~= '#'
			% Extract annotation data, we are only interested in the landmarks 
			L = sscanf(data, '%d %d %f %f %d %d %d');
			% Fields 3,4 are the relative coordinates, Field 5 is
			% the annotation id. 
			% The annotations are also transformed into cartesian
			% coordinates.
			annotations(L(5)+1,:) = [L(3), 1 - L(4)];
		end
	end
	
	% Last non-comment, non-empty line
	% is the image name
	while 1
		data = fgetl(asf_fid);
		% Check for end of file
		if ~ischar(data)
			error('unexpected end of file');
		elseif size(data,2) > 0 && data(1) ~= '#'
			img_name = data;
			break;
		end
	end
	
	fclose(asf_fid);
	
	img_path = sprintf('%s/%s', directory, img_name);
	
	% The image is needed to convert from relative to absolute
	% coordinates
	info = imfinfo(img_path);
	
	scale = [info.Width 0; 
	         0 info.Height];
	         
	annotations = annotations * scale;
	
	save(sprintf('%s/%s.mat', directory, img_name), 'annotations');
	
end % for i=1:numel(landmark_files)