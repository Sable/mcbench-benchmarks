
%************************************************************************%
%                   BS price of a vanilla binary put                     %
%************************************************************************%

function output=BSBinaryPutByLogPrice(LogCurrentPrice,LogStrike,tau,drift,variance,r)
    output=exp(-r*tau)*normcdf((LogStrike-LogCurrentPrice-drift*tau)/(sqrt(variance*tau)));
