%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demonstration packet-based transceiver for Chilipepper
% Toyon Research Corp.
% http://www.toyon.com/chilipepper.php
% Created 10/17/2012
% embedded@toyon.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstration of a Costas Loop. Refer to:
% Telecommunications Breakdown: Concepts of Communication Transmitted via 
% Software-Defined Radio C. Richard Johnson
% We employ a hard-decision feedback in order to get rid of the loop
% filters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function [z_i_out, z_q_out, fe] = qpsk_rx_foc(y_i, y_q, mu_in, finish_rx)

persistent phi

lSin = SIN;
lCos = COS;

if isempty(phi)
    phi = 0;
end

mu = mu_in/2^12;

if finish_rx == 1
    phi = 0;
end

% create the VCO signal
if phi >= 1
    phi = phi - 1;
end
if phi < 0
    phi = phi + 1;
end

phi12 = round(phi*2^12)+1;
if phi12 >= 2^12
    phi12 = 1;
end
if phi12 < 0
    phi12 = 0;
end
f_i = lCos(phi12+1);
f_q = lSin(phi12+1);
ti1 = y_i*f_i;
ti2 = y_q*f_q;
tq1 = y_q*f_i;
tq2 = -y_i*f_q;
z_i = ti1 + ti2;
z_q = tq1 + tq2;

% generate the error term to drive VCO generateion
if z_q < 0
    tf = -z_i;
else
    tf = z_i;
end
if z_i < 0
    bf = -z_q;
else
    bf = z_q;
end
% using sign of error in order to make it gain invariant
time_diff = tf-bf;
if time_diff < 0
    e = -1;
else
    e = 1;
end

c = mu*e;
phiNew = phi - c;
phi = phiNew;

fe = phiNew;

z_i_out = z_i;
z_q_out = z_q;