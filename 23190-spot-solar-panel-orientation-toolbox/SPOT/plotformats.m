
function plotformats(Phi,W,L,T,zf,aw)

c=get(gcf,'children');
set(c,'zticklabelmode', 'manual');
set(c,'xticklabel',[' ']);
set(c,'yticklabel',[' ']);
set(c,'zticklabel',[' ']);

if Phi<0
    text(-1.5*W*zf,0,-zf*5.0*T,[' ','North',' '],'fontsize', 15);
    text(1.23*W*zf,0,-zf*5.0*T,[' ','South',' '],'fontsize', 15);
    text(0,-1.3*L,-zf*5.5*T,[' ','West',' '],'fontsize', 15);
    text(0,1.5*L,-zf*5.5*T,[' ','East',' '],'fontsize', 15);
    ns='S';
else
    text(-1.5*W*zf,0,-zf*5.0*T,[' ','South',' '],'fontsize', 15);
    text(1.23*W*zf,0,-zf*5.0*T,[' ','North',' '],'fontsize', 15);
    text(0,-1.28*L,-zf*5.5*T,[' ','East',' '],'fontsize', 15);
    text(0,1.52*L,-zf*5.5*T,[' ','West',' '],'fontsize', 15);
    ns='N';
end;
A=sprintf('%2.0f',abs(str2num(aw(2,:)))); mth=monthdet(aw);
title(['Mid-Day Orientation at Latitude ' num2str(A) '^o' ns ' (' aw(1,1:2) ' ' mth ')'],'fontsize',21)
axis tight

function month=monthdet(aw)

if str2num(aw(1,4:5))==1,
    month='January';
elseif str2num(aw(1,4:5))==2,
    month='February';
elseif str2num(aw(1,4:5))==3,
    month='March';
elseif str2num(aw(1,4:5))==4,
    month='April';
elseif str2num(aw(1,4:5))==5,
    month='May'
elseif str2num(aw(1,4:5))==6,
    month='June';
elseif str2num(aw(1,4:5))==7,
    month='July';
elseif str2num(aw(1,4:5))==8,
    month='August';
elseif str2num(aw(1,4:5))==9,
    month='September';
elseif str2num(aw(1,4:5))==10,
    month='October';
elseif str2num(aw(1,4:5))==11,
    month='November';
elseif str2num(aw(1,4:5))==12,
    month='December';
end
