% HOW FAST IS YOUR GRAPHICS CARD?
% Michael Kleder, June 2005
function howfast
close all
A=rand(800,3)*2-1;
n=sqrt(sum(A.^2,2));
A=A./repmat(n,[1 size(A,2)]);
b=ones(800,1);
V=con2vert(A,b);
k=convhulln(V);
ss='How fast is your graphics card?';
ff=figure('name',ss);
hold on
for i=1:length(k)
    patch(V(k(i,:),1),V(k(i,:),2),V(k(i,:),3),...
        'w','edgecolor','none')
end
axis equal
axis vis3d
axis off
h=camlight(0,90);
h(2)=camlight(0,-17);
h(3)=camlight(107,-17);
h(4)=camlight(214,-17);
set(h(1),'color',[1 0 0]);
set(h(2),'color',[0 1 0]);
set(h(3),'color',[0 0 1]);
set(h(4),'color',[1 1 0]);
material metal
tic
for x=0:-5:-3600
    if ~ishandle(ff)
        break
    end
    view(x,0)
    set(ff,'name',[ss ' (Answer: ' num2str(abs(x/toc/6),3) ...
        ' rotations per minute)'])
    drawnow
end
function [V,nr] = con2vert(A,b)
c = A\b;
if ~all(A*c < b);
    [c,f,ef] = fminsearch(@obj,c,'params',{A,b});
end
b = b - A*c;
D = A ./ repmat(b,[1 size(A,2)]);
[k,v2] = convhulln([D;zeros(1,size(D,2))]);
[k,v1] = convhulln(D);
nr = unique(k(:));
G  = zeros(size(k,1),size(D,2));
for ix = 1:size(k,1)
    F = D(k(ix,:),:);
    G(ix,:)=F\ones(size(F,1),1);
end
V = G + repmat(c',[size(G,1),1]);
[null,I]=unique(num2str(V,12),'rows');
V=V(I,:);
return
function d = obj(c,params)
A=params{1};
b=params{2};
d = A*c-b;
k=(d>=-1e-15);
d(k)=d(k)+1;
d = max([0;d]);
return



