function dy = FalknerSkanSys(t, y)
    global ETA_INF;
    global BETA0;
    global BETA;
    dy = [ETA_INF*y(2) ETA_INF*y(3) -ETA_INF*(BETA0*y(1)*y(3) + BETA*(1-y(2)^2))]';
