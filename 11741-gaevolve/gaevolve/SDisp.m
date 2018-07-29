% Hook function:
function stop = SDisp(sol,fit,pop,fits)

% Display the number of bits:
disp(sprintf('Actual max bits: %d',fit));

% Returning:
stop = fit==32;
