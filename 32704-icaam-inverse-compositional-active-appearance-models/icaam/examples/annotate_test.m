% Test the annotation procedure, the annotation data is backed up so 
% feel free to experiment.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

clear all;

addpath('..');

training_files = dir('cootes/*.bmp.mat');

for i=1:numel(training_files)
	load(sprintf('cootes/%s', training_files(i).name));
	
	app = imread(sprintf('cootes/%s', training_files(i).name(1:end-4)));
	
	% Map RGB colors to [0,1]
	appearances(:,:,:,i) = double(app) ./ 255;
	
	shapes(:,:,i) = xy2ij(annotations, size(app,1));
end
	
load('cootes/triangulation.mat');

test = 23;
template = 22;


AAM = build_model_2d(shapes, appearances, 'triangulation', triangulation);
backup_file = sprintf('cootes/%s.bak', training_files(test).name);
copyfile(sprintf('cootes/%s', training_files(test).name), backup_file);

annotate(sprintf('cootes/%s', training_files(test).name(1:end-4)), sprintf('cootes/%s', training_files(template).name), 'AAM', AAM);

copyfile(backup_file, sprintf('cootes/%s', training_files(test).name));
delete(backup_file);
