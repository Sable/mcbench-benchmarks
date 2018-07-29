function  Output = FactorGamma(A,B,C)

% (gamma(A/2)/gamma(B/2))^C


if iseven(A) && iseven(B)
  %  disp('Both even')
    Res = 0;
    for i = [B/2:1:(A/2-1)]
    Res = Res + log(i);
    end
elseif isodd(A) && isodd(B)
    % disp('Both odd')
    Res = (B-A)/2 * log(2);
    for i = [B:2:A-2]
        Res = Res + log(i);
    end
elseif isodd(A) && iseven(B)
%    disp('A odd, B even')
    Res = log(sqrt(pi)) - (A-1)/2*log(2);
    for i = [1:2:A-2]
        Res = Res + log(i);
    end
    for i = [1:1:(B/2 - 1)]
        Res = Res - log(i);
    end
elseif iseven(A) && isodd(B)
   % disp('A even, B odd')
    Res = (B-1)/2*log(2) - log(sqrt(pi));
    for i = [1:1:(A/2 - 1)]
        Res = Res + log(i);
    end
    for i = [1:2:B-2]
        Res = Res - log(i);
    end
end

LogGamma = Res;

LogOutput = C*LogGamma;

Output = exp(LogOutput);

return
%-------------------------------------------------------------
function Output = isodd(Input)
      Output  =  mod(Input,2);
return

function Output = iseven(Input)
      Output  =  mod(Input+1,2);
return
