function [h2d, binC_x, binC_y, mesh_minmaxN_xy] = hist2(vxy, mesh_minmaxN_xy, varargin)
% [h2D, binC_x, binC_y, Edges_MinMaxN_XY] = hist2(Data_XY, Edges_MinMaxN_XY, BIN_MODE, EPSILON, GRID_ADJ_MODE)
%
% 2D histogram with 'fast' and 'exact' binning modes. Adjustable bin grid.
% Output of mesh centers for easy plot. (see section EXAMPLES, PLOT)
%
% Data_XY   - can be [M x 2] or [2 x M], will assign row/col 1 to X, 2->Y
%
% Edges_MinMaxN_XY ->
% It has two rows and 1-3 columns (see also EXAMPLES section). 
% It specifies the mesh as follows:
%   if of length 1 : {Nbins}, will scale min-to-max 
%   if of length 2 : {min,max}, will default to Nbins=10 bins
%   if of length 3 : {min, max, Nbins}
% the adjusted mesh will be returned
%
% BIN_MODE can be:
% 	'fast'  - default, classical behaviour, adequate for most real-life situations
%   'exact' - will split between adjacent bins the points whose values 
%             fall in the interval (edge-EPSILON, edge+EPSILON)
%
% EPSILON   - tolerance around edge; default 1e-14
% 
% GRID_ADJ_MODE - Input data handling, two grid adjustment modes: 
%   'crop'  - default, discard data outside the specified meshes
%  'stretch'- adjust the passed meshes so that all data is binned
%             (preserve the step and the passed locations)
%
% EXAMPLES :
%
% binEdges_minmaxN_xy = [10 100 91; 0 10 21];
% [h2d, binC_x, binC_y, binE_corr] = hist2(data2d, binEdges_minmaxN_xy);
% % - histogram that yields a 90x20 bin array
% h2d = hist2(data, [20 20]');
% % - histogram using a 20x20 bin mesh 'stretched' to data range
% [h2d, binC_x, binC_y] = hist2(data, binEdges_minmaxN_xy, 'exact', 1e-9);
% % - 'exact' histogram using binEdges_minmaxN_xy, epsilon of 1e-9
%
% to PLOT :
%   imagesc(binC_x, binC_y, h2d); 
% 
% 2011.08.28, v. 1.1, tudima at zahoo dot com, change the z into y

% 2008.01.21    - new, v. 1.0
% 2010.06.14    - v. 1.0.1, better output bin export
% 2011.08.28    - v. 1.1
%               multiple binning modes ('crop', 'stretch')
%               speed improvement in 'fast' mode (10x-40x, more for large data)

% --- input protection/detection ---
[BinningFastNotExact, GridAdj_CropNotStretch, eps] = uInHandle(varargin);

% figure out if data transposed !
if size(vxy,1) < size(vxy,2) 
    vxy = vxy.';
end
% decompose vxy in vx vy
if size(vxy,2) >= 2 % if 3+ will keep Nx2 data
    vx = vxy(:,1); vy = vxy(:,2);
else
    vx = real(vxy); vy = imag(vxy);
end
clear vxy

data_minmax_xy = [min(vx(:)) max(vx(:)); min(vy(:)) max(vy(:))];

% handle input mesh, define/adjust min/max x, y, mesh step :
mesh_minmaxN_xy = uGridAdjust(mesh_minmaxN_xy, data_minmax_xy, ...
     GridAdj_CropNotStretch);

if GridAdj_CropNotStretch % 'crop'
    ixKeep = ...
        vx >= mesh_minmaxN_xy(1,1) & ...
        vx <= mesh_minmaxN_xy(1,2) & ...
        vy >= mesh_minmaxN_xy(2,1) & ...
        vy <= mesh_minmaxN_xy(2,2);
    vx = vx(ixKeep,:);
    vy = vy(ixKeep);
end

% 2.a,b figure out xy scales, still _x and _y, next {1/2}
N_x = mesh_minmaxN_xy(1,3);
step_x = (mesh_minmaxN_xy(1,2) - mesh_minmaxN_xy(1,1))/(N_x-1);
BinUpperEdge_x = mesh_minmaxN_xy(1,1) + (1:N_x-1)*step_x;

N_y = mesh_minmaxN_xy(2,3);
step_y = (mesh_minmaxN_xy(2,2) - mesh_minmaxN_xy(2,1))/(N_y-1);
BinUpperEdge_y = mesh_minmaxN_xy(2,1) + (1:N_y-1)*step_y;

% 2.c recompose and export the (corrected) 3-length scale vector
% v.1.1
minmaxN_x = mesh_minmaxN_xy(1,:); 
minmaxN_y = mesh_minmaxN_xy(2,:); 
% was (in v. 1.0.1, new output scale, easier 2d plots!)
% calculate bin Centers, if wanted; N edges yield N-1 centers
if nargout > 1 % export binCenters_x
    binC_x = minmaxN_x(1)+step_x/2:step_x:minmaxN_x(2)-step_x/2;
    % eges was :
    % binE_x = linspace(minmaxN_x(1), minmaxN_x(2), minmaxN_x(3));
end
if nargout > 2 % export binCenters_y
    binC_y = minmaxN_y(1)+step_y/2:step_y:minmaxN_y(2)-step_y/2;
    % eges was :
    % binE_y = linspace(minmaxN_y(1), minmaxN_y(2), minmaxN_y(3));
end
% --- end input protection / conditioning ---

if BinningFastNotExact
    h2d = zeros(N_y-1, N_x-1, 'single');
%h2d = zeros(N_x, N_y, 'single');
    % insert here fast code from stat2DBin
    nP = numel(vx);
    BinIx_xy = zeros(nP,2, 'uint16');

    binE_x = [mesh_minmaxN_xy(1,1) BinUpperEdge_x];

    [hist_cum_x, tmp_BinIx] = histc(vx, binE_x);
    % consolidate the last two bins, i.e. last interval is [ ], not [ )
    nBins = numel(binE_x)-1;
    ixLastBin = tmp_BinIx == nBins+1;
    tmp_BinIx(ixLastBin) = nBins;
    % now an N+1 long binEdges vector has generated an N long bin center vector
    BinIx_xy(:,1) = uint16(tmp_BinIx);

    % bin by Y
    binE_y = [mesh_minmaxN_xy(2,1) BinUpperEdge_y];

    [hist_cum_x, tmp_BinIx] = histc(vy, binE_y);
    % consolidate the last two bins, i.e. last interval is [ ], not [ )
    nBins = numel(binE_y)-1;
    ixLastBin = tmp_BinIx == nBins+1;
    tmp_BinIx(ixLastBin) = nBins;
    % N+1 long binEdges vector -> generates an N long bin center vector
    BinIx_xy(:,2) = uint16(tmp_BinIx);
    
    % convert bin info 2 histogram:
    tSignal_10p = round((0.05:0.05:1)*nP);
    tFlagIx = 1;
    for i = 1:nP
        %fprintf('%s', prompt{rem(i,4)+1}) % 'hourglass'
        h2d(BinIx_xy(i,2),BinIx_xy(i,1)) = ...
            h2d(BinIx_xy(i,2),BinIx_xy(i,1)) + 1;
        %fprintf('%s', 8) % backspace, delete 'hourglass'
%         if i == tSignal_10p(tFlagIx)
%             fprintf('%s', '.')
%             tFlagIx = tFlagIx+1;
%         end
    end
    
    return

end

% one only gets here in "exact" mode ONLY
epsWeight = 1;
% logic table of navigation parameters
% binSkip  eps_sign    bin_coeff   LowerEdge   UpperEdge       thisBin(s)
% 0         +1          1/2         th(n-1)-eps th(n-1)+eps     n-1, n
% 1         -1          1           th(n-1)+eps th(n)-eps       n
% 0         +1          1/2         th(n)-eps   th(n)+eps       n, n+1
% ...
% 0         +1          1/2         th(e-1)-eps th(e-1)+eps     e-1 (e=end)
% 1         0           1           th(e-1)+eps th(e)           end, cum ?

% --- calculate histogram ---
h2d = zeros(N_y-1, N_x-1); 
thisBin_x = 1; 
ix_remaining_x = (1:max(size(vx)));
% init bin-navigating characteristics X, advance binSkip by binSkip :-)
epsSign_x = -1; binShareFactor_x = 1;
%binSkip_x = 1; 
while thisBin_x <= N_x-1
    % check one bin width :
    threshold_x = BinUpperEdge_x(thisBin_x) + epsSign_x*eps; % -eps
    ix_this_bin_x = find(vx(ix_remaining_x)<=threshold_x); 
    ix_orig_x = ix_remaining_x(ix_this_bin_x);
    % among these ones sort y...
    thisBin_y = 1;
    ix_remaining_y = ix_orig_x; % only look at points selected by x
    % init bin-navigating characteristics Y
    epsSign_y = -1; binShareFactor_y = 1;
    %binSkip_y = 1; 
    while thisBin_y <= N_y-1              
        threshold_y = BinUpperEdge_y(thisBin_y)+ epsSign_y*eps; % -eps
        ix_this_bin_y = find(vy(ix_remaining_y)<=threshold_y); 
        % mark as found x,y
        ix_orig_y = ix_remaining_y(ix_this_bin_y);
        % --- update the histogram ---
        noOfElHere = length(ix_this_bin_y);
        if noOfElHere >0
            if binShareFactor_y == 1/2
                if binShareFactor_x == 1/2 % some of these coud be inits, not acc.; but easy is safe !
                    h2d(thisBin_y,thisBin_x) = h2d(thisBin_y,thisBin_x)+ noOfElHere/4;
                    h2d(thisBin_y+1,thisBin_x) = h2d(thisBin_y+1,thisBin_x)+ noOfElHere/4;
                    h2d(thisBin_y,thisBin_x+1) = h2d(thisBin_y,thisBin_x+1)+ noOfElHere/4;
                    h2d(thisBin_y+1,thisBin_x+1) = h2d(thisBin_y+1,thisBin_x+1)+ noOfElHere/4;
                else % _x 1
                    h2d(thisBin_y,thisBin_x) = h2d(thisBin_y,thisBin_x) +noOfElHere/2;
                    h2d(thisBin_y+1,thisBin_x) = h2d(thisBin_y+1,thisBin_x) +noOfElHere/2;                        
                end;
            else % _y 1
                if binShareFactor_x == 1/2
                    h2d(thisBin_y,thisBin_x) = h2d(thisBin_y,thisBin_x) + noOfElHere/2;
                    h2d(thisBin_y,thisBin_x+1) = h2d(thisBin_y,thisBin_x+1) +noOfElHere/2;
                else % 1
                    h2d(thisBin_y,thisBin_x) = h2d(thisBin_y,thisBin_x) + noOfElHere;                        
                end;
            end;
        end; % --- end histogram updating 
        % eliminate these y-bins
        ix_remaining_y(ix_this_bin_y) = 0;   
        ix_remaining_y = ix_remaining_y(ix_remaining_y >0);
        % sanity :
        if isempty(ix_remaining_y), break, end
        
        % --- update navigation params Y --- advance y Bin counter ---
        epsSign_y = -epsSign_y * ~(thisBin_y == N_y-1) *epsWeight; % 0 for last bin or in 'fast' mode
        binSkip_y = ~(epsSign_y==1); 
        binShareFactor_y = (binSkip_y+1)/2;         
        thisBin_y = thisBin_y + binSkip_y;           
    end % while y
    
    % eliminate x-bins -- slow way... 
    ix_remaining_x(ix_this_bin_x) = 0;   
    ix_remaining_x = ix_remaining_x(ix_remaining_x >0);  
    % sanity :
    if isempty(ix_remaining_x), break, end
    
    % --- update navigation params X --- advance bin counter ---
    epsSign_x = -epsSign_x * ~(thisBin_x == N_x-1) *epsWeight; % 0 for last bin or in 'fast' mode
    binSkip_x = ~(epsSign_x==1); 
    binShareFactor_x = (binSkip_x+1)/2;
    thisBin_x = thisBin_x + binSkip_x;            
