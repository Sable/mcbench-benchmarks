function [ME]=vpninterp(inp)   
% interpolation
m = 2*size(inp);
    xh = 1:2:m; yh = 1:m; xv = 1:2:m; yv = 1:m;
    for i=1:(m/2)
        meo(i,:) = interp1(xh,inp(i,:),yh,'linear'); meo(i,m)=meo(i,m-1);
    end
    for i=1:m
        ME(:,i) = interp1(xv,meo(:,i),yv,'linear'); ME(m,i) = ME(m-1,i);
    end

    