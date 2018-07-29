function feelinglucky(q,n)
%FEELINGLUCKY Opens the system browser to Google's result.
%   FEELINGLUCKY(Q) opens the browser on the first hit.
%
%   FEELINGLUCKY(Q,N) opens the browser on the Nth hit.

%   Matthew J. Simoneau, April 2002
%   Copyright 2002 The MathWorks, Inc. 
%   $Revision: $  $Date: $

if (nargin < 1), q = 'matlab'; end
if (nargin < 2), n = 1; end

s = googlesearch(q,n,1);
if (s.EndIndex < n)
    disp('No results found.')
else
    web(s.ResultElements(n).URL,'-browser')
end