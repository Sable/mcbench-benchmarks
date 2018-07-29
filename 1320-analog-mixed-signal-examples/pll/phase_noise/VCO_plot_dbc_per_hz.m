% Plot simulation results with log x axis. 
% Plot only + freq terms.
% Per common practice, do not show carrier term.
% Plot measured, plus specification. 
% Dick Benson
% Copyright 2004-2013 The MathWorks, Inc.
index_start = 3;              % move out from carrier at DC and fft window effects
Frame_Length = length(Normalized_Spectrum);
Fvec_meas = Spectrum_dF*((index_start-1):Frame_Length/2);

h2  =  findobj('Tag','plot_VCO');
if isempty(h2) 
   h2 =  figure('Tag','plot_VCO')
else
   figure(h2)
end

semilogx(Fvec_meas,10*log10(Normalized_Spectrum(index_start:(Frame_Length/2+1))),....
         Fvec,Lvec,'o','markersize',10,'linewidth',1,'markerfacecolor','g');
xlabel('Hz from Carrier'); ylabel('dBc/Hz'); grid on;
legend('Measured', 'specification');
axis([Fvec(1),Fvec_meas(end),-160,-60])
