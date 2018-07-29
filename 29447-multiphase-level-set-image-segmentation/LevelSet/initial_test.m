function x=initial_test(x_iteration, x_region, x_frequency, x_noise, x_curvature, x_time)

x=0;
if str2num(x_iteration)<2 || str2num(x_iteration)>100000
    errordlg('the number of iteration is between 2 and 100000','LS Error','modal');
    x=1;
end

if str2num(x_region)<2 || str2num(x_region)>22
    errordlg('the number of region is between 2 and 22','LS Error','modal');
    x=1;
end

if str2num(x_frequency)<1 || str2num(x_frequency)>1000
    errordlg('the frequency of saving is between 1 and 1000','LS Error','modal');
    x=1;
end

if str2num(x_noise)<0 || str2num(x_noise)>5
    errordlg('the variance of noise is between 0 and 0.5','LS Error','modal');
    x=1;
end

if str2num(x_curvature)<0 || str2num(x_curvature)>50
    errordlg('the curvature factor is between 0 and 6','LS Error','modal');
    x=1;
end

if str2num(x_time)<0 || str2num(x_time)>2
    errordlg('the delta time is between 0 and 2','LS Error','modal');
    x=1;
end

if mod(str2num(x_iteration), str2num(x_frequency))~=0
    errordlg('the number of iteration must be a multiple of the frequency of saving','LS Error','modal');
    x=1;
end

if str2num(x_iteration)<= str2num(x_frequency)
    errordlg('the number of iteration must be superior of the frequency of saving','LS Error','modal');
    x=1;
end