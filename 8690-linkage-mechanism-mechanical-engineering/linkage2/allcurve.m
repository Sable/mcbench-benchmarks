function xxx1 =allcurve(r1,r3,l,r4,r5,choice,nodes,nn)  
%-----------------------------------------------------------
%format bank;
 clf;
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
   lxx = [0,a(90,2),a(90,4),l,0]'; lyy = [0,a(90,3),a(90,5),0,0]';
    plot(lxx,lyy); hold on;
   llx =[a(90,2),a(90,10),a(90,4)]'; lly =[a(90,3),a(90,11),a(90,5)]';
   plot(llx,lly);
    xxx1 = acurve(a(:,2),a(:,3),a(:,4),a(:,5),a(:,10),a(:,11),nodes,nn);
    for pi = 1:nn
       plot(xxx1(:,2*pi-1),xxx1(:,2*pi));
       text(xxx1(90,2*pi-1),xxx1(90,2*pi),int2str(pi));
%       hold on;
    end; 
    plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,10),a(:,11));
  end;
%--------------------------------------------------------------------------------
    if l < r4+r5 & r4*r5 > 0 & choice == 2
%      xxx = plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13));
    lxx = [0,a(90,2),a(90,4),l,0]'; lyy = [0,a(90,3),a(90,5),0,0]';
      plot(lxx,lyy); hold on;
      llx = [a(90,2),a(90,12),a(90,4)]'; lly = [a(90,3),a(90,13),a(90,5)]';
      plot(llx,lly);
     xxx1 =  acurve(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13),nodes,nn);
     for pi = 1:nn
       plot(xxx1(:,2*pi-1),xxx1(:,2*pi));
       text(xxx1(90,2*pi-1),xxx1(90,2*pi),int2str(pi));
%       hold on;
    end;
    plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13));
    end;
%-------------------------------------------------------------------------------
    if l < r4+r5 & r4*r5 > 0 & choice == 3
%       xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15));
      lxx = [0,a(90,2),a(90,6),l,0]'; lyy = [0,a(90,3),a(90,7),0,0]';
      plot(lxx,lyy); hold on;
      llx = [a(90,2),a(90,14),a(90,6)]'; lly = [a(90,3),a(90,15),a(90,7)]';
      plot(llx,lly);
     xxx1 =  acurve(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15),nodes,nn);
     for pi = 1:nn
       plot(xxx1(:,2*pi-1),xxx1(:,2*pi));
       text(xxx1(90,2*pi-1),xxx1(90,2*pi),int2str(pi));
       %       hold on;
    end;
    plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15));
    end;
%----------------------------------------------------------------------------------
     if l < r4+r5 & r4*r5 > 0 & choice == 4
%      xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17));
     lxx = [0,a(90,2),a(90,6),l,0]'; lyy = [0,a(90,3),a(90,7),0,0]';
     plot(lxx,lyy); hold on;
     llx = [a(90,2),a(90,16),a(90,6)]'; lly = [a(90,3),a(90,17),a(90,7)]';
     plot(llx,lly);
    xxx1 =   acurve(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17),nodes,nn);
    for pi = 1:nn
       plot(xxx1(:,2*pi-1),xxx1(:,2*pi));
       text(xxx1(90,2*pi-1),xxx1(90,2*pi),int2str(pi));
%       hold on;
    end;
    plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17));
     end;  
%---------------------------------------------------------------------------
   