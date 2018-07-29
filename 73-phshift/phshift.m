% phshift.m
%
%  This program designs analog all-pass phase shift networks. The optimal parameters are
%  searched using the Nelder-Mead simplex (direct search) method.
%  June, 1992		 Orignial by Michael Spencer
%  November, 2000    Revised to use the fminsearch() function in MATLAB R11 and R12.
%
%  Circuit schematic for analog phase shift network:
% Leg one:
%                                  10K
%                             ___/\  /\  ____
%                Section 1   |     \/  \/    |
%                            |               |
%                      10K   |   | \         |
%               ____/\  /\  _|___|-  \       |
%              |      \/  \/     |     \     |
%              |                 |      \____|______   ...                 ...       Output 1 (I)
%          ____|       C1,1      |      /                      C1,2
%         |    |______| |________|+    /
%         |           | |    |   |   /
%         |                  |   | /
%         |                   \
%         |              R1,1 /                                   R1,2
%         |                  /
%         |                  \
%         |                  |
%         |                __|__
%  Input  |                 ___
% ________|                  _
%         |
% Leg two:|
%         |                        10K
%         |                   ___/\  /\  ____
%         |      Section 1   |     \/  \/    |
%         |                  |               |
%         |            10K   |   | \         |
%         |     ____/\  /\  _|___|-  \       |
%         |    |      \/  \/     |     \     |
%         |    |                 |      \____|______   ...                 ...       Output 2 (Q)
%         |____|       C2,1      |      /                      C2,2
%              |______| |________|+    /
%                     | |    |   |   /
%                            |   | /
%                             \
%                        R2,1 /                                   R2,2
%                            /
%                            \
%                            |
%                          __|__
%                           ___
%                            _



% Norm to used in cost function. Use 2 for least squares, and use ~10 for
% minimax estimate (equal ripple phase error):
pnorm = 2;

if(1)
  phdesired = input('Enter phase lag between outputs (e.g. 90 for Hilbert Transformer): ');
  N = input('Enter number of sections in each phase shifter leg (e.g. 3): ');
  fa = input('Enter start frequency of phase shifter in Hz (e.g. 20): ');
  fb = input('Enter end frequency of phase shifter in Hz (e.g. 2000): ');
else
  phdesired = 90
  N = 5
  fa = 50
  fb = 15000
end

freqopt = logspace(log10(fa),log10(fb),N*40+1);   % generate log spaced freq. vector for optimization

% Guess initial parameters (ad hock). Parameters are the 1/(R*C) values for each phase shift section.
params = 2*pi*[logspace(log10(.75*2*fa),log10(.85*2*fb),N)' logspace(log10(.75*fa),log10(.85*fb),N)'];
params = log10(params);		% convert params to log space so their magnitude differences are smaller

fmin = fa/2;		% frequency range to plot results
fmax = fb*2;
freq = logspace(log10(fmin),log10(fmax),500);   % generate freq. vector for ploting

phase = phfunc(params,freq);		% compute phase of starting params (LxM)

% Open figure window and plot initial phase guess:
figure
phandle = semilogx(freq, phase(2,:)-phase(1,:), 'r-', 'EraseMode','normal');
grid
%axis([freq(1) freq(end) 0 100])
title(sprintf('Phase Difference'))
xlabel('Frequency in Hz')
ylabel('Phase in Deg.')
zoom on
drawnow


donecount = 4;		% number of consecutive times to force fminsearch to terminate normally
count = donecount;
while count
  % ---------------------------------------------------------------------------
  %  Estimate optimal parameters:
  [params, fval, exitflag, result] = fminsearch('phcost', params,...
    optimset('MaxIter',4000, 'MaxFunEvals', 5000, 'TolFun',1e-12, 'TolX',1e-8, 'Display','on'),...
    freqopt, phdesired, pnorm)  % find optimal parameters
  
  %params = abs(params);		% take absolute values in case negs. popped up

  % ---------------------------------------------------------------------------
  %  Update plot with new results:
  phase = phfunc(params,freq);	% compute phase of optimal params (LxM)
  set(phandle, 'XData',freq, 'YData',phase(2,:)-phase(1,:))
  drawnow
  
  if exitflag==1
    count = count - 1;
  else
    count = donecount;
  end
end


%*************************************************************************************
% Display final results:
disp('Analog phase shifter design results:')
disp(' ')
disp(sprintf('Desired phase = %i deg.', phdesired));
disp(sprintf('Number of sections in each leg = %i', N));
disp(sprintf('Starting frequency = %i Hz', fa));
disp(sprintf('Ending frequency = %i Hz', fb));
disp(sprintf('p-norm for optimization: %i', pnorm));

params = sort(params);   % sort so stages are frequency ordered
RC = 1./10.^params;     % convert parameters out of log space and take recipical to get RC values

disp(' ')
disp('The 90 degree frequencies for each section are:')
for l=1:2
  for n=1:N
    disp(sprintf('Leg %i, Phase shifter %i:  f0 = %10.2f Hz', l, n, 1./(2*pi*RC(n,l))));
  end
  disp(' ')
end

disp(' ')
disp('The R*C values are:')
for l=1:2
  for n=1:N
    disp(sprintf('Leg %i, Phase shifter %i:  R%i,%i*C%i,%i = %7.4e', l, n, l, n, l, n, RC(n,l)));
  end
  disp(' ')
end

disp(' ')
disp('Assuming each phase shifter uses a 1000 pF capacitor, the resistances are:')
for l=1:2
  for n=1:N
    disp(sprintf('Leg %i, Phase shifter %i:  R%i,%i = %7.4e', l, n, l, n, RC(n,l)./1000e-12));
  end
  disp(' ')
end

% Plot total phase for each leg:
figure
semilogx(freq,phase(1,:),'b-', freq,phase(2,:),'r-')
title(sprintf('Total Phase for each Output (Leg 1 - blue, Leg 2 - red)'))
xlabel('Frequency in Hz')
ylabel('Phase in Deg.')
grid

