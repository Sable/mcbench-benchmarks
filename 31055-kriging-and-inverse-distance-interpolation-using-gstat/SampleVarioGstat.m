function [av_dist,gamma,h,np]=SampleVarioGstat(x,y,z,varargin)
%SampleVarioGstat. Given the sample vector z and the sample locations x,y,
%SampleVarioGstat calculates the experimental variogram using Gstat.
%Varargin is optional or the number of followed by the maximum distance.
%
% INPUTS:
% x :: (vector) sample locations in x
% y :: (vector) sample locations in y
% z :: (vector) sample values
% Optional:
% width  :: (integer) number of lags
% cutoff :: (scalar) maximum distance
%
% Outputs:
% av_dist :: average distance
% gamma   :: semivariance
% h       :: seperation distance
% np      :: number of points for each h.




if nargin < 3
    error('SampleVario:wrongInput', 'Number of inputs must be 3 or 5')
elseif nargin == 5
    width = varargin{1};
    cutoff = varargin{2};
elseif nargin == 3
    fprintf('  Note that gstat may be faster with specified lag and cutoff.\n')
    proceed = input('  Specify parameters (0) or proceed (1)? ');
    if proceed == 1
        width = 0;
        cutoff = 0;
    elseif proceed == 0
        width = input('  Enter number of lags: ');
        cutoff = input('  Enter maximum distance: ');
    else
        error('SampleVario:wrongInput', 'Response must be 0 or 1')
    end
end


% write data file.
Points=[x y z];
fid = fopen('SampleData.dat','w');

fprintf(fid,'%.3f %.3f %.3f\n',Points.');
fclose(fid);

% write gstat command file
fid=fopen('SampleVario.cmd','w');
fprintf(fid,['data(Vario): ''SampleData.dat'', x=1, y=2, v=3;',...
    '\nmethod: semivariogram; \nvariogram(Vario): ''SampleVario.out'';']);

if width
    fprintf(fid,'\nset width = %i;',width);
end
if cutoff
    fprintf(fid,'\nset cutoff = %i;',cutoff);
end
fclose(fid);
fprintf(1,'Calling gstat...');
system('gstat.exe SampleVario.cmd')

%Read the resulting file
fid = fopen('SampleVario.out');
for i=1:8
    fgetl(fid);
end
d=fscanf(fid,'%g');
d=reshape(d,5,length(d)/5)';
fclose(fid);
av_dist=d(:,4);
gamma=d(:,5);
h=(d(:,1)+d(:,2))./2;
np=d(:,3);
end