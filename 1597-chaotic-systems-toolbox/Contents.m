% Chaotic Systems Toolbox
% Version 1.2 26-Oct-2003
%
% Tested under Matlab 6.5.0.180913a (R13)
%
% This toolbox contains a set of functions which can be used to
% simulate some of the most known chaotic systems. The user may add
% normal white noise to the systems, change their parameters, or 
% try different initial conditions. Additional functions provided for
% phase space reconstruction, surrogate data, and dimension calculation.
%
%
%  Chaotic maps.
%    henon           - The Henon map.
%    ikeda           - The Ikeda map.
%    logistic        - The Logistic map.
%    quadratic       - The quadratic map.
%
%  Chaotic flows.
%    lorentz         - The Lorentz flow.
%    mackeyglass     - The Mackey-Glass discretized PDE.
%    rossler         - The Rossler flow.
%
%  Phase Space reconstruction.
%    derivs          - Reconstruction based on the derivatives approach.
%    phasespace      - Reconstruction based on the Method Of Delays.
%    SSA             - Reconstruction based on the Singular Spectrum Approach.
%    SSAinv          - The inverse of Singular Spectrum Approach.
%
%  Dimension and noise estimation
%    gencorint       - The Generalized Correlation Integral.
%    vr              - The derivative of the correlation integral.
%    noiseest        - Noise estimation with normal distribution.
%
%  Distances calculation
%    radnearest      - Finds the neighbors in a radius.
%    Knearest        - Locates the K nearest neighbors.
%
%  Noise reduction
%    noisergeo       - Local Geometric Projection.
%    noiserSchreiber - Extremely simple noise reduction method.
%
%  Forecasting
%    SSAforeiter     - Iterative foracasting using SSA.
%
%  Surrogate data.
%    shuffle         - Makes shuffled surrogates.
%    phaseran        - Makes phase randomized surrogates.
%    AAFT            - Makes AAFT surrogates.
%    IAAFT           - Makes IAAFT surrogates.
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
