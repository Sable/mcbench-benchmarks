function [output binarizedContour] = CORF(I, sigma, t)
% CORF Contour detection based on a computational model of a simple cell.
%
% VERSION 22/04/2012
% CREATED BY: George Azzopardi and Nicolai Petkov, University of Groningen,
%             Johann Bernoulli Institute for Mathematics and Computer Science, Intelligent Systems
%
%If you use this script please cite the following paper:
%   George Azzopardi and Nicolai Petkov, "A CORF computational model of a
%     simple cell that relies on LGN input outperforms the Gabor function
%     model", 2012, DOI: 10.1007/s00422-012-0486-6
% 
%   CORF achieves orientation selectivity by combining the output - at certain 
%   positions with respect to the center of the CORF operator - of center-on 
%   and center-off difference of Gaussians (DoG) functions by a weighted geometric mean. 
%
%   CORF takes as input:
%      I -> intensity image
%      sigma -> the standard deviation of the outer Gaussian function of the 
%               DoG operator
%      t -> high threshold used for hysteresis thresholding
%
%   CORF returns:
%      output -> maximum superposition of CORF responses that correspond to 12 orientations
%      binarizedContour -> A contour map that is obtaiend by first thinning
%                          output and then performs hysteresis thresholding 
%                          with a high threshold t and a low threshold that 
%                          is a fraction 0.5 of the given t.
%
%   Example: [o bc] = CORF(imread('rino.pgm'),2.5,0.3);
%
%   The image rino.pgm is taken from the RuG data set of 40 images of
%   natural scenes, which can be downloaded from:
%   http://www.cs.rug.nl/~imaging/databases/contour_database/contour_database.html

% configure CORF operator
operator = configureCORF(sigma,0.5);

% Set number of orientations
noriens = 12;
orienslist = 0:180/noriens:359;

% Preprocessing
inputImage = double(I);
if ndims(inputImage) == 3
    inputImage = double(rgb2gray(inputImage));
end
if max(inputImage(:)) > 1
    inputImage = inputImage ./ 255;
end

% Apply difference of Gaussians function.
padwidth = ceil(max(operator.params.rho));
DoGresponse(:,:,1) = applyDoG(inputImage, 0, padwidth, operator.params.sigma, operator.params.sigmaRatio, 0);        
DoGresponse(:,:,2) = -DoGresponse(:,:,1);            
DoGresponse(:,:,1) = DoGresponse(:,:,1) .* (DoGresponse(:,:,1) > 0);
DoGresponse(:,:,2) = DoGresponse(:,:,2) .* (DoGresponse(:,:,2) > 0);

% Apply the CORF oeprator at different orientations
data = [];
output = zeros(size(DoGresponse,1),size(DoGresponse,2),noriens);
for rot = 1:length(orienslist)
    rotatedOperator = operator;
    rotatedOperator.tuple(4,:) = rotatedOperator.tuple(4,:) + orienslist(rot)*pi/180;    
    [output(:,:,rot) data] = getCORFresponse(DoGresponse,rotatedOperator,data);
end
output = output(padwidth+1:end-padwidth,padwidth+1:end-padwidth,:);

% Merge output of all orientations by using maximum superposition
[output, oriensMatrix] = calc_viewimage(output,1:size(output,3), orienslist*pi/180);   

% Perform thinning
thinningOutput = thinning(output, oriensMatrix, 2);     

%Perform hysteresis thresholding
t = t * max(thinningOutput(:));
binarizedContour = hysthresh(thinningOutput, t, 0.5*t);

function [output data] = getCORFresponse(DoGresponse,operator,data)

sz = [size(DoGresponse,1),size(DoGresponse,2)];

if isempty(data)
    data.params = [];   
    data.tupleOutput = cell(0);
    data.location = [];
    data.paramsindex = 1;
    data.current.tupleOutput = zeros(sz(1),sz(2),size(operator.tuple,2)); 
end

% The weight vector is requried for the computation of the weighted
% geometric mean at the bottom of the function.
weightVector = zeros(1,size(operator.tuple,2));
sgm = max(operator.tuple(3,:)) / 3;

