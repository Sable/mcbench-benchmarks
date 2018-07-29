
function [ NRI , pval ] = NetReclassificationImprovement( pred_old , pred_new , outcome )
% Net Reclassification Index (NRI) 
% Compare classification of an old vs new classification technique
% Usage:
%   [ NRI , pval ] = NetReclassificationImprovement( pred_old , pred_new , outcome )
% 
% http://www.epibiostat.ucsf.edu/courses/RoadmapK12/SIGS/Pencina.pdf
% Statist. Med. (in press) (www.interscience.wiley.com) DOI: 10.1002/sim.2929
% Evaluating the added predictive ability of a new marker: From area under the ROC curve to reclassi�cation and beyond
% Michael J. Pencina Ralph B. D'agostino Sr Ralph B. D'Agostino Jr and Ramachandran S. Vasan
% 
% (c) Louis Mayaud, 2011 (louis.mayaud@gmail.com) 
% Please reference :
% Mayaud, Louis, et al. "Dynamic Data During Hypotensive Episode Improves
%        Mortality Predictions Among Patients With Sepsis and Hypotension*."
%        Critical care medicine 41.4 (2013): 954-962.


% Remove NaNs
Idx = (isnan(pred_old) & isnan(pred_new));
pred_old(Idx) = [];
pred_new(Idx) = [];

% Need to define the following probabilities
PEventUp = sum(outcome==1 & pred_old==0 & pred_new==1)/sum(outcome==1); 
PEventDown = sum(outcome==1 & pred_old==1 & pred_new==0)/sum(outcome==1); 
PNoneventUp= sum(outcome==0 & pred_old==0 & pred_new==1)/sum(outcome==0); 
PNoneventDown= sum(outcome==0 & pred_old==1 & pred_new==0)/sum(outcome==0); 

NRI = (PEventUp - PEventDown) - (PNoneventUp - PNoneventDown) ;
z = abs(NRI)/sqrt( (PEventUp + PEventDown)/sum(outcome==1) + (PNoneventUp + PNoneventDown)/sum(outcome==0)  );
[~,pval] = ztest(z,0,1);

% Implemented from Mc Nemar 1947, as detailed in
% Biometrics, 66, 1185-1191, 2010 Dec.
% Westfall et al.
% N01 = sum(pred_old==0 & pred_new==1);
% N10 = sum(pred_old==1 & pred_new==0);
% Nd = N01 + N10 ;
% 
% pval = binocdf(N01,Nd,0.5);

