function up = predictor(xp,x,u)

up = interp1(x,u,xp,'spline');