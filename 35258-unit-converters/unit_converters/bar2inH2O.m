function [inH2O] = bar2inH2O(bar)
% Convert pressure from bar to inches of water at 4 degrees C.
% Chad Greene 2012
inH2O = bar*401.463;