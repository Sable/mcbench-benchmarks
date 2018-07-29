% An elaborate example.
% It shows the effect of thresholding the detail coefficients of a
% decomposition. All detail coefficients below a specified threshold are
% discarded, then follows the reconstruction.
%
disp('An elaborate example.');
disp('It shows the effect of thresholding the detail coefficients of a');
disp('decomposition. All detail coefficients below a specified threshold are');
disp('discarded, then follows the reconstruction.');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---PARAMETERS-----------------------------------------------------------------
% How to execute, set parameters
%
N=4;
tresh = realmax;
%
%filtername='maxmin';
 filtername='minmin';
%filtername='maxmax';
%filtername='Neville2';
%filtername='Neville4';
%filtername='Neville6';
%filtername='Neville8';
%
% Manage output, set preferences: see printshop
dops   =3;
dotiff =0;
%
%---INSERT YOUR IMAGES HERE----------------------------------------------------
%
if exist('imread','file') == 2
% Convert file with .tif format into matrix of grayvalues
  A = double(imread('zenithgray.TIF','tiff'));
else
  load zenithgray; A = zenithgray; clear zenithgray;
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
% Show original A
txt = ' Original A';
printshop('figOriginalA', txt, A, dops, dotiff, []);
%
% Decomposition
%
[CA,SA] = QLiftDec2(A,N,filtername);
%
disp([' Treshold ' num2str( tresh, '%+12.4e')]);
% Create C from CA (only the details)
%
C = CA;  S = SA;
for level = 1:N
   rectgrids = mod(level, 2)+1;
   if rectgrids == 2
     [F1A, F2A] = retrieveQ1001(level, 'd', CA, SA);
   else
     F1A = retrieveR(level, 'd', CA, SA);
   end
   for no = 1:rectgrids
      if no == 1
        fca = F1A;
      else
        fca = F2A;
      end
%      
%     A very simple thresholding rule
      fcat = (abs(fca) >= tresh) .* fca;
%
      if rectgrids == 2
        if no == 1
          [first, last] = whatcoef2QL(level, '10', 'd', S);
        else
          [first, last] = whatcoef2QL(level, '01', 'd', S);
        end
      else
        [first, last] = whatcoef2QL(level, 'none', 'd', S);
      end
      C(first:last) = fcat;
   end
end
%
% Reconstruction
%
Athresh = QLiftRec2(C,S,filtername);
printshop('Athresh', ' details thresholded ', Athresh, dops, dotiff, []);
