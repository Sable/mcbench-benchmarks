%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%Description:
%%input: m=total mass of the link
%% I=the inertia matrrix (3x3)
%% c=position of the centre of mass of the link
%%output= the pseudo inertia matrix

function pseudoI=pseudoI(m,I,c)

pseudoI=[(-I(1,1)+I(2,2)+I(3,3))/2, I(1,2),I(1,3),m*c(1);
         I(1,2),(I(1,1)-I(2,2)+I(3,3))/2,I(2,3),m*c(2);
         I(1,3),I(2,3),(I(1,1)+I(2,2)-I(3,3))/2,m*c(3);
         m*c(1),m*c(2),m*c(3),m];

end