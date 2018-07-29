function h=BreakXAxis(x,y,start,stop,width);

% Julie Haas, after Michael Robbins
% - assumes dx is same for all data
% - 'width' must be a whole number
% - to change axis, use {a=axis} to get axis, and reset in those units

%test data:  
% x=[1:.5:40]; y=rand(size(x)); start=10;stop=20;width=6; 
% x=.01:.01:10;y=sin(6*x);start=2;stop=3;width=1;

% erase unused data
y(x>start & x<stop)=[];
x(x>start & x<stop)=[];

% map to new xaxis, leaving a space 'width' wide
x2=x;
x2(x2>=stop)=x2(x2>=stop)-(stop-start-width);

h=plot(x2,y,'.');

ytick=get(gca,'YTick');
t1=text(start+width/2,ytick(1),'//','fontsize',15);
t2=text(start+width/2,ytick(max(length(ytick))),'//','fontsize',15);
% For y-axis breaks, use set(t1,'rotation',270);

% remap tick marks, and 'erase' them in the gap
xtick=get(gca,'XTick');
dtick=xtick(2)-xtick(1);
gap=floor(width/dtick);
last=max(xtick(xtick<=start));          % last tick mark in LH dataset
next=min(xtick(xtick>=(last+dtick*(1+gap))));   % first tick mark within RH dataset
offset=size(x2(x2>last&x2<next),2)*(x(2)-x(1));

for i=1:sum(xtick>(last+gap))
    xtick(find(xtick==last)+i+gap)=stop+offset+dtick*(i-1);
end
    
for i=1:length(xtick)
    if xtick(i)>last&xtick(i)<next
        xticklabel{i}=sprintf('%d',[]);
    else
        xticklabel{i}=sprintf('%d',xtick(i));
    end
end;
set(gca,'xticklabel',xticklabel);

