% Compute the analytical 3D multi-radii optimally oriented flux responses 
% for curvilinear structure analysis. Implementation based on,
% [1] M.W.K. Law and A.C.S. Chung, ``Three Dimensional Curvilinear 
% Structure Detection using Optimally Oriented Flux'', ECCV 2008, pp.
% 368--382.
% [2] Max W. K. Law et al., ``Dilated Divergence based Scale-Space 
% Representation for Curve Analysis'', ECCV 2012, pp. 557--571.
%
% Syntax: 
%  outputresponse = oof3response(image, radii, opts);
% Explanation:
%  outputresponse: The final output response. 3D matrix.
%  image: The original image. (3D matrix)
%  radii: A vector containing all interested radii for computation of OOF. 
%  (N-D vector)
%  opts: A matlab struct. It contains 4 fields to specify 4 optional 
%  settings of OOF. If any of these fields or opts is missing, the default 
%  values are used. (Optional):
%  opts.spacing: Voxel size of the input image. The pixel spacing can be 
%  isotropic or anisotropic. (default value = 1; Scalar, if voxels are 
%  isotropic; 3D vector, [x-length,y-length, z-length] for anisotropic 
%  voxels). 
%  opts.sigma: For the image smoothing at the begining to the computation 
%  OOF derivatives. (Scalar, default value = min(opts.spacing))
%  opts.useabsolute: Use absolute value to sort the eigenvalues. 
%  opts.useabsolute=1: Use absolute value;
%  opts.useabsolute=(any other value): Use original value;
%  opts.responsetype: There are six different responses implemented. This
%  input specifies the type output responses. (Scalar, [0..5], default
%  value = 0). At each detection radius, the corresponding response is:
%  opts.responsetype=0: l1; (default)
%  opts.responsetype=1: l1+l2;
%  opts.responsetype=2: sqrt(max(0, l1.*l2));
%  opts.responsetype=3: sqrt(max(0, l1) .*max(0, l2));
%  opts.responsetype=4: max(0, l1);
%  opts.responsetype=5: max(0, l1+l2).
%  Here l1 and l2 are the eigenvalues of OOF tensor, l1 is the largest and 
%  l3 is the smallest. See opts.useabsolute about their order.
%  The final response "outputresponse" is the maximum magnitude across
%  radii of one of the above response. 
%  opts.normalizationtype: There are four different scheme of normalizing
%  the responses across radii implemented. 
%  opts.normalizationtype=0: The surface-area based normalization in [1].
%  It is also identical to the normalization for blob-like structure in
%  [2].
%  opts.normalizationtype=1: The advanced normalization for curvilinear 
%  structure in [2]. Default.
%  opts.normalizationtype=2: The advanced normalization for planar 
%  structure in [2]. 
%  If the type of the detection target is known (blob-like, curvilinear or
%  planar) and the smallest detection radisu is not smaller than sigma (i.e. 
%  min(radii)>=opts.sigma, it is highly recommended to use the 
%  corresponding advanced normalization scheme in [2]. Details can be 
%  found in Appendix of [2].
%
%  Example:
%  result = oof3response(I, 1:5);
%  This gives a OOF detection results for general curvilinear structure 
%  detection. A highly recommended setting for providing features to 
%  centerline extraction and segmentation.
%  Return the result computed using the radii {1,2,3,4,5} on image I. The
%  returned responses are very suitable to be zero-thresholded, followed by
%  connectivity analysis to get a segmentation result. It is also helpful
%  to serve as the speed field for level-set evolution, see more details in
%  Max W. K. Law and Albert C. S. Chung, ``An Oriented Flux Symmetry based 
%  Active Contour Model for Three Dimensional Vessel Segmentation'', ECCV 
%  2010, pp. 720--734.
%
%  clear opts; opts.spacing=0.4;
%  result = oof3response(I, 0.4:0.4:2.8, opts);
%  Return the result computed from the radii (0.4mm,0.8mm,1.2mm,1.6mm,2mm,2.4mm,
%  2.8mm}, where the each pixel is 0.4mmx0.4mmx0.4mm and sigma is 0.4mm. 
%
%  clear opts; opts.spacing=[0.4, 0.4, 1];
%  result = oof3response(I, 0.4:0.4:4, opts);
%  Return the result computed from the raddi {0.4mm...4mm}, where each pixel
%  has a size of 0.4mm x 0.4mm x 1mm (w x l x h). 
%
%  clear opts; opts.useabsolute=0; opts.responsetype=1; opts.normalizationtype=0;
%  result = oof3response(I, 1:10, opts);
%  Return the result S^Q_x as used in Section 3.1 in [1].
%
%  clear opts; opts.useabsolute=0; opts.responsetype=3; opts.normalizationtype=0;
%  result = oof3response(I, 1:10, opts);
%  Return the result S^Q_x as used in Section 3.2 in [1].
%
%  Technical details:
%  1. The internal variables outputfeature_11, outputfeature_12,outputfeature_13,
%  outputfeature_22, outputfeature_23 and outputfeature_33 are the matrix
%  Q_{r,x} in Equation (2) in [1].
%  2. The unused variable "marginwidth" can be set to automatically crop
%  the boundary of the output feature to circumvent the wrap around FFT
%  artifact with maximum efficiency. Also see the sub-function "freqOp"
%  3. The input opts.sigma is \sigma in p.371 in [1]
%  4. GPU computation is enabled if the input is a Matlab GPUArray 
%  To workaround the Fourier wrap around artifact, use the matlab command 
%  "padarray". 
%  Please kindly cite the following paper if you use this program, or any 
%  code extended from this contribution. 
%  M.W.K. Law and A.C.S. Chung, ``Three Dimensional Curvilinear 
%  Structure Detection using Optimally Oriented Flux'', ECCV 2008, pp.
%  368--382.
%  Max W. K. Law et al., ``Dilated Divergence based Scale-Space 
%  Representation for Curve Analysis'', ECCV 2012, pp. 557--571.
%
%  Author: Max W.K. Law 
%  Email: max.w.k.law@gmail.com 
%  Page: http://www.cse.ust.hk/~maxlawwk/

function [output]= oof3response(image, radii, options)





    % marginwidth is used to define the image border which is cropped to 
    % circumvent the FFT wrap-around artifacts and save memory during 
    % calculation.
    % It is disabled by default. Enable it by uncommenting the second line
    % below this description.
    marginwidth = [0 0 0];
    % marginwidth = [ceil((max(radii)+sigma*3)/pixelspacing(1)) ceil((max(radii)+sigma*3)/pixelspacing(2)) ceil((max(radii)+sigma*3)/pixelspacing(3)) ];

    output=image(marginwidth(1)+1:end-marginwidth(1), marginwidth(2)+1:end-marginwidth(2), marginwidth(3)+1:end-marginwidth(3))*0; 

    
    
    % Default options
    rtype = 0;
    etype = 1;
    ntype = 1;
    pixelspacing=[1 1 1];
    sigma= min(pixelspacing);
   
    if exist('options', 'var')~=0
        if isfield(options, 'spacing')~=0
            pixelspacing = options.spacing;
            sigma= min(pixelspacing);
        end
        if isfield(options, 'responsetype')~=0
            rtype = options.responsetype;
        end
        if isfield(options, 'normalizationtype')~=0
            ntype = options.normalizationtype;
        end
        if isfield(options, 'sigma')~=0
            sigma = options.sigma;
        end
        if isfield(options, 'useabsolute')~=0
            etype = options.useabosolute;
        end
        if ((min(radii)<sigma) & ntype>0)
            disp('Sigma must be >= minimum range to enable the advanced normalization. The current setting falls back to options.normalizationtype=0, because of the undersize sigma.');
            ntype = 0;
        end
    end
    
    imgfft = fftn(image);
    
    %Obtaining the Fourier coordinate
    [x,y,z] = ifftshiftedcoormatrix([size(image,1) size(image,2) size(image,3)]);
    
    
    % Casting the Fourier coordiantes to be of the same type as image
    x=x+image(1)*0;
    y=y+image(1)*0;
    z=z+image(1)*0;
    % End of the type casting
    x=x/size(image,1)/pixelspacing(1);
    y=y/size(image,2)/pixelspacing(2);
    z=z/size(image,3)/pixelspacing(3);        
    radius=realsqrt(x.^2+y.^2+z.^2)+1e-12;
    
    % Save memory by clearing x y z. Although obtained from different
    % functions, x y z are equivalent to:
    % x = ifftshiftedcoordinate(size(image), 1, pixelspacing)
    % y = ifftshiftedcoordinate(size(image), 2, pixelspacing)
    % z = ifftshiftedcoordinate(size(image), 3, pixelspacing)
    % If main memory (or GPU memory) has enough memory to buffer the 
    % entire x,y,z, comment the following clear command and replace the 
    % equivalent bufferred variables inside the following for-loop. It 
    % gives around 20% speed up.
    clear x y z 

    for i=1:length(radii)
        normalization = 4/3*pi*radii(i)^3/(besselj(1.5, 2*pi*radii(i)*1e-12)/(1e-12)^(3/2)) /radii(i)^2 * ((radii(i)/sqrt(2*radii(i)*sigma-sigma*sigma))^ntype);
        
        besseljBuffer = normalization * exp((-(sigma)^2)*2*pi*pi* (radius.^2))./(radius.^(3/2));
        besseljBuffer = ( sin(2*pi*radii(i)*radius)./(2*pi*radii(i)*radius) - cos(2*pi*radii(i)*radius)) .* besseljBuffer.*sqrt(1/pi/pi/radii(i)./radius) ;

        % clear radius
        besseljBuffer=besseljBuffer.*imgfft;

% There are 6 3D IFFT performed at each radius. Here we use in-place FFT to
% save memory, although the code looks clumpsy.
% If you are using Cuda-enabled GPU acceleration or you have large enough 
% memory to use out-of-place FFT, uncomment the following 6 lines, and
% comment the inplace FFT codes. It gives about 20%-40% overall speed up.
%          outputfeature_11 = freqOp(real(ifftn(x.*x.*besseljBuffer)), marginwidth);
%          outputfeature_12 = freqOp(real(ifftn(x.*y.*besseljBuffer)), marginwidth); 
%          outputfeature_13 = freqOp(real(ifftn(x.*z.*besseljBuffer)), marginwidth);
% % 
%          outputfeature_22 = freqOp(real(ifftn(y.*y.*besseljBuffer)), marginwidth); 
%          outputfeature_23 = freqOp(real(ifftn(y.*z.*besseljBuffer)), marginwidth);
% % 
%          outputfeature_33 = freqOp(real(ifftn(z.*z.*besseljBuffer)), marginwidth); 

% Inplace FFT
        buffer=ifftshiftedcoordinate(size(image), 1, pixelspacing).^2.* ............x.*x.*  .....    
                                     besseljBuffer;
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');
        buffer = freqOp(buffer, marginwidth); outputfeature_11 = buffer;
        clear buffer;
        buffer=ifftshiftedcoordinate(size(image), 1, pixelspacing).*ifftshiftedcoordinate(size(image), 2, pixelspacing).* ........x.*y.*  .....    
                                     besseljBuffer;
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');                                 
        buffer = freqOp(buffer, marginwidth); outputfeature_12 = buffer;
        clear buffer;        
        buffer=ifftshiftedcoordinate(size(image), 1, pixelspacing).*ifftshiftedcoordinate(size(image), 3, pixelspacing).* ........x.*z.*  .....    
                                     besseljBuffer;                                 
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');                                 
        buffer = freqOp(buffer, marginwidth); outputfeature_13 = buffer;
        clear buffer;        

        buffer=ifftshiftedcoordinate(size(image), 2, pixelspacing).^2.* .........*y.*y  .....    
                                     besseljBuffer;
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');                                 
        buffer = freqOp(buffer, marginwidth); outputfeature_22 = buffer;
        clear buffer;        
        buffer=ifftshiftedcoordinate(size(image), 2, pixelspacing).*ifftshiftedcoordinate(size(image), 3, pixelspacing).* ........y.*z.*  .....    
                                     besseljBuffer;
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');                                 
        buffer = freqOp(buffer, marginwidth); outputfeature_23 = buffer;
        clear buffer;            

        buffer=ifftshiftedcoordinate(size(image), 3, pixelspacing).^2.* ........ z.*z.*  .....    
                                     besseljBuffer;
        buffer=ifft(buffer, [], 1);buffer=ifft(buffer, [], 2);buffer=ifft(buffer, [], 3, 'symmetric');        
        buffer = freqOp(buffer, marginwidth); outputfeature_33 = buffer;            
% End of in-place FFT
        
        % Tips: If you are using Cuda-enabled GPU acceleration, uncomment
        % the following line, and comment the second line below to gain
        % about 10% extra speed up. GPU works better if data is fed into ALU
        % individually. CPU works better if data is feed as a hold block.
        %[eigenvalue1,eigenvalue2,eigenvalue3] = arrayfun(@eigenvaluefield33, outputfeature_11, outputfeature_12, outputfeature_13, outputfeature_22, outputfeature_23, outputfeature_33);
        [eigenvalue1,eigenvalue2,eigenvalue3] = eigenvaluefield33(outputfeature_11, outputfeature_12, outputfeature_13, outputfeature_22, outputfeature_23, outputfeature_33);
        
        % The following code sorts the unorderred eigenvalues according to
        % their magnitude. 
        maxe = eigenvalue1;
        mine = eigenvalue1;
        clear eigenvalue1;        
        mide = maxe + eigenvalue2 + eigenvalue3;
        
        if (etype==1)
            maxe(abs(eigenvalue2)>abs(maxe)) = eigenvalue2(abs(eigenvalue2)>abs(maxe));
            mine(abs(eigenvalue2)<abs(mine)) = eigenvalue2(abs(eigenvalue2)<abs(mine));
            clear eigenvalue2;

            maxe(abs(eigenvalue3)>abs(maxe)) = eigenvalue3(abs(eigenvalue3)>abs(maxe));
            mine(abs(eigenvalue3)<abs(mine)) = eigenvalue3(abs(eigenvalue3)<abs(mine));
            clear eigenvalue3;
        else
            maxe((eigenvalue2)>abs(maxe)) = eigenvalue2((eigenvalue2)>abs(maxe));
            mine((eigenvalue2)<abs(mine)) = eigenvalue2((eigenvalue2)<abs(mine));
            clear eigenvalue2;

            maxe((eigenvalue3)>abs(maxe)) = eigenvalue3((eigenvalue3)>abs(maxe));
            mine((eigenvalue3)<abs(mine)) = eigenvalue3((eigenvalue3)<abs(mine));
            clear eigenvalue3;
        end
        
        mide = mide - maxe - mine;
        clear mine;
        
% Feel free the change the combination of the eigenvalues, just as vesselness mesaure        
        switch rtype
            case 0,
                tmpfeature = maxe;
            case 1,
                tmpfeature = maxe+mide;
            case 2,
                tmpfeature = realsqrt(max(0, maxe.*mide));
            case 3,
                tmpfeature = realsqrt(max(0, maxe).*max(0, mide));
            case 4,
                tmpfeature = max(maxe, 0);
            case 5,
                tmpfeature = max(maxe+mide, 0);
        end
        clear mide;
% Select the voxelwise responses according to the largest mangitude response
        condition = (abs(tmpfeature)>abs(output));
        output(condition) = tmpfeature(condition);
    end
    
end


function result=freqOp(freq, marginwidth)
    result=freq(marginwidth(1)+1:size(freq,1)-marginwidth(1), marginwidth(2)+1:size(freq,2)-marginwidth(2), marginwidth(3)+1:size(freq,3)-marginwidth(3));
end

%  varargout=ifftshiftedcoormatrix(dimension)
% The dimension is a vector specifying the size of the returned coordinate
% matrices. The number of output argument is equals to the dimensionality
% of the vector "dimension". All the dimension is starting from "1"
function varargout=ifftshiftedcoormatrix(dimension)
dim=length(dimension);
p = floor(dimension/2);

    for i=1:dim
        a=([p(i)+1:dimension(i) 1:p(i)])-p(i)-1;
        reshapepara=ones(1,dim);
        reshapepara(i)=dimension(i);
        A=reshape(a, reshapepara);
        repmatpara=dimension;
        repmatpara(i)=1;
        varargout{i}=repmat(A, repmatpara);
    end
end

function output=ifftshiftedcoordinate(dimension, dimindex, pixelspacing)
    dim=length(dimension);
    p = floor(dimension/2);
    a=single([p(dimindex)+1:dimension(dimindex) 1:p(dimindex)])-p(dimindex)-1;
    a=a/pixelspacing(dimindex)/dimension(dimindex);
    reshapepara=ones(1,dim, 'single');
    reshapepara(dimindex)=dimension(dimindex);
    
    a=reshape(a, reshapepara);
    repmatpara=dimension;
    repmatpara(dimindex)=1;
    output=repmat(a, repmatpara);
end