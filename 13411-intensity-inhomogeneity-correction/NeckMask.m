function    [Imask,Ibck] = NeckMask(I,alpha,corner,percent);
% NeckMask:     get a mask for the background 
%
%   [Imask,Ibck] = NeckMask(I,alpha,corner,percent);
%       alpha: threshold for masking 0.1 <=> 10 % upper histogramme is one
%               0, uses 10% of the corner
%           [amin amax] : compute weighted mask with
%                       Imask(i,j) = 0 if I<amin
%                       Imask(i,j) = 1 if I>amax   
%                       linear interpolation in between
%       corner: 1 uses top corners with percent of the dimension
%               2 uses 4 corners with percent of the dimension
%               


I   = single(I);
flagW = 0;
% --- default parameters
if ~exist('alpha'),
    alpha = 0;
end
if length(alpha) > 1,
    flagW = 1;
    corner = 0;
    percent = 0;
end
if ~exist('corner'),
    corner = 2;
    percent = 0.2;
end
if ~exist('percent'),
    percent = 0.2;
end

if ~flagW,
    if alpha==0,
        % --- use the corner to get the background
        [nr,nc] = size(I);
        r_cner  = round(nr*percent);    % 10% of the image size
        c_cner  = round(nc*percent);
        Ic1     = I(1:r_cner,           1:c_cner);
        Ic2     = I(1:r_cner,           end-c_cner:end);
        Ic3     = I(end-r_cner:end,     1:c_cner);
        Ic4     = I(end-r_cner:end,     end-c_cner:end);
        
        Ibck    = [Ic1];
        if corner==4,
            %         disp('four corners')
            Ibck    = [Ic1 Ic2;Ic3 Ic4];
        elseif corner==2,
            %         disp('2 top corners')
            Ibck    = [Ic1 Ic2];
        end
        
        Im      = mean2(Ibck);
        Is      = std2(Ibck);
        [wx,wy] = find( I > (Im+3*Is));
        idx     = sub2ind(size(I),wx,wy);
        
    else,
        
        Imax = max(max(I));
        Imin = min(min(I));
        threshold   = Imin + (Imax-Imin)*alpha;
        
        [wx,wy] = find( I > threshold);
        idx     = sub2ind(size(I),wx,wy);
        Ibck    = [];
    end
else,
    % --- Weighted mask
    if alpha(1)<1,  % assume it is a fraction of the histogram
        Imax = max(max(I));
        Imin = min(min(I));
        Idelta = Imax-Imin;
        Itl = Imin + alpha(1)*Idelta;
        Ith = Imin + alpha(2)*Idelta;
    else, %assume the thresholds are in absolute value
        Itl = alpha(1);
        Ith = alpha(2);
    end
    
    
    Imask = 0*I;    % below amin
    Imask(I>=Ith) = 1;  % above amax
    
    inbetween = 0*I;
    inbetween = (I>Itl) & (I<Ith);
    Imask(inbetween) = ( I(inbetween)-Itl )/ (Ith-Itl);
end

Ibck = I.*(1-Imask);
