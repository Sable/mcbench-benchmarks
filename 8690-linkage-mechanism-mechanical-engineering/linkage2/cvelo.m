  function [ay1,ay2]  = cvelo(a1,a2,a3,a4,a5,a6,n,loc)
          clf;
          format bank;
          y1 = velo(a1,a2,n);
          y2 = velo(a3,a4,n);
          y3 = velo(a5,a6,n);
          y =[ y1,y2(:,2:5),y3(:,2:5)];
          xx = [a1(loc+1),a3(loc+1),a5(loc+1),a1(loc+1)]';
          yy = [a2(loc+1),a4(loc+1),a6(loc+1),a2(loc+1)]';
          xxx = [xx,yy];
%-------------------------------------------------------------------------------------
% Is quiver plot possible?  If so we can add, but not now
   ux(1) = y(loc+1,2)*cos(y(loc+1,3)*pi/180);    uux(1)= y(loc+1,4)*cos(y(loc+1,5)*pi/180);
   uy(1) = y(loc+1,2)*sin(y(loc+1,3)*pi/180);    uuy(1)= y(loc+1,4)*sin(y(loc+1,5)*pi/180);
   ux(2) = y(loc+1,6)*cos(y(loc+1,7)*pi/180);    uux(2)= y(loc+1,8)*cos(y(loc+1,9)*pi/180); 
   uy(2) = y(loc+1,6)*sin(y(loc+1,7)*pi/180);    uuy(2)= y(loc+1,8)*sin(y(loc+1,9)*pi/180); 
   ux(3) = y(loc+1,10)*cos(y(loc+1,11)*pi/180);  uux(3)= y(loc+1,12)*cos(y(loc+1,13)*pi/180);
   uy(3) = y(loc+1,10)*sin(y(loc+1,11)*pi/180);  uuy(3)= y(loc+1,12)*sin(y(loc+1,13)*pi/180);
   u1 = normalize(ux(1),uy(1))';   uuu1 = normalize(uux(1),uuy(1))';
   uu1 = [a1(loc+1),a2(loc+1)];    
   u2 = normalize(ux(2),uy(2))';   uuu2 = normalize(uux(2),uuy(2))';
   uu2 = [a3(loc+1),a4(loc+1)];
   u3 = normalize(ux(3),uy(3))';   uuu3 = normalize(uux(3),uuy(3))';
   uu3 = [a5(loc+1),a6(loc+1)];
%-----------------------------------------------------------------------------------------------
%velocity diagram
         subplot(2,1,1);
         axis('square')
         plot(xxx(:,1),xxx(:,2));
         text(a1(loc+1),a2(loc+1),['(1)',num2str(y(loc+1,2)),'(',num2str(y(loc+1,3)),')']);
         text(a3(loc+1),a4(loc+1),['(2)',num2str(y(loc+1,6)),'(',num2str(y(loc+1,7)),')']);
         text(a5(loc+1),a6(loc+1),['(3)',num2str(y(loc+1,10)),'(',num2str(y(loc+1,11)),')']);
         title('Node, Velocity, Angle at coupler nodes')
%------------------------------------------------------------------------------------------------
   hold on
     quiver(uu1(1),uu1(2),u1(1),u1(2));
     quiver(uu2(1),uu2(2),u2(1),u2(2));
     quiver(uu3(1),uu3(2),u3(1),u3(2));
%------------------------------------------------------------------------------------------------         
% accelleration diagram
         subplot(2,1,2);
         axis('equal')
         plot(xxx(:,1),xxx(:,2));
         text(a1(loc+1),a2(loc+1),['(1)',num2str(y(loc+1,4)),'(',num2str(y(loc+1,5)),')']);
         text(a3(loc+1),a4(loc+1),['(2)',num2str(y(loc+1,8)),'(',num2str(y(loc+1,9)),')']);
         text(a5(loc+1),a6(loc+1),['(3)',num2str(y(loc+1,12)),'(',num2str(y(loc+1,13)),')']);
         title('Node, Accelleration, Angle at coupler nodes')
%------------------------------------------------------------------------------------------------
hold on
   quiver(uu1(1),uu1(2),uuu1(1),uuu1(2));
   quiver(uu2(1),uu2(2),uuu2(1),uuu2(2));
   quiver(uu3(1),uu3(2),uuu3(1),uuu3(2));
%------------------------------------------------------------------------------------------------
     ay2 = y(loc+1,:)';    % final answer    
     ay1 = y;   % newly added