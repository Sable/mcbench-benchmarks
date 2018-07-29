function showSolutionDemod(par, sampleRate, iq)


symbols = computeSymbolsFromParams(par, sampleRate, iq);
%%
plot(symbols, 'b.', 'MarkerSize', 16);
title('Separated symbols')
xlabel('In-Phase')
ylabel('Quadrature')