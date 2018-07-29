function demo_sigstar


clf

subplot(2,2,1)

H=bar([1.8,2,1.2,1.9,1,2,3]);
set(H,'FaceColor',[0.5,1,0.5])
groups={[4,7],[2,3],[6,5]};
H=sigstar(groups,[0.001,0.05,0.04]);


subplot(2,2,2)
H=bar([10,7,6,5]);
set(gca,'XTickLabel',{'X','a','b','c'})
set(H,'FaceColor',[0.5,1,0.5])
groups={{'X','c'},...
 		{1,'b'},... %note you can mix and match notions
		{'X','a'}};


H=sigstar(groups,[0.0001,0.005,0.04]);
set(H,'Color','b')
%Extend the last arms down:
Y=get(H(1,1),'YData'); Y(4)=7.5; set(H(1,1),'YData',Y);
Y=get(H(2,1),'YData'); Y(4)=6.5; set(H(2,1),'YData',Y);
Y=get(H(3,1),'YData'); Y(4)=5.5; set(H(3,1),'YData',Y);

ylim([0,13])



subplot(2,2,3)
d=randn([20,3]);
d(:,2)=d(:,2)+2;
boxplot(d)
ylim([-3,6])
H=sigstar({[1,2],[2,3]},[]);



subplot(2,2,4)
x=1:12;
y=randn(size(x));
y(5)=y(5)-5;
y(6)=y(6)+5;

plot(x,y,'o-r','MarkerFaceColor',[1,0.5,0.5])

H=sigstar({[5,6]},[0.05]);
xlim([1,12])


%set(gcf,'PaperPosition',[0,0,8,8])
%print -depsc test