% An elaborate example.
% It presents an example of an application of LISQ with respect to image
% fusion. Two similar, though different, images are fused into one image
% meant to unify the information included in both originals.
% Please read the source code for a detailed account of what is happening.
% It is not claimed to represent the state of the art in image fusion.
%
disp('An elaborate example.');
disp('It presents an example of an application of LISQ with respect to image');
disp('fusion. Two similar, though different, images are fused into one image');
disp('meant to unify the information included in both originals.');
disp('Please read the source code for a detailed account of what is happening.');
disp('It is not claimed to represent the state of the art in image fusion.');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands'); 
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
%
% Number of scales asked for (too many)
N=20;
%
%filtername='maxmin';
%filtername='minmin';
%filtername='maxmax';
%filtername='Neville2';
 filtername='Neville4';
%filtername='Neville6';
%filtername='Neville8';
%
% Manage the output, see printshop
dops   =3;
dotiff =0;
%
%---INSERT YOUR IMAGES HERE----------------------------------------------------
%
if exist('imread','file') == 2
% Convert files with .tif format into matrix of grayvalues
  A = double(imread('hoed_A.tif','tiff'));
  B = double(imread('hoed_B.tif','tiff'));
else
  load hoed_A; A = hoed_A; clear hoed_A;
  load hoed_B; B = hoed_B; clear hoed_B;
end
%------------------------------------------------------------------------------
% Some preliminaries
disp([' Filter type is ' filtername]);
disp([' Number of scales asked for is ' int2str(N)]);
%
M = QLmaxlev(size(A), filtername);
disp([' Maximum number of scales is ' int2str(M)]);
N = min(N,M);
disp([' Number of scales is set to ' int2str(N)]);
%
% Show the images that have to be fused
txt = ' Original A';
printshop('figOriginalA', txt, A, dops, dotiff, []);
txt = ' Original B';
printshop('figOriginalB', txt, B, dops, dotiff, []);
%
% Images A and B should have identical dimensions
if ~all(size(B) == size(A))
  error(' Dimensions of A and B are not consistent ');
end
%
% Decompositions of image A and image B are computed,
% the respective coefficients are put in CA and CB,
% the bookkeeping data (where is what) in SA and SB.
[CA,SA] = QLiftDec2(A,N,filtername);
[CB,SB] = QLiftDec2(B,N,filtername);
%
% C is the decomposition of the fused image to be, firstly
% we initialize C by either CA or CB.
C = CA;  S = SA;
%
% Update C through combining CA and CB (only the detail coefficients)
for level = 1:N
   rectgrids = mod(level, 2)+1;
   if rectgrids == 2
%    We are at a quincunx grid here, composed of two rectangular grids.
%    Report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf explains this
     [F1A, F2A] = retrieveQ1001(level, 'd', CA, SA);
     [F1B, F2B] = retrieveQ1001(level, 'd', CB, SB);
   else
%    Here we are at a mere rectangular grid
     F1A = retrieveR(level, 'd', CA, SA);
     F1B = retrieveR(level, 'd', CB, SB);
   end
   for no = 1:rectgrids
      if no == 1
        fca = F1A; fcb = F1B;
      else
        fca = F2A; fcb = F2B;
      end
%      
%     We apply a very simple, pixel-based fusion rule (Li et al). We 
%     choose the largest one (in absolute value) of two geometrically
%     corresponding detail coefficients
      D = (abs(fca)>abs(fcb));
      fcab = D.*fca + (~D).*fcb;
%
%     Find out where the coefficients are stored
      if rectgrids == 2
        if no == 1
          [first, last] = whatcoef2QL(level, '10', 'd', S);
        else
          [first, last] = whatcoef2QL(level, '01', 'd', S);
        end
      else
        [first, last] = whatcoef2QL(level, 'none', 'd', S);
      end
%     Overwrite      
      C(first:last) = fcab;
   end
end
%
% Update the approximation coefficients in C (at the coarsest grid)
% by simply averaging the approximation coefficients in CA and CB
fca = retrieveR(level, 'a', CA, SA);
fcb = retrieveR(level, 'a', CB, SB);
fcab = (fca + fcb) * 0.5;
%
% Find out where the coefficients are stored
[first, last] = whatcoef2QL(level, 'none', 'a', S);
% Overwrite
C(first:last) = fcab;
%
% Construct the fused image from the newly created coefficients
ABfused = QLiftRec2(C,S,filtername);
%
% Show the fused image
txt = ' Fusion of A and B ';
printshop('figABfused', txt, ABfused, dops, dotiff, [], 0, 255);
