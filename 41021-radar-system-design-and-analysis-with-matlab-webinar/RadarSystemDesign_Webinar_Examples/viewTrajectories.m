%Copyright 2013 The MathWorks, Inc
if ii==1,
    %% Global Coordinate System
    figure('WindowStyle','docked');
    hold on; grid on
    antT = nan(3,N);      % Array trajectory
    tgtT = nan(3,N);      % Target trajectory
    antT = [antT(:,2:end) antpos/1e3];
    tgtT = [tgtT(:,2:end) tgtpos/1e3];
    hant = plot3(antT(1,:),antT(2,:),antT(3,:),'LineWidth',2);
    htgt = plot3(tgtT(1,:),tgtT(2,:),tgtT(3,:),'LineWidth',2,'Color','red');
    axis([-100 100 -100 50 0 50])
    xlabel('X'), ylabel('Y'), zlabel('Z')
    title('Global Coordinate System','FontWeight','bold')
    view(40,48)
    legend('Antenna','Target')
    %% Target Trajectory in Local Coordinate System (from antenna perspective)
    h2 = figure('WindowStyle','docked');
    hold on; grid on
    axis([-130 0 6 13 0 50])
    xlabel('Azimuth'), ylabel('Range'), zlabel('Elevation')
    title('Local Coordinate System','FontWeight','bold')
    view(-40,48)
    %% Array visualization
    figure('WindowStyle','docked');
    viewArray(sAnt,'ShowSubarray','None')
    bx = get(gca,'Children');
    hdots = bx(8); 
    ndots = numel(get(hdots,'XData'));
    green = ones(ndots,1)*[0 1 0];
    view(40,48)
else
    %% Highlight active arrays
    mn=face(:)*ones(1,ndots);
    hlgt=repmat([mn(1,1:16) mn(2,17:32) mn(3,33:48) mn(4,49:64)],3,1);
    set(hdots,'CData',green.*hlgt');
    %% Update global trajectories
    antT = [antT(:,2:end) antpos/1e3];
    tgtT = [tgtT(:,2:end) tgtpos/1e3];
    set(hant,'XData',antT(1,:),'YData',antT(2,:),'ZData',antT(3,:))
    set(htgt,'XData',tgtT(1,:),'YData',tgtT(2,:),'ZData',tgtT(3,:))
end
%% Update local trajectory
figure(h2)
plot3(AzEl(1),range/1e4,AzEl(2),'ro','MarkerSize',20-round(range/1e4))

