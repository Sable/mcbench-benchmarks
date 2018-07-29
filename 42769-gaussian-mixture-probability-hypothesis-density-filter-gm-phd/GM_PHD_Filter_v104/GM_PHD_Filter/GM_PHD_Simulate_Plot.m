%GM_PHD_Simulate_Plot
%Last modified 2nd September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 
%error_ellipse is by AJ Johnson, taken from Matlab Central http://www.mathworks.com.au/matlabcentral/fileexchange/4705-errorellipse

%This file plots the current measurements, true target position and estimated target
%position, as well as a history of estimated target positions.

disp('Plotting...')
%Measurements
figure(1);
if(PLOT_ALL_MEASUREMENTS == false)
    clf;%Only plot the most recent measurement.
end
hold on;

%Plot all measurements, including clutter, as black 'x'
if(~isempty(Z))
    plot(Z(1,:), Z(2,:), 'xk');
end
%Plot noisy measurements of true target position(s), as black 'o'
if(~isempty(zTrue))
    plot(zTrue(1,:), zTrue(2,:), 'ok');
end

%Plot target 1 true position as red dots
plot(simTarget1History(1,:), simTarget1History(2,:), '.-r');
%Plot target 2 true position as blue dots
plot(simTarget2History(1,:), simTarget2History(2,:), '.-b');
%Plot target 3 true position as green dots
if(~isempty(simTarget3History))
    plot(simTarget3History(1,:), simTarget3History(2,:), '.-g');
end
%Plot tracked targets as magenta circles
if(~isempty(X_k_history))
    plot(X_k_history(1,:), X_k_history(2,:), 'om');
end
xlabel('X position');
ylabel('Y position');
title('Simulated targets and measurements');
axis square;

%For extracted targets, plot latest target(s) as cyan triangle, and draw an
%error ellipse to show uncertainty
if(~isempty(X_k))
    plot(X_k(1,:), X_k(2,:), '^c');
    [nRows, nCols] = size(X_k);
    for c = 1:nCols
       thisMu = X_k(1:2, c);
       covRange = calculateDataRange4(c);
       thisCov = X_k_P(:,covRange);
       thisCov = thisCov(1:2, 1:2); %We only care about position
       error_ellipse(thisCov, thisMu);
    end
end

%Individual X and Y components of measurements
figure(2);
subplot(2,1,1);
plot(k, Z(1,:), 'xk');%X coord of clutter measurements
if(~isempty(zTrue))
    plot(k, zTrue(1,:), 'ok');
end
plot(k, zTrue(1,:), 'xk');%X coord of true measurement
if(~isempty(X_k))
    plot(k, X_k(1,:), 'om');
end
subplot(2,1,2);
plot(k, Z(2,:), 'xk');%Y coord of clutter measurements
if(~isempty(zTrue))
    plot(k, zTrue(2,:), 'ok');
end
if(~isempty(X_k))
    plot(k, X_k(2,:), 'om');
end

%A few more plots are possible. You should probably re-enable the
%initialisation for these in GM_PHD_Simulate_Initialise as well.
if 0
    
%Measurements
figure(4);
plot(k, clutter(1,:), 'xk');%X coord of clutter measurements
plot(k, zTrue(1,:), 'xk');%X coord of true measurement

figure(5);
plot(k, clutter(2,:), 'xk');%Y coord of clutter measurements
plot(k, zTrue(2,:), 'xk');%Y coord of true measurement


figure(6);
if(~isempty(thisAugmentedZ))
plot(k, thisAugmentedZ(3,:), '.r');
plot(k, thisAugmentedZ(4,:), '.b');
end
if(~isempty(X_k))
    plot(k, X_k(3,:), '^r');
    plot(k, X_k(4,:), '^b');    
end
if(~isempty(m_birth))
    plot(k, m_birth(3,:), '+r');
    plot(k, m_birth(4,:), '+b');
end
plot(k, simTarget1Vel(1), 'or');
plot(k, simTarget1Vel(2), 'ob');
axis([0 k -20 10]);

figure(7);
if(~isempty(X_k))
    for i = 1:size(X_k,2) %For each target
        P_range = calculateDataRange4(i);
        plot(k, X_k_P(1,P_range(1)), '.r');
        plot(k, X_k_P(2,P_range(2)), '.b');
        plot(k, X_k_P(3,P_range(3)), '.g');
        plot(k, X_k_P(4,P_range(4)), '.k');
    end  
end

end
