function xxx =animism(r1,r3,l,r4,r5,choice,frame)   %,choice,frame)
% example xxx = animism(3,5,6,7,8,1,10)
% It gives displacement diagram of the 4bar mechanism
% r1 - crank length(AB)
% r2 - coupler length(will be calculated)(BC)
% r3 - rocker length(CD)
% l  - ground length(DA)
% r4 - coupler triangle lhs length(BE)
% r5 - coupler triangle rhs length(EC)
% B - traces  circle
% C - traces two circular sectors(Two rocker positions)
% E - traces four curves(two rocker position and two coupler position)
% mnism - abbreviation for mechanism
% It creats mnism.ps of the graph too
% keywords - algebraic geometry, groebner basis, algebraic variety
% choice - one of the four configurations,must be one of 1,2,3,4
% frame - number of cycles- can be any positive integer
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
%  xxx =  plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),a(:,7),a(:,10),a(:,11),a(:,12),a(:,13),...
%    a(:,14),a(:,15),a(:,16),a(:,17))
   xxx = plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,10),a(:,11))
   axis('equal');
%    end; %new check
%--------------------------------------------------------------------------
hold on
%  to introduce animation -------------------------------------------------
crx = [ 0;a(61,2)];  cry = [0;a(61,3)];
cox = [a(61,2);a(61,4)]; coy = [a(61,3);a(61,5)];
rox = [a(61,4);l]; roy = [a(61,5);0];
grx = [0;l]; gry = [0;0]; 
tlx = [a(61,2);a(61,10)]; tly = [a(61,3);a(61,11)];
trx = [a(61,10);a(61,4)]; tryy = [a(61,11);a(61,5)];
link1 = line(crx,cry,'erase','xor');
link2 = line(cox,coy,'erase','xor');
link3 = line(rox,roy,'erase','xor');
link4 = line(grx,gry);
link5 = line(tlx,tly,'erase','xor');
link6 = line(trx,tryy,'erase','xor');
 pause(3);
 print oo1 -dps;
  for repeat = 1:frame
   for ni = 1:361
     crx(2) = a(ni,2); cry(2) = a(ni,3);
     cox = [a(ni,2);a(ni,4)]; coy = [a(ni,3);a(ni,5)];
     rox = [a(ni,4);l]; roy = [a(ni,5);0];
     grx(2) = l;
     tlx = [a(ni,2);a(ni,10)]; tly = [a(ni,3);a(ni,11)];
     trx = [a(ni,10);a(ni,4)]; tryy = [a(ni,11);a(ni,5)];
     set(link1,'xdata',crx,'ydata',cry);
     set(link2,'xdata',cox,'ydata',coy);
     set(link3,'xdata',rox,'ydata',roy);
