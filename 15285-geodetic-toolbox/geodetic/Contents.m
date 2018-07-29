% MatLab Geodetic Toolbox
% Version 2.97 (2013-02-12)
%
% Copyright (c) 2013, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com
%
% A collection of geodetic functions that solve a variety of problems
% in geodesy. Supports a wide range of common and user-defined
% reference ellipsoids. Most functions are vectorized.
%
% Angle Conversions
% deg2rad   - Degrees to radians
% dms2deg   - Degrees,minutes,seconds to degrees
% dms2rad   - Degrees,minutes,seconds to radians
% rad2deg   - Radians to degrees
% rad2dms   - Radians to degrees,minutes,seconds
% rad2sec   - Radians to seconds
% sec2rad   - Seconds to radians
%
% Coordinate Conversions
% ell2utm   - Ellipsoidal (lat,long) to UTM (N,E) coordinates
% ell2xyz   - Ellipsoidal (lat,long) to Cartesian (x,y,z) coodinates
% sph2xyz   - Shperical (az,va,dist) to Cartesian (x,y,z) coordinates
% xyz2sph   - Cartesian (x,y,z) to spherical (az,va,dist) coordinates
% xyz2ell   - Cartesian (x,y,z) to ellipsoidal (lat,long,ht) coordinates
% xyz2ell2  - xyz2ell with Bowring height formula
% xyz2ell3  - xyz2ell using complete Bowring version
% utm2ell   - UTM (N,E) to ellipsoidal (lat,long) coordinates
%
% Coordinate Transformations
% refell    - Reference ellipsoid definition
% ellradii  - Various radii of curvature
% cct2clg   - Conventional terrestrial to local geodetic cov. matrix
% clg2cct   - Local geodetic to conventional terrestrial cov. matrix
% rotct2lg  - Rotation matrix for conventional terrestrial to local geod.
% rotlg2ct  - Rotation matrix for local geod. to conventional terrestrial
% ct2lg     - Conventional terrestrial (ECEF) to local geodetic (NEU)
% dg2lg     - Differences in Geodetic (lat,lon) to local geodetic (NEU)
% lg2ct     - Local geodetic (NEU) to conventional terrestrial (ECEF)
% lg2dg     - Local geodetic (NEU) to differences in geodetic (lat,lon)
% direct    - Direct geodetic problem (X1,Y1,Z1 + Az,VA,Dist to X2,Y2,Z2)
% inverse   - Inverse geodetic problem (X1,Y1,Z1 + X2,Y2,Z2 to Az,VA,Dist)
% simil     - Similarity transformation (translation,rotation,scale change)
%
% Date Conversions
% cal2jd    - Calendar date to Julian date
% dates     - Converts between different date formats
% doy2jd    - Year and day of year to Julian date
% gps2jd    - GPS week & seconds of week to Julian date
% jd2cal    - Julian date to calenar date
% jd2dow    - Julian date to day of week
% jd2doy    - Julian date to year & day of year
% jd2gps    - Julian date to GPS week & seconds of week
% jd2mjd    - Julian date to Modified Julian date
% jd2yr     - Julian date to year & decimal year
% mjd2jd    - Modified Julian date to Julian date
% yr2jd     - Year & decimal year to Julian date
%
% Error Ellipses
% errell2   - Computes error ellipse semi-axes and azimuth
% errell3   - Computes error ellipsoid semi-axes, azimuths, inclinations
% plterrel  - Plots error ellipse for covariance matrix
%
% Miscellaneous
% cart2euler- Converts Cartesian coordinate rotations to Euler pole rotation
% euler2cart- Converts Euler pole rotation to Cartesian coordinate rotations
% findfixed - Finds fixed station based on 3D covariance matrix
% pltnet    - Plots network of points with labels
%
% Example Scripts
%
% DirInv    - Simple partial GUI script for direct and inverse problems
% DirProb   - Example of direct problem
% Dist3D    - Example to compute incremental 3D distances between points.
% InvProb   - Example of inverse problem
% PltNetEl  - Example plot of network error ellipses
% ToUTM     - Example of conversion from latitude,longitude to UTM

