function [data,info] = load_all_projection_images(folder)
%
%	data = load_all_projection_images(folder)
%
files = dir([folder filesep 'proj_*.mat']);

N = length(files);
datenums = [files.datenum];
[temp,idxes] = sort(datenums);
files = files(idxes);
filenames = {files.name};

fname = filenames{1};
temp = load([folder filesep fname]);
dim = size(temp.proj2d);
data = zeros([dim N],class(temp.proj2d));
for k = 1:N
	fname = filenames{k};
	fprintf('Read %d (%d): %s\n',k,N,fname);
	temp = load([folder filesep fname]);
	data(:,:,k) = temp.proj2d;
end
info = rmfield(temp,{'proj2d','psrc','pcdet','angle','angle_rad'});




