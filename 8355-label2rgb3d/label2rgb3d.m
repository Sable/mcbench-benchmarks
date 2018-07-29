function rgb3d=label2rgb3d(varargin)
[label,map,zerocolor,order,fcnflag] = parse_inputs(varargin{:});
%label= 3d image with labels
% map= specified color map
%==================================
numregion = double(max(label(:)));

% If MAP is a function, evaluate it.  Make sure that the evaluated function
% returns a valid colormap.
if  fcnflag == 1
    cmap = feval(map, numregion);
    if ~isreal(cmap) || any(cmap(:) > 1) || any(cmap(:) < 0) || ...
            ~isequal(size(cmap,2),3) || size(cmap,1) < 1
        eid = sprintf('Images:%s:functionReturnsInvalidColormap',mfilename);
        msg = 'function handle MAP must return a n x 3 colormap array';
        error(eid,'%s',msg);
    end
else
    cmap = map;
end

% If ORDER is set to 'shuffle', save original state.  The SHUFFLE keyword
% uses the same state every time it is called. After shuffling is completed,
% go back to original state.
if isequal(order,'shuffle')
    S = rand('state');
    rand('state', 0);
    index = randperm(numregion);
    cmap = cmap(index,:,:);
    rand('state', S);
end

% Issue a warning if the zerocolor (boundary color) matches the color of one
% of the regions. 
for i=1:numregion
  if isequal(zerocolor,cmap(i,:))
    wid= sprintf('Images:%s:zerocolorSameAsRegionColor',mfilename);
    msg= sprintf('Region number %d has the same color as the ZEROCOLOR.',i);
    warning(wid,'%s',msg);
  end
end
cmap = [zerocolor;cmap];

% if label is of type double, need to pass 'label + 1' into IND2RGB.
% IND2RGB does not like double arrays containing zero values.
if isa(label, 'double')
    rgb3d = ind2rgb3d(label + 1, cmap);
else
    rgb3d = ind2rgb3d(label, cmap);
end

%======================================================================
%======================================================================
function [L, Map, Zerocolor, Order, Fcnflag] = parse_inputs(varargin) 
% L         label 3d matrix: matrix containing non-negative values.  
% Map       colormap: name of standard colormap, user-defined map, function
%           handle.
% Zerocolor RGB triple or Colorspec
% Order     keyword if specified: 'shuffle' or 'noshuffle'
% Fcnflag   flag to indicating that Map is a function

valid_order = {'shuffle', 'noshuffle'};
iptchecknargin(1,4,nargin,mfilename);

% set defaults
L = varargin{1};
Map = 'jet';    
Zerocolor = [1 1 1]; 
Order = 'noshuffle';
Fcnflag = 0;

% parse inputs
if nargin > 1
    Map = varargin{2};
end
if nargin > 2
    Zerocolor = varargin{3};
end
if nargin > 3
    Order = varargin{4};
end

% error checking for L
iptcheckinput(L,{'numeric' 'logical'}, ...
              {'real' 'nonsparse' 'finite' 'nonnegative' 'integer'}, ...
              mfilename,'L',1);

% error checking for Map
[fcn, fcnchk_msg] = fcnchk(Map);
if isempty(fcnchk_msg)
    Map = fcn;
    Fcnflag = 1;
else
    if isnumeric(Map)
        if ~isreal(Map) || any(Map(:) > 1) || any(Map(:) < 0) || ...
                    ~isequal(size(Map,2), 3) || size(Map,1) < 1
          eid = sprintf('Images:%s:invalidColormap',mfilename);
          msg = 'Invalid entry for MAP.';
          error(eid,'%s',msg);
        end
    else
        eid = sprintf('Images:%s:invalidFunctionforMAP',mfilename);
        error(eid,'%s',fcnchk_msg);
    end
end    
    
% error checking for Zerocolor
if ~ischar(Zerocolor)
    % check if Zerocolor is a RGB triple
    if ~isreal(Zerocolor) || ~isequal(size(Zerocolor),[1 3]) || ...
                any(Zerocolor> 1) || any(Zerocolor < 0)
      eid = sprintf('Images:%s:invalidZerocolor',mfilename);
      msg = 'Invalid RGB triple entry for ZEROCOLOR.';
      error(eid,'%s',msg);
    end
else    
    [cspec, msg] = cspecchk(Zerocolor);
    if ~isempty(msg)
        eid = sprintf('Images:%s:notInColorspec',mfilename); 
        error(eid,'%s',msg);
    else
        Zerocolor = cspec;
    end
end

% error checking for Order
idx = strmatch(lower(Order), valid_order);
eid = sprintf('Images:%s:invalidEntryForOrder',mfilename);
if isempty(idx)
    msg = 'Valid entries for ORDER are ''shuffle'' or ''noshuffle''.';
    error(eid,'%s',msg);
elseif length(idx) > 1
    msg = sprintf('Ambiguous string for ORDER: %s.', Order);
    error(eid,'%s',msg);
else
    Order = valid_order{idx};
end


%================================================================
%=================================================================
function [rout,g,b] = ind2rgb3d(a,cm)
%IND2RGB Convert indexed image to RGB image.
%   RGB = IND2RGB(X,MAP) converts the 3d matrix X and corresponding
%   colormap MAP to RGB (truecolor) format.
%
%   Class Support
%   -------------
%   X can be of class uint8, uint16, or double. RGB is an 
%   M-by-N-by-3 array of class double.
%
%   See also IND2GRAY, RGB2IND (in the Image Processing Toolbox).


if ~isa(a, 'double')
    a = double(a)+1;    % Switch to one based indexing
end

error(nargchk(2,2,nargin));

% Make sure A is in the range from 1 to size(cm,1)
a = max(1,min(a,size(cm,1)));

% Extract r,g,b components
r = zeros(size(a)); r(:) = cm(a,1);
g = zeros(size(a)); g(:) = cm(a,2);
b = zeros(size(a)); b(:) = cm(a,3);

if nargout==3,
  rout = r;
else
  rout = zeros([size(r),3]);
  rout(:,:,:,1) = r;
  rout(:,:,:,2) = g;
  rout(:,:,:,3) = b;
end
  



 