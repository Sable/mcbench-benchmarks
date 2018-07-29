function [out, years] = getigrfcoefs(datadirectory)

% GETIGRFCOEFS Extract IGRF coefficients from .dat files.
% 
% Usage: GETIGRFCOEFS(DATADIRECTORY)
%     or [COEFS, YEARS] = GETIGRFCOEFS(DATADIRECTORY)
% 
% Use this function to extract the IGRF coefficients from .dat files
% provided on the IGRF ftp here:
% 
% ftp://hanna.ccmc.gsfc.nasa.gov/pub/modelweb/geomagnetic/igrf/fortran_code/
% 
% The .dat files should be located in the directory DATADIRECTORY. If
% DATADIRECTORY is unspecified, this function will look for a directory
% called "datfiles" within the directory that this file is in or, if that
% does not exist, will just use the directory that this file is in. The
% coefficients are stored as a structure array with the following fields
% (case-sensitive):
% 
%    -year: Year for the coefficients of that index in the array.
%    -gh: g and h coefficients in a vector.
%    -g: g coefficients in a matrix with each n going down the rows and
%    all of the m's for each n going along the columns.
%    -h: h coefficients in a matrix with each n going down the rows and
%    all of the m's for each n going along the columns.
%    -slope: True if the coefficients are slopes, false otherwise.
% 
% The elements in the structure array will be sorted by year (i.e., the
% first structure in the array will have the earliest year and the last
% structure in the array will have the latest year). This structure array
% and a row vector corresponding to the year of each element in the
% structure array are returned to the user as COEFS and YEARS and no files
% are created if an output is requested from this function. If no outputs
% are requested, the variables COEFS and YEARS are saved to the file 
% igrfcoefs.mat in the same directory as this file as 'coefs' and 'years', 
% respectively.
% 
% Inputs:
%   -DATADIRECTORY: directory where the .dat IGRF coefficients can be
%   found (optional, default is the directory datfiles within the same
%   directory that this function is located or, if that does not exist, the
%   directory where this function is located.
% 
% Outputs:
%   -COEFS: Structure array with fields as explained above.
%   -YEARS: Year of each element in COEFS.
% 
% See also: IGRF, LOADIGRFCOEFS.

% Get the directory with the datfiles.
if nargin < 1 || isempty(datadirectory)
    fpath = mfilename('fullpath');
    fpath = fpath(1:end-length(mfilename));
    if exist(fullfile(fpath, 'datfiles'), 'dir')
        datadirectory = fullfile(fpath, 'datfiles');
    else
        datadirectory = fpath;
    end
end

% Get all the valid coefficient files.
datfiles = dir(fullfile(datadirectory, '*grf*.dat'));

if isempty(datfiles)
    error('getigrfcoef:filesNotFound', ['No valid .dat files found in ' ...
        datadirectory]);
end

years = zeros(1, numel(datfiles));
coefs = struct('year', [], 'g', [], 'h', [], 'gh', [], 'slope', []);
for index = 1:numel(datfiles)
    
    % Read the current file.
    fid = fopen(fullfile(datadirectory, datfiles(index).name));
    if fid == -1
        error('getigrfcoef:fileOpenError', ['Cannot open ' ...
            datfiles(index).name '.']);
    end
    line1 = fgetl(fid);
    line2 = fscanf(fid, '%d %g %g', [1 3]);
    thisnmax = line2(1); thisr = line2(2); thisyear = line2(3);
    thiscoefs = fscanf(fid, '%g', Inf);
    
    % Generate a vector that has all the m indices. It will go
    % [0 1 0 1 2 0 1 2 3 ...].
    mmat = tril(repmat(1:thisnmax, thisnmax, 1))';
    mmat(mmat == 0) = -1;
    mmat = [zeros(1, thisnmax); mmat];
    m = mmat(mmat ~= -1);
    
    % Also generate a vector that has all the n indices. It will go
    % [1 1 2 2 2 3 3 3 3 ...].
    nmat = [1:thisnmax; triu(repmat(1:thisnmax, thisnmax, 1))];
    n = nmat(nmat ~= 0);
    
    % thiscoefs omits h when m = 0. However, it is easier to just set h = 0
    % in those places. Find where those places should be in a full vector:
    m0 = m; m0(m0 == 0) = -1;
    h0 = [m'; m0'] == -1; h0 = h0(:);
    
    % Extract the g and h coefficients from thiscoefs.
    ncoefs = 2*sum((1:thisnmax) + 1);
    coefsvec = zeros(ncoefs, 1);
    coefsvec(~h0) = thiscoefs;
    gvec = coefsvec(1:2:end); hvec = coefsvec(2:2:end);
    
    % Put the coefficients in a matrix with n going down the rows and m
    % down the columns.
    thisg = zeros(thisnmax, thisnmax+1);
    thisg(sub2ind(size(thisg), n, m+1)) = gvec;
    thish = zeros(thisnmax, thisnmax+1);
    thish(sub2ind(size(thisg), n, m+1)) = hvec;
    
    % Save the data to coefs.
    coefs(index).year = thisyear;
    coefs(index).g = thisg;
    coefs(index).h = thish;
    coefs(index).gh = thiscoefs;
    coefs(index).slope = ~isempty(regexpi(datfiles(index).name, ...
        '\wgrf\d\d\d\ds.dat', 'once'));
    
    % Save the year for sorting later.
    years(index) = thisyear;
    
end

% Sort coefs based on the year.
[tmp, sortind] = sort(years);
coefs = coefs(sortind); years = years(sortind);

if nargout >= 1
    out = coefs;
else
    % Save coefs.
    save(fullfile(fpath, 'igrfcoefs.mat'), 'years', 'coefs');
end