function fintens = intensim(f)
%------------------------------------------------------------------------------%
% intensim
% Under the assumption that f is of class double, we linearly transform f into
% an intensity image according to the definition of the Image Processing Toolbox
% meaning that the values are contained in the range [0, 1].
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: July 18, 2003.
%  2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------%
fmin=min(min(f));
fmax=max(max(f));
if fmax == fmin
   if abs(f(1,1)) < 0.000000001
      fintens = zeros(size(f));
   else
      fintens = ones(size(f));
   end
else
  fintens = (f-fmin)/(fmax-fmin);
end
%------------------------------------------------------------------------------%
