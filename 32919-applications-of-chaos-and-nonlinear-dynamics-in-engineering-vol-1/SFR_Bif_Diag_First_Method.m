% SFR_Bif_Diag_First_Method - Bifurcation diagram of the SFR.
% Copyright Springer 2013 Stephen Lynch.
clear
itermax=100;B=0.15;
% Plot the last 30 iterates for each value of Input.
finalits=30;finits=itermax-(finalits-1);
for Input=0:0.01:16
    E=0.5; % Initial value for all Input.
    E0=E;
    for n=2:itermax
        En=sqrt(Input)+B*E0*exp(1i*abs(E0)^2);
        E=[E En];
        E0=En;
    end
    Esqr=abs(E).^2; % The output power.
    plot(Input*ones(finalits),Esqr(finits:itermax),'.','MarkerSize',1);
    hold on
end
fsize=15;
set(gca,'xtick',0:4:16,'FontSize',fsize)
set(gca,'ytick',0:5:25,'FontSize',fsize)
xlabel('Input Power','FontSize',fsize)
ylabel('Output Power','FontSize',fsize)
hold off
% End of Program.