for i = 1:size(operator.tuple,2)                                   
    polarity = operator.tuple(1,i);
    rho = operator.tuple(3,i);
    phi = operator.tuple(4,i);
    
    weightVector(i) = (exp(-rho^2/(2*sgm*sgm)));    
    
    mem = find(ismember(data.params,[polarity rho],'rows'),1); 
    if ~isempty(mem)
        % This tuple output is obtained by appropriate shifting of another
        % tuple output that was computed for the same values of polarity,
        % sigma and rho.
        [col row] = pol2cart(phi,rho);
        shiftrow = -(data.location{mem}(1)-fix(row));
        shiftcol = data.location{mem}(2)-fix(col);
        data.current.tupleOutput(:,:,i) = circshift(data.tupleOutput{mem},[shiftrow,shiftcol]);                                                        
    else
        DoG = DoGresponse(:,:,polarity+1);                    
        data.params(data.paramsindex,:) = [polarity rho];        
        [col row] = pol2cart(phi,rho);

        r = (operator.params.d0 + operator.params.alpha*rho)/2;
        if r > 0
            smoothfilter = fspecial('gaussian',round([2*r+1,2*r+1]),r/3);
            data.current.tupleOutput(:,:,i) = conv2(DoG,smoothfilter,'same');
            data.current.tupleOutput(:,:,i) = circshift(data.current.tupleOutput(:,:,i),[fix(row),fix(-col)]);
        else
            data.current.tupleOutput(:,:,i) = DoG;
        end
        data.current.tupleOutput(:,:,i) = data.current.tupleOutput(:,:,i) .^ weightVector(i);
        
        % We use the following variables to reuse the computations obtained
        % for the same values of parameters: polarity, sigma and rho.
        data.tupleOutput{data.paramsindex} = data.current.tupleOutput(:,:,i);
        data.location{data.paramsindex} = [round(row) round(col)];
        data.paramsindex = data.paramsindex + 1;
    end      
end

% compute the weighted geometric mean
output = prod(data.current.tupleOutput,3).^(1/sum(weightVector));

function operator = configureCORF(sigma, sigmaRatio)
% configureCORF: configure a CORF operator for the given parameters.

% The parameters alpha and d0 are set as reported in the above mentioned paper
operator.params.alpha = 0.9;
operator.params.d0 = 2;

operator.params.sigma = sigma;
operator.params.sigmaRatio = sigmaRatio;

% The following are the rho values that were used in the experiments
% reported in the above mentioned paper.
if sigma >= 1 && sigma < 2.5
    operator.params.rho = [14.38 6.9796 3.0310 1.4135];
elseif sigma >= 2.5 && sigma < 4
    operator.params.rho = [3.0515 6.1992 12.6488 24.62];
elseif sigma >= 4 && sigma <= 5
    operator.params.rho = [3.3021 4.7877 9.2467 18.08 34.43];
else
    error('The value of the parameter sigma is out of bounds');
end

maxRadius = ceil(max(operator.params.rho))+1;
stimulus = zeros((2*maxRadius));
stimulus(:,1:maxRadius) = 1;
center = [maxRadius maxRadius];

%Obtain the output of DoG function for the synthetic edge stimulus
DoGresponse(:,:,1) = applyDoG(stimulus, 0, maxRadius, sigma, sigmaRatio, 1);
DoGresponse(:,:,2) = -DoGresponse(:,:,1);
DoGresponse(:,:,1) = DoGresponse(:,:,1) .* (DoGresponse(:,:,1) > 0);
DoGresponse(:,:,2) = DoGresponse(:,:,2) .* (DoGresponse(:,:,2) > 0);

operator.tuple = [];
for r = 1:length(operator.params.rho)
    [polarity rho phi] = getTuple(DoGresponse,operator.params.rho(r),center);    
    operator.tuple = [operator.tuple [polarity; repmat(sigma,1,length(polarity)); rho; phi]];    
end

function [polarity rho phi] = getTuple(DoGresponse,radius,fp)              
% Determine the values of the polar coordinates (rho,phi)

if radius <= 0
    error('Parameter radius must be greater than 0');
end

