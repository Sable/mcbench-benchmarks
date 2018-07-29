%Copyright 2013 The MathWorks, Inc
if ii==1,
    %% Array Response
    figure('WindowStyle','docked');
    polar(deg2rad(scanAz(:)),abs(resp));
    ax = gca;
else
    polar(ax,deg2rad(scanAz(:)),abs(resp));
end