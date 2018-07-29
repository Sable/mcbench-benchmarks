function plotax(pt,R,sz)
R = permute(R,[3 1 2]);
plot3([pt(:,1) pt(:,1)+R(:,1,1)*sz],[pt(:,2) pt(:,2)+R(:,2,1)*sz],[pt(:,3) pt(:,3)+R(:,3,1)*sz],'m','LineWidth',2);
plot3([pt(:,1) pt(:,1)+R(:,1,2)*sz],[pt(:,2) pt(:,2)+R(:,2,2)*sz],[pt(:,3) pt(:,3)+R(:,3,2)*sz],'g','LineWidth',2);
plot3([pt(:,1) pt(:,1)+R(:,1,3)*sz],[pt(:,2) pt(:,2)+R(:,2,3)*sz],[pt(:,3) pt(:,3)+R(:,3,3)*sz],'b','LineWidth',2);


