%---------------------------------------------------------------------------
% Compute and plot the Green's function in a room for a given set of 
% position as a function of the frequency, and at a given frequency as 
% a function of the position r = (x,y,z).
%
% Must be used with the script 'parameter' and 'AxialMode','TangentialMode', 
%'ObliqueMode','GreenFunction1','GreenFunction2' functions.
%---------------------------------------------------------------------------

clear all, clc,
parameter;  % Define parameters

for r = r1; % receiver position
    [GF]  = GreenFunction(r0,r);
    figure(1), 
    plot(fd,20*log10(abs(rho*GF)),'-'),
    title('Green''s function in a room'),
    xlabel('Frequency (Hz)'),
    ylabel('SPL (dB)'),
    hold on,
end

for r = r2; % receiver position
    [GF] = GreenFunction(r0,r);
    figure(1), 
    plot(fd,20*log10(abs(rho*GF)),'r:'),
    legend('close to each other','far from each other'),
    hold off,
    for f0 = f01, 
        [GF2] = GreenFunction2(r0,r,f0);
        figure(2),
        plot(d,20*log10(abs(rho*GF2)),'-'),
        title('Green''s function in a room'),
        xlabel('Distance (m)'),
        ylabel('SPL (dB)'),
        hold on,
    end
    for f0 = f02,
        [GF2] = GreenFunction2(r0,r,f0);
        figure(2),
        plot(d,20*log10(abs(rho*GF2)),'r:'),
        legend(sprintf('%d Hz (close)',f01),sprintf('%d Hz (between)',f02)),
        set(gca,'XTickLabel','')
        hold off,
    end
end