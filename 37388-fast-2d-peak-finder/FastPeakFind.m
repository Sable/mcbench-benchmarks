function  [cent, varargout]=FastPeakFind(d, threshold, filt ,edg, fid)
% Analyze noisy 2D images and find peaks to 1 pixel accuracy.
% The code is desinged to be as fast as possible, so I kept it pretty basic.
% The code assumes that the peaks are relatively sparse, test whether there
% is too much pile up and set threshold or user defined filter accordingly.
%
% Inputs:
%   d           The 2D data raw image - assumes a Double\Single-precision
%               floating-point, uint8 or unit16 array. Please note that the code
%               casts the raw image to uint16 if needed.  If the image dynamic range is
%               between 0 and 1, I multiplied to fit uint16. This might not be optimal for
%               generic use, so modify according to your needs.
%   threshold   A number between 0 and max(raw_image(:)) to remove  background
%   filt        A filter matrix used to smooth the image. The filter size
%               should correspond the characteristic size of the peaks
%   edg         A number>1 for skipping the first few and the last few 'edge' pixels
%   fid         In case the user would like to save the peak positions to
%               a file, the code assumes a "fid = fopen([filename], 'w+');" line
%               in the script that uses this function. 
%
% Optional Outputs:
%   cent        a 1xN vector of coordinates of peaks (x1,y1,x2,y2,...
%   [cent cm]   in addition to cent, cm is a binary matrix  of size(d) 
%               with 1's for peak positions.
%
%   Example:
%
%   p=FastPeakFind(image);
%   imagesc(image); hold on
%   plot(p(2:2:end),p(1:2:end),'r+')
%
%
%   Natan (nate2718281828@gmail.com)
%   Ver 1.61 , Date: June 5th 2013
%
%
%% defaults
if (nargin < 1)
    d=uint16(conv2(reshape(single( 2^14*(rand(1,1024*1024)>0.99995) ),[1024 1024]) ,fspecial('gaussian', 15,3),'same')+2^8*rand(1024));
    imagesc(d);
end

if ndims(d)>2 %I added this in case one uses imread (JPG\PNG\...).
    d=uint16(rgb2gray(d));
end

if isfloat(d) %For the case the input image is double, casting to uint16 keeps enough dynamic range while speeds up the code.
    if max(d(:))<=1
        d =  uint16( d.*2^16./(max(d(:))));
    else
        d = uint16(d);
    end
end

if (nargin < 2)
    threshold = (max([min(max(d,[],1))  min(max(d,[],2))])) ;
end

if (nargin < 3)
    filt = (fspecial('gaussian', 7,1)); %if needed modify the filter according to the expected peaks sizes
end

if (nargin < 4)
    edg =3;
end

if (nargin < 5)
    savefileflag = false;
else
    savefileflag = true;
end

%% Analyze image
if any(d(:))  ; %for the case of non zero raw image
 
    d = medfilt2(d,[3,3]);
    
    % apply threshold
    if isa(d,'uint8')
    d=d.*uint8(d>threshold);
    else 
    d=d.*uint16(d>threshold); 
    end
    
    if any(d(:))   ; %for the case of the image is still non zero
        
        % smooth image
        d=conv2(single(d),filt,'same') ;
        
        % Apply again threshold (and change if needed according to SNR)
        d=d.*(d>0.9*threshold);
        
        
        % peak find - using the local maxima approach - 1 pixle resolution
        % d will be noisy on the edges, since no hits are expected there anyway we'll skip 'edge' pixels.
        sd=size(d);
        [x y]=find(d(edg:sd(1)-edg,edg:sd(2)-edg));
        
        % initialize outputs
          cent=[];% 
          cent_map=zeros(sd);
         
        x=x+edg-1;
        y=y+edg-1;
        for j=1:length(y)
            if (d(x(j),y(j))>=d(x(j)-1,y(j)-1 )) &&...
                    (d(x(j),y(j))>d(x(j)-1,y(j))) &&...
                    (d(x(j),y(j))>=d(x(j)-1,y(j)+1)) &&...
                    (d(x(j),y(j))>d(x(j),y(j)-1)) && ...
                    (d(x(j),y(j))>d(x(j),y(j)+1)) && ...
                    (d(x(j),y(j))>=d(x(j)+1,y(j)-1)) && ...
                    (d(x(j),y(j))>d(x(j)+1,y(j))) && ...
                    (d(x(j),y(j))>=d(x(j)+1,y(j)+1));
                
                  %All these alternatives were slower...
                %if all(reshape( d(x(j),y(j))>=d(x(j)-1:x(j)+1,y(j)-1:y(j)+1),9,1))
                %if  d(x(j),y(j)) == max(max(d((x(j)-1):(x(j)+1),(y(j)-1):(y(j)+1))))
                %if  d(x(j),y(j))  == max(reshape(d(x(j),y(j))  >=  d(x(j)-1:x(j)+1,y(j)-1:y(j)+1),9,1))
              
                        cent = [cent ; x(j) ; y(j)];                
                        cent_map(x(j),y(j))=cent_map(x(j),y(j))+1; % if a binary matrix output is desired
              
            end
        end
        
        if savefileflag
            % previous version used dlmwrite, which can be slower than  fprinf
            %             dlmwrite([filename '.txt'],[cent],   '-append', ...
            %                 'roffset', 0,   'delimiter', '\t', 'newline', 'unix');+
            
            fprintf(fid, '%f ', cent(:));
            fprintf(fid, '\n');
            
        end
        
    else % in case image after threshold is all zeros
        cent=[];
        cent_map=zeros(size(d));
        if nargout>1 ;  varargout{1}=cent_map; end
        return
    end
    
else % in case raw image is all zeros (dead event)
    cent=[];
    cent_map=zeros(size(d));
    if nargout>1 ;  varargout{1}=cent_map; end
    return
end

%demo mode - no input to the function
if (nargin < 1); colormap(bone);hold on; plot(cent(2:2:end),cent(1:2:end),'rs');hold off; end

% return binary mask of centroid positions if asked for
if nargout>1 ;  varargout{1}=cent_map; end