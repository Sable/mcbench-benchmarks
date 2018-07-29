% Chapter 5 - Fractals and Multifractals.
% Program_5d - The tau curve.
% Copyright Birkhauser 2013. Stephen Lynch.

% Plot a tau curve for a multifractal Cantor set (Figure 5.16a).
ezplot('(log((1/9)^x+(8/9)^x))/(log(3))',[-20,20])
axis([-20 20 -8 20])
fsize=15;
set(gca,'XTick',-20:10:20,'FontSize',fsize)
set(gca,'YTick',-8:4:20,'FontSize',fsize)
xlabel('\itq','FontSize',fsize)
ylabel('\it{\tau(q)}','FontSize',fsize)
title(' ')

% End of Program_5d.


