clear all;close all;%set(0,'DefaultFigureWindowStyle','docked');
rand('state', 0.1);
[nlp,MonteCarloSteps,Q,Trials,PrintToJPEG]=Procure_Input_Values();
for trial = 1:Trials
    [x,y,state,Energy,TotalEnergy1MCS,ColorMatrix]=FirstThingsFirst(nlp,MonteCarloSteps,Q);
    for mcs=1:MonteCarloSteps
         for n=1:(nlp+1)*(nlp+1)
            [i,j] = PickRandomLatticeSiteQPOTTS(x,y);
            caseis = EdgeBoundaryWrapQPOTTS(i,j,x);
            IESM = IndexElementStateMatrixQPOTTS(x,caseis,state,i,j);
            Energy1=(8-kdelsum1QPOTTS(IESM));
            IESMnew = IESMwithNewFlippedStateQPOTTS(IESM,Q);
            Energy2=(8-kdelsum2QPOTTS(IESMnew));
            DelEnergy = EnergyDifferenceQPOTTS(Energy1,Energy2);
            if DelEnergy<0;state(i,j)=IESMnew(2,2);Energy(i,j,mcs)=Energy2;else;Energy(i,j,mcs)=Energy1;end
         end
         [GrainBoundaryX,GrainBoundaryY]=IdentifyGrainBoundary(x,y,state);
         TotalEnergy1MCS(1,mcs)=sum(sum(Energy(:,:,mcs)));
         AGS(mcs) = AverageGrainSize(state,x,y);
         fprintf('[Trial, MCS, AGS, %% Comp] = [%d, %d , %d, %2.4f%%]\n',...
             trial,mcs,AGS(mcs),mcs*100/MonteCarloSteps);
         run PlotMicrostructure2DPotts
    end
    run PlotAverageGrainSize_2D_QPOTTS
end
run PlotHamiltonian
run clearvariables
run Plot_D_iplus1Sq_minus_D_iSq_VsMCS_2D_QPOTTS

% A=d2current_M_d2previous_CorrMCS(1:289,1);
% B=d2current_M_d2previous_CorrMCS(1:289,2);
% 
% hold on
% d2current_M_d2previous_CorrMCS_mean=[];
% for count=2:(size(d2current_M_d2previous_CorrMCS,1))
%     d2current_M_d2previous_CorrMCS_mean=[d2current_M_d2previous_CorrMCS_mean;(d2current_M_d2previous_CorrMCS(count-1,1)+d2current_M_d2previous_CorrMCS(count,1))/2,d2current_M_d2previous_CorrMCS(count,2)];
% end
% plot(d2current_M_d2previous_CorrMCS_mean(:,2),d2current_M_d2previous_Corr
% MCS_mean(:,1),'ro','MarkerSize',8,'MarkerFaceColor','r')