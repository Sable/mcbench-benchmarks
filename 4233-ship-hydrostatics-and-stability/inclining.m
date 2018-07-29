%INCLINING21	Inclining Experiment data for Example 7.1.
% Data taken from Hansen (1985), `An analytical treatment of the accuracy of the 
% results of the inclining experiment', Naval Engineers Journal, Vol. 97, No.4, 
% May, pp. 97-115.
% Format is [ moment tangent ], initial units [ ft-tons - ]
% Companion file for Biran, A. (2003), Ship Hydrostatics and Stability,
% Oxford: Butterworth-Heinemann.

incldata = [
 3853.7	 0.01869
 3853.7	 0.01854
 3853.7	 0.01788
 2570.1	 0.01259
 2570.1  0.01255
 2570.1	 0.01214
 1286.8	 0.00648
 1286.8	 0.00641
 1286.8	 0.00615
    3.8	 0.00042
    3.8	 0.00047
    3.8	 0.00000
-3785.8	-0.01791   
-3785.8 -0.01802
-3785.8 -0.01850
-2523.3 -0.01194
-2523.3 -0.01203
-2523.3 -0.01235
-1263.7 -0.00574
-1263.7 -0.00599
-1263.7 -0.00646
   -0.6 -0.00000
   -0.6 -0.00000
   -0.6 -0.00063 ];
format bank
% separate data and convert to SI units
moment  = (0.305/1.016)*incldata(:, 1);
tangent = incldata(:, 2);
plot(tangent, moment, 'k.'), grid
Hl = ylabel('Inclining moment, pd, tm');
set(Hl, 'FontSize', 14)
Hl = xlabel('Heel angle tangent, tan\theta');
set(Hl, 'FontSize', 14)

hold on
tmin = min(tangent);
tmax = max(tangent);
M    = sum(tangent.*moment)/sum(tangent.^2);
Mmin = M*tmin;
Mmax = M*tmax;
plot( [ tmin tmax ], [ Mmin Mmax ], 'k-')
Ht = text(-0.015, 1100, [ 'Average slope = ' num2str(M) ]);
set(Ht, 'FontSize', 14)

hold off

