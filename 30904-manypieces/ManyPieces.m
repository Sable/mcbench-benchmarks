function [] = ManyPieces()
%MANYPIECES Produce a photomosiac from an image and a directory of images
%   Given an image and a directory of images create a photomosaic
%	Paramets may be modified within m file
%	Written by Justin Dailey
%	dailejl@auburn.edu

%Mosaic Parameters
%Number of thumbs spanning width of img
thumb_ratio = 100;
%Default thumb directory (only if saving thumbs)
thumb_dir = strcat(pwd, filesep, 'Thumbs');
%Coefficient for scaling of output tiles
output_scale = 2;
%Output file name
output_file_name = 'Mosaic.jpg';
%Dithering distance
dval = 1;

%List of file types
file_types = {['*.BMP;*.GIF;*.HDF;*.JPEG;*.JPG;*.PBM;*.PCX;*.PGM;',...
    '*.PNG;*.PNM;*.PPM;*.RAS;*.TIFF;*.TIF;*.XWD'],'MATLAB Graphical Files'};
comp_file_types = {'BMP' 'GIF' 'HDF' 'JPEG' 'JPG' 'PBM' 'PCX' 'PGM' ...
    'PNG' 'PNM' 'PPM' 'RAS' 'TIFF' 'TIF' 'XWD'};

%% Get main image and directory of images
img_path = uigetfile(file_types, 'Select the main mosiac image');
img_dir = uigetdir();

%Get original img size
ref_img = imread(img_path);
img_size = size(ref_img);
img_size = img_size(1:2);

%% Calc values
%Set size for thumbnail based on original size
thumb_pixels = floor(img_size(1)/thumb_ratio);
thumb_size = [thumb_pixels thumb_pixels];
%Make sure h/w are proportional to thumb size
new_height = floor(img_size(2)/thumb_pixels);
num_tiles = [thumb_ratio new_height];
new_size = [thumb_ratio new_height].*thumb_pixels;
ref_img = imresize(ref_img, new_size);

%% Get all directory images
dir_files = dir(img_dir);
mosaic_ind = 1;
%For each image add it to array
for dir_ind = 1:length(dir_files)
    if ~dir_files(dir_ind).isdir
        file_name = dir_files(dir_ind).name;
        %Check file extension
        [~, ~, ext, ~] = fileparts(file_name);
        if max(strcmpi(ext(2:end), comp_file_types))
            mosaic_files{mosaic_ind} = file_name;
            mosaic_ind = mosaic_ind+1;
        end
    end
end

%% Resize directory images into thumbs
progress = waitbar(0, 'Creating Mosaic Thumbnails...');
num_files = length(mosaic_files);
mosaic_imgs = cell(1, num_files);
%mkdir(thumb_dir);
%Resize each image
for mosaic_ind = 1:num_files
    img = imread([img_dir, filesep, mosaic_files{mosaic_ind}]);
    %if read in grayscale img
    if size(img, 3) == 1
        img = ind2rgb(img, gray(256));
    end
    res_img = uint8(imresize(img, thumb_size*output_scale));
    thumbs{mosaic_ind} = res_img;
    %imwrite(res_img, [thumb_dir, filesep, strcat(num2str(mosaic_ind),'.jpg')], 'jpg');
    waitbar(mosaic_ind/num_files, progress);
end
close(progress);

%% Calculating thumbnail averages
progress = waitbar(0, 'Calculating Thumbnail Averages...');
for mosaic_ind = 1:num_files
    %calc average vals for thumbs
    cur_thumb = thumbs{mosaic_ind};
    RGB_vals{mosaic_ind} = mean(reshape(cur_thumb, [], 3), 1);
    waitbar(mosaic_ind/num_files, progress);
end
close(progress);

%% For each tile of image find closest matching thumb
progress = waitbar(0, 'Creating Photomosiac...');
pic_map = zeros(num_tiles);
tiles_done = 0;
for row_tile = 1:num_tiles(1)
    for col_tile = 1:num_tiles(2)
        closest = 1;
        shortest_dist = 1000;
        %get mean vals for the image tiles
        cur_tile = ref_img(thumb_pixels*(row_tile-1)+1:thumb_pixels*(row_tile), ...
        thumb_pixels*(col_tile-1)+1:thumb_pixels*(col_tile),:);
        cur_RGB = mean(reshape(cur_tile, [], 3), 1);
        %find the closest thumb to each tile
        for thumb_tile = 1:num_files
            dist = calc_distance(RGB_vals{thumb_tile}, cur_RGB);
            %if new pt is closer
            if dist < shortest_dist
                %implement dithering to limit use of tile in an area
                if isempty(find( ...
                        pic_map(max(row_tile-dval,1): ...
                        min(row_tile+dval,num_tiles(1)),... 
                        max(col_tile-dval,1): ...
                        min(col_tile+dval,num_tiles(2))) ... 
                        == thumb_tile, 1))
                    shortest_dist = dist;
                    pic_map(row_tile, col_tile) = thumb_tile;
                end
            end
        end
        tiles_done = tiles_done + 1;
        waitbar(tiles_done/(num_tiles(1)*num_tiles(2)), progress);
    end
end
close(progress);

%% Take mapping of thumbnails and create photomosaic
progress = waitbar(0, 'Assembling Photomosaic...');
for row_tile = 1:num_tiles(1)
    cur_row = thumbs{pic_map(row_tile, 1)};
    for col_tile = 2:num_tiles(2)
        cur_row = horzcat(cur_row, thumbs{pic_map(row_tile, col_tile)});
    end
    if row_tile == 1
        mosaic = cur_row;
    else
        mosaic = vertcat(mosaic, cur_row);
        clear cur_row;
    end
    waitbar(row_tile/num_tiles(1), progress);
end
close(progress);

imshow(mosaic)
imwrite(mosaic, output_file_name, 'jpg');
end

function distance = calc_distance(pt1, pt2)
    distance = sqrt(sum((pt1-pt2).^2));
end