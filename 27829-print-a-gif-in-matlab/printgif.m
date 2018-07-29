function printgif(varargin)
% printgif(varargin) prints gif files in matlab
%    printgif accepts all print arguments in varargin.
%    printgif ignores all printer drivers passed to it 
%             ('-deps', '-dtiff', etc.)
%    instead it used the -djpeg100' driver and converts 
%      the resulting jpg file to a gif using 
%      imread/rgb2ind/imwrite
%
% EXAMPLE:
%    printgif(gcf,'foo')
%    prints the file foo.gif

% Author: Ben Barrowes 6/2010, Barrowes Consulting, barrowes@alum.mit.edu


drivers={'-dps','-dpsc','-dps2','-dpsc2','-deps','-depsc','-deps2','-depsc2','-dhpgl','-dill','-djpeg','-dtiff','-dtiffnocompression','-dpng','-r'};

%what is the filename? & remove driver(s) if present
driver=[]; fnFound=0;
for i=1:length(varargin)
 if ~fnFound && ischar(varargin{i}) && ...
      length(varargin{i})>0 && ~strncmp(strtrim(varargin{i}),'-',1)
  filename=strtrim(varargin{i});
  % Did they already specify an extension?
  [fnPath,filenameBase,fnExt] = fileparts(filename);
  filenameBaseTemp=[filenameBase,'_temp'];
  varargin{i}=filenameBaseTemp;
  fnFound=1;
 end
 if ischar(varargin{i})
  for j=1:length(drivers)
   if strncmpi(drivers{j},varargin{i},length(drivers{j}))
    driver=unique([driver,i]);
   end
  end
 end
end
vararginNoDrivers=varargin(setxor([1:length(varargin)],driver));

%now print this as a jpeg with maximum quality
print(vararginNoDrivers{:},'-djpeg100');
%read it back in
jpegImage=imread([filenameBaseTemp,'.jpg']);
%convert it to an index format for the imwrite gif command
[gifImage,gifMap] = rgb2ind(jpegImage,256);
%and finally write the gif
imwrite(gifImage,gifMap,[filenameBase,'.gif'],'gif');

% delete the temp jpeg file
delete([filenameBaseTemp,'.jpg']);