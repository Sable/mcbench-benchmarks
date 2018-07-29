function [term_mat,for_mat,bac_mat] = termjoin(plant_mat,for_mat,bac_mat,T)
%
% Utility Function: TERMJOIN
%
% The purpose of this function is to join the plant and controller
% matrices

% Author: Craig Borghesani
% Date: 8/31/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if all(size(for_mat)==[1,4]),
 if for_mat(4) == 40, for_mat = pid2pid(for_mat,1); end
 for_mat = termpars(for_mat([3,1,2]),[1,0]);
end
if all(size(bac_mat)==[1,4]),
 if bac_mat(4) == 40, bac_mat = pid2pid(bac_mat,1); end
 bac_mat = termpars(bac_mat([3,1,2]),[1,0]);
end
for_mat2 = for_mat; bac_mat2 = bac_mat;

if nargin == 3,
 term_mat = plant_mat(1:2,:);
 term_mat(1,1) = term_mat(1,1)*for_mat2(1,1)*bac_mat2(1,1);
 term_mat(2,1) = term_mat(2,1)+for_mat2(2,1)+bac_mat2(2,1);
 plant_mat(1:2,:)=[]; for_mat2(1:2,:)=[]; bac_mat2(1:2,:)=[];
 term_mat = [term_mat;plant_mat;for_mat2;bac_mat2];
else
 term_mat = plant_mat(1:3,:);
 term_mat(1,1) = term_mat(1,1)*cont_mat(1,1);
 term_mat(2,1) = term_mat(2,1)+cont_mat(2,1);
 term_mat(2,2) = term_mat(2,2)+cont_mat(2,2);
 term_mat(3,1) = term_mat(3,1)+cont_mat(3,1);
 plant_mat(1:3,:)=[]; cont_mat(1:3,:)=[];
 term_mat = [term_mat;plant_mat;cont_mat];
end