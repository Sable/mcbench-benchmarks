%          DESCRIPTION OF THE CURVCOORD WORKSPACE
% Several programs and utility functions using symbolic math are 
% provided to analyze vectors and tensors in general curvilinear
% coordinates. The principal programs are: 1) runcoord plots
% coordinate surfaces for typical coordinate systems 2) runmetric
% computes and prints metric tensor properties for a general
% curvilinear coordinate system 3) rundivcurl compares divergence
% and curl of an arbitrary vector computed in both cartesian and
% curvilinear coordinates 4) runconic plots surfaces showing how
% intersections of a cone and a plane produce conic section curves.
%
% Curvilinear coordinates arise when cartesian coordinates (x,y,z)
% are expressed in terms of three auxiliary parameters such as
% (t1,t2,t3). Allowing one of the parameters, say t1, to vary,
% with t2 and t3 held fixed, defines a space curve called the t1
% coordinate line. Similarly, holding t1 constant,while t2 and t3
% vary defines the t1 coordinate surface. Coordinate surfaces
% intersect in coordinate lines which are typically not orthogonal.
% Furthermore,two different sets of base vectors, defined by 
% coordinate line tangents and coordinate surface normals, naturally
% occur with curvilinear coordinate formulations. Vector and tensor
% quantities can be conveniently represented by using either set of
% base vectors, with conversion between bases being facilitated by
% use of the metric tensor components. Differentiation of vector 
% quantities in curvilinear coordinates requires differentiation of
% both the component magnitudes and the base vectors. This process
% leads to the concept of covariant derivatives and Christoffel
% symbols which are functions of the metric tensor components.
%  
% Two different kinds of tools are included in the workspace. The
% first uses numerics to graphically show intersecting coordinate
% surfaces of a general curvilinear coordinate system. Illustrative
% examples such as cylindrical, spherical, toroidal, ellipsoidal,
% and oblate spheroidal coordinates are presented. Although surface 
% plots only require numerics, symbolic computation is needed to  
% obtain base vectors, metric tensor components, etc. The MATLAB
% Symbolic Math Toolbox, based on Maple software, handles matrices
% of symbolic elements very conveniently. This greatly simplifies
% symbolic operations such as dot and cross products, divergence,
% curl, Christoffel symbols, and covariant derivatives.
%
% A summary of the equations basic to the programs developed here
% can be obtained by the command: help equations. Helpful references
% on the analytical methods used include: 
% "Field Theory Handbook" by Parry Moon and Domina E. Spencer
% "Vector Analysis" by Murral Speigel
% "MathWorld" by Eric W. Weisstein (available on the internet)
%
% The principal functions in the workspace are described below.
%
% cart2curv.m      convert cartesian components to curvilinear
% cone.m           symbolic function for non-orthogonal conical
%                  coordinates
% cone0.m          function to plot non-orthogonal conical
%                  coordinates
% covardif.m       computes covariant derivatives of a vector
% crldivxyz.m      divergence and curl of a cartesian vector
% curls.m          vector curl in curvilinear coordinates
% curv2cart.m      convert curvilinear components to cartesian
% cylin.m          symbolic function defining cylindrical
%                  coordinates
% cylin0.m         function used to plot cylindrical coordinates
% diverge.m        vector divergence in curvilinear coordinates 
% elipcyl.m        symbolic function defining elliptic cylinder
%                  coordinates
% elipcyl0.m       function to plot elliptic cylinder coordinates
% edilsod.m        symbolic function defining ellipsoidal coordinates
% elipsod0.m       function to plot ellipsoidal coordinates
% equations.m      the command: help equations lists fundamental
%                  equations pertaining to curvilinear coordinates
% metric.m         computes base vectors, metric tensors, and 
%                  Christoffel symbols for general curvilinear
%                  coordinates
% notort.m         a special non-orthogonal curvilinear coordinate
%                  system 
% oblate.m         symbolic function defining oblate spheroidal 
%                  coordinates
% oblate0.m        function used to plot oblate spheroidal coordinates
% parab.m          symbolic function defining parabolic coordinates
% parabo.m         function used to plot parabolic coordinates
% readme.m         typing help readme prints this workspace description
% runconic.m       illustrates planes intersecting a cone to produce
%                  the four conic section curves: parabola, hyperbola, 
%                  circle, and ellipse 
% runcoord.m       interactive program to draw coordinate surfaces for
%                  several curvilinear coordinate systems
% 
% rundivcrl.m      program to compare numerical results when divergence
%                  and curl of a general vector are computed in both
%                  cartesian and curvilinear coordinates
%
% rundivcrl.tst    shows numerical output from progam rundivcrl for 
%                  several coordinate systems
%
% runmetric.m      program to compute and print the base vectors, metric 
%                  tensors, and Christoffel symbols for a general
%                  curvilinear coordinate system. 
% runmetric.tst    shows extensive symbolic output from program
%                  runmetric for various coordinate systems. Output for
%                  some of the coordinate systems is quite lengthy.
% sphr.m           symbolic function defining spherical coordinates
% sphr0.m          function used to plot spherical coordinates     
% testdivcrl.m     script to run data cases on program rundivcrl
% testmetric.m     script to run data cases on program runmetric
% toroid.m         symbolic function defining toroidal coordinates
% toroid0.m        function used to plot toroidal coordinates