phi = []; polarity = [];
x = 1:360;

for pol = 1:size(DoGresponse,3)       
    DoG = DoGresponse(:,:,pol);
    y = DoG(sub2ind(size(DoG),round(fp(1) + radius*cos(pi/2+x*pi/180)),round(fp(2) + radius*sin(pi/2+x*pi/180))));
       
    % Threshold low values
    y(y < 0.1*max(DoGresponse(:))) = 0;   
    y = round(y*1000)/1000;
    
    BW     = bwlabel(imregionalmax(y));
    npeaks = max(BW(:));    

    for i = 1:npeaks
        phi(end+1) = mean(x(BW == i)) * pi/180;
        polarity(end+1) = pol - 1;            
    end     
end
rho = repmat(radius,1,length(phi));

function output = applyDoG(inputImage,polarity,padwidth,sigma,sigmaRatio,crop)

% pad input image
paddedInputImage = padarray(inputImage,[padwidth padwidth],'both','symmetric');

% create DoG operator
sz = size(inputImage) + padwidth + padwidth;    
g1 = fspecial('gaussian',sz,sigma);
g2 = fspecial('gaussian',sz,sigma*sigmaRatio);
if polarity == 1
    DoG = g2 - g1;  
elseif polarity == 0
    DoG = g1 - g2;
else
    error('Polarity must be either 0 (on) or 1 (off)');
end

% compute DoG
output = fftshift(ifft2(fft2(DoG,sz(1),sz(2)) .* fft2(paddedInputImage)));

if crop == 1
    output = output(padwidth+1:end-padwidth,padwidth+1:end-padwidth);
end

function [result, oriensMatrix] = calc_viewimage(matrices, dispcomb, theta)
% VERSION 14/05/04
% CREATED BY: M.B. Wieling and N. Petkov, Groningen University,
%             Department of Computer Science, Intelligent Systems
%
% CALC_VIEWIMAGE: calculates the maximum-superposition of all the matrices stored
% in MATRICES (according to the L-infinity norm). It uses only the matrices for
% which the index is entered in DISPCOMB, e.g. if DISPCOMB contains the values
% 1,2,4: only the first, second and fourth matrix contained in MATRICES are used
% for the superposition. This method also calculates the orientationmatrix (ORIENSMATRIX) 
% which stores the maximum orientation response of each point in the resulting matrix
% (RESULT) - for use in CALC_THINNING. A progressbar of the calculations is also shown. 
%   CALC_VIEWIMAGE(MATRICES, DISPCOMB, THETA) 
%   calculates the single viewing image according to the following parameters
%     MATRICES - the matrices which hold all the convolutions for each orientation
%     DISPCOMB  - the indexes of each matrix (in MATRICES) which should be used for the
%                 superposition  
%     THETA - a list of all the orientations - to create ORIENSMATRIX

% initialize values
oriensMatrix = 0;
tmpMaxConv = -Inf;
result = -Inf;
cnt1 = 1;

if (size(dispcomb,2) == 1)
  result = matrices(:,:,dispcomb(1));
else

  % calculate the superposition (L-infinity norm)
  while (cnt1 <= size(dispcomb,2))
    % calculate the maximum orientation-response in each point (based on the absolute values)
    oriensMatrixtmp1 = (abs(matrices(:,:,dispcomb(cnt1))) > tmpMaxConv) .* theta(dispcomb(cnt1));
    oriensMatrixtmp2 = (abs(matrices(:,:,dispcomb(cnt1))) <= tmpMaxConv) .* oriensMatrix;
    oriensMatrix = oriensMatrixtmp1 + oriensMatrixtmp2;
    tmpMaxConv = max(abs(matrices(:,:,dispcomb(cnt1))), tmpMaxConv);
   
    % calculate the superposition
    result = max(result,abs(matrices(:,:,dispcomb(cnt1))));
    cnt1 = cnt1 + 1;
  end
end
 
