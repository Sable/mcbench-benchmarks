function y = wavelift(x, nlevel, wname)
%WAVELIFT: Multi-level discrete two-dimension wavelet transform
%based on lifting method.
%
% c = wavelift(x, nlevel, wname) performs the follows according to the 
% value of nlevel:
%   nlevel > 0:   decomposes 2-dimension matrix x up to nlevel level;
%   nlevel < 0:   does the inverse transform to nlevel level;
%   nlevel = 0:   sets c equal to x;
%
% wname is name of wavelet used for DWT or IDWT. It can be omitted. 
% If so, WAVELIFT use the default Cohen-Daubechies-Feauveau (CDF) 9/7 
% wavelet, which is the name 'cdf97'.Currently, WAVELIFT only support
% two kind of wavelets, i.e. cdf97 and spline 5/3 with the name 'spl53'.
% However, aided with the organized lifting structure illustrated below,
% it is adaptive to other specific lifting realizations. The only thing
% needed in most cases is only to modify the structure L and the mode to
% indicate lossy or lossless compression.
%
% WAVELIFT call another function COLWAVELIFT to perform 1-D FWT based on
% lifting method. Deliberately organized lifting structure is provided 
% to COLWAVELIFT as a major parameter.
%   
% The lifting structure is organized as follows:
% L: 1-by-1 structure with two fields lamdaz and K.
%   K is two-element vector [K0, K1], which is the lifting gains.
%   lamdaz is 1-by-M structure if M lifting units are used.
%     lamdaz's two fields coeff and zorder denote the transfer function
%     of every lifting units lamda(Z)
%   e.g. for a wavelet transform with 3 lifting units as
%     lamda1 = a1+a2*z, lamda2 = b1+b2*z^-1, lamda3 = c1*z^(-1)+c2*z
%     and the lifting gains K0 and K1
%   L is to be organized as
%     lamdaz = struct('coeff', {[a1, a2], [b1, b2], [c1, c2], ...
%                    'zorder', {[ 0,  1], [ 0, -1], [-1, 1 ]} );
%     L = struct('lamdaz', lamdaz, 'K', [K0, K1]);
%
% You can test WAVELIFT with following lines:
%   x=imread('E:\study\jpeg2000\images\lena.tif');
%   % see the decomposition coefficients 
%   y=wavelift(x, 1, 'spl53'); % using lossless spline 5/3 wavelet
%   figure; subplot(1,2,1); imshow(x); subplot(1,2,2); imshow(mat2gray(y))
%   % see the reconstruction precision
%   yy=wavelift(x, 5); % using lossy cdf 9/7 wavelet
%   ix=wavelift(yy, -5); % inverse
%   sum(sum((double(x)-ix).^2))
% 
% Reference:
%   [1] D.S.Taubman et al., JPEC2000 Image Compression: F. S. & P.,
%       Chinese Edition, section 6.4, 6.5, 10.3 and 10.4
%   [2] Pascal Getreuer, waveletcdf97.m from Matlab file Exchange website
%
% Cantact information: 
%   Email/MSN messenger: wangthth@hotmail.com
%
% Tianhui Wang at Beijing, China,  Aug 5, 2006
%                  Last Revision:  Aug 6, 2006

%----------------------- input arguments checking ----------------------%
error(nargchk(2, 3, nargin));
% default decomposition/forward lifting level
if nargin < 3
    wname = 'cdf97';
end
% check nlevel
if ~isreal(nlevel) || ~isnumeric(nlevel) || round(nlevel)~=nlevel
    error('WAVELIFT:InArgErr', ['The 2nd argument shall be ' ...
        'a real and numeric integer.']);
end
% check x
if ~isreal(x) || ~isnumeric(x) || (ndims(x) > 2)
    error('WAVELIFT:InArgErr', ['The first argument must' ...
        ' be a real, numeric 2-D or 1-D matrix.']);
end
if isinteger(x)
    x = double(x);
end
% check wname
if ~ischar(wname) || ~ismember(wname, {'cdf97', 'spl53'})
    error('WAVELIFT:InArgErr', ['The last argument must be a wavelet ' ...
        'name. \nCurrently only ''cdf97'' and ''spl53'' are supported.']);
end
%------------- forming lifting structure and lifting mode --------------%
switch wname
    case 'cdf97'
       lamdaz=struct('coeff',{[-1.5861343420693648,-1.5861343420693648],...
                              [-0.0529801185718856,-0.0529801185718856],...
                              [ 0.8829110755411875, 0.8829110755411875],...
                              [ 0.4435068520511142,0.4435068520511142]},...
                   'zorder', {[0 1], [0 -1], [0 1], [0 -1]});
       L=struct('lamdaz',lamdaz,'K',[1/1.230174104914, 1.230174104914/2]);
       % the line below is another version of K used by P.Getreuer[2]
       % L = struct('lamdaz', lamdaz, 'K', ...
       %    [1.1496043988602418, 1/1.1496043988602418]);
       mode='lossy';
    case 'spl53'
       lamdaz = struct('coeff',  {[-.5, -.5], [.25 .25]}, ...
                       'zorder', {[ 0,   1 ], [ 0, -1 ]});
       L = struct('lamdaz', lamdaz, 'K', [1, 1/2]);
       mode='lossless';
end
clear lamdaz;
% set y be x for the sake of lifting processes
% and also for the case of nlevel = zero
y = x;
%-----------  decomposition/forward lifting,  when nlevel > 0  ---------%
if nlevel > 0
    for i = 1:nlevel
        sx = size(x);
        % first lift all columns of x
        [temp0, temp1] = colwavelift(x, L, 'd', mode);
        % the inverse lifting for rows of temp0 and temp1 can be 
        % performed simultaneously using 1-D column lifting process
        [temp0, temp1] = colwavelift([temp0; temp1]', L, 'd', mode);
        temp = [temp0', temp1'];
        % update coefficient matrix
        y(1:sx(1), 1:sx(2)) = temp;
        % replace x with temp upper left quarter for next level FWT
        x = temp(1:ceil(sx(1)/2), 1:ceil(sx(2)/2)); 
        % give a warning if nlevel is too large
        if size(x,1)<=1 && size(x,2)<=1 && i~=nlevel
            warning('WAVELIFT:InArgDegrade', ['Only decompose to ' ...
                num2str(i) '-level instead of ' num2str(nlevel) ...
                ', \nas the approximation coefficients at ' num2str(i) ...
                '-level has row or/and column of length 1.']);
            break
        end
    end
%------------  reconstruction/inverse lifting,  if nlevel < 0  ---------%
else
    sx = size(x);
    % reconstruction level
    nl = -nlevel;
    while sx(1)/2^nl<=1/2 && sx(2)/2^nl<=1/2,  nl = nl-1;  end
    if nl ~= -nlevel 
        warning('WAVELIFT:InArgDegrade', ['Only reconstruct to ' ...
            num2str(nl) '-level instead of ' num2str(-nlevel) ...
            ', \n as the approximation coefficients at ' num2str(nl) ...
            '-level has row or/and column of length 1.']);
    end
    % 2-D reconstruction
    for i = 1 : nl
        % find the target LL block
        sTarget = ceil(sx/2^(nl-i));
        target = y(1:sTarget(1), 1:sTarget(2));
        % perform inverse lifting for all rows using column 1-D lifting
        sLL = ceil(sTarget/2);
        temp0 = target(:, 1: sLL(2));
        temp1 = target(:, sLL(2)+1:end);
        temp = colwavelift(temp0', temp1', L, 'r', mode);
        temp = temp';
        % with the upper half of temp being the even sequences and the 
        % lower half being the odd, perform inverse lifting 
        % simultaneously for all columns
        temp0 = temp(1: sLL(1), :);
        temp1 = temp(sLL(1)+1 :end, :);
        temp = colwavelift(temp0, temp1, L, 'r', mode);
        % update y with the new LL block
        y(1:sTarget(1), 1:sTarget(2)) = temp;
    end
end
% EOF