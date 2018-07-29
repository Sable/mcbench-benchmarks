function [V_ord] = ordfilt3(V0,ord,winSize,pad_opts)
% ordfilt3:    Performs 3D order-statistic filtering on 3D volumetric data.
%              The memory and computational overhead for such an operation
%              can be extremely demanding. Here - memory efficiency has been 
%              achieved with a recursive-split algorithm,
%              allowing for far larger volumes and/or window sizes to be
%              processed. 
%              
%              The basic operation is fairly simple - the volume is
%              recursively split into 8 even sub-blocks, until sub-blocks
%              are reached that are small enough for the filter to be
%              computed with a single call (i.e. when there is enough free
%              contiguous 
%              memory to process the entire sub-block)
%              The intermediate results are propagated back up the
%              call stack which then fill output matrix (V_ord)
%               
%              By calling  [V_ord] = ordfilt3(V0,ord,3,pad_opts), 
%              this code computes the 26-neighbourhood order statistic
%              filter, which is the same as outputted by Olivier Salvado's implementation 
%              (but which is non-splitting, and uses a fixed
%              3*3*3 window.)
%               
%              Usage:
%
%       [V_ord] = ordfilt3(V0,ord,winSize,pad_opts)
%
%
%       Inputs:
%       V0: Numeric 3D volume. Supports all numeric classes
%       ord: Speficies which order statistic to return.
%           This can be a string, or a number 1<=ord<=winSize^3
%           For example:
%           ord = 'min' returns the minimum window value (same as ord = 1)
%           ord = 'max' returns the maximum window value (same as ord =
%           winSize^3)
%           ord = 'med' returns the median window value
%
%       winSize: Size of filter window. Currently, only cubic windows are
%           permitted, whose Length=Width=Height = winSize. This must be
%           odd.
%
%       pad_opts: same as defined in 'padarray'
%
%       Outputs:
%       V_ord - Order Statistic.
%
% (c) Toby Collins, Edinburgh University, UK, September 2008#
%     toby.collins@gmail.com
%     2008

%check pad arguments:
if ~exist('pad_opts','var')
    pad_opts = 'replicate';
end

if ~(mod(winSize,2)==1)
    error('ordfilt3: winSize mist be odd.');
end

%parse ord argument:
if isnumeric(ord)
    if  ord<1||ord>winSize^3
        error('ord parameter is out of bounds');
    end
    if ord==1
        ord='min'; %more efficient to use 'min' rather than sorting
    end
    if ord==winSize^3
        ord='max'; %more efficient to use 'max' rather than sorting
    end
end
%check for valid ord string:
if ischar(ord)
    switch ord
        case 'max'
        case 'min'
        case 'med'
        otherwise
            error('Invalid ord parameter');
    end
end

%check for valid winSize agrument:
if mod(winSize,2)~=1
    error('Window size must be odd');
end

w = (winSize-1)/2;

%store size of the volume:
sz = size(V0,1)*size(V0,2)*size(V0,3);

%pad the volume:
V = (padarray(V0,[w w w],pad_opts));

p = 0;%variable storing the number of elements in V0 which have been processed. This is used for outputting progress to terminal.

%get the amount of free contiguous system memory:
M = feature('memstats');

f=0.4;
M=M*f; %do not use all contiguous memory (additional memory is needed, for example, for sorting the within the window)
%The factor f=0.4 is a good choice, but can be modified: 0<f<=1. Smaller
%values have the effect of processing smaller sub-blocks (which looses
%efficiency since there are more filter calls.) Larger values means that
%you may encounter out-of-memory issues, since there may be insufficient
%additional memory for the intermediate filter computations (e.g. sorting.)


%get the data class of V0:
T = whos('V0');
dClass = T.class;


%Now do the recursive call:
V_ord = ordfilt_compute(V,ord,M,w,dClass,sz,p);

