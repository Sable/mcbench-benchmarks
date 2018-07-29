function minDosage(tFit, pFit)
% This function accepts response surface models, and determines the minimal
% drug concentrations that results in pressure and tetany responses > 0.98.
%
% Copyright 2011 The MathWorks, Inc.

% Create a Grid to Evaluate Surface Fits
[op, sed] = meshgrid(linspace(0,50,50), linspace(0,10,50));
op = op(:); 
sed = sed(:);

% Evaluate Surface Fit on Grid
sfT = tFit(op,sed); 
sfP = pFit(op,sed);

% Find Cutoff For a Particular Pressure and Tetany Condition
cutoffT = sfT > 0.98;
cutoffP = sfP > 0.98;
idx = cutoffT & cutoffP; 
opN = op(idx); sedN = sed(idx); 


% Find and Display Minimal Drug Concentrations 
drugDist = hypot(opN/50,sedN/10);
[cMin,id] = min(drugDist);
opMin = opN(id);
sedMin = sedN(id);

disp('Minimal Drug Concentrations -')
disp(['Opioid: ', num2str(opMin), ', Sedative: ', num2str(sedMin)])
                          
% Plot minimal drug concentrations on tetany contour plot
figure;
plot(tFit, 'Style', 'contour');
colorbar;
xlabel('opiod', 'FontSize', 12);
ylabel('sedative', 'FontSize', 12);
title('Minimal Doses (Tetany)', 'FontSize', 14);
hold on
plot3(op,sed,tFit(op,sed),'k.')
plot3(opMin,sedMin,tFit(opMin,sedMin),'py','MarkerFaceColor',...
      'y','MarkerSize', 10)
  
% Plot minimal drug concentrations on pressure contour plot
figure;
plot(pFit, 'Style', 'contour');
colorbar;
xlabel('opiod', 'FontSize', 12);
ylabel('sedative', 'FontSize', 12);
title('Minimal Doses (Pressure)', 'FontSize', 14);
hold on
plot3(op,sed,pFit(op,sed),'k.')
plot3(opMin,sedMin,pFit(opMin,sedMin),'py','MarkerFaceColor',...
      'y','MarkerSize', 10)
