function out = optPriceVal(type, Price, Strike, Rate, Time, Vol, Yield, Strike2, Spread)
% OPTPRICE: Pricing function for basic and composite European options.
%
% OPTPRICE provides the means to calculate the price of certian options for
% which a closed-form solution via the Black-Scholes model is known.  It is
% meant to be called using the GUI in one of the following syntaxes:
%

% Sanitize the inputs
if any(isnan(Price(:))) || ~isnumeric(Price) || isempty(Price) || ~isreal(Price) || any(Price(:) < 0)
    error('optPriceVal:InvalidPrice', ...
        'Spot price must be a positive number')
elseif any(isnan(Strike(:))) || ~isnumeric(Strike) || isempty(Strike) || ~isreal(Strike) || any(Strike(:) < 0)
    error('optPriceVal:InvalidStrike', ...
        'Strike price must be a positive number')
elseif any(isnan(Rate(:))) ||~isnumeric(Rate) || isempty(Rate) || ~isreal(Rate) || any(Rate(:) < 0)
    error('optPriceVal:InvalidRate', ...
        'Risk free rate must be a positive number')
elseif any(isnan(Time(:))) ||~isnumeric(Time) || isempty(Time) || ~isreal(Time) || any(Time(:) < 0)
    error('optPriceVal:InvalidTime', ...
        'Time to expiration must be a positive number')
elseif any(isnan(Vol(:))) ||~isnumeric(Vol) || isempty(Vol) || ~isreal(Vol) || any(Vol(:) < 0)
    error('optPriceVal:InvalidVol', ...
        'Volatility must be a positive number')
elseif any(isnan(Yield(:))) ||~isnumeric(Yield) || isempty(Yield) || ~isreal(Yield) || any(Yield(:) < 0)
    error('optPriceVal:InvalidYield', ...
        'Yield must be a positive number')
end
% Optional sanitation of inputs, depending on the option:
switch type
    case {'Strangle', 'Bull Spread', 'Bear Spread'}
        if isnan(Strike2) || ~isnumeric(Strike2) || isempty(Strike2) || ~isreal(Strike2) || Strike2 < 0
            error('optPriceVal:InvalidStrike', ...
                'Strike price must be a positive number')
        end
    case 'Butterfly'
        if isnan(Spread) || ~isnumeric(Spread) || isempty(Spread) || ~isreal(Spread) || Spread < 0 || Spread > 1
            error('optPriceVal:InvalidSpread', ...
                'Spread must be a positive number between 0 and 1')
        end
end
    
switch type
    case 'Call'
        out = blsprice(Price, Strike, Rate, Time, Vol, Yield);
    case 'Put'
        [dummy, out] = blsprice(Price, Strike, Rate, Time, Vol, Yield);
    case 'Straddle'
        % A Straddle is just a Call and Put option bought at the same
        % strike price and with the same dates involved.
        [Call, Put] = blsprice(Price, Strike, Rate, Time, Vol, Yield);
        out = Call + Put;
    case 'Strangle'
        % A strangle is similar to the straddle, except that there are two
        % strike prices involved: one for the put, and the other for the
        % call.
        Call = blsprice(Price, Strike2, Rate, Time, Vol, Yield);
        [dummy, Put] = blsprice(Price, Strike, Rate, Time, Vol, Yield);
        out = Call + Put;
    case 'Bull Spread'
        % A Bull Spread is formed by buying a call option with a given
        % strike price and then selling another call option with a higher
        % strike price.
        Call1 = blsprice(Price, Strike, Rate, Time, Vol, Yield);
        Call2 = blsprice(Price, Strike2, Rate, Time, Vol, Yield);
        out = Call1 - Call2;
        % Strike2 should be larger than Strike; if not, we'll just
        % tacitly invert them rather than giving an error message.
        if Strike2 < Strike
            out = -out;
        end
    case 'Bear Spread'
        % A Bear Spread is formed by buying a call option with a given
        % strike price and then selling another call option with a lower
        % strike price.
        Call1 = blsprice(Price, Strike, Rate, Time, Vol, Yield);
        Call2 = blsprice(Price, Strike2, Rate, Time, Vol, Yield);
        out = Call2 - Call1;
        % Strike2 should be larger than Strike; if not, we'll just
        % tacitly invert them rather than giving an error message.
        if Strike2 < Strike
            out = -out;
        end
    case 'Butterfly'
        % A Butterfly option involves 4 call options at differing strike
        % prices: 
        % Long 1 call at (1 - Spread)*Strike
        % Short 2 calls at Strike
        % Long 1 call at (1 + Spread)*Strike
        Call1 = blsprice(Price, (1-Spread)*Strike, Rate, Time, Vol, Yield);
        Call2 = blsprice(Price, Strike, Rate, Time, Vol, Yield);
        Call3 = blsprice(Price, (1+Spread)*Strike, Rate, Time, Vol, Yield);
        out = Call1 - 2*Call2 + Call3;
    otherwise
        error('optPriceVal:UnknownOption', ...
        ['Invalid option type.  Valid choices are Call, Put, Straddle, '...
        'Strangle, Bull Spread, Bear Spread, or Butterfly'])
end