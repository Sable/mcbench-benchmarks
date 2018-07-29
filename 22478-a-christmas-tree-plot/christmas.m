function christmas

% Anselm Ivanovas, anselm.ivanovas@student.unisg.ch

%Basically just a nice plot for some christmas fun.
%3D Plot of a hhristmas tree with some presents and snow

%% setup
snow=800;     % number of snow flakes [0 .. 5000]


%% draw tree
h=0:0.2:25; %vertical grid
[X,Y,Z] = cylinder(tree(h)); %produce a tree formed cylinder
Z=Z*25; %scale to the right heigth

%Add some diffusion to the surface of the tree to make it look more real

treeDiffusion=rand(126,21)-0.5;%some horizontal diffusion data

%add diffusion to the grid points 
for cnt1=1:21
    
    for cnt2=16:126%starting above the trunk
        %get the angle to always diffuse in direction of the radius
        angle=atan(Y(cnt2,cnt1)/X(cnt2,cnt1));
        %split the diffusion in the two coordinates, depending on the angle
        X(cnt2,cnt1)=X(cnt2,cnt1)+cos(angle)*treeDiffusion(cnt2,cnt1);
        Y(cnt2,cnt1)=Y(cnt2,cnt1)+sin(angle)*treeDiffusion(cnt2,cnt1);
        %some Vertical diffusion for each point
        Z(cnt2,cnt1)=Z(cnt2,cnt1)+(rand-0.5)*0.5;
    end
    
end
%draw the tree
surfl(X,Y,Z,'light')

%% View and format

%Use as nice green color map (darker at the bottom, lighter at the top)
r=(0.0430:(0.2061/50):0.2491)';%red component
g=(0.2969:(0.4012/50):0.6981)';%green component
b=(0.0625:(0.2696/50):0.3321)';%blue component
map=[r,g,b];%join in a map
for cnt=1:6
    %change the lower part to brown for the trunk
    map(cnt,:)=[77,63,5]/265;
end

colormap(map)%set the map
view([-37.5,4])%Change the view to see a little more of the Actual 3D tree
lighting phong %some nice lighting
shading interp %remove grid and smoothen the surface color
axis equal %takes care of display in the right proportion
axis([-10 10 -10 10 0 30]) %give some more axis space (for the snow later)
axis off %but don't show axis
hold on %to draw the rest
title('HAPPY HOLIDAYS')%self explaining

%% Presents
%Draw some presents around the tree (each with random color)
drawPresent(2,-4,0,3,3,2);
drawPresent(-4,3,0,2,3,1.5);
drawPresent(5,3,0,4,3,3);
drawPresent(-14,-5,0,6,3,1);
drawPresent(-9,-10,0,2,2,2);
drawPresent(0,4,0,4,3,3);
drawPresent(-6,-13,0,3,3,3);

%% Snow

%create some random 3D coordinates for the snow (amount as in setup above)
snowX=(rand(snow,1)*25-12.5);
snowY=(rand(snow,1)*25-12.5);
snowZ=(rand(snow,1)*27);
%Note:Some flakes will end up IN the tree but just can't be seen then
plot3(snowX,snowY,snowZ,'w*')%plot coordinates as white snow flakes
hold off%Done
end % of function


%% ============= private functions

function r=tree(h)%Gives a profile for the tree
for cnt=1:length(h)
    
    if(h(cnt)==0)%no Width at the bottom. Ensures a "closed" trunk
        r(cnt)=0;
    end
    %smaller radius for the trunk
    if (h(cnt)>0 && h(cnt)<=3)
        r(cnt)=1.5;
    end

    %reduce radius gradually from 8 to 0. Note: will only work with a trunk heigth
    %of 3 and a whole tree heigth of 25. Scale the height of the tree in
    %the "draw tree" section, since the cylinder command will return a 1
    %unit high cylinder anyway
    if(h(cnt)>3)
        r(cnt)=8-(h(cnt)-3)*0.3636;
    end

end

end % of function

%Draws a present with the given coordinate + size in a random color
%Note:Given coordinates apply to the lower front + left corner of the
%present (the one closest to the viewer) as seen in the plot
function drawPresent(dx,dy,dz,scalex,scaley,scalez) 

%the standard present coordinates
presentX=[0.5 0.5 0.5 0.5 0.5; 0 1 1 0 0; 0 1 1 0 0; 0 1 1 0 0; 0.5 0.5 0.5 0.5 0.5];
presentY=[0.5 0.5 0.5 0.5 0.5; 0 0 1 1 0; 0 0 1 1 0; 0 0 1 1 0; 0.5 0.5 0.5 0.5 0.5];
presentZ=[0 0 0 0 0; 0 0 0 0 0; 0.5 0.5 0.5 0.5 0.5; 1 1 1 1 1; 1 1 1 1 1];

%draw some presents with random colors
%scale present and move it to the right place and get the plot handle
myHandle=surf((presentX*scalex+dx),(presentY*scaley+dy), (presentZ*scalez+dz));
%some random color map
randColorMap(:,:,1)=repmat(rand,[5,5]);%r component
randColorMap(:,:,2)=repmat(rand,[5,5]);%g component
randColorMap(:,:,3)=repmat(rand,[5,5]);%b component
%Assign colormap just to the plot handle object of the present, so the tree
%does not change color
set(myHandle,'CData',randColorMap)
shading interp %Nice shding + without grid

end % of function
