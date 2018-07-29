% Circuit Multiport Toolbox 
%
% useful for the RF designer, it manipulates the various 
% complex representations of the circuits as multiports,
% namely transformation from one representation to another
% and reading/writing to file in industry-standard format
%
% it contains stuff written/revised between 1993 and 2003,
% therefore a couple of things could be better done today;
% however, most of the transformations are singularity-protected 
%
% the file parsing/writing greatly improved thanks to the 
% input received from users on this site !
% 
% I think this toolbox can help getting that elusive insight
% so much sought for when working at high frequencies !
%
% +-----------------------------------------------------+
% |  Circuit Multiport Representation Transformations   |
% +-----------------------------------------------------+
%
% a		- is the ABCD Matrix
% g		- is the Hybrid-G Matrix
% h		- is the Hybrid-H Matrix
% s		- is the Scattering Matrix
% t		- is the Transmission Matrix
% y		- is the Admittance Matrix
% z		- is the Impedance Matrix
%
% for example :
% z2s       - Impedance to Scattering Transformation
% z2s4      - same as above, with Z and S as F-by-4 matrices describing
%             a 2-port at F frequencies, using the order 11, 12, 21, 22,
%             (kept for compatibility with older matlab versions that do 
%             not support multi-dimensional arrays)
%
% in all functions of the type s2*.m and *2s.m and also in a few others
% the matrices are of size [P,P,F], where:
%   - P is the number of ports 
%   - F is the number of frequencies
% for the ones using size [P,P] matrices a call indexed by F is necessary
%
% +-----------------------------------------------------+
% |  Manipulation of Circuit Multiport Parameter Files  |
% |  (a.k.a. MDIF, or "S2P" files)                      |
% +-----------------------------------------------------+
%
% SXPParse	- reads .sxp data files
% SXPWrite	- writes .sxp data files
%
% changes:
% 2005.06.03	- limited compatibility to octave (s2a, a2s, y2s, SXPParse)
% 2006.03.08	- fixed SXPParse to handle comment lines inside body of file
% 2008.10.25	- fix nPort>4 (when lines are split) 
%                 allow comments on lines
%                 better parsing, subfunctions introduced
%                 limited protection for non-standard files
% 2009.09.05    - allow for more separators, further cleanup
% 2011.09.30    - added 3rd (i.e. frequency) dimension to
%                 h2y, y2h, g2y, y2g, h2g, fixed s2g
%                 h2g (and its wrap, g2h) are now protected inverses
% 2012.05.29    - SXPWrite: properly write long numbers in scientific notation
%                 accept multi-line comments, more frequency units
%               - SXPParse: close the parsed file
% written by Tudor Dima, tudima@zahoo.com (replace the 'z' with a 'y'...)
%
% have fun !