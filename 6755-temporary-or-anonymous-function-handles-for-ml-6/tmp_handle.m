function t_handle = tmp_handle(varargin)

% TMP_HANDLE
% syntax:
%  fh = tmp_handle(Function_body, Output_var, [ Input_var(s) ])
%   or
%  tmp_handle  % cleanup only
%
% Function_body is a string or cell array of strings
%  which will evaluate correctly in an m-file
%
% Output_var is a string representing the function return
%  values
%
% Input_var(s) is one or more strings representing the
%  function arguments
%
% Example1:
%  Function handle to convert real, imaginary to magnitude, radians
%
%  >> ri2mr_body = 'm=sqrt(re*re+im*im);\nr=atan2(im,re);\n';
%  >> ri2mr = tmp_handle(ri2mr_body,'[m,r]','re','im')
%  ri2mr = 
%      @th_732337_950
%  >> [a,b]=feval(ri2mr,3,4)
%  a = 5
%  b = 0.9273
%
% Example2:
%  sin for degrees or radians created using a cell array
%   for the function body and one string for both input
%   arguments
%
%  >> sin2_body = { 'if exist(''b'',''var'') && strcmp(b,''d'')', ...
%                   '      a = a * pi / 180;', ...
%                   'end', ...
%                   'c = sin(a);' };
%  >> sin2 = tmp_handle(sin2_body,'c','a,b');
%  >> feval(sin2,45,'d')
%  ans =
%        0.70711
%  >> feval(sin2,pi/4)
%  ans =
%        0.70711
%

% set how_old to the number of days that may elapse
% before tmp_handle deletes a file
how_old = 30;

% capture the date as a number
dn = datenum(date);

% locate & possibly create the "private" directory
pdir2 = fileparts(mfilename('fullpath'));
pdir = [ pdir2 '/private/' ];
if exist(pdir) ~= 7
    mkdir(pdir2, 'private');
end

% clean up the "private" directory
th_files = dir([ pdir 'th_*.m']);
for fname = { th_files(:).name }
    fdate = fname{1}(4:9);
    fdate = str2num(fdate);
    if fdate < (dn - how_old)
        delete([ pdir fname{1} ]);
    end
end

% no error handling implemented yet
%  if not enough args given then
%  just clean up the directory and exit
if (nargin < 2)
    return;
end

% parse the arguments
func_body = varargin{1};
out_var = varargin{2};
in_vars = '';
if nargin >= 3
    in_vars = varargin{3};
    if nargin > 3
        for next_in_var = { varargin{4:end} }
            in_vars = [ in_vars ',' next_in_var{1} ];
        end
    end
end

% come up with a filename
func_name = sprintf('th_%d_%03d', dn, floor(rand*1000));
full_name = sprintf('%s%s.m', pdir, func_name);
while exist(full_name) == 2
    func_name = sprintf('th_%d_%d.m', dn, floor(rand*1000));
    full_name = sprintf('%s%s.m', pdir, func_name);
end

% write out the function m-file
fid = fopen(full_name, 'w');
fprintf(fid, 'function %s = %s(%s)\n',out_var ,func_name, in_vars);
if iscell(func_body)
    fprintf(fid, '%s\n', func_body{:});
else
    fprintf(fid, '%s\n', func_body);
end
fclose(fid);

% rehash is often necessary with networked drives
rehash path;

eval([ 't_handle = @' func_name ';' ]);