function result = thinning(matrix, oriensMatrix, method)
% VERSION 27/02/05
% CREATED BY: M.B. Wieling and N. Petkov, Groningen University,
%             Department of Computer Science, Intelligent Systems
%
% THINNING: reduces the edges to a width of 1 pixel. This is done 
%           by looking at the two pixels next to the current pixel.
%           the neighbourpixels are determined by the orientation of 
%           the current point (this is stored in the exact same location
%           as in the matrix ORIENSMATRIX). A progressbar of the
%           calculations is also shown. 
%   THINNING(MATRIX, ORIENSMATRIX, METHOD) thins the edge
%      MATRIX - the matrix which should be thinned
%      ORIENSMATRIX - the matrix which holds for every pixel of MATRIX the
%                     orientation (in the same position)
%      METHOD - the method of thinning: METHOD == 1: simple method, just
%               take the value of the nearest pixels to compare with.
%               e.g. if the orientation = 20 degrees, the points S & N are chosen
%               to compare to, if the orientation = 25 degrees the points SW & NE
%               are chosen (see below, P = current point)
%                             NW  N  NE
%                             W   P   E
%                             SW  S  SE
%               METHOD == 2: the values to compare with are calculated using
%               interpolation based on the surrounding pixels (NW, N, NE, E, SE, S, SW, W) 
%
% corrected an error: <pi := <=pi

% create the coordinate-system
h = size(matrix,1); % height of image
w = size(matrix,2); % width of image
mx = max(h,w);
[xcoords, ycoords] = meshgrid(1:mx);
xcoords = xcoords(1:h, 1:w);
ycoords = ycoords(1:h, 1:w);

% set every value between 0 and pi
oriensMatrix = mod(oriensMatrix, pi);

% add a border of zeros to 'matrix' and 'oriensMatrix' to ease calculations.
matrixB(h+2,w+2) = 0;
matrixB(2:h+1,2:w+1) = matrix(:,:);
oriensMatrixB(h+2,w+2) = 0;
oriensMatrixB(2:h+1,2:w+1) = oriensMatrix(:,:);

if (method == 1) % simple thinning
  result = 0;
  for I=2:h+1 % the rows
    for J=2:w+1 % the columns
      orien = oriensMatrixB(I,J);
      
      % calculate dx and dy - this is correct as can be seen
      % in a picture
      dx = (orien < (3/8)*pi) - (orien > (5/8)*pi); 
      dy = ((orien > (1/8)*pi) & (orien <= (1/2)*pi)) - ((orien > (1/2)*pi) & (orien < (7/8)*pi));

      % normally the same pixels would be checked if (dy and dx > 0) and (dy and dx < 0). because
      % different pixels should be checked with a gabor-orientation of 45 and 135 this difference should
      % be checked
      if (dy < 0) & (dx < 0)
       result(I,J) = ((matrixB(I,J) >= matrixB(I+dy, J+dx)) & (matrixB(I,J) >= matrixB(I-dy, J-dx))) * matrixB(I,J);  
      else
       result(I,J) = ((matrixB(I,J) >= matrixB(I-dy, J+dx)) & (matrixB(I,J) >= matrixB(I+dy, J-dx))) * matrixB(I,J);  
      end  
    end
  end
else % linear thinning
  %hb = waitbar(0,'Applying linear thinning, please wait ... (Step 6/7)'); % display a progressbar
  result = 0;
  for I=2:h+1 % the rows
    for J=2:w+1 % the columns
      orien = oriensMatrixB(I,J);
      % get the values of the surrounding pixels
      north = matrixB(I-1, J); 
      northeast = matrixB(I-1, J+1); 
      east = matrixB(I, J+1);
      southeast = matrixB(I+1, J+1);
      south = matrixB(I+1, J);
      southwest = matrixB(I+1, J-1);
      west = matrixB(I, J-1);
      northwest = matrixB(I-1, J-1);
    
      % calculate the value of the points in one line (using interpolation)
      if (orien <= (1/4)*pi)
          fraction = orien/((1/4)*pi);
          pnt1 = (1-fraction) * east + (fraction) * northeast;
          pnt2 = (1-fraction) * west + (fraction) * southwest;     
      elseif (orien <= (1/2)*pi)
          fraction = (orien-(1/4)*pi)/((1/4)*pi);
          pnt1 = (1-fraction) * northeast + (fraction) * north;  
          pnt2 = (1-fraction) * southwest + (fraction) * south;
      elseif (orien <= (3/4)*pi)
          fraction = (orien-(1/2)*pi)/((1/4)*pi);
          pnt1 = (1-fraction) * north + (fraction) * northwest;
          pnt2 = (1-fraction) * south + (fraction) * southeast;
      elseif (orien <= pi)
          fraction = (orien-(3/4)*pi)/((1/4)*pi);
          pnt1 = (1-fraction) * northwest + (fraction) * west;
          pnt2 = (1-fraction) * southeast + (fraction) * east;
      else
        orien
      end
      result(I,J) = ( (matrixB(I,J) >= pnt1) & (matrixB(I,J) >= pnt2) ) * matrixB(I,J);
    end
    %waitbar(I/h); % update the progressbar
  end
  %close(hb);
