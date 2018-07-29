%Segments and Missing data
%=========================
%
%   Reference:
%   S. de Waele,
%   "Automatic model inference from finite time observations
%    of stationary stochastic signals",
%   Ph.D. Thesis, Delft university of Technology, 2003.
%
%   This reference contains a comparison of different methods to
%   deal with segments and missing data.
%
%
%Notation segments
%   See DATA_SEGMENTS
%
%Notation missing data
%   Measurements with missing data are denoted (ng,xg), where im contains
%   the integer times at which the observations were done; xm contains
%   the corresponding measurment values. Several segments of missing data
%   can be combined into a cell.
%   Example: to sets of data (ng1,xg1) and (ng2,xg2) can be combined as 
%   ng = {ng1 ng2};
%   xg = {xg1 xg2};
%
%Conversions
%   irr2grid      - conversion of irregularly sampled data to missing data
%   missing2seg   - extraction of segments from missing data
%
%Estimation
%   burg_s        - (in ARMASA Toolbox) Burg type AR estimator for multiple segments
%   burg_su       - Burg type AR estimator for multiple segments of unequal length
%   armasel_rs    - (in ARMASA_RS dir) reduced statistics ARMAsel model identification
%   sig2ar_misd   - selection of AR models from measurements with missing data
%                   (uses ARShat_misd, ARhat_misd, ARMLfit).