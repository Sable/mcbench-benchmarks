function [Mstore Medge] = shrinkWrap(varargin)
%Function to make a binary map of objects i.e. 'Shrinkwrapping' them.
%SCd 09/10/2010
%
%Updates:
%   09/23/2010: Added further documentation for selecting an ObjThresh.
%               Added Output of Edge image (Medge)
%   01/04/2011: Fixed bug in myed output
%
%Usage:
%   map = shrinkWrap(I,'PropertyName',PropertyValue,...)
%
%Required Input Arguments:
%   -I = image volume or slice to be wrapped
%
%Optional Input Arguments: 'PropertyNames'
%   -'ObjThresh' = This is the lower threshold value for the convolution image.
%       I.e: after the 2-dimensional convolution this threshold is used to
%       binarize the image.  Everything less than or equal to this threshold is 
%       background (false) and everything more is foreground (true).
%       This value defaults to 1500.  This value was determined for uint8
%       images converted to double precision.
%       How to select an appropriate ObjThresh?
%         >>imtool(conv2(double(I),ones(5),'same'));
%           Use the "adjust contrast" tool and move the lower bound to the
%           desirable threshold.  The lower bound should be the ObjThresh.
%
%   -'MinSize' = Minimum size of an object to keep after processing.  The 
%       default is to 500 voxels with DimView = 3.
%       See 'DimView' for a further explanation.
%       NOTE: If MinSize = 1; and Biggest is not called; no connected
%           components analysis will be performed and this will be much
%           faster.
%
%   -'Biggest' = This PropertyName does not require a PropertValue.  If is
%       called only the biggest object will be saved.  The default
%       'DimView' for shrinkWrap is 3 so it will preserve the biggest
%       object across all slices.
%       NOTE: If this is called and the biggest object is smaller than 
%           MinSize, then all objects are deleted.
%
%   -'DimView' = This property is only valid if 'MinSize' or 'Biggest' has been called
%       DimView expects its PropertyValue to be either 2 or 3.  This means
%       that objects will be sized by viewing them in this number of
%       dimensions.
%
%   -'Verbose' = This PropertyName does not require a PropertyValue.  If 
%       it is called the current slice and step is displayed in the command 
%       window while it is working.  If it is not called they are not displayed.
%
%   -'Parallel' = This PropertyName does not require a PropertyValue.  If
%       it is called the engine is processed in parallel.  If it is not
%       called the engine is processed in serial.
%       NOTE: The matlabpool workers are expected to be open before shrinkWrap()
%           is called.  If they are not, it will be run in parallel with 
%           only one worker which is slower.
%           (Please See: help matlabpool)
%
%Output Arguments
%   -Mstore = Binary map of retained objects.
%
%   -Medge = Edge Image of Binary Map. (Optional, not calculated if not
%       requested)
%
  
    %Volume in double precision & Parse Inputs
    invol = double(varargin{1});
    [ObjThresh, MinSize, Biggest, DimView, Verbose, isparallel] = parseInputs(varargin(2:end)); 
    
    %Get dimensional sizes so they don't need to be recalculated and so
    %invol is sliced in parfor loop
    nr = size(invol,1);
    nc = size(invol,2);
    np = size(invol,3);
    
    %Preallocate the map
    Mstore= false(nr,nc,np);
    if nargout == 2; Medge = false(nr,nc,np); end
    if Verbose; disp('Inputs Parsed, Volumes Preallocated; Engine Running...'); end
    
    %Run the Engine:
    if isparallel
        parfor ii = 1:np
            if Verbose; disp(['Processing Slice: ' num2str(ii) '...']); end
            [Mstore(:,:,ii), myed] = Engine(invol(:,:,ii),nr,nc,ObjThresh);
            if nargout == 2; Medge(:,:,ii) = myed; end 
            if Verbose; disp(['Slice ' num2str(ii) ' Complete!']); end
        end
    else    
        for ii = 1:np
            if Verbose; disp(['Processing Slice: ' num2str(ii) '...']); end
            [Mstore(:,:,ii), myed] = Engine(invol(:,:,ii),nr,nc,ObjThresh);
            if nargout == 2; Medge(:,:,ii) = myed; end 
            if Verbose; disp(['Slice ' num2str(ii) ' Complete!']); end
        end
    end
    if Verbose; disp('Engine Complete; Post Processing...'); end
    
    %Get rid of unwanted objects:
    if MinSize == 1 && ~Biggest
        if Verbose; disp('Shrinkwrap Complete!'); end
        return
    end
    if Verbose; disp('Removing Small Objects'); end
    if DimView == 2 && ~Biggest
        if isparallel
            parfor ii = 1:np
                [Mstore(:,:,ii)] = bwareaopen(Mstore(:,:,ii),MinSize);
            end        
        else    
            for ii = 1:np
                Mstore(:,:,ii) = bwareaopen(Mstore(:,:,ii),MinSize);
            end
        end
    elseif DimView == 2 %Biggest
        if isparallel
            parfor ii = 1:np    
                Mslice = Mstore(:,:,ii);
                CC = bwconncomp(Mslice);
                sizes = cellfun(@numel,CC.PixelIdxList);
                Mslice(cell2mat(CC.PixelIdxList(sizes~=max(sizes)).')) = false;
                Mstore(:,:,ii) = Mslice;           
            end
        else    
            for ii = 1:np
                Mslice = Mstore(:,:,ii);
                CC = bwconncomp(Mslice);
                sizes = cellfun(@numel,CC.PixelIdxList);
                if max(sizes)>=MinSize
                    Mslice(cell2mat(CC.PixelIdxList(sizes~=max(sizes)).')) = false;
                    Mstore(:,:,ii) = Mslice;
                end    
            end
        end
    elseif ~Biggest %Dimview == 3 
        Mstore = bwareaopen(Mstore,MinSize);
    else %DimView = 3 && Biggest    
        CC = bwconncomp(Mstore);
        sizes = cellfun(@numel,CC.PixelIdxList);
        if max(sizes)>=MinSize
            Mstore(cell2mat(CC.PixelIdxList(sizes~=max(sizes)).')) = false;
        end
    end
    if nargout == 2 
        Medge= Medge & Mstore; %Get rid of edges that were removed
    end
    if Verbose; disp('Shrinkwrap Complete!'); end
end

function [M myed] = Engine(I,nr,nc,ObjThresh)
%The Engine

    %Filtered 2-d convolution & True points in it
    Icon = conv2(double(I),ones(5),'same')>ObjThresh;
    [r c] = find(Icon);
    
    if length(r)>2 && ~all(r==r(1)) && ~all(c==c(1)) %Ensure that a convex hull can be calculated
        %Compute the convex hull and create a mask (map) from it
        k = convhulln([r, c]);
        M = double(poly2mask(c(k(:,1)),r(k(:,1)),nr,nc));
        
        %Use a 2-dimensional convolution and threshold of 8 to find the edge
        myed = (conv2(M,ones(3),'same')<8)&M;
        Icon = ~Icon;
        %While the edge is changing on every iteration continue eroding the map with it
        while 1
            M(Icon&myed) = 0;
            myed2 = myed;
            myed = (conv2(M,ones(3),'same')<8)&M;
            if isequal(myed2,myed)
                M = logical(M);
                break;
            end
        end 
    else
        M = false(nr,nc);
        myed = false(nr,nc);
    end      
end

function [ObjThresh, MinSize, Biggest, DimView, Verbose, isparallel] = parseInputs(in)
%Parse the inputs

    %Possible properties 
    props = {'objthresh','minsize','biggest','dimview','verbose','parallel'}; 
    in = cellfun(@lower,in,'uni',false);
    
    %Defaults
    isparallel = false; %isparallel since 'parallel' is stock function
    Verbose = false;
    DimView = 3;
    Biggest = false;
    MinSize = 500;
    ObjThresh = 1500;
    
    %Assign Chosen Properties
    [~, idx,idv] = intersect(props,cellfun(@char,in,'uni',false));
    if any(idx==1); ObjThresh = in{idv(idx==1)+1}; end
    if any(idx==2); MinSize = in{idv(idx==2)+1}; end        
    if any(idx==3); Biggest = true; end
    if any(idx==4); DimView = in{idv(idx==4)+1}; end
    if any(idx==5); Verbose = true; end        
    if any(idx==6); isparallel = true; end
    
    %Error Checking:
    assert(isnumeric(ObjThresh),'ObjThresh is expected to be numeric');
    assert(isnumeric(MinSize),'MinSize is expected to be numeric');
    assert(DimView == 2 || DimView == 3,'DimView is expected to have a value of 2 or 3');
end
