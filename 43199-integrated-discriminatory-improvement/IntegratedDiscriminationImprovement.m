function [IDI , pval ] = IntegratedDiscriminationImprovement( pred_old , pred_new , outcome )
% Integrated Discrimination Improvement (IDI)
% Usage:
%    [IDI , pval ] = IntegratedDiscriminationImprovement( pred_old , pred_new , outcome )
% 
% Compare a old vs new classification technique 
% http://www.epibiostat.ucsf.edu/courses/RoadmapK12/SIGS/Pencina.pdf
% Statist. Med. (in press) (www.interscience.wiley.com) DOI: 10.1002/sim.2929
% Evaluating the added predictive ability of a new marker: From area under the ROC curve to reclassification and beyond
% Michael J. Pencina Ralph B. Dgostino Sr Ralph B. Dgostino Jr and Ramachandran S. Vasan
% 
% (c) Louis Mayaud, 2011 (louis.mayaud@gmail.com) 
% Please reference :
% Mayaud, Louis, et al. "Dynamic Data During Hypotensive Episode Improves
%        Mortality Predictions Among Patients With Sepsis and Hypotension*."
%        Critical care medicine 41.4 (2013): 954-962.
% 

% Remove NaNs
Idx = (isnan(pred_old) & isnan(pred_new));
pred_old(Idx) = [];
pred_new(Idx) = [];

pred_old = 1./(1+exp(-(pred_old-mean(pred_old))/std(pred_old)));
pred_new = 1./(1+exp(-(pred_new-mean(pred_new))/std(pred_new)));


% pred_old  = pred_old + 1000;
% % 
% [SenOld SpeOld] = SenSpe(pred_old,outcome);
% [SenNew SpeNew] = SenSpe(pred_new,outcome);
% 
% ISnew = trapz(SenNew)/length(SenNew) ; 
% ISold = trapz(SenOld)/length(SenOld) ; 
% IPnew = trapz(1-SpeNew)/length(SenNew) ; 
% IPold = trapz(1-SpeOld)/length(SpeOld) ; 
% 
% IDI = (ISnew - ISold) - (IPnew - IPold) ;

% 
P_new_ev = mean(pred_new(outcome==1));
P_new_Nev = mean(pred_new(outcome==0));
P_old_ev = mean(pred_old(outcome==1));
P_old_Nev =mean(pred_old(outcome==0));
IDI = (P_new_ev - P_new_Nev) - ( P_old_ev - P_old_Nev ) ;

SEevent = std( pred_old(outcome==1)-pred_new(outcome==1) ) / sqrt(sum(outcome==1)) ; 
SENevent = std( pred_old(outcome==0)-pred_new(outcome==0) ) / sqrt(sum(outcome==0)) ; 
z = abs(IDI)/ sqrt( SEevent.^2 +  SENevent.^2 ) ;
[~,pval] = ztest(z,0,1); 

function [Sen Spe] = SenSpe(pred,out)

    [pred , idx] = sort(pred,'ascend');
    out = out(idx);
    for i=1:length(pred)
        pred_bin = pred > pred(i);
        tp = sum(pred_bin == 1 & out == 1 ); 
        tn = sum(pred_bin == 0 & out == 0 );
        fp = sum(pred_bin == 1 & out == 0 );
        fn = sum(pred_bin == 0 & out == 1 );
        Sen(i) = tp/(tp+fn);
        Spe(i) = tn/(tn+fp);
    end
    %Sen = [0 Sen 1];
    %Spe = [1 Spe 0];