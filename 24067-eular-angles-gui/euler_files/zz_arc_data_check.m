R=2;
h=1;
hpl=plot(0,0,'-k');
hold on;
axis equal;
xlim([-1.2*R 1.2*R]);
ylim([-1.2*R 1.2*R]);
hpt=plot(0,0,'-k');
for al=0:-2*pi/150:-2.01*pi
    an=arc_data(al,R,h,R);
    Ml=an{1};
    Mr=an{2};
    set(hpl,'XData',Ml(1,:),'YData',Ml(2,:));
    set(hpt,'XData',Mr(1,:),'YData',Mr(2,:));
    
    %pause(0.1);
    
    drawnow;
end