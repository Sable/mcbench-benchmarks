function filename = webvizroutine(SpotPrice, StrikePrice, RiskFreeRate,TimeExpiry, Volatility,VizRange,optionType,ButterflyRange)

%VIZROUTINE Visualize the value of the option over a range of inputs

%Create the figure window within which the value surface of the option will
%be plotted

filename = 'D:\Applications\tomcat\Tomcat 5.5\webapps\BlackScholes\images\vizoption';

OptionType = lower(optionType);

%Convert months to expiry to years to expiry

TimeExpiry = TimeExpiry / 12;
         
OutHandle = figure('Numbertitle', 'off', 'visible','off',...
                   'Menubar', 'none', 'Name', 'Option Pricing Tool', ...
                   'Tag', 'OutputFigure','PaperPositionMode','auto');
          
%           %Add a button to the figure window to turn ROTATE3D on
%           PosVec = get(gcf, 'Position');
%           uicontrol('Style', 'checkbox', ...
%                'Position', [PosVec(3)-105 20 90 25], ...
%                'String', 'Rotate 3D', ...
%                'FontSize', 10, ...
%                'FontWeight', 'bold', ...
%                'Tag', 'ButtonRotate3D', ...
%                'Callback', 'rotate3d');
%           
%           %Normalize the units of all the controls
%           AllUICtrlHandles = findobj(gcf, 'Type', 'uicontrol');
%           set(AllUICtrlHandles, 'Units', 'normal');


if (strcmpi(OptionType,'call') == 1) %Call option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Call the BLSPRICE function to value the call option
     
     CallValue = blsprice(SpotMat, StrikePrice, RiskFreeRate, TimeMat,...
          Volatility);
          
     %Plot the resulting value surface
     %figure(OutHandle);
     
     surf(SpotMat, TimeMat, CallValue);
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Call Option');
     print(OutHandle,'-djpeg',filename);
     close all;
     
elseif (strcmpi(OptionType,'put') == 1) %Put option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Price the option over the ranges
     [Temp, PutValue] = blsprice(SpotMat, StrikePrice, ...
          RiskFreeRate, TimeMat, Volatility);
     
     %Plot the resulting value surface
     %figure(OutHandle);
     surf(SpotMat, TimeMat, PutValue);
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Put Option');
     print(OutHandle,'-djpeg',filename);
     close all;
          
elseif (strcmpi(OptionType,'straddle') == 1) %Straddle option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Price the option over the ranges
     StraddleValue = blsstrval(SpotMat, StrikePrice, ...
          RiskFreeRate, TimeMat, Volatility);
     
     %Plot the resulting value surface
     %figure(OutHandle);
     surf(SpotMat, TimeMat, StraddleValue);
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Straddle Option')
     print(OutHandle,'-djpeg',filename);
     close all;
     
elseif (strcmpi(OptionType,'butterfly') == 1) %Butterfly option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     
     %Price the option over the ranges
     ButterflyValue = blsbtyval(SpotMat, StrikePrice, RiskFreeRate, ...
          TimeMat, Volatility, ButterflyRange);
     
     %Plot the resulting value surface
     %figure(OutHandle);
     surf(SpotMat, TimeMat, ButterflyValue);
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Butterfly Option');
     print(OutHandle,'-djpeg',filename);
     close all;
          
end

%-----------------------------------------------------------------------------

function [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange)

%CALCRANGE Compute spot price and time to expiry range based on visualization
%range

%Compute a step for the spot price range which scales based on the magnitude
%of the spot price and the visualization range
SpotStep = (SpotPrice - SpotPrice * (1 - VizRange / 2)) / 10;

%Compute the range of spot prices based on the visualization range
SpotRange = SpotPrice * (1 - VizRange / 2) : ...
     SpotStep : SpotPrice * ((1 + VizRange / 2));

%Compute a step for the time to expiry range which scales based on the
%magnitude of the time to expiry and the visualization range
TimeStep = (TimeExpiry / 12) / 30;

%Compute the range of times to expiry
TimeRange = 0 : TimeStep : TimeExpiry / 12;

%Generate matrix spot prices and times to expiry based on the size of the
%spot price and time to expiry ranges
[SpotMat, TimeMat] = meshgrid(SpotRange, TimeRange);

%end of CALCRANGE subroutine

%-----------------------------------------------------------------------------
function StraddleValue = blsstrval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility)
%BLSSTRVAL Black Scholes value of a straddle option

%Calculate the value of both the call and put option
[CallValue, PutValue] = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Compute the value of the straddle
StraddleValue = CallValue + PutValue;

%end of BLSSTRVAL subroutine

%-----------------------------------------------------------------------------
function ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange)
%BLSBTYVAL Black Scholes value of a butterfly option

%Set the different strike prices
LowStrike = StrikePrice .* (1 - ButterflyRange);
HighStrike = StrikePrice .* (1 + ButterflyRange);

%Value the long positions in the low and high struck calls
LowValue = blsprice(SpotPrice, LowStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);
HighValue = blsprice(SpotPrice, HighStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Value the short position in the calls struck at the initial strike
%price
ShortValue = 2 .* -(blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility));

%Calculate the total value of the butterfly
ButterflyValue = LowValue + HighValue + ShortValue;

%end of BLSBTYVAL subroutine
