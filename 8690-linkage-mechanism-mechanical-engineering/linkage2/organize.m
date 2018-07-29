    function [y1,y2,y3,y4] = organize(x1,x2,x3,x4,x5,x6)
                     dis1 = (x1-x3)^2+(x2-x4)^2;
                     dis2 = (x1-x5)^2+(x2-x6)^2;
                       if dis1 <= dis2
                          y1 = x3;
                          y2 = x4;
                          y3 = x5;
                          y4 = x6;
                      else
                          y1 = x5;
                          y2 = x6;
                          y3 = x3;
                          y4 = x4;
                      end;   