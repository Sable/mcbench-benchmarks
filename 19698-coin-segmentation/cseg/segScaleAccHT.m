function [result peak_value]= segScaleAccHT(img, minR, maxR, ...
    scaleParam, th, filter_pre, refine_opts)
% function result = segScaleHT(img, minR, maxR, scaleParam, ...
%  th, filter_pre, refine_flag)
% IN:
%  img         grayscale image
%  minR        minimum coin radius in pixel (defaul 80)
%  maxR        maximum coin radius in pixel (defaul 180)
%  scaleParam  either a cell array or a matrix or string
%    if cell array:
%              cell 1: number of levels to recurse (n)
%              cell 2: base for exponential shrinking of accumulator
%                      b^(-n+1) b^(-n+2) ... b^0
%              cell 3: number of bins per level (=HTs per level)
%              cell 4: sigma for gauss filter for accumulator smoothing
%                      (will be scaled with accumulator scale)
%    if matrix:
%      number of colums == levels
%      1st row explicit scalings
%      2nd row explicit number of bins for each level
%      3rd ror explicit sigma values for gaussian filter used in
%                       accumulator smoothing
%    if string:
%      'refine'         as 'quality' but refine afterwards. 
%                       This is the default mode of operation.
%      'quality'        Sets all parameters except img, minR and maxR to 
%                       values tuned for good segmentation. 
%                       This is the default mode of operation.
%      'speed'          Sets all parameters except img, minR and maxR to 
%                       values that tuned for fair segmentation quality 
%                       at improved processing speed. (a factor 0.6 
%                       compared to 'quality' setting is realistic)
%      'noscale'        Similar to Reisert's method. No scaling is done.
%                       4 levels, 4 bins at each level.
%
%    note: a value of 0 for sigma will disable accumulator smoothing
%
%    (default 'quality')
%
% th           threshold value for the gradient. For performance reasons
%              low gradient magnitude values do not get accumulated
%              if th is negative than a relative threshold is applied.
%              abs(th) * max(max(abs(grad(img)))
%
% filter_pre   with this parameter you can specify a filter to be used to
%              smooth the image as a preprocessing step. If you specify
%              nothing a Gaussian filter will be applied per default. If
%              you set this parameter to 'false' preprocessing is disabled.
%              You can specify a scalar sigma value for Gauss FIR filter.
%              If you specify the same scalar value with a negative sign
%              the calculation will be performed separated (using 
%              horizontal and vertical 1D Gauss filters with the specified 
%              sigma.)
%              For large filters this can lead to a performance boost.
%
% refine_opts (default 0)
%             if >0 center and radius get recalibrated in an additional
%             pass masking the image with a ring around the border of the
%             coin. Format is bd_dist or {bd_dist, theta_refine} where 
%             bd_dist is the distance from the border originally found to
%             consider.
%   if cell aray: 
%      cell 1: distance from the border to take into account. Image is
%             masked by a ring.
%      cell 2: threshold to use on gradients for refinement stage.
%             (default th/3)
%      cell 3: r radius of the peak window. A rectangular window of size
%              2r+1 x 2r +1 around the maximum in the accoumulator is 
%              used and the center of gravity computed.
%
% OUT:
%  result      vector : [radius centerY centerX]
%  peak_value  The peakvalue in the accumulator. (mainly for debugging
%              purpose)
%              if r == 0 then no coin was detected

% author:  Christian Kotz
% version: 1.0
% date:    02/15/07
%
% $Id: segScaleAccHT.m,v 1.5 2007/12/03 00:44:34 ck Exp $
%
% $Log: segScaleAccHT.m,v $
% Revision 1.5  2007/12/03 00:44:34  ck
% changed to internal houghpeaks function
%
% Revision 1.4  2007/12/03 00:30:56  ck
% using matlab houghpeaks (with restriction integer removed)
%
% Revision 1.3  2007/11/29 23:31:48  ck
% comment added
%
% Revision 1.2  2007/11/29 23:21:25  ck
% refine added
%
% Revision 1.1  2007/11/29 18:34:06  ck
% fixed help not to include logfile
%
% Revision 1.8  2007/05/07 00:21:07  ck
% Bugfix abs(r) abs removed in nested function!
%
% Revision 1.7  2007/02/21 19:06:13  ck
% help text fixed
%
% Revision 1.6  2007/02/21 18:01:13  ck
% release
% minor changes
%
% Revision 1.5  2007/02/20 22:30:37  ck
% separated gaussfiltering preprocessing added
% specify preprocessing filter by sigma added
% bugfix sign of r in result
%
% Revision 1.4  2007/02/20 13:07:24  ck
% relative threshold added
%
% Revision 1.3  2007/02/15 23:42:24  ck
% default params
%
% Revision 1.2  2007/02/15 21:58:06  ck
% changed default params
% bugfix
%
% Revision 1.1  2007/02/15 20:43:10  ck
% Initial revision
%
%
% (C) Christian Kotz 2007
%
% Note: special thanks to Tao Peng whos code inspired me and taught me
%       the use of 'accumarray' for the circular Hough transform
% 
%       It seems that 'refine' is not more accurate than 'quality'!
%% initializations and argument checking
if nargin < 1
    error 'at least one argument expected.'
end

if nargin < 2
    minR = 80;
end

if nargin < 3
    maxR = 180;
end

if nargin < 4
   scaleParam = 'quality'; 
end

if nargin < 7
   refine_opts = 0;
end

if nargin < 5 
    th = -0.3; 
end

if nargin < 6
   filter_pre = -5.0;
%    filter_pre = fspecial('gaussian', ...
%       [2*(floor(3*sigma_pre))+1 2*(floor(3*sigma_pre))+1], sigma_pre); 
end

if ischar(scaleParam)
  if strcmp(scaleParam, 'refine') 
    refine_opts = {10, -0.01, 3};
  end      
  if strcmp(scaleParam, 'speed')
    scaleParam = {3,3,5,0}; % quite aggressive values :-)    
    th = -0.3;
    filter_pre = -5.0;  
  elseif strcmp(scaleParam, 'quality') || strcmp(scaleParam, 'refine')
    scaleParam = {3,3,8,1};
    th = -0.3;  
    filter_pre = -1.0;  
  elseif strcmp(scaleParam, 'noscale')
    scaleParam = {4,1,4,1}; % quite similar to Reisert
    th = -0.3;  
    filter_pre = -1.0;    
  end
