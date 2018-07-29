%%  A study of volume flow rate in a pipe as a function of radius
%
%% 
% The volume flow rate of a fluid flowing in a round pipe of radius $r0$ is
%
% $$Q = \int_{0}^{r0} v(r) \, 2 \pi \, r \, dr$$
%
% $v(r)$ = velocity

%% 
% Plot volume flow rate as a function of radius.

%% 
clear
clc
close all

r0 = linspace(0.0001,6,5);
for i = 1:length(r0)
    Q(i) = Volume_Flow(r0(i));
end
%% Plot
plot(r0,Q,'linewidth',2)
xlabel('Radius (cm)'), ylabel('Volume Flow Rate (cm^3/s)')
title('Volume Flow Rate in a Circular Pipe')
