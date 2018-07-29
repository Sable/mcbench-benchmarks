function [y, opty] = colwavelift(x, optx, L, direction, mode)
%COLWAVELIFT  performs a single-level one-dimensional wavelet 
%decomposition/construction based on lifting method.
% 
% x, optx: 1-D column array or 2-D matrix.
%   If 2-D matrix is used, the computation is carried on every COLUMNs.
%   optx can be omitted. If not, x is regarded as the even subsequence
%   of the original signal to be transformed, while optx is the odd
%   subsequence, which has the column numbers with x.
%
% L: 1-by-1 structure with two fields lamdaz and K.
%   K is two-element vector [K0, K1], which is the lifting gains.
%   lamdaz is 1-by-M structure if M lifting units are used.
%     lamdaz's two fields coeff and zorder denote the transfer
%     function of every lifting units lamda(Z)
%   e.g. for a wavelet transform with 3 lifting units as
%     lamda1 = a1+a2*z, lamda2 = b1+b2*z^-1, lamda3 = c1*z^(-1)+c2*z
%     and the lifting gains K0 and K1
%   L is to be organized as
%     lamdaz = struct('coeff', {[a1, a2], [b1, b2], [c1, c2], ...
%                    'zorder', {[ 0,  1], [ 0, -1], [-1, 1 ]} );
%     L = struct('lamdaz', lamdaz, 'K', [K0, K1]);
%   With the structure, the lifting process is convenient to reuse.
%
% direction:  'd', 'f', 'dec' or 'forward' 
%                          to indicate decomposition/forward lifting;
%             'r', 'i', 'b', 'rec', 'inverse' or 'backward'
%                          for reconstruction/inverse lifting.
%
% mode: 'lossless' to perform nonlinear approximate lifting for the sake
%                  of lossless compression applications
%       'lossy' to perform common linear lifting structure
%
% Output opty can be omitted. If not, y is denoted the even subsequence
%   of the obtained signal after the lifting process, while opty is the
%   odd subsequence.
%
% Syntax can be used to call COLWAVELIFT:   
%   y = colwavelift(x, L, 'd', 'lossy');
%   y = colwavelift(x0, x1, L, 'd', 'lossy');
%   [y0, y1] = colwavelift(x, L, 'd', 'lossy');
%   [y0, y1] = colwavelift(x0, x1, L, 'd', 'lossy');
%
% Reference:
%   [1] D.S.Taubman et al., JPEC2000 Image Compression: F. S. & P.,
%       Chinese Edition, section 6.4, 6.5, 10.3 and 10.4
%   [2] Pascal Getreuer, waveletcdf97.m from Matlab file Exchange website
%
% Contact information: 
%   Email/MSN messenger:  wangthth@hotmail.com
%
% Tianhui Wang at Beijing, China,  Aug 5, 2006
%                  Last Revision:  Aug 6, 2006

%---------------------- input arguments checking  ----------------------%
error(nargchk(4, 5, nargin));
if nargin == 4
    mode = direction;
    direction = L;
    L = optx;
end
% check optx
if nargin == 5
    if size(optx, 2) ~= size(x, 2)
        error('COLWAVELIFT:InArgErr', ['The first two arguments must' ...
        ' have the same column numbers.']);
    end
    if ~isreal(optx) || ~isnumeric(optx) || (ndims(optx) > 2)
        error('COLWAVELIFT:InArgErr', ['The second arguments must' ...
        ' be a real, numeric 2-D or 1-D matrix.']);
    end
end
% check x
if ~isreal(x) || ~isnumeric(x) || (ndims(x) > 2)
    error('COLWAVELIFT:InArgErr', ['The first argument must' ...
    ' be a real, numeric 2-D or 1-D matrix.']);
end
% check direction
if ischar(direction) && ismember(direction, {'d', 'dec', 'f', 'forward'})
    direction = 'd';
elseif ischar(direction) && ismember(direction, {'r', 'rec', ...
        'b', 'backward', 'i', 'inverse'})
    direction = 'r';
else
    error('COLWAVELIFT:InArgErr', ['For the last argument, use ''d'' ' ...
        'to denote decomposition/forward lifting \n or ''r'' for ' ...
        'reconstruction/inverse lifting.']);
end
% check mode
if ~ischar(mode) || ~ismember(mode, {'lossy', 'lossless'})
	error('COLWAVELIFT:InArgErr', ['The last argument must be either' ...
        ' ''lossy'' or ''lossless'' to decide the reversibility.']);
end
% check L
% a thorough check on L is too lengthy. see the comment lines 
% for the way L is organized
if ~isstruct(L)
    error('COLWAVELIFT:InArgErr', ['Use a Matlab data type' ...
        ' ''structure'' to denote the lifting structure. \n Type' ...
        ' ''help colwavelift'' to see the way the structure shall be' ...
        ' organized.']);
end
%-----------------------  input pretreatment ---------------------------%
% use notation y y0 y1 and clear x optx
if nargin == 4 % without optx
    y0 = x(1:2:end, :);
    y1 = x(2:2:end, :);
    y = x;
else % nargin == 5, ie, with optx
    y0 = x;
    y1 = optx;
    y = zeros(size([y0; y1]));
    y(1:2:end, :) = y0;
    y(2:2:end, :) = y1;
end
clear x optx;
sy = size(y);
% for unit-length seqence, skip lifting precess, ie, return y = x
if size(y, 1) > 1
    ry0 = size(y0, 1);  % y y0 y1 are changing during extension and
    ry1 = size(y1, 1);  % lifting and inverse lifting processes, while 
                        % sy ry0 ry1 remain unchanged for use
    len = length(L.lamdaz);
    % default plus/minus switch for core lifting process
    eval('plusminus = 1;');
%---------------------    symmetric extension    -----------------------%
% Difficulty lies in the boundary handling. For the sake of the
% adaptability of lifting structure L, more general but more complex
% treatment is employed here. Note for a single realization of FWT, eg. 
% for cdf9/7 or spline5/3, simpler algorithm can be used.    
    % compute the lift and right shifts needed for x0 or x1
    temp = [L.lamdaz.zorder];
    rshift = - sum( temp(find(temp<0)) ) * 2;
    lshift = sum(temp) * 2 + rshift;
    if ry1 ~= ry0
        rshift = rshift + 1;
    end
    % extension
    for i = 1: max(lshift, rshift)
        y = [y(2*i, :); y; y(sy(1)-1, :)];
    end
    if rshift > lshift
        y = y(rshift-lshift+1:end, :);
    elseif rshift < lshift
        y = y(1:end+rshift-lshift, :);
    end
    % get even and odd subsequences with extensions to be lifted
    y0 = y(1:2:end, :);
    y1 = y(2:2:end, :);
    clear y;    
%---------  additional input pretreatment for inverse lifting  ---------%
% algorithm: modify the input of inverse lifting to include the inverse 
% process in the same framework(core lifting process) with forward lifting.
    if strcmp(direction, 'r')
        % move lifting gains to front
        y0 = y0 / L.K(1);  L.K(1) = 1;
        y1 = y1 / L.K(2);  L.K(2) = 1;
        % if lamdas' number is even, x0 and x1 shall be exchanged and 
        % after forward lifting exploited, corresponding output y0 and y1
        % are to be exchanged back
        if rem(len,2) == 0
            temp = y0;
            y0 = y1;
            y1 = temp;
        end
        % reversely place the lamdas
        for i = 1: floor(len/2)
            temp = L.lamdaz(i).coeff;
            L.lamdaz(i).coeff = L.lamdaz(len-i+1).coeff;
            L.lamdaz(len-i+1).coeff = temp;            
            temp = L.lamdaz(i).zorder;
            L.lamdaz(i).zorder =  L.lamdaz(len-i+1).zorder;
            L.lamdaz(len-i+1).zorder = temp;
        end
        % set plus/minus switch for the core lifting process
        eval('plusminus = -1;');
    end
%-----------------------   core lifting process  -----------------------%        
    for i = 1: len
        % lamdaz(i) ** y_(rem(i-1,2)). ** denotes convolution here 
        eval('yconv = zeros(size(y0));');
        for j = 1: length(L.lamdaz(i).zorder)
            % the use of circshift is only to achieve concise writing and
            % the overflowed samples on both sides can be simply dropped
            eval(['yconv = yconv +  circshift(y' num2str(rem(i-1,2)) ...
                    ', -L.lamdaz(i).zorder(j)) * L.lamdaz(i).coeff(j);']); 
        end
        % lossy: y_(rem(i,2)) = y_(rem(i,2))+ lamdaz(i) ** y_(rem(i,2))
        % lossless: 
        % y_(rem(i,2)) = y_(rem(i,2)) + floor(0.5+lamdaz(i)**y_(rem(i,2)))
        % change + to - for reconstruction/inverse lifting 
        if strcmp(mode, 'lossy')
            eval(['y' num2str(rem(i,2)) ' = y' num2str(rem(i,2)) ...
                ' + yconv * plusminus;']);
        else % 'lossless'
        	eval(['y' num2str(rem(i,2)) '= y' num2str(rem(i,2)) ...
                ' + floor(yconv + .5) * plusminus;']);
        end
    end
%----------  additional post-treatment for inverse lifting  ------------%
    if strcmp(direction, 'r') && rem(len,2) == 0
        temp = y0;
        y0 = y1;
        y1 = temp;
    end
%-----------------------   de-extension    -----------------------------%
	% remove the extended part and multiply by gains
    y0 = y0(1+lshift/2 : end-floor(rshift/2), :) * L.K(1);
    y1 = y1(1+lshift/2 : end-floor(rshift/2), :) * L.K(2);
    % delete the column having added for odd-length input
    if ry1 < ry0
        y1 = y1(1:end-1, :);
    elseif ry1 > ry0
        y0 = y0(1:end-1, :);
    end
end
%--------------------------   output process   -------------------------%
if nargout == 1
    y = zeros(sy);
    y(1:2:end, :) = y0;
    if sy(1) > 1
        y(2:2:end, :) = y1;
    end
elseif nargout == 2
    y = y0;
    opty = y1;
else
    error('COLWAVELIFT:OutArgErr', ['Invalid output argument numbers. '...
        'Use ''help wavecdf97lift'' for help.']);
end
% EOF