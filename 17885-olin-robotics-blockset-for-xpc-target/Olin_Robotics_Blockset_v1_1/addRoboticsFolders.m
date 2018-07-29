addpath(genpath(pwd))
x = input('Would you like to save the path for the next session of MATLAB? (y/(n))','s');
if (isempty(x))
    x = 'n';
end

if x=='y' || x=='Y'
    savepath
    disp('Path saved.')
else
    disp('Path added, but not saved.  It will only be used for this session of MATLAB.')
end
