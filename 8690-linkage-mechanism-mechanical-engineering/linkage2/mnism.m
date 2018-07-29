function xxx = mnism(r1,r3,l,r4,r5)
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
  if l < r4+r5 & r4*r5 > 0 % new check
xxx =  plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),a(:,7),a(:,10),a(:,11),a(:,12),a(:,13),...
    a(:,14),a(:,15),a(:,16),a(:,17))
  note = ' GOOD SELECTION OF LINK LENGTHS'
end; %new check
%--------------------------------------------------------------------------
   if r4*r5 == 0 | l > r4+r5   % new check
xxx =  plot(a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),a(:,7))
    note = ' THE COUPLER TRIANGLE IS NOT COMPATIBLE'  
end
%-------------------------------------------------------------------------------------
  hold on
    plot(cx(1,1),cx(1,2),'+',cx(1,3),cx(1,4),'+')
         [aa1,aa2] = max(a(:,8));
         [aa3,aa4] = min(a(:,8));
         aa2 = aa2-1;
         aa4 = aa4-1;
         ra1 = abs(aa1-aa3);
         ra11 = abs(aa2-aa4);
%------------------------------------------------------------
         [bb1,bb2] = max(a(:,9));
         [bb3,bb4] = min(a(:,9));
         bb2 = bb2-1;
         bb4 = bb4-1;
         rb1 = abs(bb1-bb3);
         rb11 = abs(bb2-bb4);
%--------------------------------------------------------------
axis('equal');
text(a(90,2),a(90,3),'\gamma_{B}')
text(a(90,4),a(90,5),'\gamma_{C1}')
text(a(90,6),a(90,7),'\gamma_{C2}')
%--------------------------------------------------------------
if l < r4+r5 & r4*r5 > 0  % new check
text(a(200,10),a(200,11),'\gamma_{E11}')
text(a(90,12),a(90,13),'\gamma_{E12}')
text(a(90,14),a(90,15),'\gamma_{E21}')
text(a(90,16),a(90,17),'\gamma_{E22}')
end      % new check
%----------------------------------------------------------------
title(['r1 = ',num2str(r1),',','  r2 = ',num2str(r2),',','  r3 = ',num2str(r3),',','  l =',...
        num2str(l),',','  r4 =',num2str(r4),',','  r5 = ',num2str(r5)],'fontsize',12)
print mnism -dps
% open('f4bar.fig')
%--------------------------------------------------------------------------
% angle calculation 
naxa(:,1) = a(:,1); 
    for ix = 1:361;
      naxa(ix,2) = tang(a(ix,4)-l,a(ix,5));
      naxa(ix,3) = tang(a(ix,6)-l,a(ix,7));
    end;
 naxa;
 [l11,l12] = max(naxa(:,2));
 [l21,l22] = min(naxa(:,2));
 [l31,l32] = max(naxa(:,3));
 [l41,l42] = min(naxa(:,3));
 vs1   = l22-1;
 ve1   = l12-1;
 dve1   = ve1-vs1;
 vs2   = l42-1;
 ve2   = l32-1;
 dve2  = ve2-vs2; 
 ylabel(['crank angles(a)-minmax','  (',num2str(vs1),',', num2str(ve1),',',num2str(dve1),...
         ',',num2str(vs2),',',num2str(ve2),',',num2str(dve2),')']) %,'fontsize',12)
 dvve1 = l11-l21;
 dvve2 = l31-l41;
 xlabel(['rocker angles(b)-minmax','(',num2str(l21),',',num2str(l11),',',num2str(dvve1),...
         ',',num2str(l41),',',num2str(l31),',',num2str(dvve2),')'])%  ,'fontsize',12)
labelnote = 'x&y labels give the minmax angles corresponding to the rocker range'
%------------------------------------------------------------------------------------
open('f4bar.fig')
 