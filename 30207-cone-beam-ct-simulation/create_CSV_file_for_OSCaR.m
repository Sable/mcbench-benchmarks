function [data,info] = create_CSV_file_for_OSCaR(folder)
%
%	data = create_CSV_file_for_OSCaR(folder)
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
I_0 = zeros(N,1);
theta = zeros(N,1);
for k = 1:N
	fname = filenames{k};
	fprintf('Read %d (%d): %s\n',k,N,fname);
	temp = load([folder filesep fname]);
	data(:,:,k) = temp.proj2d;
	I_0(k) = max(temp.proj2d(:));
	theta(k) = temp.angle;
end
info = rmfield(temp,{'proj2d','psrc','pcdet','angle','angle_rad'});


u_off = (dim(2)+1)/2;
v_off = (dim(1)+1)/2;


csv_filename = [folder filesep 'OSCaR_data.csv'];
fp = fopen(csv_filename,'w');
if fp<0
	uiwait(msgbox('Cannot create a new CSV file','warning','warn'));
	return;
end

for k = 1:N
	% Proj_00588.tif, -150.020000, 128.500000, 96.500000, 43306.000000, 1.0
	fprintf(fp,'%s,%.2f,%.2f,%.2f,%f,%f\n',filenames{k},theta(k),u_off,v_off,I_0(k),1);
end


fclose(fp);


