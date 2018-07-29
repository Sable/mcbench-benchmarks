function [theta]=checkquad(x1,y1,rvec,dim,xlim,ylim)


if dim==1
    if (xlim-x1)>rvec
        thetax=0;
    else
        thetax=acos((xlim-x1)/rvec);
    end
    
    if y1>rvec
        thetay=0;
    else
        thetay=acos((y1)/rvec);
    end
    
    theta=pi/2-thetax-thetay;
end

if dim==2
    if x1>rvec
        thetax=0;
    else
        thetax=acos((x1)/rvec);
    end
    
    if y1>rvec
        thetay=0;
    else
        thetay=acos((y1)/rvec);
    end
    
    theta=pi/2-thetax-thetay;
end

if dim==3
    if x1>rvec
        thetax=0;
    else
        thetax=acos((x1)/rvec);
    end
    
    if (ylim-y1)>rvec
        thetay=0;
    else
        thetay=acos((ylim-y1)/rvec);
    end
    
    theta=pi/2-thetax-thetay;
end

if dim==4
    if (xlim-x1)>rvec
        thetax=0;
    else
        thetax=acos((xlim-x1)/rvec);
    end
    
    if (ylim-y1)>rvec
        thetay=0;
    else
        thetay=acos((ylim-y1)/rvec);
    end
    
    theta=pi/2-thetax-thetay;
end


