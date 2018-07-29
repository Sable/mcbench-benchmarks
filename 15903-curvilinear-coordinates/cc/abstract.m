% Programs and utility functions using the Symbolic Math Toolbox are
% provided to analyze vectors and tensors in general curvilinear
% coordinates. The programs perform the following functions:
% 1) runcoord plots intersecting coordinate surfaces for typical
%    coordinate systems 
% 2) runmetric computes and prints metric tensor properties for a
%    general curvilinear coordinate system 
% 3) rundivcrl verifies agreement of numerical values of divergence and
%    curl of an arbitrary vector computed in both cartesian and curvilinear
%    coordinates 
% 4) runconic plots surfaces illustrating how intersections of a cone and
%    a plane produce conic section curves.
% 5) Testmetric computes properties for nine different coordinate systems
%    and places the output in runmetric.tst. The symbolic equations from
%    some of the examples are fairly complicated.
% 
% The programs employ a number of other functions to define several
% coordinate systems (such as cylindrical, spherical, toroidal, conical,
% parabolic, ellipsoidal, and oblate spheroidal) and to compute base 
% vectors, metric tensors, Christoffel symbols, covariant derivatives, 
% divergence, and curl. 
% 
% Files readme.m and equations.m describe the workspace contents and
% governing equations. These files consist completely of comments and 
% can be examined with either the help or the edit commands. A pdf.file
% named TensorNotes presents derivations of the classical analytical
% formulas used.