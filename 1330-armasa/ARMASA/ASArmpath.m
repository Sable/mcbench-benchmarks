function ASArmpath

dir_mem = pwd;
cd(matlabroot);

load('ASApath.mat');
for i=1:length(directory)
   rmpath(directory{i});
end

cd(dir_mem);

path2rc;