function [CD0] = DetermineProfileDrag(airfoildata,geo,panel)
%Determine the wing profile drag from the airfoils' drag polars

airfoil_r = geo.rootindex;
airfoil_t = geo.tipindex;

%Root dimensions
chord_r = geo.c_r;

%Determine Reynolds number at root; using log10 because regression was
%done this way
Re_r = log10(geo.Re_r);

%Convert back to degrees because the polynomial regression of the XFOIL
%drag data is in terms of degrees
alpha_r = (geo.i_r + geo.alpha)*180/pi;
b = cell2mat(airfoildata{2}(airfoil_r)); %Load the coefficients
c = cell2mat(airfoildata{3}(airfoil_r));
d = cell2mat(airfoildata{4}(airfoil_r));
k = cell2mat(airfoildata{5}(airfoil_r));
cd0_r = b(1) + b(2)*Re_r + b(3)*Re_r^2;
cd1_r = c(1) + c(2)*Re_r + c(3)*Re_r^2;
cd2_r = d(1) + d(2)*Re_r + d(3)*Re_r^2;
alpha_stall_r = k(1) + k(2)*Re_r + k(3)*Re_r^2;

%Test to see if airfoil is past stall angle of attack
if alpha_r > alpha_stall_r
    cd2_r = 2*cd2_r;
    %Double the last coefficient to account for the large increase in drag
    %past stall
end

%Tip dimensions
chord_t = geo.c_r*geo.taper;

%Determine Reynolds number at tip, use log10 because performed regression
%using log10
Re_t = log10(geo.Re_t);

%Convert back to degrees because the polynomial regression of the XFOIL
%drag data is in terms of degrees
alpha_t = (geo.i_r + geo.twist + geo.alpha)*180/pi; 
b = cell2mat(airfoildata{2}(airfoil_t)); %Load the coefficients
c = cell2mat(airfoildata{3}(airfoil_t));
d = cell2mat(airfoildata{4}(airfoil_t));
k = cell2mat(airfoildata{5}(airfoil_t));
cd0_t = b(1) + b(2)*Re_t + b(3)*Re_t^2;
cd1_t = c(1) + c(2)*Re_t + c(3)*Re_t^2;
cd2_t = d(1) + d(2)*Re_t + d(3)*Re_t^2;
alpha_stall_t = k(1) + k(2)*Re_t + k(3)*Re_t^2;

%Test to see if airfoil is past stall angle of attack
if alpha_t > alpha_stall_t
    cd2_t = 2*cd2_t;
    %Double the last coefficient to account for the large increase in drag
    %past stall
end

%eta represents the fraction from 0 to 1 at the center of the panel where 0
%corresponds to y = 0 and 1 corresponds to y = b
eta = (2*(1:geo.ns)-1)/(2*geo.ns);
chord = chord_r + eta*(chord_t-chord_r);
alpha = alpha_r + eta*(alpha_t-alpha_r);
cd0 = cd0_r + eta*(cd0_t-cd0_r);
cd1 = cd1_r + eta*(cd1_t-cd1_r);
cd2 = cd2_r + eta*(cd2_t-cd2_r);

Deltay = zeros(1,geo.ns);
for i = 1:geo.ns
    Deltay(i) = panel(i,1).BV2(2) - panel(i,1).BV1(2);
end

D_q = (cd0 + cd1.*alpha + cd2.*alpha.^2).*chord.*Deltay;

CD0 = 2*sum(D_q,2)/geo.S;