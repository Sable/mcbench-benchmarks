function D=Data3
Coord=100*[1 1 0;0 1 0; 0 0 0];   % coordinates of nodes
Con=[1 2; 1 3 ];          
Re=[0 0 1;1 1 1; 1 1 1];
Load=zeros(size(Coord)); Load(1,:)=[0 -1e5 0];
% or:   Load=[0 0 0;0 -1e5 0;0 0 0;0 -1e5 0;0 0 0;0 0 0];
E=ones(1,size(Con,1))*1e7;      %*1e7;  % Elasticity ( Youngs Modulous) 
% or:   E=[1 1 1 1 1 1 1 1 1 1]*1e7;
A=[10 10 ];
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');