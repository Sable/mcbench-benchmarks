function mat7to6(filename)

v = ver('MATLAB');
p = strfind(v.Version, '.');
if str2num(v.Version(1:(p(1)-1)))<7
    error('MATLAB 7.0 or higher is required!');
end

v7 = load(filename);
v7names = fieldnames(v7);

cmdline = ['save ' filename ' -v6'];

for ii=1:length(v7names)
    eval([char(v7names(ii)) '=' 'v7.' char(v7names(ii)) ';']);
    cmdline = [cmdline ' ' char(v7names(ii))];
end

cmdline = [cmdline ';'];
disp(cmdline);
eval(cmdline);



