function [yd2] = cm22yd2(cm2)
% Convert area from square centimeters to square yards.
% I really would've preferred to use sqcm and sqyd to represent square
% centimeters and square yards, etc.  But these conversion functions
% warrant consistency.  And I cleverly thought ahead and realized that
% following the formula above, cubic meters would've presented a PR problem. 
% Chad A. Greene 2012
yd2 = cm2*0.0001195990046301;