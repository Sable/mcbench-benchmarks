function M = moveLRB(F, d)
%------------------------------------------------------------------------------
% Moves gridfunction F in horizontal direction.
% Excess area is filled by extension of boundaryvalues.
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: July 7, 2001.
% (c) 1999-2002 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
M = moveUDB(F.', d).';
%------------------------------------------------------------------------------
