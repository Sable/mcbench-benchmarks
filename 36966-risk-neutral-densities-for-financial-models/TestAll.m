% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 

% For the models we use closed form solutions if available
% If not available we use a simple fft approach; more sophisticated
% approaches can be found in the files illustrating the COS method which
% is described in chapters 5 and 6 of the book.

% Diffusion Models
Script_Density_Bachelier
Script_Density_Black
Script_Density_HullWhite

% Local Vol
Script_Density_DD
Script_Density_CEV

% Stoch Vol
Script_Density_Heston
Script_Density_SABR

% Stoch Vol Stoch rates
Script_Density_Heston_HullWhite

% Jump Diffusion
Script_Density_Merton

% Stoch Vol with Jumps
Script_Density_Bates

% Levy
Script_Density_VG
Script_Density_NIG
Script_Density_CGMY

% Levy Stoch Vol
Script_Density_VGCIR
Script_Density_VGGOU
Script_Density_NIGCIR
Script_Density_NIGOU
