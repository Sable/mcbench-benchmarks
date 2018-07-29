function beta = betafinder(AC,betain,payloadin,fuelin,fueltime)
% direct - AUW
% fuel and payload
% fuel time and payload (not supported)

if nargin < 5; fueltime = NaN;end
if nargin < 4; fuelin = []; end
if nargin < 3; payloadin = [];end


if ~isnan(betain) && isnan(payloadin) && isnan(fuelin) && isnan(fueltime); %if there's a value in the AUW column
    %direct beta
    beta = betain;
elseif isnan(betain) && ~isnan(payloadin) && ~isnan(fuelin) && isnan(fueltime);
    % %fuel + %payload
    W0 = AC.W;
    W = W0;
    Wemp = W0.AUM - W.fuelfrac*W.AUM - AC.Vars.Wpayload*1000;
    Wfuel = W.fuelfrac*W.AUM*fuelin;
    Wpay = AC.Vars.Wpayload*1000*payloadin;
    W = Wemp + Wfuel + Wpay;
    beta = W./W0.AUM;
elseif isnan(betain) && ~isnan(payloadin) && isnan(fuelin) && ~isnan(fueltime);
    % fuel time + %payload
    disp('BETAFINDER does not support a fuel time condition at this time. Use fuel load')
else
    disp('Invalid weight fraction definition. Beta is defined by single value -or- fuel load and payload load')
end    

end