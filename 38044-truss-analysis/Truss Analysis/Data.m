function D=Data
%  Definition of Data

%  Nodal Coordinates
Coord=[-37.5 0 200;37.5 0 200;-37.5 37.5 100;37.5 37.5 100;37.5 -37.5 100;-37.5 -37.5 100;-100 100 0;100 100 0;100 -100 0;-100 -100 0];

%  Connectivity
Con=[1 2;1 4;2 3;1 5;2 6;2 4;2 5;1 3;1 6;3 6;4 5;3 4;5 6;3 10;6 7;4 9;5 8;4 7;3 8;5 10;6 9;6 10;3 7;4 8;5 9];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord));Re(7:10,:)=[1 1 1;1 1 1;1 1 1;1 1 1];
% or:   Re=[0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;1 1 1;1 1 1;1 1 1;1 1 1];

% Definition of Nodal loads 
Load=zeros(size(Coord));Load([1:3,6],:)=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0.6 0 0];
% or:   Load=1e3*[1 -10 -10;0 -10 -10;0.5 0 0;0 0 0;0 0 0;0.6 0 0;0 0 0;0 0 0;0 0 0;0 0 0];

% Definition of Modulus of Elasticity
E=ones(1,size(Con,1))*1e7;
% or:   E=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*1e7;

% Definition of Area
A=[.4 .1 .1 .1 .1 3.4 3.4 3.4 3.4 .4 .4 1.3 1.3 .9 .9 .9 .9 1 1 1 1 3.4 3.4 3.4 3.4];

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');