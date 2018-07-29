function [xxx1,xxx2] =dymism(r1,r3,l,r4,r5,choice,rpm,loc)  
%-----------------------------------------------------------
format bank;
% clf;
   t = 0:1:360;
   tg = t*pi/180.0;
    cx =[0,0,l,0];
   r2 = sqrt(l^2 - r3^2 + r1^2);
      jj = 0;
%-----------------------------------------------------------      
        for j = 1:1:361
          jj = jj+1;
          x1 = r1 * cos(tg(j));
          x2 = r1 * sin(tg(j));
          [cx41, cx42, cx43] = x4fun(x1,x2,r3,l);
          [x41,x42] = qfun(cx41,cx42,cx43);
               x31 = x3fun(x1,x2,x41,r3,l);
               x32 = x3fun(x1,x2,x42,r3,l);
          a(jj,1) = jj;
          a(jj,2) = x1;
          a(jj,3) = x2;
          a(jj,4) = x31;
          a(jj,5) = x41;
          a(jj,6) = x32;
          a(jj,7) = x42;
          a(jj,8) = tang(x31-l,x41);
          a(jj,9) = tang(x32-l,x42);
%------------------------------------------------------------------------------------------------------
         if l < r4+r5 & r4*r5 > 0  % new check
          [cx61,cx62,cx63] = x6fun(x1,x2,x31,x41,r1,r4,r5);
               [x61,x62] = qfun(cx61,cx62,cx63);
               x51 = x5fun(x1,x2,x31,x41,x61,r1,r4,r5);
               x52 = x5fun(x1,x2,x31,x41,x62,r1,r4,r5);
          a(jj,10) = x51;
          a(jj,11) = x61;
          a(jj,12) = x52;
          a(jj,13) = x62;
          [ccx61,ccx62,ccx63] = x6fun(x1,x2,x32,x42,r1,r4,r5);
              [xx61,xx62] = qfun(ccx61,ccx62,ccx63);
                    xx51  = x5fun(x1,x2,x32,x42,xx61,r1,r4,r5);
                    xx52  = x5fun(x1,x2,x32,x42,xx62,r1,r4,r5);
           a(jj,14) = xx51;
           a(jj,15) = xx61;
           a(jj,16) = xx52;
           a(jj,17) = xx62;
       end; % new check  
      end;
%-----------------------------------------------------------
if l < r4+r5 & r4*r5 > 0 % new check
  for i1 = 2:1:361
 [a(i1,10),a(i1,11),a(i1,12),a(i1,13)] = organize(a(i1-1,10),a(i1-1,11),a(i1,10),a(i1,11),a(i1,12),a(i1,13));
 [a(i1,14),a(i1,15),a(i1,16),a(i1,17)] = organize(a(i1-1,14),a(i1-1,15),a(i1,14),a(i1,15),a(i1,16),a(i1,17));
end;
end; % new check  
%-----------------------------------------------------------
  if l < r4+r5 & r4*r5 > 0 & choice == 1  
%   xxx = plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,10),a(:,11))
    [xxx1,xxx2] = cvelo(a(:,2),a(:,3),a(:,4),a(:,5),a(:,10),a(:,11),rpm,loc);
  end;
%--------------------------------------------------------------------------------
    if l < r4+r5 & r4*r5 > 0 & choice == 2
%      xxx = plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13));
     [xxx1,xxx2] =  cvelo(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13),rpm,loc)
    end;
%-------------------------------------------------------------------------------
    if l < r4+r5 & r4*r5 > 0 & choice == 3
%       xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15));
     [xxx1,xxx2] =  cvelo(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15),rpm,loc);
    end;
%----------------------------------------------------------------------------------
     if l < r4+r5 & r4*r5 > 0 & choice == 4
%      xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17));
    [xxx1,xxx2] =   cvelo(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17),rpm,loc);  
     end;    
%---------------------------------------------------------------------------
  save  link_age.dat  xxx1 -ascii
    disp('The answers are')
    disp('Given crank location')
    disp('Velocity')
    disp('velocity angle')
    disp('Accelleration')
    disp('Accelleration angle')
    disp('.....')
    disp('For three nodes');
   