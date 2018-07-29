%Voice Based Biometric System
%By Ambavi K. Patel.
function m1 = freq2mel (f1)
  m1 = 2595 * log10(1 + f1./700);       % compute mel value from frequency f

