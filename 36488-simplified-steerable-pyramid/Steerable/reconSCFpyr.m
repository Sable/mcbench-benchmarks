% The inverse of buildSCFpyr: Reconstruct image from its complex steerable pyramid representation,
% in the Fourier domain.
%
% The image is reconstructed by forcing the complex subbands to be analytic
% (zero on half of the 2D Fourier plane, as they are supossed to be unless
% they have being modified), and reconstructing from the real part of those
% analytic subbands. That is equivalent to compute the Hilbert transforms of
% the imaginary parts of the subbands, average them with their real
% counterparts, and then reconstructing from the resulting real subbands.
                                                                                     
% Javier Portilla, 7/04, basing on Eero Simoncelli's Matlab Pyrtools code
% and our common code on texture synthesis (textureSynthesis.m).
                                                                                                                        
function res = reconSCFpyr(coeff)

Nsc = length(coeff); % Number of bandpasses
nbands = length(coeff{2});%number of orientations
                                                                                                                        
for i = 2:Nsc-1
    for j = 1:nbands
      coeff{i}{j}=real(coeff{i}{j});
    end    
end        
                                                                                                                        
res = reconSFpyr(coeff);
                                                                                                                        
