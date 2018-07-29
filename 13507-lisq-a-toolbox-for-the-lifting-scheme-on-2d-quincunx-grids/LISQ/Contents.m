% 
%  ===================================================================
%
%                              L I S Q
%   LISQ is a toolbox for the lifting scheme on two-dimensional grids
%   (rectangular and quincunx) and for the computation of moment
%   invariants.
%
%  ===================================================================
%
%  FUNCTIONS (selected)
%
%  momentsupto3 - one of the main functions. After the computation of 
%              central moments (upto 3rd order) it computes similitude
%              invariants, orthogonal invariants and invariants with  
%              respect to similitude and orthogonal transforms combined.
%              Typically called as
%               [mass, mus, orthos, sims, simorthos] = momentsupto3(F);
%              For more information use the command
%               help momentsupto3
%              See also exampleHU.
%  QLiftDec2 - one of the main functions. It performs a multiresolution
%              2D decomposition by the lifting scheme and involves 
%              quincunx grids. Typically called as
%               [C, S] = QLiftDec2(X, N, filtername);
%              For more information use the command
%               help QLiftDec2
%              See also example04 or consult the report mentioned below.
%  QLiftRec2 - one of the main functions. It performs a multiresolution
%              2D reconstruction by inverting the lifting scheme and 
%              using quincunx grids. Typically called as
%               X = QLiftRec2(C, S, filtername);
%              For more information use the command
%               help QLiftRec2
%              See also example04 or consult the report mentioned below.
%
%  Many subsidiary functions and expedient functions exist. See the 
%  examples or consult the report mentioned below.
%
%
%  EXAMPLES 
%
%  exampleIF - an elaborate example with respect to multiresolution 
%              image fusion, the source code includes lots of comments.
%  exampleTH - an elaborate example where details (below a certain 
%              treshold) are discarded.
%  exampleHU - an elaborate example which demonstrates how (little)
%              the vector of invariants based on central moments 
%              depends on either rotation or similitude transforms.
%              This example requires the Image Processing Toolbox.
%  example00 - this small technical example shows hows how to call for
%              the computation of central moments and invariants. 
%  example01 - this small technical example performs a check on the 
%              computation of central moments on a rectangular grid.
%  example02 - this small technical example demonstrates an expedient
%              for showing an image.  
%  example03 - this small technical example shows how to call for the
%              multiresolution decomposition of an image and shows the
%              detailed bookkeeping. 
%  example04 - this small technical example shows how to call for the
%              multiresolution reconstruction of an image after its 
%              decomposition. 
%  example05 - this small technical example shows how to ask for the
%              maximum number of levels in a decomposition. 
%  example06 - this small technical example shows how to retrieve the
%              details on a quincunx grid, after a multiresolution 
%              decomposition has been performed. 
%  example07 - this small technical example shows how to retrieve the
%              details on a rectangular grid, after a multiresolution
%              decomposition has been performed.  
%  example08 - this small technical example demonstrates how to show
%              the details on the rotated quincunx grid.  
%  example09 - this small technical example performs a check on the
%              computation of certain central moments on a quincunx 
%              grid.
%  example10 - this small technical example shows how a gridfunction
%              constituting part of a quincunx grid is stored.
%  example11 - this small technical example demonstrates how to show an
%              all-scales image of the multiresolution decomposition.
%
%  ===================================================================
%
%  REPORT (also manual)
%
%  P.M. de Zeeuw,
%  A Toolbox for the Lifting Scheme on Quincunx Grids (LISQ),
%  CWI Report PNA-R0224,
%  Centrum voor Wiskunde en Informatica,
%  Amsterdam, 2002.
%
%  This report is readily available as:
%    http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf
%  or
%    http://ftp.cwi.nl/CWIreports/PNA/PNA-R0224.ps.Z
%
%  
%  ERRATA
%
%  Page  Line  Correction
%   16     2   "square grid" should be "rectangular grid"
%
% ===================================================================
%
%   VERSION
%
%   This is Version 1.3, December 21, 2006.
%
% ===================================================================
