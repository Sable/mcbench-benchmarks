function superima = QLsuperimage(C, S, iscale)
%------------------------------------------------------------------------------
% Creates an image that goes with a multiresolutiondecomposition that has been
% made in the way of LISQ. The superimage, that is an image that comprises
% all levels, is constructed as a rectangular gridfunction.
%
% C        is a one-dimensional array that contains the coefficients of the
%          Quincunx Lifting Scheme (LISQ) decompositions.
% S        is the bookkeeping vector
% iscale   optional inputparameter
%          1 show superimage as is (default)
%          2 show superimage after removal of outliers
%          3 show superimage after enhancement of contrast using
%            histogram equalisation (if available)
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 24, 2003.
%  2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
 if nargin == 3
   iopt = iscale;
 elseif nargin == 2
   iopt = 1;
 else
   error(' QLsuperimage - number of arguments should be either 2 or 3 ');
 end
%
 [nS, mS] = size(S);
 if mS ~= 6
   error(' QLsuperimage - unexpected dimensions of bookkeeping vector ');
 end
levels = S(nS,1);
if mod(levels, 2) == 1
  error('  QLsuperimage - only an even number of levels is accepted ');
elseif levels < 1
  superima = [];
else
%
% Firstly, we determine the dimensions of the superimage to be and create the
% necessary space (see LISQ/storeR.m and LISQ/QLiftRec2Nevill.m)
%
  [Detail10, Detail01] = retrieveQ1001(1, 'd', C, S);
  sizeR = size(Detail10) + size(Detail01);
  n  = sizeR(1); m = sizeR(2);
  nH = round((n+m+1.999)/2)+round((m+0.999)/2);
  nm = round((n+m+1.999)/2)+1;
  nV = 1;
  levels = S(nS,1);
  for k = 1:2:levels
    nV = nV + nm;
    nm = round((nm+0.999)/2);
  end
  Approx = retrieveR(levels, 'a', C, S);
  [nl, ml] = size(Approx); nV = nV + nl;
  superima = ones(nV, nH);
%
% Secondly, we fill the superimage with all subsequent detail coefficients 
% Put the details at the rotated quincunx grid (level 1)
  background=max(max(max(Detail10)), max(max(Detail01)));
  RotaDet=rota1001fill(Detail10, Detail01, background);
  clear Detail10 Detail01;
%-----intermezzo---begin--
  hgram=ones(1,64);
  hgram(64)=round(31.5*(n/m+m/n))+1;
% hgram is a histogram that is desired to be matched by the image after
% its values have been transformed by histeq, see the documentation of
% histeq() in the Matlab Image Processing Toolbox.
% Due to the rotation of the quincunx grid to make it visible, there
% is a substantial area for padding with one colour (white or nearly
% white). Here follows an overview of the quantities of pixels involved
% at the rotated quincunx grid (asymptotically):
%  Let n and m be the dimensions of the original image.
%
%                               2
%                      ( n + m )
%  Grand total:         -------
%                          4
%
%                         n m
%  Used pixels:           ---
%                          2
%
%                        2    2
%                       n  + m
%  Pixels for padding:  --------
%                          4
%
%                            2    2
%                  n m      n  + m                 n   m
%  Used:padding =  ---   :  -------  = 63 : 31.5*( - + - )
%                   2          4                   m   n
%
%-----intermezzo---end----
  [nl, ml] = size(RotaDet);
  OrigV=1; OrigH=1;
  superima(OrigV:(OrigV+nl-1), OrigH:(OrigH+ml-1)) = imequi(RotaDet,iopt,hgram);
  Detail11 = retrieveR(2, 'd', C, S);
  OrigV=1; OrigH=ml+1;
  [nr, mr] = size(Detail11);
  superima(OrigV:(OrigV+nr-1), OrigH:(OrigH+mr-1)) = imequi(Detail11,iopt);
% Now the other levels, if any
  OrigV=OrigV+nl; OrigH=1;
  for k = 3:2:levels
%   Put the details at the rotated quincunx grid
    [Detail10, Detail01] = retrieveQ1001(k, 'd', C, S);
    background=max([max(max(Detail10))  max(max(Detail01))]);
    RotaDet = rota1001fill(Detail10, Detail01, background);
    clear Detail10 Detail01;
    [nl, ml] = size(RotaDet);
    superima(OrigV:(OrigV+nl-1), OrigH:(OrigH+ml-1)) = imequi(RotaDet,iopt,hgram);
    Detail11 = retrieveR(k+1, 'd', C, S);
    OrigH=ml+1;
    [nr, mr] = size(Detail11);
    superima(OrigV:(OrigV+nr-1), OrigH:(OrigH+mr-1)) = imequi(Detail11,iopt);
    clear Detail11;
    OrigV=OrigV+nl; OrigH=1;
  end
% Thirdly, we fill the superimage with approximation coefficients.
  [nl, ml] = size(Approx);
  superima(OrigV:(OrigV+nl-1), OrigH:(OrigH+ml-1)) = imequi(Approx,iopt);
end
%------------------------------------------------------------------------------
