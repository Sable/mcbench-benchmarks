function   mytable(input,type)

%--------------------------------------------------------------------------
% Purpose:
%         Print outputs in tabular form
% Synopsis :
%         mytable(input,type)
% Variable Description:
%           input - displacement or Stress matrix
%           type = 1    displacement 
%                = 2    Von Mises stress
%                = 3    Stress matrix
%                = 4    Averaged stress matrix
%--------------------------------------------------------------------------
load nodes.dat ;
load coordinates.dat ;

nel = length(nodes) ;                  % number of elements
nnel=4;                                % number of nodes per element
ndof=2;                                % number of dofs per node (UX,UY)
nnode = length(coordinates) ;          % total number of nodes in system
sdof=nnode*ndof;                       % total system dofs  

if type == 1

UX = input(1:2:sdof) ;
UY = input(2:2:sdof) ;
display('======PER NODE DISPLACEMENTS====== ');
fprintf('================================================\n');
fprintf('   node                UX              UY       \n')
fprintf('================================================\n');
for i = 1:nnode
    node = i;
    ux = UX(i);
    uy = UY(i);
 fprintf('  %5d      %+6.5e     %+6.5e    \n',node,ux,uy);
end
fprintf('=================================================\n');

elseif type == 2

display('=====VON MISES STRESSES PER NODE=======')
fprintf('=======================================\n');
fprintf('element   node      Von Mises         \n')
fprintf('======================================\n');
for ielp = 1:nel
    pos = 4*(ielp-1)+(1:4);
    for i = 1:nnel ;
    nodeno = nodes(ielp,i);
    vmis = input(pos(i));
   
 fprintf('%5d  %5d    %+6.5e      \n',ielp,nodeno,vmis);
    end
end
fprintf('=======================================\n');


elseif type == 3

fprintf('===============================================================\n');
fprintf('element   node         sigmax          sigmay         sigmaxy       \n')
fprintf('===============================================================\n');
for ielp = 1:nel
    pos = 4*(ielp-1)+(1:4);
    for i = 1:nnel ;
    nodeno = nodes(ielp,i);
    sigmaX = input(pos(i),1);
    sigmaY = input(pos(i),2);
    sigmaXY = input(pos(i),3);
   
 fprintf('%5d  %5d    %+6.5e   %+6.5e   %+6.5e    \n',ielp,nodeno,sigmaX,sigmaY,sigmaXY);
    end
end
fprintf('===============================================================\n');

else
    
fprintf('==========================================================\n');
fprintf('  node          sigmax          sigmay         sigmaxy    \n')
fprintf('==========================================================\n');
for i = 1:nnode
    nodeno = i;
    sigmaX = input(i,1) ;
    sigmaY = input(i,2) ;
    sigmaXY = input(i,3) ;
    
fprintf('%5d    %+6.5e   %+6.5e   %+6.5e    \n',nodeno,sigmaX,sigmaY,sigmaXY);
end
fprintf('===========================================================\n');
end


