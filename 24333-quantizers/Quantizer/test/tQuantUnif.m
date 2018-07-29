function tQuantUnif

FPDF = PDFFn('Laplace');

Sym = true;
%Sym = false;
NlevA = [4 8 16 32 64 128 256];
for (Nlev = NlevA)
  [Yq, Xq, MSE, Entropy, SNRdB, sdV] = QuantUnif(Nlev, FPDF, Sym);
%  Xq
%  Yq
  fprintf('Nlev:%4d, SNR =%5.1f dB, s/V =%6.3f, Entropy =%5.2f bits\n', ...
      Nlev, SNRdB, sdV, Entropy); 
end

return
