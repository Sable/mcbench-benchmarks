%First an homogenous matrix
A=ones(4,4,4)*10;

%We put son random data, note that there is now a minimun (value 5) on the boundary
% (4,1,3) (there is another in (1,2,3) (value 1) but only valid if the
% Robust  method is not activated)'

A(:,:,3) =[ 4 1 3 7 ; ...
   5 7 8 8 ; ...
   9 9 9 9 ; ...
   5 6 7 9];

%A minimun in the layer 2 
A(2,3,2)=-2;

%A maximum also in layer 2
A(3,2,2)=12;

%and another maximum at layer 4 (in the boundary); 
A(3,2,4)=13;

disp('This is the Input Matrix');

A

disp('Results when boundary is not taken into account and Robust method is activated');
[Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(A,1,0)

disp('Results when boundary is taken into account and Robust method is activated');
[Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(A,1,1)

disp('Results when boundary is not taken into account and Robust method is desactivated');
[Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(A,0,0)

disp('Results when boundary is taken into account and Robust method is desactivated');
[Maxima,MaxPos,Minima,MinPos]=MinimaMaxima3D(A,0,1)