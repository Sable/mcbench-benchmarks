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

function y = sabrtmax(asabr,b,r,nsabr,f,fbar,eps)
% calclates the maximum time for the sabr approximation formula
% to be valid (see Risk paper by Doust)

    a = asabr / eps;
    n = nsabr / eps;
    
    zF = f^(1-b)/asabr/(1-b);
    zFbar = fbar.^(1-b)/asabr/(1-b);
    
    fav = sqrt(f*fbar);
    gamma1 = b./fav;
    gamma2 = b*(b-1)./fav.^2;
    
    kH = 0.125 * (2*gamma2-gamma1.^2)*a^2.*fav.^(2*b) ...
        + 0.75 * r*n*a*gamma1.*fav.^b ...
        + 0.125*(2-3*r^2)*n^2;
    
    z = zF - zFbar;
    integral = (f^(1-b)-fbar.^(1-b)) / (1-b);
    
    xz = 1/nsabr *log((sqrt(1-2*nsabr*r*z+nsabr^2*z.^2)-r+nsabr*z)/(1-r));
    if f==fbar
       y = 12 ./(eps^2*8 * kH); 
    else
       y = 12 ./(eps^2*(8 * kH + a^2*(log(f./fbar)./integral .* (z./xz)).^2)); 
    end
end