function [v1,v2,v3]=vehicle()

% [v1,v2,v3]=vehicle;
% creates 3 different vehicle configurations, which vary one 
% from another only by the distance between prow and wings.

% -----------------------------------------------------------------------
% configuration # 1

% phisical world variables
v1.g_e=[0; 0; 9.81];	% Gravitational acceleration
v1.rho=1033;			% Marine water density

% mass
v1.m=1444.0;			% mass (kg)


% Rigid body mass matrix [Kg Kg*m; Kg*m Kg*m^2]

v1.Mrb=[	1444	0	0	0	252.7	0	;
			0	1444	0	-252.7	0	-2527	;
			0	0	1444	0	2527	0	;
			0	-252.7	0	142.8	0	0	;
			252.7	0	2527	0	2796	0	;
			0	-2527	0	0	0	2778	];


% Added mass matrix [Kg Kg*m; Kg*m Kg*m^2]

v1.Ma=[	55.7	0	0	0	0	0	;
			0	1460	0	0	0	-102	;
			0	0	1460	0	102	0	;
			0	0	0	83.4	0	0	;
			0	0	102	0	3401	0	;
			0	-102	0	0	0	3401	];


% inverse total mass matrix 
v1.iM=inv(v1.Mrb+v1.Ma);

% geometric variables

v1.l=3.5;			% Fuselage length (m)
v1.d=0.7;			% Fuselage diameter (m)
v1.vol=1.39787;		% Fuselage volume (m^3)


% vectors

v1.P_b=[0; 0; 0];		% Pole wrt B (m)
v1.G_b=[-1.75; 0; 0.175];	% Center of mass wrt B (m)
v1.B_b=[-1.75; 0; 0];	% Center of buoyancy wrt B (m)


% wings

v1.sw=0.2;			% Wing surface (m^2)
v1.cw=0.4;			% Wing width (m)
v1.bw=0.5;			% Wing length (m)

% Position of wings wrt B along x (m) in config 1
lw=-1.65;

% distance of wing middle point from prow and from axis in config 1
dpfw =    -lw +0.25*v1.cw;
dafw = v1.d/2 +0.43*v1.bw;

% wings middle point positions wrt B in config 1
v1.P1_b = [-dpfw; dafw;    0];
v1.P2_b = [-dpfw;    0; dafw];
v1.P3_b = [-dpfw;-dafw;    0]; 
v1.P4_b = [-dpfw;    0;-dafw];


% tails

v1.st=0.2;			% Tail surface (m^2)
v1.ct=0.4;			% Tail width (m)
v1.bt=0.5;			% Tail length (m)

lt=-3.1;				% Position of tails along x wrt B (m)

% distance of tail middle point from prow and from axis
dpft =    -lt +0.25*v1.ct;
daft = v1.d/2 +0.43*v1.bt;

% tails middle point positions wrt B
v1.P5_b = [-dpft; daft;    0];
v1.P6_b = [-dpft;    0; daft];
v1.P7_b = [-dpft;-daft;    0]; 
v1.P8_b = [-dpft;    0;-daft];


% -----------------------------------------------------------------------
% configuration # 2

v2=v1;

% Position of wings wrt B along x (m) in config 2
lw=-1.15;

% distance of wing middle point from prow and from axis in config 2
dpfw =    -lw +0.25*v2.cw;
dafw = v2.d/2 +0.43*v2.bw;

% wings middle point positions wrt B in config 2
v2.P1_b = [-dpfw; dafw;    0];
v2.P2_b = [-dpfw;    0; dafw];
v2.P3_b = [-dpfw;-dafw;    0];
v2.P4_b = [-dpfw;    0;-dafw];

% -----------------------------------------------------------------------
% configuration # 3

v3=v1;

% Position of wings wrt B along x (m) in config 3
lw=-0.35;

% distance of wing middle point from prow and from axis in config 3
dpfw =    -lw +0.25*v3.cw;
dafw = v3.d/2 +0.43*v3.bw;

% wings middle point positions wrt B in config 2
v3.P1_b = [-dpfw; dafw;    0];
v3.P2_b = [-dpfw;    0; dafw];
v3.P3_b = [-dpfw;-dafw;    0];
v3.P4_b = [-dpfw;    0;-dafw];
