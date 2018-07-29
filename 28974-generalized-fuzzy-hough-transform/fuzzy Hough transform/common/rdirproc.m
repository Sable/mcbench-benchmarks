function error = rdirproc(wdir, varargin)
%
% Inputs
% wdir:         working directory
% varargin{1}:  verbose the processing info ('true' or 'false')
%
% Outputs
% error:        'true' or 'false' for checking the final results

% parsing inputs
error = true;
if nargin == 1
    verbose = true;
elseif nargin == 2
    verbose = varargin{1};
else
    return;
end
cdir = pwd; % current directory

% recursive directory list in 'dir_list'
list = genpath(wdir);
ext = ';'; i = 1;
while ~isempty(ext)
    [dir_i, ext] = strtok(list, ';');
    if ~isempty(dir_i)  
        dir_list{i,1} = dir_i;
    end
    list = ext(2:end);
    i = i+1;
end

% =================== START algorithm params
% =================== END algorithm params

% file processing
count = 1;
for i = 1:length(dir_list)
    cd(dir_list{i});
    d = dir(dir_list{i});
    for j = 3:length(d)
        if verbose
            clc;
            disp(['processing directory ' num2str(i) ' of ' num2str(length(dir_list))]);
            disp(['processing file ' num2str(j-2) ' of ' num2str(length(d)-2)]);
        end
        if ~d(j).isdir
            % =================== START processing block
            [name, ext] = strtok(d(j).name, '.');
            if strcmp(ext, '.bmp')
                delete(d(j).name);
                count = count + 1;
            end
            % =================== END processing block
        end
    end
end
cd(cdir);

% ========== plots

error = false;