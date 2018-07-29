function [mt1,mt2,upl_mt1,lor_mt1,upl_mt2,lor_mt2,match_weight,err]=temp_temp_matching(t1,t2,upl_1,lor_1,upl_2,lor_2,th,cal)

%% TEMPLATE-TEMPLATE MATCHING PROCEDURE

% Input
%% t1, t2           : templates to be matched
%% upl_1, upl_2     : image coordinates of the templates' upper left corner
%% lor_1, lor_2     : image coordinates of the templates' lower right corner
%% th               : matching threshold
%% cal              : (1=rectified images with epipolar horizontal lines; 0=uncalibrated images )

%% Output
%% mt1,mt2          : matched subwindows
%% upl_mt1, upl_mt2 : image coordinates of the templates' upper left corner
%% lor_mt1, lor_mt2 : image coordinates of the templates' lower right corner
%% match_weight     : match weight
%% err              : matching error tag. err=1 -> no valid match 


%% INITIALIZATION
global IM1 IM2 IM1_X IM1_Y IM1_X2 IM1_Y2 SIGMA_MAX;

err=0;

[Ny1,Nx1]=size(t1);
[Ny2,Nx2]=size(t2);
Nyt=min(Ny1,Ny2);
Nxt=min(Nx1,Nx2);

Ny=2*Nyt-1;
Nx=2*Nxt-1;  %% Matching correlation map dimension

mt1=[0];
mt2=[0];
upl_mt1=[0,0];
upl_mt2=[0,0];
lor_mt1=[0,0];
lor_mt2=[0,0];   
match_weight=NaN; %%Output values

%% check the Fisher information matrix for the first template
sigma_num = sum(sum(  IM1_X2(upl_1(1):lor_1(1),upl_1(2):lor_1(2)) + IM1_Y2(upl_1(1):lor_1(1),upl_1(2):lor_1(2))   ));
sigma_den = sum(sum(  IM1_X2(upl_1(1):lor_1(1),upl_1(2):lor_1(2)) )) * sum(sum(  IM1_Y2(upl_1(1):lor_1(1),upl_1(2):lor_1(2)) )) - (   sum(sum( IM1_X(upl_1(1):lor_1(1),upl_1(2):lor_1(2)).*IM1_Y(upl_1(1):lor_1(1),upl_1(2):lor_1(2)) ))  )^2; 

if (sigma_den)
    sigma_t1= sigma_num/sigma_den;
    if sigma_t1>SIGMA_MAX
        err=1;
        return
    end
else
    err=1; 
    return;
end



corrmap=zeros(Ny,Nx); %% Correlation map

dec_factor=ceil(Nx1/80); % Subsampling factor to speed up the procedure
t1dec=decimage(t1,dec_factor);
t2dec=decimage(t2,dec_factor); % Decimated templates


%% Matching

if (cal==1)
    corrmap=circ_corr_1d(t1dec,t2dec);
    match_weight=max(max(corrmap));
    if (match_weight<th)  %% No valid match
        err=1;
        return 
    end
    
    dx=find( corrmap==match_weight );
    dx=dx*dec_factor;
    dx=dx(1); 
    
    dy=0;
    dx=dx-Nxt;  % best matching shift
    
else
    corrmap=circ_corr_2d(t1dec,t2dec);
    match_weight=max(max(corrmap));
    if (match_weight<th)  %% No valid match
        err=1;
        return 
    end                  
    [dy,dx]=find( corrmap==match_weight );
    dy=dy*dec_factor;
    dx=dx*dec_factor;
    dy=dy(1);
    dx=dx(1); 
    dy=dy-Nyt;
    dx=dx-Nxt; %Best matching shift
end
    
  % Matched subwindows extraction
    scale=(lor_1-upl_1)./[Nyt-1,Nxt-1];
  
  upl_1_dy=max(0,dy);
  upl_1_dx=max(0,dx);
  upl_mt1=upl_1 + [upl_1_dy upl_1_dx].*scale;
  
  lor_1_dy=min(0,dy);
  lor_1_dx=min(0,dx);
  lor_mt1=lor_1 + [lor_1_dy lor_1_dx].*scale;
  
  mt1=t1(1+upl_1_dy:Nyt+lor_1_dy , 1+upl_1_dx:Nxt+lor_1_dx);
    
  
  upl_2_dy=max(0,-dy);
  upl_2_dx=max(0,-dx);
  upl_mt2=upl_2 + [upl_2_dy upl_2_dx].*scale;
    
  lor_2_dy=min(0,-dy);
  lor_2_dx=min(0,-dx);
  lor_mt2=lor_2 + [lor_2_dy lor_2_dx].*scale;
   
  mt2=t2(1+upl_2_dy:Nyt+lor_2_dy , 1+upl_2_dx:Nxt+lor_2_dx);
 
  