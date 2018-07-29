d2current_M_d2previous_CorrMCS = [];
for count=2:numel(AGS)
    d2current_M_d2previous_CorrMCS = [d2current_M_d2previous_CorrMCS;(AGS(count)^2-AGS(count-1)^2),count];
end
ZeroIndices=find(d2current_M_d2previous_CorrMCS<=0);
d2current_M_d2previous_CorrMCS(ZeroIndices(:),:)=[];clear ZeroIndices
figure
plot(d2current_M_d2previous_CorrMCS(:,2),d2current_M_d2previous_CorrMCS(:,1),'ko','MarkerSize',5,'MarkerFaceColor','k'),axis square,box on,grid on
title('(d_{i+1}^2 - d_{i}^2) Vs. MCS')
xlabel('MCS')
ylabel('d_{i+1}^2 - d_{i}^2')