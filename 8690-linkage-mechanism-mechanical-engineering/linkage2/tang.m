   function y = tang(x,y)
    % to find the exact angle in degrees
           y1 = atan2(y,x);
             if y1 >= 0
               y = y1*180.0/pi;
                 elseif  y1 < 0
                    y = y1*180.0/pi + 360.0;
                end;      