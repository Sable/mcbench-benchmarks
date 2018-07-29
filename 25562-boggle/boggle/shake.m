function a = shake();
global layout;
rand('twister',sum(100*clock));

a=1;
figure(1);
plot([0 1],[.25 .25],'k',[0 1],[.5 .5],'k',[0 1],[.75 .75],'k',[0 1],[1 1],'k'); hold on;
plot([.25 .25],[0 1],'k',[.5 .5],[0 1],'k',[.75 .75],[0 1],'k',[1 1],[0 1],'k');
axis([0 1 0 1],'equal','square');


Cube(1).letter = {'L','R','Y','T','T','E'};
Cube(2).letter = {'V','T','H','R','W','E'};
Cube(3).letter = {'E','G','H','W','N','E'};
Cube(4).letter = {'S','E','O','T','I','S'};
Cube(5).letter = {'A','N','A','E','E','G'};
Cube(6).letter = {'I','D','S','Y','T','T'};
Cube(7).letter = {'O','A','T','T','O','W'};
Cube(8).letter = {'M','T','O','I','C','U'};
Cube(9).letter = {'A','F','P','K','F','S'};
Cube(10).letter = {'X','L','D','E','R','I'};
Cube(11).letter = {'H','C','P','O','A','S'};
Cube(12).letter = {'E','N','S','I','E','U'};
Cube(13).letter = {'Y','L','D','E','V','R'};
Cube(14).letter = {'Z','N','R','N','H','L'};
Cube(15).letter = {'N','M','I','Qu','H','U'};
Cube(16).letter = {'O','B','B','A','O','J'};

rand(1,16);
[temp,order]=sort(rand(1,16));
Cube=Cube(order);

for i=1:4,
	for j=1:4,
		layout{i,j} = Cube(i+(j-1)*4).letter(ceil(rand*6));
		text(i/4-.15,j/4-.13,layout{i,j},'FontSize',20);
	end;
end;
set(gca,'XTick',[],'YTick',[]);