end

if iscell(scaleParam)
    levels = scaleParam{1};
    scalings = scaleParam{2} .^ ((-levels+1):0);
    nbins = repmat(scaleParam{3}, 1, levels);    
    accu_sigma  = scaleParam{4}.* scalings;
 else
    levels      = size(scaleParam, 2);
    scalings    = scaleParam(1,:);
    nbins       = scaleParam(2,:);
    accu_sigma  = scaleParam(3,:);
end    


if ~isa(refine_opts, 'cell')
    refine_opts = {refine_opts, th/3};
end

[h w] = size(img);
%% smooth image
if filter_pre
  if isscalar(filter_pre)
    % separated gauss filtering  
    if filter_pre < 0
      sigma_pre = -filter_pre;  
      filter_pre = fspecial('gaussian', ...
         [1 2*(floor(3*sigma_pre))+1], sigma_pre); 
      img = imfilter(imfilter(single(img), filter_pre), filter_pre');
    else
     % non separated gauss filtering 
       sigma_pre = filter_pre;
       filter_pre = fspecial('gaussian', ...
         [2*(floor(3*sigma_pre))+1 2*(floor(3*sigma_pre))+1], sigma_pre); 
       img = imfilter(single(img), filter_pre);
    end    
  else % filter from argument     
    img = imfilter(single(img), filter_pre);
  end
end
%% gradient
[gx gy]  = gradient(img);
gn = sqrt(gx.*gx + gy.*gy);
% zero divide we threshold anyway (nan instead of 0 don't bother)
warns = warning('off'); 
gdx = gx ./ gn;
gdy = gy ./ gn;
warning(warns);
%% apply threshold to gradient
if th > 0
  gn_mask = (gn > th);
else % relative theshold
    gn_mask = (gn > (max(max(gn)))*-th);
end
gn_mask_idx = find(gn_mask);
[idx_y, idx_x] = ind2sub(size(gn_mask), gn_mask_idx);

recurseOverLevels;

%% optional refinement stage    
    if refine_opts{1}>0        
        cR = abs(result(1));
        cX = result(2);
        cY = result(3);        
        bd = min(cR, refine_opts{1});
        th = refine_opts{2};
        if th > 0            
            gn_mask = (gn > th);
        else % relative theshold
            gn_mask = (gn > (max(max(gn)))*-th);
        end
        gn_mask_idx = find(gn_mask & ringMask(h, w, cR, cX, cY, bd));
        [idx_y, idx_x] = ind2sub(size(gn_mask), gn_mask_idx); 
        result = CHT(cR, 1, false, -refine_opts{3});
        result = result(2:end);
        peak_value = result(1);  
        %TODO refine radius value  
    end

function recurseOverLevels
%% recurse over levels
loR = minR;
hiR = maxR;
% we don't know if coin is brighter or darker than background
directions = [-1 1]; 
for level=1:levels
    if accu_sigma(level) ~= 0
      sigma = accu_sigma(level);
      accu_smoother = fspecial('gaussian',[2*(floor(3*sigma))+1 ... 
          2*(floor(3*sigma))+1],sigma);
    else
      accu_smoother = false;
    end
    step  = (hiR-loR)/nbins(level);
    % setup radius bins
    radiiBins = loR:step:hiR;
    radii = (radiiBins(1:end-1)+radiiBins(2:end))/2; % centers of bins   
    % format of cgt result:
    % accu_max, signed radius, y center , x center
    cgt_result  = zeros(numel(directions)*numel(radii),4);
    n = 1; % index for cgt result
    for d=directions % possibly dark and bright coins
        for r=radii
          cgt_result(n,:) = CHT(d*r, scalings(level), accu_smoother, ...
              level==levels(end));
          n = n + 1;
        end
    end
    best_idx = find(cgt_result(:,1)==max(cgt_result(:,1)));
    best_idx = best_idx(1); % in case of a deuce arbitrary choice
    best = cgt_result(best_idx,:);
    best_r = best(2);
    % consider only either dark or bright coin from now on
    directions = sign(best_r); 
    loR = abs(best_r) - step / 2; % setup new intervall 
    hiR = abs(best_r) + step / 2;
    result = best(2:end);
    peak_value = result(1);    
end

end % subfunction recurseOverLevels

function mask = ringMask(h, w, cR, cX, cY, bd)

    a=(0:(h-1))'-cY;
    b=(0:(w-1))-cX;
    d = (repmat(a.*a, 1, w) + repmat(b.*b, h, 1)); % squard euclidean distances
    rsmall = max(0,cR - bd);
    rbig = cR + bd;
    mask = (d >= (rsmall.*rsmall)) & (d <= (rbig.*rbig) );
  end % subfunction circMask

function result = CHT(r, scale, smoother, want_centers)
    sz_accum = ceil([h w].*scale);
    ah = sz_accum(1);
    aw = sz_accum(2);
%% CHT starts here
    vec_x = floor(0.5 + idx_x + r * gdx(gn_mask_idx));
    vec_y = floor(0.5 + idx_y + r * gdy(gn_mask_idx));
%% scale
    vec_x = floor(0.5 + vec_x .* scale);
    vec_y = floor(0.5 + vec_y .* scale);
%% clip
    valid_vec = ((vec_x > 0) & (vec_y > 0) & (vec_x <= sz_accum(2)) & ...
        (vec_y <= sz_accum(1)));
    % no 0 allowed, so we misuse [1 1]!
    vec_x = vec_x.* valid_vec + ~valid_vec; 
    % no 0 allowed, so we add [1 1]!
    vec_y = vec_y.* valid_vec + ~valid_vec; 
%% convert to indices 
    vec_idx = sub2ind(sz_accum, vec_y, vec_x);
%% accumulate
    accum = accumarray(vec_idx, gn(gn_mask_idx));
    accum = [accum ; zeros(ah*aw - numel(accum), 1)]; % pad last row
    accum(1)=0; % reset misused dummy field
    accum = reshape(accum, ah, aw);
%% smooth accumulator
    if smoother
      accum = imfilter(accum, smoother);
    end
%% maximum search (currently no subpixel accurracy)
      peak = houghpeaksF(double(accum));
      if numel(peak) == 0
          result(1:4) = 0;
      else
        result(1)=accum(peak(1,1),peak(1,2));
        result(2)=r;
        result(3)=peak(1,1);
        result(4)=peak(1,2);
      end  
%     accum_max = max(max(accum));
%     % note: center calculation is usually only performed in the last level
%     result = zeros(1,4);
%     result(1) = accum_max;
%     result(2) = r;
%     if want_centers
%       [centry centrx]=ind2sub(size(accum), find(accum==accum_max(1)));
%       result(3) = centry(1) / scale;
%       result(4) = centrx(1) / scale;
%       if want_centers < 0 % compute of mass
%         cXX = centrx(1);
%         cYY = centry(1);
%         nrx = -want_centers; nry = -want_centers;
%         nrx = min(min(centrx(1)-1, nrx), aw-centrx(1)-1); 
%         nry = min(min(centry(1)-1, nry), aw-centry(1)-1);
%         peak_win = accum(cYY+(-nry:nry),cXX+(-nrx:nrx));
%         dblSum = sum(sum(peak_win));
%         cXX = sum(sum(repmat(cXX+(-nrx:nrx), 2*nry+1,1) .* peak_win))/dblSum;
%         cYY = sum(sum(repmat(cYY+(-nry:nry)', 1, 2*nry+1) .* peak_win))/dblSum;
%         result(3) = cYY / scale;
%         result(4) = cXX / scale;
%       end  
%     end        
    end % sub function
    function peaks = houghpeaksF(h, numpeaks, threshold, nhood)
     if nargin < 2
         numpeaks = 1;
     end
     
     if nargin < 3
         threshold = [];
     end
     
     if nargin < 4
         nhood = [];
     end
        
     if isempty(nhood)
       nhood = size(h)/50; 
       nhood = max(2*ceil(nhood/2) + 1, 1); % Make sure the nhood size is odd.
     end

     if isempty(threshold)
        threshold = 0.5 * max(h(:));
      end

      % initialize the loop variables
      done = false; 
      hnew = h;
      nhood_center = (nhood-1)/2;
      peaks = [];

      while ~done
       [dummy max_idx] = max(hnew(:)); %#ok
       [p, q] = ind2sub(size(hnew), max_idx);
  
       p = p(1); q = q(1);
       if hnew(p, q) >= threshold
         peaks = [peaks; [p q]]; % add the peak to the list
    
         % Suppress this maximum and its close neighbors.
         p1 = p - nhood_center(1); p2 = p + nhood_center(1);
         q1 = q - nhood_center(2); q2 = q + nhood_center(2);
         % Throw away neighbor coordinates that are out of bounds in
         % the rho direction.
         [qq, pp] = meshgrid(q1:q2, max(p1,1):min(p2,size(h,1)));
         pp = pp(:); qq = qq(:);
    
         % For coordinates that are out of bounds in the theta
         % direction, we want to consider that H is antisymmetric
         % along the rho axis for theta = +/- 90 degrees.
         theta_too_low = find(qq < 1);         qq(theta_too_low) = size(h, 2) + qq(theta_too_low);
         pp(theta_too_low) = size(h, 1) - pp(theta_too_low) + 1;
         theta_too_high = find(qq > size(h, 2));
         qq(theta_too_high) = qq(theta_too_high) - size(h, 2);
         pp(theta_too_high) = size(h, 1) - pp(theta_too_high) + 1;
    
         % Convert to linear indices to zero out all the values.
         hnew(sub2ind(size(hnew), pp, qq)) = 0;
    
         done = size(peaks,1) == numpeaks;
       else
         done = true;
       end
      end % while      
    end %subfunction    
end % primary function
