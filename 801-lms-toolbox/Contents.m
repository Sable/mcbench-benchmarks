% Least Median of Squares Toolbox.
% Version 1.0 03-Sep-2001
%
% (Requires the Statistics toolbox.)
%
% Tested under Matlab 5.3.1.29215a (R11.1)
%
% This toolbox contains a set of functions which can be used to
% compute the Least Median of Squares regression, the Reweighted
% Least Squares regression, the associated location and scale
% estimators, and the Minimum Volume Ellipsoid. The concept is the
% minimization of the median of the squared errors (residuals) in
% order to achieve robustness against the outliers.
%
%
%  Least Median of Squares (LMS).
%    LMSloc      - LMS location parameter.
%    LMSsca      - LMS scale parameter.
%    LMSreg      - LMS linear regression.
%    LMSregor    - LMS linear regression through the origin.
%    LMSpol      - LMS polynomial regression.
%    LMSpolor    - LMS polynomial regression through the origin.
%    LMSar       - LMS autoregressive.
%
%  Reweighted Least Squares (RLS).
%    RLSloc      - RLS location parameter.
%    RLSsca      - RLS scale parameter.
%    RLSreg      - RLS linear regression.
%    RLSregor    - RLS linear regression through the origin.
%
%  Minimum Volume Elipsoid (MVE).
%    MVE         - MVE of a data set.
%    RMVE        - Reweighted MVE of a data set.
%
% Notes:
%  It is strongly advisable not to use large data sets.
%  The data sets must not contain any "NaNs".
%
% Alexandros Leontitsis
% Institute of Mathematics and Statistics
% University of Kent at Canterbury
% Canterbury
% Kent, CT2 7NF
% U.K.
%
% University e-mail: al10@ukc.ac.uk (until December 2002)
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
