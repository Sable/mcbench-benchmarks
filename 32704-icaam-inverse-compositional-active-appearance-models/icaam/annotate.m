function annotate(image_path, template_path, varargin)
% annotate(image_path, [template_path])
% annotate(image_path, template_path, 'AAM', AAM)
% annotate(image_path, template_path, 'triangulation', triangulation)
%
% Annotate images, starting from scratch or using another annotation file as a template.
%
% Brief user guide:
% - MOUSE LEFT moves selected points if the selection is not empty, otherwise it adds a
%   new annotation point at the end of the list
% - MOUSE RIGHT selects the closest annotation point to the cursor
% - 'a' will select all the annotation points
% - 'n' will select the next annotation point in the list, or the first if 
%   not possible
% - 'p  will select the previous annotation point in the list, or the last if 
%   not possible  
% - 'd' will clear the selection
% - 'c' will remove the selected annotations from the list
% - 'r' will reset the annotations to the template. If the template wasn't provided
%   all annotations will be wiped out from the list.
% - 'z' allows to zoom in and zoom out
% - 't' toggles the display of the triangular mesh (only if triangulation data was provided)
% - 'f' runs an AAM fitting iteration, starting from the annotation data (only if AAM model was provided)
% - '`' will save on 'sprintf('%s-backprj.jpg', image_path(1:end-4))' the reconstructed appearance 
%   made using the appearance models  (only if AAM model was provided)
% - 'l' will cause the current annotation data to be projected on the shape modes, giving the best approximation
%   the shape model can provide (only if AAM model was provided)
% - Pressing 'q' will terminate the annotation process and save the annotations to 
%   strcat(image_path, '.mat')
%
% The annotation list format is simple: the 2D points are stored as rows in a n-by-2 matrix
% called 'annotations' in a .mat file with path: strcat(image_path, '.mat'). 
% The coordinates, though, are arranged to represent points in a cartesian plane, such that
% the origin is placed on the bottom-left corner of the image.
% 
% 
%                         PARAMETERS
%
% image_path Path to the image to be annotated.
%
% template_path (Optional) Path to an annotation file to be used as starting template.
%
%                    OPTIONAL PROPERTIES
%
% 'AAM' Active Appearance Models training data as returned by build_model_2d.
%
% 'triangulation' Triangular mesh data as returned by delaunay. This is redundant if AAM is set.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)
	
	% Constants
	MOUSE_LEFT   = 1;
	MOUSE_RIGHT  = 3;

	image_data = double(imread(image_path)) / 255;
	triangulation = zeros(0,0);
	
	% By default, don't plot the triangular mesh and
	% disable AAM features
	plotri = 0;
	haveaam = 0;   

	if nargin == 1
		template = zeros(0, 2);
	else
		load(template_path);
		
		% Convert from cartesian to image coordinates
		template = xy2ij(annotations, size(image_data,1));
		clear annotations;
	
		i = 1;
		while i < numel(varargin)
			if strcmp(varargin{i}, 'triangulation')
				if haveaam == 0
					% Be sure the triangle indices are unsigned integers.
					triangulation = uint32(varargin{i+1});
					plotri = 1;
				else
					disp '"triangulation" property ignored, using the mesh embedded in the AAM structure'
				end
			elseif strcmp(varargin{i}, 'AAM')
				haveaam = 1;
				plotri = 1;
				AAM = varargin{i+1};
				if size(triangulation, 1) > 0
					disp '"triangulation" property ignored, using the mesh embedded in the AAM structure'
				end
				triangulation = AAM.shape_mesh;
			else
				error(sprintf('Unsupported property: %s.', varargin{i}));
			end
			
			i = i + 2;
		end		
	end
	
	annotations = template;
		
	figure;
  
  % First plot
  plot_bitmap(image_data);
  hold on;
  plot(annotations(:,2), annotations(:,1), 'rx');
  if plotri == 1 && size(triangulation, 1) > 0
  	triplot(triangulation, annotations(:,2), annotations(:,1), 'g');
	end
  hold off; 
  set(gcf, 'Pointer', 'cross'); 
  
  axis off;
  
  button = 0;
  selection = 0;
  
  while button ~= 'q'
	  [j_coord, i_coord, button] = ginput(1);
	  
	  if button == MOUSE_LEFT
	  	% No selection, add annotation
	  	if selection == 0
	  		annotations = [annotations; i_coord j_coord];
	  	% Move selection
	  	elseif selection > 0
	  		annotations(selection,:) = [i_coord j_coord];
	  	% All selected, move the center of gravity of the shape
	  	else
	  		center = mean(annotations, 1);
	  		annotations = annotations + repmat([i_coord j_coord] - center, [size(annotations, 1) 1]);
	  	end
	  elseif button == MOUSE_RIGHT
	  	nearest = 0;
	  	nearest_d = inf;
  		
  		% Find nearest point to the cursor
	  	for i=1:size(annotations, 1)
	  		if norm(annotations(i,:) - [i_coord j_coord]) < nearest_d
	  			nearest = i;
	  			nearest_d = norm(annotations(i,:) - [i_coord j_coord]);
	  		end
	  	end

	  	selection = nearest;
	  elseif button == 'a'
	  	% Select all
	  	selection = -1;
	  elseif button == 'n'
	  	% Select next, if possible
	  	if selection >= 0 && selection < size(annotations, 1)
	  		selection = selection + 1;
	  	else
	  		disp 'Unable to select next element.'
	  	end
	  elseif button == 'p'
	  	% Select previous, if possible
	  	if selection > 1
	  		selection = selection - 1;
	  	elseif selection == 0 && size(annotations, 1) > 0
	  		% Select last
	  		selection = size(annotations, 1);
	  	else
	  		disp 'Unable to select previous element.'
	  	end
	  elseif button == 'd'
	  	% Deselect
	  	selection = 0;
	  elseif button == 'c'
	  	% Cancel selected annotation
	  	if selection > 0
	  		annotations = [annotations(1:selection-1,:); annotations(selection+1:end,:)];
	  		selection = 0;
	  	elseif selection == -1
	  		disp 'To reset all annotations either use \'r\' or restart the procedure.'
	  	else
	  		disp 'Unable to cancel annotation: no selection.'
	  	end
	  elseif button == 'r'
	  	% Reset to the the initial state of the procedure
	  	annotations = template;
	  	if selection > size(annotations, 1)
	  		selection = 0;
	  	end
	   	disp 'Annotations have been reset to default.'
	  elseif button == 'z' 				
       zoom on 
       disp 'Use the mouse to zoom. Press any key when done.'
       set(gcf, 'Pointer', 'cross');
       pause
  	   zoom off
  	elseif button == 't'
  			% Toggle triangular mesh plot
  			plotri = 1 - plotri;
  	elseif button == 'f'
  			% Run a fitting iteration from current shape
  	 		if haveaam == 1
  	 			annotations = fit_2d(AAM, annotations, image_data, 1);
  			end
  	elseif button == '`'
  		% TODO: better error checking
  		if haveaam == 1
	  		% Error image
	  		error_img = reshape(pa_warp(AAM, annotations, image_data), [], 1) - AAM.A0;
	  		% Reconstructed appearance, using the appearance parameters estimated from the error image
	  		fitted_app = reshape(AAM.A0 + AAM.A * (AAM.A' * error_img), [size(AAM.warp_map,1) size(AAM.warp_map,2) size(image_data, 3)]);
	  		
	  		% Backwarp the reconstructed appearance into the current shape
	  		backprj_img = pa_warp(AAM, reshape(AAM.s0, [size(annotations,1) 2]), fitted_app, annotations);
	  		
	  		% Fill the backwarped image with data from the input image
	  		for i=1:size(image_data,1)
	  			for j=1:size(image_data,2)
	  				if (j > size(backprj_img, 2) || i > size(backprj_img, 1)) || sum(backprj_img(i,j,:)) == 0
							backprj_img(i,j,:) = image_data(i,j,:);
						end
					end
				end
	  		
	  		imwrite(backprj_img, sprintf('%s-backprj.jpg', image_path(1:end-4)));
	  	end
  	elseif button == 'l'
  		% TODO: better error checking
  		if haveaam == 1
	  		% Align the current shape to the mean shape
	  		[D Z M] = procrustes(reshape(AAM.s0, [size(annotations, 1) 2]), annotations);
	  		% Reconstructed shape using the shape parameters obtained by projecting the current shape onto the modes
				annotations = reshape(AAM.s0 + AAM.s * (AAM.s' * (reshape(Z, [], 1) - AAM.s0)), [size(annotations, 1) 2]);
				% Restore position, scale, and orientation
				annotations = (annotations - M.c) * (1/M.b) * inv(M.T);
			end
			
    end % if button == 
      
    plot_bitmap(image_data);
    hold on;
    plot(annotations(:,2), annotations(:,1), 'rx');
    
    if plotri == 1 && size(triangulation, 1) > 0
    	triplot(triangulation, annotations(:,2), annotations(:,1), 'g');
  	end
  	
    if selection > 0
    	plot(annotations(selection,2), annotations(selection,1), 'yo');
    elseif selection == -1
    	plot(annotations(:,2), annotations(:,1), 'yo');
    end
    hold off;
    
  end % while button ~= 'q'
  
  close all;  
  
  annotation_path = sprintf('%s.mat', image_path);
  
  % From image coordinates to cartesian coordinates
  annotations = ij2xy(annotations, size(image_data, 1));
  save(annotation_path, 'annotations');

	clear all;
