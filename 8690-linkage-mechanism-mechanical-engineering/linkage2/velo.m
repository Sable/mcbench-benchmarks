function y = velo(a1,a2,n)
       t = 0:60/(n*360):60/n;
       a1s = csape(t,a1,'periodic');
       a2s = csape(t,a2,'periodic');
%-----------------------------------------------------------------------       
       a1v = fnval(fnder(a1s),t); 
       a2v = fnval(fnder(a2s),t);
%-----------------------------------------------------------------------       
       a1a = fnval(fnder(a1s,2),t);
       a2a = fnval(fnder(a2s,2),t);
%-----------------------------------------------------------------------       
       for i = 1:361
            y(i,1) = sqrt(a1v(i)^2+a2v(i)^2); 
            y(i,2) = atan2(a2v(i),a1v(i))*180/pi; 
            y(i,3) = sqrt(a1a(i)^2+a2a(i)^2);
            y(i,4) = atan2(a2a(i),a1a(i))*180/pi;
            if y(i,2) < 0
                y(i,2) = y(i,2)+360;
            end; 
            if y(i,4) < 0
                y(i,4) = y(i,4)+360;
            end;    
        end;     
        count = 0:1:360;
        y =[count',y];