% MATLAB code for paper:
%
% Ha T. Nguyen and Minh N. Do, Hybrid Filter Banks With Fractional Delays:
% Minimax Design and Applications to Multichannel Sampling, IEEE
% Transactions on Signal Processing, vol. 56, no 7, July 2008.
%
% Last modification date: December 15th, 2008.
% Upload date December 15th, 2008.
%
% Created by Ha Nguyen (Sony Electronics Inc.)
%
% DEMO:
%       demo: demo of the design procedure and plots of figures shown in
%       the paper
%
% Main functions:
%       designIIR: design filters F_i(z) (as in Section III.B.)
%       designFIR: design filters F_i(z) (as in Section IV.B.)
%
% Other functions used in demo, designIIR and designFIR:
%       initialization
%
%       analog_conv: simulate an analog system. Input and output will be
%       given as an array of values at equi-distance time interval.  
%
%       plot_equi_filters: plot Fig. 12 in the paper. 
%
%       getAd: get the A-matrix as in equation (15)
%       getBd: get the B-matrix as in equation (16) and Lemma 2
%       getCd: get the C-matrix as in equation (15)
%
%       getF: get the IIR filters F_1(z),..., F_N(z) from the system F
%       getH: get system H as in Theorem 1
%       getP: get system P as in Figure 7
%       getW: get system W as in Theorem 1
%
%       INTDELAYOP: Integer Delay Operator. IntDelayOp delays the i-th
%       channel of a digital LTI system by m(i) samples. 
%
%       Analog2Digital: bilinear transformation of an analog system K to
%       discrete time  
%
%       Digital2Analog: bilinear transformation of a discrete system P to
%       analog domain  
%
%       LMI_OPT: Linear Matrix Inequality Optimization, used in the design
%       of FIR filters F_i(z), as described in Section IV.B. 
%
%       MVL: compute the integral Mij(t) as in equation (51)