% Version History
%
% 1.0  Created
% 1.1  Corrected dms2rad.m & dms2deg.m when converting vectors with both
%      positive and negative angles;
%      Replaced incomplete pl2utm.m with complete version;
%      Added ConvertToUTM for example of conversion from lat,long to UTM;
%      Added caldate & juldate to convert between Gregorian calendar and
%      Julian dates.
% 1.2  Added Dist3D for example of computing incremental 3D distances
%      between points.
% 1.3  Corrected rad2deg.m function name in file;
%      Modified r2p.m to use atan instead of atan2.
% 1.4  Added covct2lg.m & covlg2ct.m.
% 1.5  Added Krassovsky & International ellipsoids to refell.m
% 1.6  Added xyz2plh2.m to use Bowring height formula;
%      Added xyz2plh3.m to use entire Bowring algorithm.
% 1.7  Added errell.m to compute error ellipse parameters
%      Added ploterrell.m to plot error ellipses
%      Added PlotNetEll example to plot network error ellipses
% 1.8  Added dg2lg.m & lg2dg.m to convert between geodetic & local geodetic
%      Added rad2sec.m & sec2rad to convert between radians & arc seconds
%      Renamed ct2local.m to ct2lg.m and local2ct to lg2ct
%      Modified refell.m input parameter sequence (e2 before finv)
% 1.9  Modified ploterrell.m to add user-defined color
% 1.9a Corrected errell.m to handle equal major/minor axes
% 1.9b Modified ploterrell.m to plot solid line
% 1.9c Modified ploterrell.m for any line type/color
% 1.9d Changed errell to errell2 for 2D error ellipses
%      Added errell3d for computing 3D error ellipsoids
% 2.0  Modified for MatLab 4.2c.1
% 2.0a Modified cct2clg.m & clg2cct.m to check sizes of matrices
% 2.0b Modified rad2dms to output negative angles.
% 2.0c Changed names of scripts & ploterrell (plterrel) for PC compatibility
% 2.0d Updated direct & indirect for new function names
% 2.0e Corrected xyz2ell to take abs value of dlat,dh for neg. latitudes
% 2.0f Corrected sec2rad function help description
% 2.0g Noted in comments which functions are vectorized
%      Vectorized dms2deg, dms2rad, rad2deg, rad2dms
% 2.0h Corrected juldate to refer to beginning of UT day not noon
%      Added pltnet for plotting a network of points with labels
% 2.0i Corrected rad2dms for negative angles less than 1 min of arc
% 2.1  Moved juldate & caldate to utils toolbox and replaced with new date
%      routines cal2jd, doy2jd, gps2jd, jd2cal, jd2dow, jd2doy, jd2gps and
%      dates
% 2.2  Changed rad2deg output +/- radians for compatibility with other funtions
%      Corrected help comments in dms2deg, dms2rad and rad2dms
% 2.3  Added rotlg2ct and rotct2lg to give rotation matrix between CT and LG
%      Corrected comments in refell, errell3
%      Correctly sorted functions in this file
% 2.4  Corrected ell2utm for long>180 & switched order of dummy args
%      Added comments in sph2xyz & xyz2sph to specify handedness of xyz system
% 2.5  Added Modified Airy reference ellipsoid in refell.
% 2.6  Added findfixed
% 2.7  Corrected gps2jd and jd2gps to begin GPS week numbering at 0
% 2.8  Added ellradii
%      Added TOPEX/POSEIDEN ellipsoid to refell
% 2.9  Modified ell2utm for any arbitrary central meridian (default standard
%      UTM zones)
% 2.91 Corrected ell2utm for mixed N & S latitudes
% 2.92 Corrected correction to ell2utm for mixed N & S latitudes
% 2.92a Removed copyright info for automated Matlab File Exchange licensing
% 2.93 Modified ct2lg & lg2ct to optionally use lat,lon vectors for different
%      LG origin for each point
% 2.94 Added jd2mjd, mjd2jd
%      Changed jd2gps to output GPS week w/o rollover at 1024
%      Corrected order of input variables to ell2utm in ToUTM script 
% 2.95 Modified dates to clear specific variables used instead of using clear
%      all
%      Commented clear all in example scripts DirInv, DirProb, Dist3D, InvProb,
%      PltNetEl & ToUTM
%      Modified lg2dg, ellradii, direct, dg2lg, ell2utm, ell2xyz, inverse,
%      xyz2ell2, xyz2ell3 & xyz2ell to use GRS80 reference ellipsoid by default
%      Revised description of direct & inverse
%      Added copyright notice to all functions
% 2.95a Corrected comment symbol in dg2lg.
% 2.96 Added rotct2lg, rotlg2ct & utm2ell.
%      Corrected ell2utm for use with default GRS80 reference ellipsoid, added
%      ouput of central meridians, modified comments to indicate support for
%      input of a vector of non-standard central meridians, used h-squared (h2)
%      variable for more efficient computations, and added additional methods
%      for computing merdian arc length (still using faster Helmert method).
%      Modified cct2clg & clg2cct to use rotct2lg & rotlg2ct.
%      Corrected cal2jd to Noon for start/end of Julian/Gregorian calendars.
%      Modified jd2yr for vectorized input & output.
%      Corrected pltnet comments/help for correct variable usage.
% 2.97 Corrected starting latitude for iteration in xyz2ell.
%      Added cart2euler & euler2cart for converting between Euler pole rotation
%      and Cartesian coordinate rotations.
%      Corrected help comments in lg2ct (lat,lon are input variables).
