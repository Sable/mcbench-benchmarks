function [registered]=nonrigidICP(target,source,Ft,Fs,iterations)

% INPUT
% -target: vertices of target mesh; n*3 array of xyz coordinates
% -source: vertices of source mesh; n*3 array of xyz coordinates
% -Ft: faces of target mesh; n*3 array
% -Fs: faces of source mesh; n*3 array
% -iterations: number of iterations; usually > 100
% 
% OUTPUT
% -registered: registered source vertices on target mesh. Faces are not affected and remain the same is before the registration (Fs). 

%EXAMPLE

% load EXAMPLE
% [registered]=nonrigidICP(target,source,Ft,Fs,200);

tic
clf
%initial allignment and scaling
[error1,source,transform]=rigidICP(target,source,0);

%plot of the meshes
h=trisurf(Fs,source(:,1),source(:,2),source(:,3),0.3,'Edgecolor','none');
hold
light
lighting phong;
set(gca, 'visible', 'off')
set(gcf,'Color',[1 1 0.88])
view(90,90)
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
trisurf(Ft,target(:,1),target(:,2),target(:,3),0.75,'Edgecolor','none');
alpha(0.6)

for i =1:iterations
    % find index of max deviating point
    [distancemax,I,error,Reallignedsource]=ICPmanu_allign2(target,source);
     distancemax=distancemax
     % define measure for decreasing surface area to be transformed
     areafactor=0.5+24*i/iterations;
    
    for j=1:4
        areafactor=areafactor*j;
        r=areafactor/25;

        if r>1
            r=1;
        end
        %decrease sample size for large surfaces
       
        [nfs,nvs] = reducepatch(Fs,source,r);
        [nft,nvt] = reducepatch(Ft,target,r);
        %define index of max deviating point on reduced surface
        Inieuw=knnsearch(nvs,source(I,:));
        % define order of neighbouring vertices
        [distancemap]=surfacemap(nvs,nfs,Inieuw);
        d2=distancemap(:,3);
        %use distance to define specific surface area of interest
        d2=d2.^areafactor;
        [error,Reallignedsource,transform]=ICPmanu2weigthed(nvt,nvs,d2);
        [distancemap]=surfacemap(source,Fs,I);
        d2=distancemap(:,3);
        d2=d2.^areafactor;
        correction=1-d2;
        Reallignedsource=transform.b*source*transform.T+repmat(transform.c(1,1:3),length(source(:,1)),1);
        source=horzcat(source(:,1).*correction,source(:,2).*correction,source(:,3).*correction)+horzcat(Reallignedsource(:,1).*d2,Reallignedsource(:,2).*d2,Reallignedsource(:,3).*d2);
        [error,source,transform]=rigidICP(target,source,1);
            delete(h)
            h=trisurf(Fs,source(:,1),source(:,2),source(:,3),d2,'Edgecolor','none');
            pause (0.1)
    end
end
registered=source;
toc