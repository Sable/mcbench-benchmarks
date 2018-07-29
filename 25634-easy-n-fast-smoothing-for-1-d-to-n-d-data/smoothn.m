function [z,s,exitflag] = smoothn(varargin)

%SMOOTHN Robust spline smoothing for 1-D to N-D data.
%   SMOOTHN provides a fast, automatized and robust discretized spline
%   smoothing for data of arbitrary dimension.
%
%   Z = SMOOTHN(Y) automatically smoothes the uniformly-sampled array Y. Y
%   can be any N-D noisy array (time series, images, 3D data,...). Non
%   finite data (NaN or Inf) are treated as missing values.
%
%   Z = SMOOTHN(Y,S) smoothes the array Y using the smoothing parameter S.
%   S must be a real positive scalar. The larger S is, the smoother the
%   output will be. If the smoothing parameter S is omitted (see previous
%   option) or empty (i.e. S = []), it is automatically determined by
%   minimizing the generalized cross-validation (GCV) score.
%
%   Z = SMOOTHN(Y,W) or Z = SMOOTHN(Y,W,S) smoothes Y using a weighting
%   array W of positive values, that must have the same size as Y. Note
%   that a nil weight corresponds to a missing value.
%
%   If you want to smooth a vector field or multicomponent data, Y must be
%   a cell array. For example, if you need to smooth a 3-D vectorial flow
%   (Vx,Vy,Vz), use Y = {Vx,Vy,Vz}. The output Z is also a cell array which
%   contains the smoothed components. See examples 5 to 8 below. 
%
%   Robust smoothing
%   ----------------
%   Z = SMOOTHN(...,'robust') carries out a robust smoothing that minimizes
%   the influence of outlying data.
%
%   [Z,S] = SMOOTHN(...) also returns the calculated value for the
%   smoothness parameter S so that you can fine-tune the smoothing
%   subsequently if needed.
%
%   An iteration process is used in the presence of weighted and/or missing
%   values. Z = SMOOTHN(...,OPTION_NAME,OPTION_VALUE) smoothes with the
%   termination parameters specified by OPTION_NAME and OPTION_VALUE. They
%   can contain the following criteria:
%       -----------------
%       TolZ:       Termination tolerance on Z (default = 1e-3)
%                   TolZ must be in ]0,1[
%       MaxIter:    Maximum number of iterations allowed (default = 100)
%       Initial:    Initial value for the iterative process (default =
%                   original data)
%       Weights:    Weighting function for robust smoothing:
%                   'bisquare' (default), 'talworth' or 'cauchy'
%       -----------------
%   Syntax: [Z,...] = SMOOTHN(...,'MaxIter',500,'TolZ',1e-4,'Initial',Z0);
%
%   [Z,S,EXITFLAG] = SMOOTHN(...) returns a boolean value EXITFLAG that
%   describes the exit condition of SMOOTHN:
%       1       SMOOTHN converged.
%       0       Maximum number of iterations was reached.
%
%   Reference
%   --------- 
%   Garcia D, Robust smoothing of gridded data in one and higher dimensions
%   with missing values. Computational Statistics & Data Analysis, 2010. 
%   <a
%   href="matlab:web('http://www.biomecardio.com/pageshtm/publi/csda10.pdf')">PDF download</a>
%
%   Examples:
%   --------
%   %--- Example #1: smooth a curve ---
%   x = linspace(0,100,2^8);
%   y = cos(x/10)+(x/50).^2 + randn(size(x))/10;
%   y([70 75 80]) = [5.5 5 6];
%   z = smoothn(y); % Regular smoothing
%   zr = smoothn(y,'robust'); % Robust smoothing
%   subplot(121), plot(x,y,'r.',x,z,'k','LineWidth',2)
%   axis square, title('Regular smoothing')
%   subplot(122), plot(x,y,'r.',x,zr,'k','LineWidth',2)
%   axis square, title('Robust smoothing')
%
%   %--- Example #2: smooth a surface ---
%   xp = 0:.02:1;
%   [x,y] = meshgrid(xp);
%   f = exp(x+y) + sin((x-2*y)*3);
%   fn = f + randn(size(f))*0.5;
%   fs = smoothn(fn);
%   subplot(121), surf(xp,xp,fn), zlim([0 8]), axis square
%   subplot(122), surf(xp,xp,fs), zlim([0 8]), axis square
%
%   %--- Example #3: smooth an image with missing data ---
%   n = 256;
%   y0 = peaks(n);
%   y = y0 + randn(size(y0))*2;
%   I = randperm(n^2);
%   y(I(1:n^2*0.5)) = NaN; % lose 1/2 of data
%   y(40:90,140:190) = NaN; % create a hole
%   z = smoothn(y); % smooth data
%   subplot(2,2,1:2), imagesc(y), axis equal off
%   title('Noisy corrupt data')
%   subplot(223), imagesc(z), axis equal off
%   title('Recovered data ...')
%   subplot(224), imagesc(y0), axis equal off
%   title('... compared with the actual data')
%
%   %--- Example #4: smooth volumetric data ---
%   [x,y,z] = meshgrid(-2:.2:2);
%   xslice = [-0.8,1]; yslice = 2; zslice = [-2,0];
%   vn = x.*exp(-x.^2-y.^2-z.^2) + randn(size(x))*0.06;
%   subplot(121), slice(x,y,z,vn,xslice,yslice,zslice,'cubic')
%   title('Noisy data')
%   v = smoothn(vn);
%   subplot(122), slice(x,y,z,v,xslice,yslice,zslice,'cubic')
%   title('Smoothed data')
%
%   %--- Example #5: smooth a cardioid ---
%   t = linspace(0,2*pi,1000);
%   x = 2*cos(t).*(1-cos(t)) + randn(size(t))*0.1;
%   y = 2*sin(t).*(1-cos(t)) + randn(size(t))*0.1;
%   z = smoothn({x,y});
%   plot(x,y,'r.',z{1},z{2},'k','linewidth',2)
%   axis equal tight
%
%   %--- Example #6: smooth a 3-D parametric curve ---
%   t = linspace(0,6*pi,1000);
%   x = sin(t) + 0.1*randn(size(t));
%   y = cos(t) + 0.1*randn(size(t));
%   z = t + 0.1*randn(size(t));
%   u = smoothn({x,y,z});
%   plot3(x,y,z,'r.',u{1},u{2},u{3},'k','linewidth',2)
%   axis tight square
%
%   %--- Example #7: smooth a 2-D vector field ---
%   [x,y] = meshgrid(linspace(0,1,24));
%   Vx = cos(2*pi*x+pi/2).*cos(2*pi*y);
%   Vy = sin(2*pi*x+pi/2).*sin(2*pi*y);
%   Vx = Vx + sqrt(0.05)*randn(24,24); % adding Gaussian noise
%   Vy = Vy + sqrt(0.05)*randn(24,24); % adding Gaussian noise
%   I = randperm(numel(Vx));
%   Vx(I(1:30)) = (rand(30,1)-0.5)*5; % adding outliers
%   Vy(I(1:30)) = (rand(30,1)-0.5)*5; % adding outliers
%   Vx(I(31:60)) = NaN; % missing values
%   Vy(I(31:60)) = NaN; % missing values
%   Vs = smoothn({Vx,Vy},'robust'); % automatic smoothing
%   subplot(121), quiver(x,y,Vx,Vy,2.5), axis square
%   title('Noisy velocity field')
%   subplot(122), quiver(x,y,Vs{1},Vs{2}), axis square
%   title('Smoothed velocity field')
%
%   %--- Example #8: smooth a 3-D vector field ---
%   load wind % original 3-D flow
%   % -- Create noisy data
%   % Gaussian noise
%   un = u + randn(size(u))*8;
%   vn = v + randn(size(v))*8;
%   wn = w + randn(size(w))*8;
%   % Add some outliers
%   I = randperm(numel(u)) < numel(u)*0.025;
%   un(I) = (rand(1,nnz(I))-0.5)*200;
%   vn(I) = (rand(1,nnz(I))-0.5)*200;
%   wn(I) = (rand(1,nnz(I))-0.5)*200;
%   % -- Visualize the noisy flow (see CONEPLOT documentation)
%   figure, title('Noisy 3-D vectorial flow')
%   xmin = min(x(:)); xmax = max(x(:));
%   ymin = min(y(:)); ymax = max(y(:));
%   zmin = min(z(:));
%   daspect([2,2,1])
%   xrange = linspace(xmin,xmax,8);
%   yrange = linspace(ymin,ymax,8);
%   zrange = 3:4:15;
%   [cx cy cz] = meshgrid(xrange,yrange,zrange);
%   k = 0.1;
%   hcones = coneplot(x,y,z,un*k,vn*k,wn*k,cx,cy,cz,0);
%   set(hcones,'FaceColor','red','EdgeColor','none')
%   hold on
%   wind_speed = sqrt(un.^2 + vn.^2 + wn.^2);
%   hsurfaces = slice(x,y,z,wind_speed,[xmin,xmax],ymax,zmin);
%   set(hsurfaces,'FaceColor','interp','EdgeColor','none')
%   hold off
%   axis tight; view(30,40); axis off
%   camproj perspective; camzoom(1.5)
%   camlight right; lighting phong
%   set(hsurfaces,'AmbientStrength',.6)
%   set(hcones,'DiffuseStrength',.8)
%   % -- Smooth the noisy flow
%   Vs = smoothn({un,vn,wn},'robust');
%   % -- Display the result
%   figure, title('3-D flow smoothed by SMOOTHN')
%   daspect([2,2,1])
%   hcones = coneplot(x,y,z,Vs{1}*k,Vs{2}*k,Vs{3}*k,cx,cy,cz,0);
%   set(hcones,'FaceColor','red','EdgeColor','none')
%   hold on
%   wind_speed = sqrt(Vs{1}.^2 + Vs{2}.^2 + Vs{3}.^2);
%   hsurfaces = slice(x,y,z,wind_speed,[xmin,xmax],ymax,zmin);
%   set(hsurfaces,'FaceColor','interp','EdgeColor','none')
%   hold off
%   axis tight; view(30,40); axis off
%   camproj perspective; camzoom(1.5)
%   camlight right; lighting phong
%   set(hsurfaces,'AmbientStrength',.6)
%   set(hcones,'DiffuseStrength',.8)
%
%   See also DCTSMOOTH, SMOOTH1Q, DCTN, IDCTN.
%
%   -- Damien Garcia -- 2009/03, revised 2013/09
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

% Check input arguments
error(nargchk(1,12,nargin));

%% Test & prepare the variables
%---
k = 0;
while k<nargin && ~ischar(varargin{k+1}), k = k+1; end
%---
% y = array to be smoothed
y = varargin{1};
if ~iscell(y), y = {y}; end
sizy = size(y{1});
ny = numel(y); % number of y components
for i = 1:ny
    if ~isequal(sizy,size(y{i}))
        error('Matlab:smoothn:SizeMismatch',...
            'Data arrays must have the same size.')
    end
    y{i} = double(y{i});
end
noe = prod(sizy); % number of elements
if noe<2, z = y; s = []; exitflag = true; return, end
%---
% Smoothness parameter and weights
W = ones(sizy);
s = [];
if k==2
    if isempty(varargin{2}) || isscalar(varargin{2}) % smoothn(y,s)
        s = varargin{2}; % smoothness parameter
    else % smoothn(y,W)
        W = varargin{2}; % weight array
    end
elseif k==3 % smoothn(y,W,s)
        W = varargin{2}; % weight array
        s = varargin{3}; % smoothness parameter
end
if ~isequal(size(W),sizy)
        error('MATLAB:smoothn:SizeMismatch',...
            'Arrays for data and weights (Y and W) must have same size.')
elseif ~isempty(s) && (~isscalar(s) || s<0)
    error('MATLAB:smoothn:IncorrectSmoothingParameter',...
        'The smoothing parameter S must be a scalar >=0')
end
%---
% "Maximal number of iterations" criterion
I = find(strcmpi(varargin,'MaxIter'),1);
if isempty(I)
    MaxIter = 100; % default value for MaxIter
else
    try
        MaxIter = varargin{I+1};
    catch %#ok
        error('MATLAB:smoothn:IncorrectMaxIter',...
            'MaxIter must be an integer >=1')
    end
    if ~isnumeric(MaxIter) || ~isscalar(MaxIter) ||...
            MaxIter<1 || MaxIter~=round(MaxIter)
        error('MATLAB:smoothn:IncorrectMaxIter',...
            'MaxIter must be an integer >=1')        
    end    
end
%---
% "Tolerance on smoothed output" criterion
I = find(strcmpi(varargin,'TolZ'),1);
if isempty(I)
    TolZ = 1e-3; % default value for TolZ
else
    try
        TolZ = varargin{I+1};
    catch %#ok
        error('MATLAB:smoothn:IncorrectTolZ',...
            'TolZ must be in ]0,1[')
    end
    if ~isnumeric(TolZ) || ~isscalar(TolZ) || TolZ<=0 || TolZ>=1 
        error('MATLAB:smoothn:IncorrectTolZ',...
            'TolZ must be in ]0,1[')
    end    
end
%---
% "Initial Guess" criterion
I = find(strcmpi(varargin,'Initial'),1);
if isempty(I)
    isinitial = false; % default value for TolZ
else
    isinitial = true;
    try
        z0 = varargin{I+1};
    catch %#ok
        error('MATLAB:smoothn:IncorrectInitialGuess',...
            'Z0 must be a valid initial guess for Z')
    end
    if ~isnumeric(z0) || ~isequal(size(z0),sizy) 
        error('MATLAB:smoothn:IncorrectTolZ',...
            'Z0 must be a valid initial guess for Z')
    end    
end
%---
% "Weighting function" criterion (for robust smoothing)
I = find(strcmpi(varargin,'Weights'),1);
if isempty(I)
    weightstr = 'bisquare'; % default weighting function
else
    try
        weightstr = lower(varargin{I+1});
    catch ME
        error('MATLAB:smoothn:IncorrectWeights',...
            'A valid weighting function must be chosen')
    end
    if ~ischar(weightstr)
        error('MATLAB:smoothn:IncorrectWeights',...
            'A valid weighting function must be chosen')
    end    
end
%---
% "Order" criterion (by default m = 2)
% Note: m = 0 is of course not recommended!
I = find(strcmpi(varargin,'Order'),1);
if isempty(I)
    m = 2; % order
else
    try
        m = varargin{I+1};
    catch %#ok
        error('MATLAB:smoothn:IncorrectOrder',...
            'A valid order must be chosen')
    end
    if ~ismember(m,0:2);
        error('MATLAB:smoothn:IncorrectOrder',...
            'The order must be 0, 1 or 2.')
    end    
end
%---
% Weights. Zero weights are assigned to not finite values (Inf or NaN),
% (Inf/NaN values = missing data).
IsFinite = isfinite(y{1});
for i = 2:ny, IsFinite = IsFinite & isfinite(y{i}); end
nof = nnz(IsFinite); % number of finite elements
W = W.*IsFinite;
if any(W<0)
    error('MATLAB:smoothn:NegativeWeights',...
        'Weights must all be >=0')
else 
    W = W/max(W(:));
end
%---
% Weighted or missing data?
isweighted = any(W(:)<1);
%---
% Robust smoothing?
isrobust = any(strcmpi(varargin,'robust'));
%---
% Automatic smoothing?
isauto = isempty(s);

%% Create the Lambda tensor
%---
% Lambda contains the eingenvalues of the difference matrix used in this
% penalized least squares process (see CSDA paper for details)
d = ndims(y);
Lambda = zeros(sizy);
for i = 1:d
    siz0 = ones(1,d);
    siz0(i) = sizy(i);
    Lambda = bsxfun(@plus,Lambda,...
        cos(pi*(reshape(1:sizy(i),siz0)-1)/sizy(i)));
end
Lambda = 2*(d-Lambda);
if ~isauto, Gamma = 1./(1+s*Lambda.^m); end

%% Upper and lower bound for the smoothness parameter
% The average leverage (h) is by definition in [0 1]. Weak smoothing occurs
% if h is close to 1, while over-smoothing appears when h is near 0. Upper
% and lower bounds for h are given to avoid under- or over-smoothing. See
% equation relating h to the smoothness parameter for m = 2 (Equation #12
% in the referenced CSDA paper).
N = sum(sizy~=1); % tensor rank of the y-array
hMin = 1e-6; hMax = 0.99;
if m==0 % Not recommended. For mathematical purpose only.
    sMinBnd = 1/hMax^(1/N)-1;
    sMaxBnd = 1/hMin^(1/N)-1;
elseif m==1
    sMinBnd = (1/hMax^(2/N)-1)/4;
    sMaxBnd = (1/hMin^(2/N)-1)/4;
elseif m==2
    sMinBnd = (((1+sqrt(1+8*hMax^(2/N)))/4/hMax^(2/N))^2-1)/16;
    sMaxBnd = (((1+sqrt(1+8*hMin^(2/N)))/4/hMin^(2/N))^2-1)/16;
end

%% Initialize before iterating
%---
Wtot = W;
%--- Initial conditions for z
if isweighted
    %--- With weighted/missing data
    % An initial guess is provided to ensure faster convergence. For that
    % purpose, a nearest neighbor interpolation followed by a coarse
    % smoothing are performed.
    %---
    if isinitial % an initial guess (z0) has been already given
        z = z0;
    else
        z = InitialGuess(y,IsFinite);
    end
else
    z = cell(size(y));
    for i = 1:ny, z{i} = zeros(sizy); end
end
%---
z0 = z;
for i = 1:ny
    y{i}(~IsFinite) = 0; % arbitrary values for missing y-data
end
%---
tol = 1;
RobustIterativeProcess = true;
RobustStep = 1;
nit = 0;
DCTy = cell(1,ny);
vec = @(x) x(:);
%--- Error on p. Smoothness parameter s = 10^p
errp = 0.1;
opt = optimset('TolX',errp);
%--- Relaxation factor RF: to speedup convergence
RF = 1 + 0.75*isweighted;

%% Main iterative process
%---
while RobustIterativeProcess
    %--- "amount" of weights (see the function GCVscore)
    aow = sum(Wtot(:))/noe; % 0 < aow <= 1
    %---
    while tol>TolZ && nit<MaxIter
        nit = nit+1;
        for i = 1:ny
            DCTy{i} = dctn(Wtot.*(y{i}-z{i})+z{i});
        end
        if isauto && ~rem(log2(nit),1)
            %---
            % The generalized cross-validation (GCV) method is used.
            % We seek the smoothing parameter S that minimizes the GCV
            % score i.e. S = Argmin(GCVscore).
            % Because this process is time-consuming, it is performed from
            % time to time (when the step number - nit - is a power of 2)
            %---
            fminbnd(@gcv,log10(sMinBnd),log10(sMaxBnd),opt);
        end
        for i = 1:ny
            z{i} = RF*idctn(Gamma.*DCTy{i}) + (1-RF)*z{i};
        end
        
        % if no weighted/missing data => tol=0 (no iteration)
        tol = isweighted*norm(vec([z0{:}]-[z{:}]))/norm(vec([z{:}]));
       
        z0 = z; % re-initialization
    end
    exitflag = nit<MaxIter;

    if isrobust %-- Robust Smoothing: iteratively re-weighted process
        %--- average leverage
        if m==0 % not recommended
            h = 1/(1+s);
        elseif m==1
            h = 1/sqrt(1+4*s);
        elseif m==2
            h = sqrt(1+16*s);
            h = sqrt(1+h)/sqrt(2)/h;
        else
            error('m must be 0, 1 or 2.')
        end
        h = h^N;
        %--- take robust weights into account
        Wtot = W.*RobustWeights(y,z,IsFinite,h,weightstr);
        %--- re-initialize for another iterative weighted process
        isweighted = true; tol = 1; nit = 0; 
        %---
        RobustStep = RobustStep+1;
        RobustIterativeProcess = RobustStep<4; % 3 robust steps are enough.
    else
        RobustIterativeProcess = false; % stop the whole process
    end
end

%% Warning messages
%---
if isauto
    if abs(log10(s)-log10(sMinBnd))<errp
        warning('MATLAB:smoothn:SLowerBound',...
            ['S = ' num2str(s,'%.3e') ': the lower bound for S ',...
            'has been reached. Put S as an input variable if required.'])
    elseif abs(log10(s)-log10(sMaxBnd))<errp
        warning('MATLAB:smoothn:SUpperBound',...
            ['S = ' num2str(s,'%.3e') ': the upper bound for S ',...
            'has been reached. Put S as an input variable if required.'])
    end
end
if nargout<3 && ~exitflag
    warning('MATLAB:smoothn:MaxIter',...
        ['Maximum number of iterations (' int2str(MaxIter) ') has ',...
        'been exceeded. Increase MaxIter option or decrease TolZ value.'])
end

if numel(z)==1, z = z{:}; end


%% GCV score
%---
function GCVscore = gcv(p)
    % Search the smoothing parameter s that minimizes the GCV score
    %---
    s = 10^p;
    Gamma = 1./(1+s*Lambda.^m);
    %--- RSS = Residual sum-of-squares
    RSS = 0;
    if aow>0.9 % aow = 1 means that all of the data are equally weighted
        % very much faster: does not require any inverse DCT
        for kk = 1:ny
            RSS = RSS + norm(DCTy{kk}(:).*(Gamma(:)-1))^2;
        end
    else
        % take account of the weights to calculate RSS:
        for kk = 1:ny
            yhat = idctn(Gamma.*DCTy{kk});
            RSS = RSS + norm(sqrt(Wtot(IsFinite)).*...
                (y{kk}(IsFinite)-yhat(IsFinite)))^2;
        end
    end
    %---
    TrH = sum(Gamma(:));
    GCVscore = RSS/nof/(1-TrH/noe)^2;
end

end

function W = RobustWeights(y,z,I,h,wstr)
    % One seeks the weights for robust smoothing...
    ABS = @(x) sqrt(sum(abs(x).^2,2));
    r = cellfun(@minus,y,z,'UniformOutput',0); % residuals
    r = cellfun(@(x) x(:),r,'UniformOutput',0);
    rI = cell2mat(cellfun(@(x) x(I),r,'UniformOutput',0));
    MMED = median(rI); % marginal median
    AD = ABS(bsxfun(@minus,rI,MMED)); % absolute deviation
    MAD = median(AD); % median absolute deviation
 
    %-- Studentized residuals
    u = ABS(cell2mat(r))/(1.4826*MAD)/sqrt(1-h); 
    u = reshape(u,size(I));
    
    if strcmp(wstr,'cauchy')
        c = 2.385; W = 1./(1+(u/c).^2); % Cauchy weights
    elseif strcmp(wstr,'talworth')
        c = 2.795; W = u<c; % Talworth weights
    elseif strcmp(wstr,'bisquare')
        c = 4.685; W = (1-(u/c).^2).^2.*((u/c)<1); % bisquare weights
    else
        error('MATLAB:smoothn:IncorrectWeights',...
            'A valid weighting function must be chosen')        
    end
    W(isnan(W)) = 0;

% NOTE:
% ----
% The RobustWeights subfunction looks complicated since we work with cell
% arrays. For better clarity, here is how it would look like without the
% use of cells. Much more readable, isn't it?
%
% function W = RobustWeights(y,z,I,h)
%     % weights for robust smoothing.
%     r = y-z; % residuals
%     MAD = median(abs(r(I)-median(r(I)))); % median absolute deviation
%     u = abs(r/(1.4826*MAD)/sqrt(1-h)); % studentized residuals
%     c = 4.685; W = (1-(u/c).^2).^2.*((u/c)<1); % bisquare weights
%     W(isnan(W)) = 0;
% end

end

%% Initial Guess with weighted/missing data
function z = InitialGuess(y,I)
    ny = numel(y);
    %-- nearest neighbor interpolation (in case of missing values)
    if any(~I(:))
        z = cell(size(y));        
        if license('test','image_toolbox')
            for i = 1:ny
                [z{i},L] = bwdist(I);
                z{i} = y{i};
                z{i}(~I) = y{i}(L(~I));
            end
        else
        % If BWDIST does not exist, NaN values are all replaced with the
        % same scalar. The initial guess is not optimal and a warning
        % message thus appears.
            z = y;
            for i = 1:ny
                z{i}(~I) = mean(y{i}(I));
            end
            warning('MATLAB:smoothn:InitialGuess',...
                ['BWDIST (Image Processing Toolbox) does not exist. ',...
                'The initial guess may not be optimal; additional',...
                ' iterations can thus be required to ensure complete',...
                ' convergence. Increase ''MaxIter'' criterion if necessary.'])    
        end
    else
        z = y;
    end
    %-- coarse fast smoothing using one-tenth of the DCT coefficients
    siz = size(z{1});
    z = cellfun(@(x) dctn(x),z,'UniformOutput',0);
    for k = 1:ndims(z{1})
        for i = 1:ny
            z{i}(ceil(siz(k)/10)+1:end,:) = 0;
            z{i} = reshape(z{i},circshift(siz,[0 1-k]));
            z{i} = shiftdim(z{i},1);
        end
    end
    z = cellfun(@(x) idctn(x),z,'UniformOutput',0);
end

%% DCTN
function y = dctn(y)

%DCTN N-D discrete cosine transform.
%   Y = DCTN(X) returns the discrete cosine transform of X. The array Y is
%   the same size as X and contains the discrete cosine transform
%   coefficients. This transform can be inverted using IDCTN.
%
%   Reference
%   ---------
%   Narasimha M. et al, On the computation of the discrete cosine
%   transform, IEEE Trans Comm, 26, 6, 1978, pp 934-936.
%
%   Example
%   -------
%       RGB = imread('autumn.tif');
%       I = rgb2gray(RGB);
%       J = dctn(I);
%       imshow(log(abs(J)),[]), colormap(jet), colorbar
%
%   The commands below set values less than magnitude 10 in the DCT matrix
%   to zero, then reconstruct the image using the inverse DCT.
%
%       J(abs(J)<10) = 0;
%       K = idctn(J);
%       figure, imshow(I)
%       figure, imshow(K,[0 255])
%
%   -- Damien Garcia -- 2008/06, revised 2011/11
%   -- www.BiomeCardio.com --

y = double(y);
sizy = size(y);
y = squeeze(y);
dimy = ndims(y);

% Some modifications are required if Y is a vector
if isvector(y)
    dimy = 1;
    if size(y,1)==1, y = y.'; end
end

% Weighting vectors
w = cell(1,dimy);
for dim = 1:dimy
    n = (dimy==1)*numel(y) + (dimy>1)*sizy(dim);
    w{dim} = exp(1i*(0:n-1)'*pi/2/n);
end

% --- DCT algorithm ---
if ~isreal(y)
    y = complex(dctn(real(y)),dctn(imag(y)));
else
    for dim = 1:dimy
        siz = size(y);
        n = siz(1);
        y = y([1:2:n 2*floor(n/2):-2:2],:);
        y = reshape(y,n,[]);
        y = y*sqrt(2*n);
        y = ifft(y,[],1);
        y = bsxfun(@times,y,w{dim});
        y = real(y);
        y(1,:) = y(1,:)/sqrt(2);
        y = reshape(y,siz);
        y = shiftdim(y,1);
    end
end
        
y = reshape(y,sizy);

end

%% IDCTN
function y = idctn(y)

%IDCTN N-D inverse discrete cosine transform.
%   X = IDCTN(Y) inverts the N-D DCT transform, returning the original
%   array if Y was obtained using Y = DCTN(X).
%
%   Reference
%   ---------
%   Narasimha M. et al, On the computation of the discrete cosine
%   transform, IEEE Trans Comm, 26, 6, 1978, pp 934-936.
%
%   Example
%   -------
%       RGB = imread('autumn.tif');
%       I = rgb2gray(RGB);
%       J = dctn(I);
%       imshow(log(abs(J)),[]), colormap(jet), colorbar
%
%   The commands below set values less than magnitude 10 in the DCT matrix
%   to zero, then reconstruct the image using the inverse DCT.
%
%       J(abs(J)<10) = 0;
%       K = idctn(J);
%       figure, imshow(I)
%       figure, imshow(K,[0 255])
%
%   See also DCTN, IDSTN, IDCT, IDCT2, IDCT3.
%
%   -- Damien Garcia -- 2009/04, revised 2011/11
%   -- www.BiomeCardio.com --

y = double(y);
sizy = size(y);
y = squeeze(y);
dimy = ndims(y);

% Some modifications are required if Y is a vector
if isvector(y)
    dimy = 1;
    if size(y,1)==1
        y = y.';
    end
end

% Weighing vectors
w = cell(1,dimy);
for dim = 1:dimy
    n = (dimy==1)*numel(y) + (dimy>1)*sizy(dim);
    w{dim} = exp(1i*(0:n-1)'*pi/2/n);
end

% --- IDCT algorithm ---
if ~isreal(y)
    y = complex(idctn(real(y)),idctn(imag(y)));
else
    for dim = 1:dimy
        siz = size(y);
        n = siz(1);
        y = reshape(y,n,[]);
        y = bsxfun(@times,y,w{dim});
        y(1,:) = y(1,:)/sqrt(2);
        y = ifft(y,[],1);
        y = real(y*sqrt(2*n));
        I = (1:n)*0.5+0.5;
        I(2:2:end) = n-I(1:2:end-1)+1;
        y = y(I,:);
        y = reshape(y,siz);
        y = shiftdim(y,1);            
    end
end
        
y = reshape(y,sizy);

end

