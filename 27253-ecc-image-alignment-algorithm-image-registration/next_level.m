function warp=next_level(warp_in, transform, high_flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WARP=NEXT_LEVEL(WARP_IN, TRANSFORM, HIGH_FLAG)
% This function modifies appropriately the WARP values in order to apply
% the warp in the next level. If HIGH_FLAG is equal to 1, the function
% makes the warp appropriate for the next level of higher resolution. If
% HIGH_FLAG is equal to 0, the function makes the warp appropriate
% for the previous level of lower resolution.
%
% Input variables:
% WARP_IN:      the current warp transform,
% TRANSFORM:    the type of adopted transform, accepted strings:
%               'tranlation','affine' and 'homography'.
% HIGH_FLAG:    The flag which defines the 'next' level. 1 means that the
%               the next level is a higher resolution level,
%               while 0 means that it is a lower resolution level.
% Output:
% WARP:         the next-level warp transform
%--------------------------------------
%
% $ Ver: 1.3, 13/5/2012,  released by Georgios D. Evangelidis.
% For any comment, please contact georgios.evangelidis@inria.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warp=warp_in;
if high_flag==1
    if strcmp(transform,'homography')
        warp(7:8)=warp(7:8)*2;
        warp(3)=warp(3)/2;
        warp(6)=warp(6)/2;
    end
    
    if strcmp(transform,'affine')
        warp(7:8)=warp(7:8)*2;
        
    end
    
    if strcmp(transform,'translation')
        warp = warp*2;
    end
    
    if strcmp(transform,'euclidean')
        warp(1:2,3) = warp(1:2,3)*2;
    end
    
end

if high_flag==0
    if strcmp(transform,'homography')
        warp(7:8)=warp(7:8)/2;
        warp(3)=warp(3)*2;
        warp(6)=warp(6)*2;
    end
    
    if strcmp(transform,'affine')
        warp(7:8)=warp(7:8)/2;
    end
    
    if strcmp(transform,'euclidean')
        warp(1:2,3) = warp(1:2,3)/2;
    end
    
    if strcmp(transform,'translation')
        warp = warp/2;
    end
    
end