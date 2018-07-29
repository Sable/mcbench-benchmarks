% Add the relevant sub directories

GLG_dir = pwd;

% Make sure there is a '/' at the end
if GLG_dir(end) ~= filesep
    GLG_dir = [GLG_dir filesep];
end

% Add paths
addpath(GLG_dir);
addpath([GLG_dir 'GLG']);
addpath([GLG_dir 'INLA']);
addpath([GLG_dir 'GFM']);
addpath([GLG_dir 'INLA']);
addpath([GLG_dir 'examples']);
