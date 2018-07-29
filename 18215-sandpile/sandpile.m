function [nrgrains,nrout,avsize] = sandpile(siz,nrsteps)

% sandpile cellular automaton according to Bak & Paczuski (1995)
%
% [nrgrains,avsize,nrout] = sandpile(siz,nrsteps)
% _________________________________________________________________________
% 
% Cellular automaton model (CA) of a sandpile on a 2-dimensional grid. The
% size of the grid matrix is given by siz (e.g. [20 20]) and nrsteps is a
% scalar positive integer defining the number of time steps of the model 
% run.
%
% Each time step a sandgrain is added to a random location on the grid.
% When the critical number of grains in a cell exceeds 3 all grains in the 
% cell are turned to the 4 neighbors (v. Neumann Neighborhood). This
% avalanche may prograde and trigger even more avalanches. After a while
% the sandpile comes to a state of self-organized criticality.
%
% Each timesteps values are written to the output vectors. nrgrains is the
% total number of sandgrains on the grid. nrout is the number of grains 
% that fall off the sides of the grid. avsize is the number of sandgrains
% moved during one timestep to neighbor cell. Since each grain may be
% moved several times during a timestep, avsize may be larger than 
% nrgrains. 
%
% Example:
%
% siz = [20 20];
% nrsteps = 2000;
% [nrgrains,nrout,avsize] = sandpile(siz,nrsteps);
% AX = plotyy([1:nrsteps],nrgrains,[1:nrsteps],nrout,'plot');
% set(get(AX(1),'Ylabel'),'String','# of grains on the grid')
% set(get(AX(2),'Ylabel'),'String','# of grains falling from the grid')
%
% Reference:
%
% Bak, P. & Paczuski, M. (1995): Complexity, contingency, and criticality.
% Proceedings of the National Acadamy of Sciences of the USA, 1995, 92, 
% 6689-6696
% _________________________________________________________________________
% Wolfgang Schwanghart
%

% check input
if nargin ~= 2;
    error('two input arguments must be provided')
end

if numel(siz)~=2;
    error('siz must be a two-element vector')
end

if siz(1)*siz(2) > 900;
    warning('Caution! I suggest to take a smaller grid (e.g. siz = [20 20]).')
end

nrsteps = ceil(nrsteps);
if ~isscalar(nrsteps) || any(nrsteps<1);
    error('nrsteps must be a positive integer')
end

% Ceil siz in case non-integers are provided
siz = ceil(siz);

% Nr of cells
nrc = siz(1)*siz(2);

% Grid containing sand
Z   = zeros(siz);

% critical height
Zcr = 4;                     

% preallocate output
nrgrains = zeros(nrsteps,1);   % nr grains in the sandpile
avsize   = zeros(nrsteps,1);   % avalanche size
nrout    = zeros(nrsteps,1);   % grains falling from the grid

% define adjacency
ixc             = reshape((1:nrc)',siz);
ixnu            = nan(siz);
ixnu(2:end,:)   = ixc(1:end-1,:); %upper neighbor;
ixnb            = nan(siz);
ixnb(1:end-1,:) = ixc(2:end,:); %lower neighbor;
ixnl            = nan(siz);
ixnl(:,2:end,:) = ixc(:,1:end-1); %right neighbor;
ixnr            = nan(siz);
ixnr(:,1:end-1) = ixc(:,2:end); %left neighbor;

% add one more cell that captures grains falling from the grid
ixg             = repmat(ixc(:),4,1);
ixr             = [ixnu(:); ixnb(:); ixnl(:); ixnr(:)];
ixr(isnan(ixr)) = nrc+1;

% create sparse distribution matrix (M)
M = sparse(ixg,ixr,ones(length(ixg),1)*0.25,nrc+1,nrc+1);

% add one more cell also to Z
Z = [Z(:); 0];

% waitbar
h = waitbar(0,'Grains fall...');

for r1 = 1:nrsteps;
    waitbar(r1/nrsteps)
    % Put a grain at a random location of the grid
    ixdrop = ceil(nrc*rand(1));
    Z(ixdrop) = Z(ixdrop)+1;
    
    % Check if any location exceeds the critical height Zcr
    I = Z>=Zcr;
    
    % If any, distribute
    while any(I);
        Z = (Z-4*I) + M'*(4*I);
        nrout(r1) = nrout(r1)+Z(end);
        Z(end) = 0;
        avsize(r1) = avsize(r1)+sum(I);
        I = Z>=Zcr;

    end    
   
    nrgrains(r1) = sum(Z);
    
end
        
close(h)

