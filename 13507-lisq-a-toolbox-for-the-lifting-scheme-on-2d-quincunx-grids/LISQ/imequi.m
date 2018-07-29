function feq = imequi(f, iscale, hgram)
%------------------------------------------------------------------------------
% imequi
% Under the assumption that f is of class double, we linearly transform f into
% an intensity image according to the definition of the Image Processing Toolbox
% meaning that the values are contained in the range [0, 1]. Moreover, the
% contrast is enhanced. In case the Image Processing Toolbox is available this
% is performed by histogram equalization, if this toolbox is not available it is
% performed by removing the outliers.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: July 31, 2003.
%  2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
if nargin ~=2  && nargin ~=3
  error(' imequi - number of arguments should be either 2 or 3 ');
else
  if exist('histeq','file') ~= 2 && iscale == 3
%   Note: if histeq exists then imshow exists as well (in same toolbox).
    isca = 2;
    disp(' imequi - WARNING histeq does not exist ');
  else
    isca = iscale;
  end
end
%
if isca == 1
  feq = intensim(f);
elseif isca == 2
  showmean=mean(f(:));           showstd=std(f(:));
  showlow=showmean-2.0*showstd;  showhgh=showmean+2.0*showstd;
  supermin=min(min(f));          supermax=max(max(f));
  showlow=max(supermin,showlow); showhgh=min(showhgh,supermax);
  fs = (f < showlow)*showlow + (f > showhgh)*showhgh + ...
       (f >= showlow).*(f <= showhgh).*f;
  feq = intensim(fs);
elseif isca == 3
  if nargin == 3
    feq = histeq(intensim(f), hgram);
  else
    feq = histeq(intensim(f));
  end
else
  error(' imequi - value of argument iscale should be either 1 or 2 or 3 ');
end
%------------------------------------------------------------------------------
