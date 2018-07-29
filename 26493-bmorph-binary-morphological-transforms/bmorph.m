function [img, ContourColl] = bmorph(img, B_Coll, ...
    DilateNotErode, ContourColl, ObjectStopsAtEdge)
% BMORPH binary morphological operations (erosion, dilation)
%        allows iterative calls
% 
% [IMG_OUT, Contour] = BMORPH(IMG, B, DilateNotErode, SetContour, ObjStopAtEdge)
%
% IMG               - input binary image
% B                 - structuring element(s) (NOT strel!) 
%                     either boolean matrix or 2-long cell of boolean 
%                     matrices {B, Bp} (in which case the structuring 
%                     element will be delta = B\Bp
% DilateNotErode    - 1/0 dilate/erode
% SetContour        - subindexes of 1-pixel wide IMG contours 
%                     4-length cell array (N-by-2 of double)
%                     if empty (not imposed) will be calculated from IMG 
% ObjStopAtEdge     - boolean option, when TRUE it erodes away 
%                     from edges too (only in ERODE mode)
% 
% EXAMPLE
%   % first call
%   [IMG_OUT, Contour] = bmorph(IMG, B{1});
%   % subsequent calls
%   for i = 2:size(B,2)
%      IMG_OUT = bmorph(IMG_OUT, {B{i}, B{i-1}}, 1, Contour);
%      % insert here code to process or store IMG_OUT
%   end
% 
% iterative dilation, where B has been generated previously as 
% a cell array of boolean masks of increasing size
%
% tudor dima, tudima@yahoo.com
% 27.01.2010    - new
% 28.04.2012    - v. 0.3.b, allow assymetrical structuring elements, or with holes

if nargin < 5, ObjectStopsAtEdge = true; end
if nargin < 4, ContourColl = {}; end
if nargin < 3, DilateNotErode = true; end% 1/0 dilate/erode
ObjectStopsAtEdge = ObjectStopsAtEdge && ~DilateNotErode; % only in erode

%% find contours, (scaled) offsets

ErodeWithDelta = false; % detect input strel, 1/2 <=> array/cell/
if iscell(B_Coll)       % build delta strels !
    % {1} is the current, larger
    % {2}, if any, is the smaller (previous) strel!
    if size(B_Coll,2) >= 1, B = B_Coll{1}; end
    if size(B_Coll,2) >= 2
        Bp = B_Coll{2}; % turn on differential erosion/dilation
        if ~isempty(Bp) % only if a 2nd nonempty strel is present
            ErodeWithDelta = true; 
        end
    end
else                    % B_Coll is simply a boolean matrix
    B = B_Coll; % one strel
end
clear B_coll

[nRi, nCi] = size(img);

% --- find OffsetColl, 4-length cell array, R,L,U,D --- 
if ErodeWithDelta
    OffsetColl = uFindOffsets(B, DilateNotErode, Bp);
else
    OffsetColl = uFindOffsets(B, DilateNotErode);
end

% --- find Contours, 4-length cell array, R,L,U,D, 1-pixel thick ---
if isempty(ContourColl) % i.e. no ImposedContour from input 
    ContourColl = uFindContours(img, ObjectStopsAtEdge);
end % else get ImposedContour from input

%% actual erosion

for iS = 1:4   % {1,2,3,4} : R,L,U,D (H+, H-, V+, V-)
    % walk Half_* on the * contour
    thisBorder = ContourColl{iS}; % was {iS}
    theseOffsets = OffsetColl{iS};%PairHalf2Contour(
    % protect against ill-defined strels that contain
    if ~isempty(theseOffsets) % some empty halves
        nOffs = size(theseOffsets,1);      % - subind, i,j
        for i = 1:nOffs
            ixR = thisBorder(:,1) + theseOffsets(i,1);
            ixC = thisBorder(:,2) + theseOffsets(i,2);
            % size check
            UpdPix = (ixR > 0) & (ixR <=nRi) & ...
                (ixC > 0) & (ixC <=nCi);
            % find 1D indices of pixels to update
            ix1D = ixR(UpdPix) + ...
                (ixC(UpdPix)-1)*nRi; % protected, no sub2ind
            img(ix1D) = DilateNotErode;
        end
    end
end
clear OffsetColl UpdIx thisBorder theseOffsets
end
% -------------------------------------------------

function ContourColl = uFindContours(img, ObjectStopsAtEdge)
% ContourColl = uFindContours(IMG)
%
% find 1-pixel thick contours in binary image IMG
%
% ContourColl is a 4-length cell, R, L, U, D are nP x 2 arrays
% in a cartesian sense (L & D decrease the grid count, R & U increase it)
%
% if ObjectStopsAtEdge will add contours where IMG touches the edges

[nR, nC] = size(img);
% --- Right ---
ZeroColumn = false(nR,1);
ThisDoubleContour = xor(img(:,2:end), img(:,1:end-1));
ThisInsidePart = [ZeroColumn ThisDoubleContour] & img; % R
if ObjectStopsAtEdge
    ThisInsidePart(:,1) = img(:,1);
end
[ri, cj] = find(ThisInsidePart);
ContourColl{1} = [ri cj];
% --- Left ---
ThisInsidePart = [ThisDoubleContour ZeroColumn] & img; % L
if ObjectStopsAtEdge
    ThisInsidePart(:,nC) = img(:,nC);
end
[ri, cj] = find(ThisInsidePart);
ContourColl{2} = [ri cj];
% --- Up ---
ZeroRow = false(1, nC);
ThisDoubleContour = xor(img(2:end,:), img(1:end-1,:));
ThisInsidePart = [ ZeroRow; ThisDoubleContour ] & img; % U
if ObjectStopsAtEdge
    ThisInsidePart(1,:) = img(1,:);
end
[ri, cj] = find(ThisInsidePart);
ContourColl{3} = [ri cj];
% --- Down ---
ThisInsidePart = [ ThisDoubleContour; ZeroRow ] & img; % D
if ObjectStopsAtEdge
    ThisInsidePart(nR,:) = img(nR,:);
end
[ri, cj] = find(ThisInsidePart);
ContourColl{4} = [ri cj];

end

function OffsetColl = uFindOffsets(B, DilateNotErode, Bp)
% OffsetColl = uFindOffsets(B, nR)
%
% output sacrosanct order, 1:4 -> R, L, U, D
% ------------------------------------------

ErodeWithDelta = false;
if nargin >= 3
    ErodeWithDelta = true;
    % check Bp < B in size ...
end
if nargin < 2 % default dilate
    DilateNotErode = true;
end

% find "halves" of B
[Halves, Centers] = uFindHalves(B, DilateNotErode); % optDoFillHalves ?

if ErodeWithDelta   % build delta, only in "incremental" mode
    % "delete" B_p(revious) from B, i.e. reset in Half_* the pixels
    % that are TRUE in Half_*p (minding the offsets!), since
    % these have been eroded in a previous pass
     
    % 1. find Bp halves
    [Halves_P, Centers_P] = uFindHalves(Bp, DilateNotErode);
    % 2. get their sizes    
    sH = zeros(4,2);
    for i=1:4 % 
        sH(i,1:2) = size(Halves_P{i});
    end
    % 3. find center shifts, will use to align Halves_P to Halves
    Shifts = Centers - Centers_P; % 2-by-4, RLUD-by-XY
    % 4. actual pixel reset
    for ixH = 1:4 % LRUD
        Halves{ixH}((1:sH(ixH,1))+Shifts(ixH,2), (1:sH(ixH,2))+Shifts(ixH,1)) = ...
            Halves{ixH}((1:sH(ixH,1))+Shifts(ixH,2), (1:sH(ixH,2))+Shifts(ixH,1)) & ~Halves_P{ixH};
    end
end

% find offsets that will be walked along the same letter(number!) contour
OffsetColl{4} = [];
for i = 1:4
    OffsetColl{i} = BoolHalf2Subind(Halves{i}, Centers(i,:));
end

end

function [Halves, Centers] = uFindHalves(B, DilateNotErode, optDoFillHalves)
% 1234->RLUD
if nargin < 3, optDoFillHalves = false; end 
% find size of lower B halves, EXcluding origin
B_dX = floor((size(B,2)-1)/2);
B_dY = floor((size(B,1)-1)/2);
B_Xo = B_dX+1; % this is the origin (cols)
B_Yo = B_dY+1;  % rows

% the halves are "almost"-half (1pix smaller) !
% L & R are 'vertical' or 'portrait',    [2*B_dY+1  B_dX    ]
% U & D are 'horizontal' or 'landscape', [B_dY      2*B_dX+1]

Centers = zeros(4,2);

if DilateNotErode   %  __dilate__
    Halves{1} = B(:,1:B_dX);       % will walk these halves
    Halves{2} = B(:,B_dX+2:end);   % on the "same letter" contour
    Halves{3} = B(1:B_dY,:);
    Halves{4} = B(B_dY+2:end,:);
    
    % set center coordinates, 1234->RLUD
    % fliplr, 31.12.2011, dilate only, test
    Centers(1,:) = [ B_Xo B_Yo];     % R
    Centers(2,:) = [ 0 B_Yo];        % L
    Centers(3,:) = [ B_Xo B_Yo];     % U
    Centers(4,:) = [ B_Xo 0];        % D
else                % __erode__, that is :-)
    % will walk these flipped halves
    % on ? "same letter" contour

    % new, 2xflip ! was flip lr pt LR, ud pt UD...
    Halves{1} = rot90(B(:,1:B_dX),2);    % in erode mode > flip 
    Halves{2} = rot90(B(:,B_dX+2:end),2);
    Halves{3} = rot90(B(1:B_dY,:),2);
    Halves{4} = rot90(B(B_dY+2:end,:),2);
    % new idea: should fill falses between first and last
    % and only then split LR, UD
    % now fill halves only!
    if optDoFillHalves
        d = [0 0 1 1];
        s = [-1 1 -1 1];
        for i=1:4
            Halves{i} = subFillHalf(Halves{i}, d(i), s(i));
        end
    end
    % set center coordinates, 1234->RLUD
    Centers(1,:) = [1 B_Yo];
    Centers(2,:) = [B_Xo-1 B_Yo];
    Centers(3,:) = [B_Xo 1];
    Centers(4,:) = [B_Xo B_Yo-1]; 
    
end

end

function ScaledIJ = BoolHalf2Subind(Half, XoYo)
% ScaledOffsets = BoolHalf2Subind(Half, XoYo, nRows)
%
% build list of 2-D subindices offsets generated by Half,
% calibrated around XoYo; they'll be applied to contours
[ri, cj] = find(Half);
% force them to be column
ri = ri(:); cj = cj(:);
ScaledIJ = [ri-XoYo(2) cj-XoYo(1)]; % 2 columns, i,j
end

function Hf = subFillHalf(H, dir, sense)
% keep external contour of half H
% 'fill' interiour pixels
% % dir 0/1 V/H, sense -/+ R/L or U/D
nRC = size(H, dir+1);
nCR = size(H, ~dir+1);
Hf = H;
switch sense
    case {0, -1, 'R', 'U'}
        whichExtreme = 'last';
        s = false;
    case {1, 'L', 'D'}
        whichExtreme = 'first';
        s = true;
end
switch dir
    case 0
        for i=1:nRC
           tRow = H(i,:); 
           ixEx = find(tRow, 1, whichExtreme);
           ixSet = (~s + s*ixEx):(~s*ixEx + s*nCR);
           Hf(i,ixSet) = true;
        end
    case 1 % V
        for j=1:nRC
           tCol = H(:,j); 
           ixEx = find(tCol, 1, whichExtreme);
           ixSet = (~s + s*ixEx):(~s*ixEx + s*nCR);
           Hf(ixSet,j) = true;
        end
end
end
