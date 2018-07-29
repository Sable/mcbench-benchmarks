function varargout = curvature(DEM,varargin)

% 8-connected neighborhood curvature of a digital elevation model 
%
% Syntax
%
%     profc = curvature(DEM)
%     [profc,planc] = curvature(DEM)
%     ...   = curvature(DEM,d)
%     curv  = curvature(DEM,d,'type')
%     [profc,planc] = curvature(DEM,d,'both')
%
% Description
%     
%     curvature returns the second numerical derivative (curvature) of a
%     digital elevation model with cellspacing d (default = 1). 
%     profc is the curvature along the steepest downward gradient (profile 
%     curvature) and planc is the curvature perpendicular to the downward 
%     gradient (planform curvature).
%     
%     In case you wish to have only one of both curvatures returned you can 
%     do so by providing 'prof' or 'plan' as third argument.
%
% Remarks
%     
%     Please note that:
%     - curvature returns 0 for cells with no downward neighbor.
%     - curvature works for single and double precision matrices.
%     - curvature might return discontinuities in the 2nd derivative for 
%       smooth surfaces (e.g. peaks). This is due to the rather coarse 
%       numerical approximation of the steepest gradient.
%
% Example
% 
%     DEM = peaks(50);
%     [profc,planc]=curvature(DEM);
%     subplot(1,3,1)
%     surf(DEM,profc); title('Profile curvature')
%     axis image
%     subplot(1,3,2)
%     surf(DEM,planc); title('Planform curvature')
%     axis image
%     subplot(1,3,3)
%     surf(DEM,profc+planc); title('Profile + planform curvature')
%     axis image
%        
% Author    
%     
%     Wolfgang Schwanghart (w.schwanghart[at]unibas.ch)
% 


% .......................................................................
% check input arguments
if nargin == 1 || nargin == 2;
    if nargin == 1;
        d = 1;
    else
        d = varargin{1};
    end
    if nargout == 2;
        method = 'both';
    elseif nargout <= 1;
        method = 'prof';
    end
elseif nargin == 3;
    d = varargin{1};
    method = varargin{2};
    if ~ischar(method);
        error('type must be a string')
    end
else
    error('Too many input arguments')
end

if ~isscalar(d) || d <= 0
    error('cellsize must be a positive scalar')
end

% ........................................................................
% General variables
siz    = size(DEM);
DEM    = padarray(DEM,[1 1],'replicate');
sizpad = siz+2;
dd     = hypot(d,d);

% anonymous functions for neighborhood operations
neighfun = cell(8,2);

neighfun{1,1} = @() (DEM(2:end-1,2:end-1)-DEM(1:end-2,2:end-1))/d;
neighfun{2,1} = @() (DEM(2:end-1,2:end-1)-DEM(1:end-2,3:end))/dd;
neighfun{3,1} = @() (DEM(2:end-1,2:end-1)-DEM(2:end-1,3:end))/d;
neighfun{4,1} = @() (DEM(2:end-1,2:end-1)-DEM(3:end,3:end))/dd;

neighfun{5,1} = @() (DEM(2:end-1,2:end-1)-DEM(3:end,2:end-1))/d;
neighfun{6,1} = @() (DEM(2:end-1,2:end-1)-DEM(3:end,1:end-2))/dd;
neighfun{7,1} = @() (DEM(2:end-1,2:end-1)-DEM(2:end-1,1:end-2))/d;
neighfun{8,1} = @() (DEM(2:end-1,2:end-1)-DEM(1:end-2,1:end-2))/dd;

neighfun{1,2} = @() -1;
neighfun{2,2} = @() -1 + sizpad(1);
neighfun{3,2} = @() sizpad(1);
neighfun{4,2} = @() 1 + sizpad(1);

neighfun{5,2} = @() 1;
neighfun{6,2} = @() 1 - sizpad(1);
neighfun{7,2} = @() - sizpad(1);
neighfun{8,2} = @() -1 - sizpad(1);


% search maximum downward neighbor
SN  = zeros(siz);
G   = SN;

for neigh = 1:8;
    G2       = neighfun{neigh,1}();
    I        = G2>G;
    G(I)     = G2(I);
    SN(I)    = neighfun{neigh,2}();