end % while x

end

function binEdges_minmaxN_xy = uGridAdjust(binEdges_minmaxN_xy, data_minmax_xy, ...
     GridAdj_CropNotStretch) % later pass? BinningFastNotExact for 'exact' 2x bins
% binEdges_minmaxN_xy has 2 rows x/y, 1 col:N, 2:minmax, 3: minmaxN

% init. defaults first
Ne = [10 10]'; % number of EDGES, bare minimum
scale_start = data_minmax_xy(:,1);
scale_end = data_minmax_xy(:,2);

% --- condition meshes, scale ends, step size
if size(binEdges_minmaxN_xy,2) >= 2
    scale_start = binEdges_minmaxN_xy(:,1);
    scale_end = binEdges_minmaxN_xy(:,2);
elseif size(binEdges_minmaxN_xy,2) ==1
    Ne = binEdges_minmaxN_xy;
end
if size(binEdges_minmaxN_xy,2) == 3
    Ne = max(binEdges_minmaxN_xy(:,3),1);
end

% figure out output meshes (bin upper EDGES) depending on the data
% range and also on the passed prefered meshes
if ~GridAdj_CropNotStretch  % stretch to include all passed data range
    % re-adjust min max limits to integer multiples of step_xy
    step_xy = (scale_end - scale_start)./(Ne-1);
    off_min_xy = ceil((max(0, scale_start-data_minmax_xy(:,1)))./step_xy);
    off_max_xy = ceil((max(0, -scale_end+data_minmax_xy(:,2)))./step_xy);
    scale_start = scale_start - off_min_xy.*step_xy;
    scale_end = scale_end+ off_max_xy.*step_xy;
    %scale_start = data_minmax_xy(:,1);
    %scale_end = data_minmax_xy(:,2);
    Ne = (scale_end - scale_start)./step_xy + 1;
    % will recalc bins, trim data at top
end
% recompose mesh to export, jic
binEdges_minmaxN_xy = [scale_start scale_end Ne];

end

function [modeBin_FnE, mGrid_CnS, eps] = uInHandle(varargin)
varargin = varargin{1};
nA = numel(varargin);
% dafaults: fast, crop, 1e-15
eps = 1e-15;
modeBin_FnE = true;
mGrid_CnS = true;
flagUnrec = false;
for i=1:nA
    if isnumeric(varargin{i})
        eps = varargin{i};
    else
        switch varargin{i}
            case 'fast'
                modeBin_FnE = true;
            case 'exact'
                modeBin_FnE = false;
            case 'stretch'
                mGrid_CnS = false;
            case 'crop'
                mGrid_CnS = true;
            otherwise
                flagUnrec = true;
        end
    end
end

if flagUnrec % report unknown identifiers
    if modeBin_FnE, strMode = 'fast';
    else strMode = 'exact';  end
    if modeBin_Cns, strGrid = 'crop';
    else strGrid = 'stretch'; end
    disp(['hist2: unrecognized mode(s), using ' strGrid ', ' strMode] );
end

end