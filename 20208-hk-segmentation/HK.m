%/***********************************************************************
% Function Name : HK
% Author    Alireza Bossaghzadeh
% PURPOSE:  The Code calculate the Mean and Gaussian Curvature according to the method described in
% Modern Differential Geometry of Curves and Surfaces with Mathematica.2nd ed, 1997 (p. 377).

% The method Used in the Code:
% If x:U->R^3 is a regular patch, then the mean curvature is given by
%       
%           H = (eG-2fF+gE)/(2(EG-F^2)),	
%           G = (eg-f^2)   /(EG-F^2)
% where E, F, and G are coefficients of the first fundamental form and
% e, f, and g are coefficients of the second fundamental form 
% For more information see Links Below
% http://mathworld.wolfram.com/MeanCurvature.html
% http://mathworld.wolfram.com/MongePatch.html
% http://mathworld.wolfram.com/GaussianCurvature.html

% Function Variables:
% Input             I   mesh contain depth values
% outputs           H   Contain Mean Curvature of surface
%                   K   Contain Gaussian Curvature of surface
% Example           [H K]=HK(I);

% In the case of any problem you can call me by 
% Email:Alibossagh@yahoo.co.uk

% Version:    1.00       Published: 2008 June 07

%This Code was written By Alireza Bossaghzadeh.
%In the case of any problem you can contact me By
%Email:Alibossagh@yahooc.o.uk


function [H K]=HK(Z)

% Calculate base parameters
    Zx  =gradient(Z);
    Zxx =gradient(Zx);
    Zy  =gradient(Z')';
    Zyy =gradient(Zy')';
    Zxy =gradient(Zx')';

%Calculate First Fundamental Form coefficients
    E=1+Zx.^2;
    F=Zx.*Zy;
    G=1+Zy.^2;
%Calculate First Fundamental Form coefficients
    nom=sqrt(1+Zx.^2+Zy.^2);
    e=Zxx./nom;
    f=Zxy./nom;
    g=Zyy./nom;
    
% Calculate Mean Curvature    
    H=-(e.*G-2*f.*F+g.*E)./(2*(E.*G-F.^2));

%This code also can be used
%     H=(1+Zx.^2).*Zyy-2.*Zx.*Zy.*Zxy+(1+Zy.^2).*Zxx;
%     H=-H./(2.*(1+Zx.^2+Zy.^2).^(3/2));

% Calculate Gaussian Curvature
    K=(e.*g-f.^2)./(E.*G-F.^2);
    
    
    