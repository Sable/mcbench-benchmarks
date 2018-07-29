function thiem_test
% determination of transmissivity  T                    Holzbecher October 2005
% using Thiem's solution
% and fzero for automatic estimation 
global rfit sfit reach Q 

% specify fitting data
rfit = [0.8 30 90 215];                     % observation well distance
sfit = [2.236 1.088 0.716 0.25];            % observated steady state drawdowns
Q = 788;                                    % pumping rate
rwell = 1;                                  % well radius
reach = 500;                                % reach
T = 500;                                    % guess for transmissivity
test = 0;                                   % test run flag  

% -------------------------------------------------------------------------
if test == 1               % input pumptest 'Oude Korendijk' 
    rfit = [0.8 30 90 215]; sfit = [2.236 1.088 0.716 0.25];       
    Q = 788; rwell = 0.5; T = 400; reach = 500;
end
options = optimset('Display','iter','TolFun',1e-8);
T = fzero(@myfun,T,options);
res = sum(Q*log(rfit/reach)/T/2/pi+sfit);
display (['Residual = ' num2str(res)]);
r = linspace (rwell,reach,100);
h = Q*log(r/reach)/T/2/pi;
plot (rfit,-sfit,'o',r,h,'-');
legend ('measured','ideally',4);
xlabel ('r'); ylabel ('h');
title ('Thiem Solution');
text (10*rwell,-0.1*max(sfit),['T = ' num2str(T)]);

function f = myfun(T) 
global rfit sfit reach Q

% calculate Thiem solution
h = Q*log(rfit/reach)/T/2/pi;

% specify function f to vanish
f = (h+sfit)*h'/T;