end

% calculate curvature
I     = ismember(SN,...
        [neighfun{1,2}() neighfun{3,2}() neighfun{5,2}() neighfun{7,2}()]);
SN    = padarray(SN,[1 1],'replicate');

switch method
    case 'both'
        profc = zeros(sizpad);
        planc = zeros(sizpad);
    case 'prof'
        profc = zeros(sizpad);
    case 'plan'
        planc = zeros(sizpad);
end

for neightype = [1 2];    
    if neightype == 1; % direct neighbors
        I   = padarray(I,[1 1],false);
    else               % diagonal neighbors
        I   = padarray(~I,[1 1],false);
        d   = dd;        
    end
    
    IXc  = find(I);
    IXn  = IXc + SN(IXc);
    
    switch method
        case {'prof','both'}
            IXnd = getneigh(sizpad,IXc,IXn,180);    
            profc(IXc) = (DEM(IXn) - 2*DEM(IXc) + DEM(IXnd))/(d.^2);
        otherwise
    end
    switch method
        case {'plan','both'}
            IXnd = getneigh(sizpad,IXc,IXn,[90 270]);
            planc(IXc) = (DEM(IXnd(:,1)) - 2*DEM(IXc) + DEM(IXnd(:,2)))/(d.^2);
        otherwise
    end
    if neightype == 1;
        I = I(2:end-1,2:end-1);
    end
    
end

switch method
    case 'both'
        varargout{1} = profc(2:end-1,2:end-1);
        varargout{2} = planc(2:end-1,2:end-1);
    case 'prof'
        varargout{1} = profc(2:end-1,2:end-1);
    case 'plan'
        varargout{1} = planc(2:end-1,2:end-1);
end

end




function IXnd = getneigh(siz,IXc,IXn,degs)

% IXnd = getneigh(A,IXc,IXn,degs)
%
% getneigh returns indices IXnd of cells in matrix A, that are 
% (1) neighbors to cells with the indices IXc and
% (2) clockwise rotated by degs degrees to the axis from IXc to IXn 
%
% IXn  45   90
% 315  IXc  135
% 270  225  180
%
% Example:
% 
% A = magic(5)
% 
% A =
% 
%     17    24     1     8    15
%     23     5     7    14    16
%      4     6    13    20    22
%     10    12    19    21     3
%     11    18    25     2     9
%     
% IXc = find(A==5)
% 
% IXc =
% 
%      7
%  
% IXn = find(A==13)
% 
% IXn =
% 
%     13
% 
% IXnd = getneigh(A,IXc,IXn,[45 180])
% 
% IXnd =
% 
%      8     1
%      
%
% Wolfgang Schwanghart
%


% check input arguments
% force row vector
degs = degs(:)';
% force col vector
IXc = IXc(:);
IXn = IXn(:);
nrIX = length(IXc);

if nrIX~=length(IXn);
    error('Indices vectors must have same length')
end

if any(mod(degs,45)~=0);
    error('invalid degree value(s)')
end

nrIX    = length(IXc);
nrdegs  = length(degs);
[r1,c1] = ind2sub(siz,IXc);
[r2,c2] = ind2sub(siz,IXn);


% need for radius adjustment?
i_RA = mod(degs,90);

if any(i_RA);
    d        = hypot(r1'-r2',c1'-c2');
    d1       = 1;
    d2       = sqrt(2);
    d(d==d2) = 1./d2;
    d(d==d1) = d2;
end

IXnd = zeros(nrIX,nrdegs);

% loop through degrees
for run=(1:nrdegs);
    de = degs(run);
    % rotation matrix
    m = [cosd(-de) -sind(-de);sind(-de) cosd(-de)];
    
    if i_RA(run)
        tn = m*([r2'; c2']-[r1'; c1']).*([d;d]) +[r1'; c1'];
    else
        tn = m*([r2'; c2']-[r1'; c1'])+[r1'; c1'];
    end
    tn = tn';
    IXnd(:,run) = (tn(:,2)*siz(1))-siz(1)+tn(:,1);
end
end


