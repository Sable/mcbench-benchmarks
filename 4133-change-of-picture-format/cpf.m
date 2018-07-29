function cpf(fig_no,target_name,format)
% This function cpf.m (change picture format)
% takes a picture in one format
% and saves it in another format.
%
% Syntax: load_pics(fig_no,target_name,format)
% e.g.  : load_pics(1,'holiday_on_Bornholm.bmp','epsc2');
%
% fig no      : Figure number where the figure is displayed
% target_name : Filename of new file. target_name = ''
%               gives target_name=input_filename.
% format      : One of the output formats availeble in MATLAB,
%               type "help fileformats" or
%                    "help print"

if nargin ~= 3
 error('Please specify: fig no., target name and output format');
end

% Pick file
[filename, pathname,filterspec] = uigetfile('*.*');

if strcmp(target_name,'')
    target_name = filename(1:end-4);
end

% Load file as image
[A,map]=imread(filename);

% Display image
figure(fig_no)
clf
image(A);
colormap(map);
axis equal off

% Save in new format
saveas(fig_no,target_name,format);