function tQuantOpt

FPDF = PDFFn('gamma');

Sym = true;
%Sym = false;
NlevA = [2 4 8 16 32];
for (Nlev = NlevA)
  [Yq, Xq, MSE, Entropy, SNRdB] = QuantOpt(Nlev, FPDF, Sym);
%  Xq
%  Yq
  fprintf('Nlev:%4d, MSE = %.3g, SNR =%6.2f dB, Entropy =%4.1f bits\n', ...
          Nlev, MSE, SNRdB, Entropy); 
end

return