function [B,p] = ordfilt_compute(V0,ord,M,w,dClass,sz,p)
%ordfilt_compute: Recursively called for computing the 3D order-statistics:
%       Inputs:
%       V0: Padded numeric 3D volume. Supports all numeric classes.
%       ord: Speficies which order statistic to return.
%           This can be a string, or a number 1<=ord<=winSize^3
%           For example:
%           ord = 'min' returns the minimum window value (same as ord = 1)
%           ord = 'max' returns the maximum window value (same as ord =
%           winSize^3)
%           ord = 'med' returns the median window value
%
%       M: Maximum number of bytes of contiguous memory available for
%       computing the order statistic
%
%       w: window length either side of centre element
%       dClass: data class of V0
%       sz: number of elements in complete volume
%       p: number of elements whose stats have already been computed.
%
%       Outputs:
%       B: Order statistic for sub-block V0
%       p: Updated number of elements that have been processed.
%
% (c) Toby Collins, Edinburgh University, UK, September 2008
%     toby.collins@gmail.com
%     2008


S = size(V0);
mid = round((S)/2);
T = whos('V0');
%test if we should evaluate data block stats:
if (2*w+1)^3*T.bytes>M
    %no - so split the volume (8 sub-volumes and call ordfilt_compute on
    %each)
    V1 = V0(1:mid(1)+w,1:mid(2)+w,1:mid(3)+w);
    if sum(size(V1)==size(V0))==3 %Not enough free memory, since block size has not been reduced:
        error('Not enough free contiguous memory to compute order statistics.');       
    end
    [B1,p] = ordfilt_compute(V1,ord,M,w,dClass,sz,p); clear V1;

    V2 = V0(1:mid(1)+w,mid(2)-w+1:end,1:mid(3)+w);
    [B2,p]= ordfilt_compute(V2,ord,M,w,dClass,sz,p);  clear V2;

    V3 = V0(mid(1)-w+1:end,1:mid(2)+w,1:mid(3)+w);
    [B3,p] = ordfilt_compute(V3,ord,M,w,dClass,sz,p); clear V3;

    V4 = V0(mid(1)-w+1:end,mid(2)-w+1:end,1:mid(3)+w);
    [B4,p] = ordfilt_compute(V4,ord,M,w,dClass,sz,p); clear V4;

    V5 = V0(1:mid(1)+w,1:mid(2)+w,mid(3)-w+1:end);
    [B5,p] = ordfilt_compute(V5,ord,M,w,dClass,sz,p); clear V5;

    V6 = V0(1:mid(1)+w,mid(2)-w+1:end,mid(3)-w+1:end);
    [B6,p] = ordfilt_compute(V6,ord,M,w,dClass,sz,p); clear V6;

    V7 = V0(mid(1)-w+1:end,1:mid(2)+w,mid(3)-w+1:end);
    [B7,p] = ordfilt_compute(V7,ord,M,w,dClass,sz,p); clear V7;

    V8 = V0(mid(1)-w+1:end,mid(2)-w+1:end,mid(3)-w+1:end);
    [B8,p] = ordfilt_compute(V8,ord,M,w,dClass,sz,p); clear V8;

    %concatinate filtered sub-blocks:
    B = cat(3,cat(1,cat(2,B1,B2),cat(2,B3,B4)),cat(1,cat(2,B5,B6),cat(2,B7,B8)));
    clear B1 B2 B3 B4 B5 B6 B7 B8 V0;

else
    %yes - compute it.
    
    %concatinated neighbouring elements along 4th dimension:
    Bfull = zeros([S-2*w,(2*w+1)^3],dClass);
    cc=0;
    for ii=-w:w
        ind1 = (w+1:S(1)-w)+ii;
        for jj=-w:w
            ind2 = (w+1:S(2)-w)+jj;
            for kk=-w:w
                ind3 = (w+1:S(3)-w)+kk;
                cc=cc+1;
                Bfull(:,:,:,cc) = V0(ind1,ind2,ind3);
            end
        end
    end
    
    % Now perform the filtering:
    if isnumeric(ord)
        Bfull = sort(Bfull,4);
        B = Bfull(:,:,:,ord);
    else
        switch ord
            case 'max'
                B=max(Bfull,[],4);
            case 'min'
                B=min(Bfull,[],4);
            case 'med'
                B=median(Bfull,4);
            otherwise
        end
    end
    %update p:
    p=p+ (size(B,1))*(size(B,2))*(size(B,3));
    disp(['ordfilt3: ' num2str(round(100*p/sz)) '% done']);    
end