%     set(link4,'xdata',grx,'ydata',gry);
     set(link5,'xdata',tlx,'ydata',tly);
     set(link6,'xdata',trx,'ydata',tryy);
     drawnow;
  end; end; end;  
    if l < r4+r5 & r4*r5 > 0 & choice == 2
      xxx = plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,12),a(:,13));
      axis('equal');
      hold on
      crx = [0;a(61,2)]; cry = [0;a(61,3)];
      cox = [a(61,2);a(61,4)]; coy = [a(61,3);a(61,5)];
      rox = [a(61,4);l]; roy = [a(61,5);0];
      grx = [0,l]; gry = [0,0];
      tlx = [a(61,2);a(61,12)]; tly = [a(61,3);a(61,13)];
      trx = [a(61,12);a(61,4)]; tryy = [a(61,13);a(61,5)];
      link1 = line(crx,cry,'erase','xor');
      link2 = line(cox,coy,'erase','xor');
      link3 = line(rox,roy,'erase','xor');
      link4 = line(grx,gry);
      link5 = line(tlx,tly,'erase','xor');
      link6 = line(trx,tryy,'erase','xor');
      pause(3);
      print oo2 -dps;
     for repeat = 1:frame
      for ni = 1:361
       crx(2) = a(ni,2); cry(2)=a(ni,3);
       cox = [a(ni,2);a(ni,4)]; coy = [a(ni,3);a(ni,5)];
       rox = [a(ni,4);l]; roy = [a(ni,5);0];
       grx(2) = l;
       tlx = [a(ni,2);a(ni,12)]; tly = [a(ni,3);a(ni,13)];
       trx = [a(ni,12);a(ni,4)]; tryy = [a(ni,13);a(ni,5)];
       set(link1,'xdata',crx,'ydata',cry);
       set(link2,'xdata',cox,'ydata',coy);
       set(link3,'xdata',rox,'ydata',roy);
       set(link5,'xdata',tlx,'ydata',tly);
       set(link6,'xdata',trx,'ydata',tryy);
       drawnow;
   end; end; end;
    if l < r4+r5 & r4*r5 > 0 & choice == 3
       xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,14),a(:,15));
       axis('equal')
       hold on; 
       crx = [0;a(61,2)]; cry = [0;a(61,3)];
       cox = [a(61,2);a(61,6)]; coy = [a(61,3);a(61,7)];
       rox = [a(61,6);l]; roy = [a(61,7);0];
       grx = [0;l]; gry = [0,0];
       tlx = [a(61,2);a(61,14)]; tly = [a(61,3);a(61,15)];
       trx = [a(61,14);a(61,6)]; tryy = [a(61,15);a(61,7)];
       link1 = line(crx,cry,'erase','xor');
      link2 = line(cox,coy,'erase','xor');
      link3 = line(rox,roy,'erase','xor');
      link4 = line(grx,gry);
      link5 = line(tlx,tly,'erase','xor');
      link6 = line(trx,tryy,'erase','xor');
      pause(3);
      print oo3 -dps;
         for repeat = 1:frame
           for ni = 1:361
            crx(2)= a(ni,2); cry(2) = a(ni,3);
            cox = [a(ni,2);a(ni,6)]; coy = [a(ni,3);a(ni,7)];
            rox = [a(ni,6);l]; roy = [a(ni,7);0];
            tlx = [a(ni,2);a(ni,14)]; tly = [a(ni,3);a(ni,15)];
            trx = [a(ni,14);a(ni,6)]; tryy = [a(ni,15);a(ni,7)];
       set(link1,'xdata',crx,'ydata',cry);
       set(link2,'xdata',cox,'ydata',coy);
       set(link3,'xdata',rox,'ydata',roy);
       set(link5,'xdata',tlx,'ydata',tly);
       set(link6,'xdata',trx,'ydata',tryy);
       drawnow;
   end; end; end;
     if l < r4+r5 & r4*r5 > 0 & choice == 4
      xxx = plot(a(:,2),a(:,3),a(:,6),a(:,7),a(:,16),a(:,17));
      axis('equal');
      hold on; 
      crx = [0;a(61,2)]; cry = [0;a(61,3)];
      cox = [a(61,2);a(61,6)]; coy = [a(61,3);a(61,7)];
      rox = [a(61,6);l]; roy = [a(61,7);0];
      grx = [0;l]; gry = [0;0];
      tlx = [a(61,2);a(61,16)]; tly = [a(61,3);a(61,17)];
      trx = [a(61,16);a(61,6)]; tryy = [a(61,17);a(61,7)];
      link1 = line(crx,cry,'erase','xor');
      link2 = line(cox,coy,'erase','xor');
      link3 = line(rox,roy,'erasemode','xor');
      link4 = line(grx,gry);
      link5 = line(tlx,tly,'erase','xor');
      link6 = line(trx,tryy,'erase','xor');
      pause(3);
        print oo4 -dps;
         for repeat = 1:frame
           for ni = 1:361
             crx(2)=a(ni,2); cry(2) = a(ni,3);
             cox = [a(ni,2);a(ni,6)]; coy = [a(ni,3);a(ni,7)];
             rox = [a(ni,6);l]; roy = [a(ni,7);0];
             tlx = [a(ni,2);a(ni,16)]; tly = [a(ni,3);a(ni,17)];
             trx = [a(ni,16);a(ni,6)]; tryy = [a(ni,17);a(ni,7)];
         set(link1,'xdata',crx,'ydata',cry);
       set(link2,'xdata',cox,'ydata',coy);
       set(link3,'xdata',rox,'ydata',roy);
       set(link5,'xdata',tlx,'ydata',tly);
       set(link6,'xdata',trx,'ydata',tryy);
       drawnow;
   end; end; end;    
%---------------------------------------------------------------------------
   if r4*r5 == 0 | l > r4+r5   % new check
xxx =  plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),a(:,7));
  axis('equal');
    note = ' THE COUPLER TRIANGLE IS NOT COMPATIBLE'  
end
%-------------------------------------------------------------------------------------
% hold on
%    plot(cx(1,1),cx(1,2),'+',cx(1,3),cx(1,4),'+')
%----------------------------------------------------------------
%title(['r1 = ',num2str(r1),',','  r2 = ',num2str(r2),',','  r3 = ',num2str(r3),',','  l =',...
%        num2str(l),',','  r4 =',num2str(r4),',','  r5 = ',num2str(r5)],'fontsize',12)
hold off;
  if choice > 4
   note = ' The 6th argument must be one of {1,2,3,4}'
end; 
    print oo5 -dps;