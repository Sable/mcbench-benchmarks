function matched_points=it_features_matching(upl_1, lor_1, upl_2, lor_2, th, cal, matches, past_weigth)

%% ITERATIVE FEATURES MATCHING
%% As features are selected the best matching in any iteration.
%% Then it is recursively refined till reaching the threshold size
%% subwindows

%% Input
%% iml,imr       : templates to be matched
%% upl_1, upl_2  : image coordinates of the templates' upper left corner
%% lor_1, lor_2  : image coordinates of the templates' lower right corner
%% th            : matching threshold
%% cal           : (1=rectified images with epipolar horizontal lines; 0=uncalibrated images )
%% matches       : N x 4 matrix comprised of the already matched points
%% past weigth   : present match weigth

%% Output
%% matched_points : Correspondences matrix (N x 4) 
%%                  [v1_1 u1_1 v2_1 u2_1
%%                   v1_2 u1_2 v2_2 u2_2
%%                  ...
%%                   v1_N u1_N v1_N u1_N]



global IM1 IM2 IM1_X IM1_Y IM1_X2 IM1_Y2 SIGMA_MAX;
offset=0;
imw1=IM1(upl_1(1):lor_1(1),upl_1(2):lor_1(2));
imw2=IM2(upl_2(1):lor_2(1),upl_2(2):lor_2(2));

[mt1,mt2,upl_mt1,lor_mt1,upl_mt2,lor_mt2,pres_weigth,err]=temp_temp_matching(imw1,imw2,upl_1,lor_1,upl_2,lor_2,th,cal); 
pres_weigth=pres_weigth+past_weigth;
[tysize,txsize]=size(mt1);

if (~err)  %% returned valid match
    
    if (tysize<8 | txsize<8)  %% last step. The central position of the matched subwindows are added to the correspondences set. 
        matched_points=[matches; (upl_mt1+lor_mt1)/2, (upl_mt2+lor_mt2)/2, pres_weigth]; 

    else
        %% matched subwindows tiling
        y1=floor(tysize/2)-offset;
        y2=floor(tysize/2)+offset;
        x1=floor(txsize/2)-offset;
        x2=floor(txsize/2)+offset;
          
        %hi-le templates
        t1_1=mt1( 1:y2 , 1:x2 );
        upl_1_1=upl_mt1 + [0,0];
        lor_1_1=upl_mt1 + [y2-1,x2-1];
        
        t2_1=mt2( 1:y2  , 1:x2 );
        upl_2_1=upl_mt2 + [0,0];
        lor_2_1=upl_mt2 + [y2-1,x2-1];
        
        %hi-ri templates
        t1_2=mt1( 1:y2 , x1:txsize );
        upl_1_2=upl_mt1 + [0,x1-1];
        lor_1_2=upl_mt1 + [y2-1,txsize-1];
        
        t2_2=mt2( 1:y2 , x1:txsize );
        upl_2_2=upl_mt2 + [0,x1-1];
        lor_2_2=upl_mt2 + [y2-1,txsize-1];
        
        %lo-le templates
        t1_3=mt1( y1:tysize , 1:x2 );
        upl_1_3=upl_mt1 + [y1-1,0];
        lor_1_3=upl_mt1 + [tysize-1,x2-1];
        
        t2_3=mt2( y1:tysize , 1:x2 );
        upl_2_3=upl_mt2 + [y1-1,0];
        lor_2_3=upl_mt2 + [tysize-1,x2-1];
        
        %lo-ri templates
        t1_4=mt1( y1:tysize , x1:txsize );
        upl_1_4=upl_mt1 + [y1-1,x1-1];
        lor_1_4=upl_mt1 + [tysize-1,txsize-1];
        
        t2_4=mt2( y1:tysize , x1:txsize );
        upl_2_4=upl_mt2 + [y1-1,x1-1];
        lor_2_4=upl_mt2 + [tysize-1,txsize-1];
        
        matched_points=[matches;
                             it_features_matching(upl_1_1,lor_1_1,upl_2_1,lor_2_1,th,cal,matches,pres_weigth);
                             it_features_matching(upl_1_2,lor_1_2,upl_2_2,lor_2_2,th,cal,matches,pres_weigth);
                             it_features_matching(upl_1_3,lor_1_3,upl_2_3,lor_2_3,th,cal,matches,pres_weigth);
                             it_features_matching(upl_1_4,lor_1_4,upl_2_4,lor_2_4,th,cal,matches,pres_weigth)];
            
     end
     
 else
     matched_points=matches;
 end     
 
 
