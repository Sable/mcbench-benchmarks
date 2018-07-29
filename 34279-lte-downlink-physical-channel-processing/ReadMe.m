%% ReadMe.m

%% Modeling assumptions for PDSCH processing link
%
% Specifications based:
%   FDD mode (vs. TDD mode)
%   Multicodeword transmission for Spatial Mux, num=2 (vs. single codeword)
%       same length blocks of data - per one user only.
%           same Mod/rate per codeword - can be different to get the benefits
%       assumes 2x2, 4x4 tx mode only
%   Normal cyclic prefix (vs. extended CP)
%   DeltaF = 15KHz (vs. 7.5KHz)
%   16QAM (vs. QPSK/64QAM)
%
% Modeling one subframe per time step => 2 slot transmission, @ 1ms
%
% Fading channel
%   MIMO - 2x2, 4x4 configurations only 
%       supports multiple delay profiles
%       no correlation between links
%
% Precoding - SU-MIMO - Mode 4 transmission
%   codebook based precoding for 4x4 system, without CDD
%   for 2 and 4 layers (antenna ports) - as use 2 codewords
%       no feedback modeled, selects a random codebook index per simulation run
%
% Simplifications:
%   all data processing for one user only
%       added only cell-specific reference signals - set up for 2,4 layers
%       localized resource mapping - no distributed type
%   fixed size, modes determined from the upper level mask - Channel BW
%   All data/frequency for one user - no multiple access yet
%   Full bandwidth modes only
%
% Cell specific reference (CSR) signals - set up for 1,2,4 layers
%   added per port
%
% Assume NcellId = 1 (one of 504 values), RNTI = 1 
%   used in scrambler + CSR + mapper + extractor + estimator
%
% Nfft = varies as per channel bandwidth
%
% FDE - updated to use the CSR signals for multiple antennas
%   For 2x2, 4x4 only - does allow varying the bandwidths.
%
% MIMO receiver -
%   only direct matrix inversion for now - works best with no AWGnoise
%   only square channel matrices (use inv)
%
% Random codebook selection, no feedback or selection.

%% Parameter variations allowed:
%
% Select different channel bandwidths to see the effect on the data and sampling rate
% Select between 2x2 and 4x4 antenna configuration schemes
% Change between different fading channel profiles to see effect on performance
