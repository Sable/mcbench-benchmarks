%This function develop by Renoald Tang
%University Teknologi Malaysia, Photogrammetry and Laser scanning group
%for academic purpose
%Email:renoald@live.com
%This function plot 3D figure 
function myview(e,f,value,map)
[a,b]=size(e);
if b==1 
 F=dlmread('face');
P=dlmread('point');
n=length(F);
r=runique(F);
n1=length(r);

for i=1 : n1
    fprintf('number face %d is read\n',r(i,1))
C=fnum(F,r(i,1));
b=returnf(F,r(i,1),C);
if map==2 
    colormap(jet)
end
if map==3 
    colormap(hsv)
end
if map==4 
    colormap(hot)
end
if map==5 
    colormap(cool)
end
if map==6 
    colormap(spring)
end
if map==7 
    colormap(summer)
end
if map==8 
    colormap(autumn)
end
if map==9 
    colormap(winter)
end
if map==10 
    colormap(gray)
end
if map==11 
    colormap(bone)
end
if map==12 
    colormap(copper)
end
if map==13 
    colormap(pink)
end
if map==14 
    colormap(lines)
end
if map==0
    h=trisurf(b,P(:,1),P(:,2),P(:,3));
end 
h=trisurf(b,P(:,1),P(:,2),P(:,3));
hold on 
axis off
end 
disp(value)
if value==1
    shading faceted
end
if value==2
    shading flat
end
if value==3
    shading interp
end
    
end

if b==3 
 F=dlmread('face');
P=dlmread('point');
n=length(F);
r=runique(F);
n1=length(r);
for i=1 : n1
    fprintf('number face %d is read\n',r(i,1))
C=fnum(F,r(i,1));
b=returnf(F,r(i,1),C);
h=trisurf(b,P(:,1),P(:,2),P(:,3),'facecolor',e,'edgecolor',f);
hold on 
axis off
end 

    
end

%retun unique value
function r=runique(value)
r=unique(value(:,1));
%return C
function C=fnum(value,f)
n=length(value);
C=0;
for i=1 : n 
    if value(i,1)==f
        C=C+1;
    end
end
function b=returnf(value,u,f)
n=length(value);
fid=fopen('value','w');
for i=1 : n 
    if value(i,1)==u
        for j=2 : u+1
           
           %disp(value(i,j))
        
            if j < u+1
            fprintf(fid,'%.d ',value(i,j));
            else
                fprintf(fid,'%.d\n',value(i,j));
            end
            
           
            
        
        end
    end
end
fclose('all');
b=dlmread('value');
[m1,m2]=size(b);
for k=1 : m1
    for j=1 : m2
    b(k,j)=b(k,j)+1;
    end
end

delete('value');


