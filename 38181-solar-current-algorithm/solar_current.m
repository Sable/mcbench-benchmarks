% Algorithm for Solar Current
% Mohammad Ismail Hossain
% Jacobs University Bremen

function [Total_current, Blue_current, Red_current]=solar_current(QE_total, lam)

c=299792458;
q_elem = 1.602e-19;
h = 6.6262e-34;
mi0 = 4*pi*1e-7;
eps0 = 1/(mi0*c^2);

load AM1_5_300_1100.txt;

for p = 1:length(lam)
    for q = 1:length(AM1_5_300_1100)
        if lam(p) == AM1_5_300_1100(q,1)
            spec_irrad(p) = AM1_5_300_1100(q,2);
        end
    end
end

qe_2_SR = (q_elem.*lam*1e-9/(h*c)).*QE_total;
sr_2_sir = qe_2_SR.*spec_irrad';

% Integral
isc_sum = 0;

for p = 1:length(lam)-1 % spectrum response, 300-1100nm
    xx = lam(p+1)-lam(p);
    yy = (sr_2_sir(p)+sr_2_sir(p+1))/2;
    isc_sum = isc_sum + xx*yy;
end
Total_current = isc_sum/10;

% Integral BLUE
isc_sum = 0;
bl_index = min(find(lam==500)); % lambda 500 nm
for p = 1:bl_index-1 % spectrum response, 300-500nm
    xx = lam(p+1)-lam(p);
    yy = (sr_2_sir(p)+sr_2_sir(p+1))/2;
    isc_sum = isc_sum + xx*yy;
end
Blue_current = isc_sum/10;

% Integral RED
isc_sum = 0;
rd_index = min(find(lam==700)); % lambda 700 nm
for p = rd_index:length(lam)-1 % spectrum response, 700-1100nm
    xx = lam(p+1)-lam(p);
    yy = (sr_2_sir(p)+sr_2_sir(p+1))/2;
    isc_sum = isc_sum + xx*yy;
end
Red_current = isc_sum/10;
end