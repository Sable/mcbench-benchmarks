function tauc = taucv(alfa,f,n)
%TAUCV  Upper percentage point of the tau distribution.
%       tauc=taucv(alfa,f,n) computes the critical value of tau distribution
%       for the Type I error--significance level (alfa), degree of freedom (f)
%       and the number of observations (n). It is used in Pope test for outliers.
%      
%       References:
%       [1] Koch KR,1999, Parameter estimation and hypothesis testing in linear models,
%       Springer Verlag, Berlin
%       [2] Pope AJ,1976, The  statistics  of residuals and the detection of outliers.
%       NOAA Technical Report NOS65 NGS1, US Department of Commerce, National Geodetic
%       Survey,Rockville, Maryland
%       -----------------------------------------------------------------------------
%       Written by Cuneyt AYDIN, 2003, Yildiz Technical University, Geodesy Division
%       e-mail:caydin@yildiz.edu.tr
%       -----------------------------------------------------------------------------      

if nargin < 3, 
    error('requires at least three input arguments; alfa,f and n'); 
 end 
 
if f==1
   error('degree of freedom must be larger than 1 (f>1)')
   
end

fdist=finv((1-alfa/n),1,(f-1));
tauc=sqrt((f*fdist)/(f-1+fdist));
