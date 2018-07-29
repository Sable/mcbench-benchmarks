%% Simple two-d plot

dataA = linspace(0.1, 0.7, 20);
dataB = -dataA.^2 + dataA + (rand(size(dataA)) - 0.5)/7;
dataC = 1 - dataA - dataB;

A = linspace(0, 1, 100);
B = -A.^2+A;

ternplot(dataA, dataB, dataC, 'r.');
hold on
ternplot(A, B)
ternlabel('A', 'B', 'C')
legend('Data', 'Fit')
hold off

%% Three D plot for viscosity of HIPS, ABS and PETG polymer blends
experimental = [...
    1.000	0.000	0.000
    0.000	1.000	0.000
    0.000	0.000	1.000
    0.500	0.500	0.000
    0.500	0.000	0.500
    0.000	0.500	0.500
    0.333	0.333	0.333
    0.750	0.250	0.000
    0.250	0.750	0.000
    0.750	0.000	0.250
    0.250	0.000	0.750
    0.000	0.750	0.250
    0.000	0.250	0.750
    0.667	0.167	0.167
    0.167	0.667	0.167
    0.167	0.167	0.667
    0.000	0.900	0.100];
data = [...
    0.139
    0.373
    0.089
    0.151
    0.056
    0.679
    0.095
    0.153
    0.178
    0.084
    0.040
    0.463
    0.163
    0.111
    0.170
    0.072
    0.333];

A = experimental(:, 1)';
B = experimental(:, 2)';
C = 1 - (A + B);

figure
subplot(2, 2, 1)
ternplot(A, B, C, '.'); ternlabel('HIPS', 'ABS', 'PETG');
subplot(2, 2, 2)
ternpcolor(A, B, data); ternlabel('HIPS', 'ABS', 'PETG');
shading interp
subplot(2, 2, 3)
terncontour(A, B, data); ternlabel('HIPS', 'ABS', 'PETG');
subplot(2, 2, 4)
ternsurf(A, B, data);
