figure
plot([1:MonteCarloSteps],(TotalEnergy1MCS/((nlp+1)*(nlp+1))),'b',...
    [1:MonteCarloSteps],(TotalEnergy1MCS/((nlp+1)*(nlp+1))),'ro',...
    'MarkerFaceColor','k','MarkerSize',5),hold on,axis square,grid on,box on
xlabel('Monte-Carlo Steps')
ylabel('E/(JN)')
title('Hamiltonian variation with M.C.Steps')