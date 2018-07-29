% example to import TwinCAT Scope View data into MATLAB
% see: rdTCscope.pdf for further information
%

% import data
[A,offset,scale,channels]=rdTCscope('NCiExample');

% plot CH1 vs. time
plot(A(:,1),A(:,2));    % plot CH1 vs. time
hold on;
plot(A(:,3),A(:,4));    % plot CH2 vs. time
plot(A(:,7),A(:,8));    % plot CH4 vs. time

% resample, if necessary
Ap = padTCscope(A,channels);
