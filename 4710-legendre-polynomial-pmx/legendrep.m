function p=legendrep(m,x)
%   function which construct Legendre polynomial Pm(x)
%   where M is the degree of polynomial and X is the variable. 
%   Result - P is the char string that should be evaluated EVAL(P)
%   Example:
%   P=legendrep(2,'cos(theta)') will produce
%   P='(3*cos(theta).^2 -1)/2' which then can be evaluated as
%   theta=0.3; P=legendrep(2,'cos(theta)'); Lp=eval(P); produce
%   Lp = 0.8690
%   For Matlab R14 the following example can be used:
%   x=-5:.1:5; p=legendrep(5,'x .*cos(x)'); xp = eval(p); 
%   figure; plot(x, xp, 'r.-'); grid

%% References: 
%   Gradshteyn, Ryzhik "Table of Integrals Series and Products", 6th ed., p.973
%        
%__________________________________________________
% 	Sergei Koptenko, Resonant Medical Inc., Toronto 
%	sergei.koptenko@resonantmedical.com 
%______________March/30/2004_______________________
%%
switch m
case 0
    p='1';     return
case 1
    p=x;     return
case 2
    p=['(3*' x '.^2 -1)/2'];     return
case 3
    p=['(5*' x '.^3 - 3 *' x ')/2'];     return
case 4
    p=['(35 *' x '.^4 - 30 * ' x '.^2 + 3)/8'];     return
case 5
    p=['( 63 * ' x '.^5 - 70 * ' x '.^3 + 15 *' x ' )/8'];     return
case 6
    p=['(231 *' x '.^6 - 315 * ' x '.^4 + 105 * ' x '.^2 -5)/16'];     return
 case 7
   p=['(429 * ' x '.^7 - 693 * ' x '.^5 +315 * ' x '.^3 -35 *' x ' )/16'];     return
case 8
    p=['(6435 *' x '.^8 -12012 *' x '.^6 + 6930 * ' x '.^4 -1260 * ' x '.^2 +35)/128'];     return
case 9
    p=['(12155 * ' x '.^9 -25740 * ' x '.^7 +18018 * ' x '.^5 -4620 * ' x '.^3 +315 *' x ' )/128'];
    return
case 10
       p=['(46189 *' x '.^10 -109395 *' x '.^8 +90090 *' x '.^6 -30030 * ' x '.^4 +3465 * ' x '.^2 -63)/256'];
    return
case 11
   p=['(88179 * ' x '.^11 -230945 * ' x '.^9 +218790 * ' x '.^7 -90090 * ' x '.^5 +15015 * ' x '.^3 -693 *' x ' )/256'];
    return  
case 12
    p=['(676039 *' x '.^12 -1939938 *' x '.^10 +2078505 *' x '.^8 -1021020 *' x '.^6 +225225 * ' x '.^4 -18018 * ' x '.^2 +231)/1024'];
    return
    
otherwise
    iii=m-10;    %shift counter    
   pp=strvcat(legendrep(11,x),legendrep(12,x)); % get last two members
    for ii=3:1:iii,   % Begin construct from 13th member        
        p_ii=[num2str(1/(ii)) ' * (' num2str(2*ii-1) ' * ' x '.*(' ...
        deblank(pp(ii-1,:)) ')-' num2str(ii-1) '.*(' deblank(pp(ii-2,:)) '))'];
        pp=strvcat(pp, p_ii);
    end
p=deblank(pp(iii,:)); % remove traiing blanks
   return
end

return

