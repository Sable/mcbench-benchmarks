function retention
% Retention curve examples     
%    using MATLAB                    
%
%   $Ekkehard Holzbecher  $Date: 2006/07/13 $
%
% Soil data from Hornberger and Wiberg, 2005
%--------------------------------------------------------------------------
qr = [0.153 0.19 0.131 0.218];
f = [0.25 0.469 0.396 0.52];
n = [10.4 7.09 2.06 2.03];
a = [0.0079 0.005 0.00423 0.0115];
p = linspace (0,200,50); 

figure
for i = 1:4
    m=1-(1/n(i));
    q = qr(i)+((f(i)-qr(i))./(((p.*a(i)).^n(i))+1).^m);
    plot (p,q);
    hold on;
end
legend ('Hygiene sandstone','Touchet Silt Loam','Silt Loam','Guelph Loam');
xlabel ('Suction head [cm]');
ylabel ('Volumetric water content [-]');