end

% removing the borders
result = result(2:h+1, 2:w+1); 

function bw = hysthresh(im, T1, T2)
% HYSTHRESH - Hysteresis thresholding
%
% Usage: bw = hysthresh(im, T1, T2)
%
% Arguments:
%             im  - image to be thresholded (assumed to be non-negative)
%             T1  - upper threshold value
%             T2  - lower threshold value
%
% Returns:
%             bw  - the thresholded image (containing values 0 or 1)
%
% Function performs hysteresis thresholding of an image.
% All pixels with values above threshold T1 are marked as edges
% All pixels that are adjacent to points that have been marked as edges
% and with values above threshold T2 are also marked as edges. Eight
% connectivity is used.
%
% It is assumed that the input image is non-negative
%
% Author: Peter Kovesi   
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au   http://www.csse.uwa.edu.au/~pk   
%
% December 1996  - Original version
% March    2001  - Speed improvements made (~4x)

%
% A stack (implemented as an array) is used to keep track of all the
% indices of pixels that need to be checked.
% Note: For speed the number of conditional tests have been minimised
% This results in the top and bottom edges of the image being considered to
% be connected.  This may cause some stray edges to be propagated further than 
% they should be from the top or bottom.
%

if (T2 > T1 | T2 < 0 | T1 < 0)  % Check thesholds are sensible
  error('T1 must be >= T2 and both must be >= 0 ');
end

[rows, cols] = size(im);    % Precompute some values for speed and convenience.
rc = rows*cols;
rcmr = rc - rows;
rp1 = rows+1;

bw = im(:);                 % Make image into a column vector
pix = find(bw > T1);        % Find indices of all pixels with value > T1
npix = size(pix,1);         % Find the number of pixels with value > T1

stack = zeros(rows*cols,1); % Create a stack array (that should never
                            % overflow!)

stack(1:npix) = pix;        % Put all the edge points on the stack
stp = npix;                 % set stack pointer
for k = 1:npix
    bw(pix(k)) = -1;        % mark points as edges
end


% Precompute an array, O, of index offset values that correspond to the eight 
% surrounding pixels of any point. Note that the image was transformed into
% a column vector, so if we reshape the image back to a square the indices 
% surrounding a pixel with index, n, will be:
%              n-rows-1   n-1   n+rows-1
%
%               n-rows     n     n+rows
%                     
%              n-rows+1   n+1   n+rows+1

O = [-1, 1, -rows-1, -rows, -rows+1, rows-1, rows, rows+1];

while stp ~= 0            % While the stack is not empty
    v = stack(stp);         % Pop next index off the stack
    stp = stp - 1;
    
    if v > rp1 & v < rcmr   % Prevent us from generating illegal indices
			    % Now look at surrounding pixels to see if they
                            % should be pushed onto the stack to be
                            % processed as well.
       index = O+v;	    % Calculate indices of points around this pixel.	    
       for l = 1:8
	   ind = index(l);
	   if bw(ind) > T2   % if value > T2,
	       stp = stp+1;  % push index onto the stack.
	       stack(stp) = ind;
	       bw(ind) = -1; % mark this as an edge point
	   end
       end
    end
end

bw = (bw == -1);            % Finally zero out anything that was not an edge 
bw = reshape(bw,rows,cols); % and reshape the image