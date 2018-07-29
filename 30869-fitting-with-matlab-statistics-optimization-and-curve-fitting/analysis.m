%% Data import
%Copyright (c) 2011, The MathWorks, Inc.

% Import tumor-weight profile for drugs A & B
ds = dataset('xlsfile', 'Data.xls') ;

% Convert drug type column to nominal
ds.Drug = nominal(ds.Drug)               ;

%% Curve fitting 

% Initial estimates for [L0, L1, k1, k2_A and k2_B]
p0 = [0.11 , .149 , 1.836, 0.0154, 0.00732] ;

% Estimate parameters
fh   = @(p , t ) objFcn(p , t , ds.Drug) ;% Function handle
tic 
pFit = lsqcurvefit(fh , p0 , ds.Time , ds.TumorWeight ) ;
toc
%% Display results & plot

disp([' Drug-independent parameters: '          , ...
        num2str(pFit(1)), ' (L0), '             , ...
        num2str(pFit(2)), ' (L1) and '          , ...
        num2str(pFit(3)), ' (k1) '              ]) ;

disp([' Drug-dependent parameters: ' , ...
        num2str(pFit(4)), ' (k2 - Drug A) and '              , ...
        num2str(pFit(5)), ' (k2 - Drug B)'   ]) ;

% Plot observations
figure; hold on  ;
idx_A = ds.Drug == 'A' ;
plot(ds.Time(idx_A) , ds.TumorWeight(idx_A) , 'ro')  ;
plot(ds.Time(~idx_A), ds.TumorWeight(~idx_A), 'bo')  ;

% Plot predictions
yPred = fh(pFit, ds.Time) ;
plot(ds.Time(idx_A)  , yPred(idx_A) , 'r:')  ;
plot(ds.Time(~idx_A) , yPred(~idx_A), 'b:')  ;

xlabel('Time (days)')
ylabel('Tumor Weight (milligram)')
title('Tumor growth profile')
legend({'Drug A', 'Drug B'})
