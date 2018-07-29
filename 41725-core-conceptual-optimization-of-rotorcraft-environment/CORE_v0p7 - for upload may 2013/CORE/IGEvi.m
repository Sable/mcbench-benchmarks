function viratio = IGEvi(z_over_D)
at1 = 1.25;
z_over_D(isempty(z_over_D)) = at1;

x = z_over_D-1.25;

curvybit = -.01834*x.^4-.2889*x.^2+1;

viratio = curvybit;

viratio(z_over_D>at1) = 1;
end


% Data for curve fit from Prouty:
% X =
%          0
%     0.1300
%     0.2500
%     0.5100
%     0.7800
%     1.0000
%     
%     y =
%     0.5000
%     0.6100
%     0.7000
%     0.8400
%     0.9200
%     0.9600