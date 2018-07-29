function ng=ngrav(fi);
%NGRAV    :Normal gravity value of a point on Geodetic Reference System 1980 (GRS80) ellipsoid using 
%         Somigliana's formula.
%        
%         NGRAV(fi) computes the normal gravity value (in m/sec^2 unit) of a point with the
%         geodetic latitude "fi" (in degree unit) defined in GRS80 ellipsoid.
%                  
%         The computation depends on the Somigliana's formula, which is the most accurate one among
%         the others (e.g, first and second Chebyshev approximations), and depends on the GRS80
%         ellipsoid, which is the more up-to-date and internationally adopted reference ellipsoid.
%
%         References:
%         [1] Featherstone WE and Dentith MC, 1997, A geodetic approach to gravity data reduction for 
%         geophysics, Computers&Geosciences, Vol.23,No.10,pp:1063-1070
%         [2] Moritz H, 2000, Geodetic Reference System 1980, Journal of Geodesy, 74/1, pp:128-162
%         [3] Vanicek P and Krakiwsky EJ, 1986, Geodesy: The concepts, North-Holland, Amsterdam
%
%         ______________________________________________________________________________________________
%
%         Written by Cuneyt Aydin, Geodesy Division, Yildiz Technical University, 2004
%                      
%                 e-mails : caydin@yildiz.edu.tr, agrimensores1978@yahoo.com
%                 web page: www.yildiz.edu.tr/~caydin
%         ______________________________________________________________________________________________
%
%GRS80 reference ellipsoid constants (Moritz,2000);
k=0.001931851353; %normal gravity constant
e2=0.00669438002290;%the square of the first numerical eccentricity
nge=9.7803267715;%normal gravity value on the equator (m/sec^2)

fi1=fi*pi/180;a=sin(fi1);b=a^2;
ng=nge*(1+k*b)/(sqrt(1-e2*b));


