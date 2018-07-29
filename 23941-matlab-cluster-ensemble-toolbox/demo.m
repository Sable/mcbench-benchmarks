% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

clear
x = [];
idxTruth = [];

for i = 1:5
    theta = pi*rand(1)/2;
    rmean(i,:) = [(20*rand(1) - 10) (20*rand(1) - 10)];
    covariance = covm2d(theta, (.75*rand(1)+.25), (.75*rand(1)+.25));
    xClust = normdist(400, 2, rmean(i,:), covariance);
    idxTruth = [idxTruth; i*ones(400,1)];
    x = [x; xClust];
end

h = figure
scatter(x(:,1),x(:,2),3,idxTruth)
axis equal
title('truth clustering')
saveas(h,'fig1.fig')

%% Bayes error cluster %%
idxBayes = nearestcenter(x,rmean);
voi_bayes = varinfo(idxBayes,idxTruth);

h = figure
scatter(x(:,1),x(:,2),3,idxBayes)
axis equal
title(strcat('Bayes error clustering: voi = ',num2str(voi_bayes)))
saveas(h,'fig2.fig')

%% Kmeans %%
idxKmeans = kmeans(x,5);
voi_kmeans = varinfo(idxKmeans,idxTruth);

h = figure
scatter(x(:,1),x(:,2),3,idxKmeans)
axis equal
title(strcat('kmeans clustering: voi = ',num2str(voi_kmeans)))
saveas(h,'fig3.fig')

%% Kcenters %%
tic
Sdist = distmat(x);
idx = kcenters(Sdist, 5);
centers_full = unique(idx(:,1000));
idxKcenters = clustermap(idx(:,1000));
t_kcenters_full = toc

voi_kcenters_full = varinfo(idxKcenters,idxTruth);

h = figure
scatter(x(:,1),x(:,2),3,idxKcenters)
axis equal
hold on;

for i = 1:size(centers_full,1)
    plot(x(centers_full(i),1),x(centers_full(i),2),'k+')
end
title(strcat('kcenters clustering derived from full sample: voi = ',num2str(voi_kcenters_full), ', compute time = ', num2str(t_kcenters_full),'s'))
saveas(h,'fig4.fig')

%% Kcenters sub-sampling (evaluation over iterations) %%
for j = 1:2
    Ssamptot = zeros(2000,2000);
    iter = 500;
    sample_size = 400*j;

    Sdist = distmat(x);
    for i = 1:iter
        samples = sort(randsample(2000, sample_size));
        xsamp = x(samples,:);
        Ssampdist = smpdistmat(Sdist, samples);
        idx = kcenters(Ssampdist, 5,'runs',10);
        centers = unique(idx(:,10));
        idxSampKcenters = clustermap(idx(:,10));

        Ssamptot = Ssamptot + similaritymat(idxSampKcenters, samples, 2000);
        Ssampcum = Ssamptot/i;
        idx = kcenters(Ssampcum, 5,'runs',100);
        centers = unique(idx(:,100));
        idxCumSampKcenters(:,i) = clustermap(idx(:,100));
        voi_kcenters_sub(i,j) = varinfo(idxCumSampKcenters(:,i),idxTruth)
    end

    h(j) = figure
    plot(voi_kcenters_sub(:,j))
    title(strcat('variation of information: sample size = ',int2str(sample_size)))
end
saveas(h(1),'fig5.fig')
saveas(h(2),'fig6.fig')

%% Kcenters sub-sampling %%
for j = 1:2
    Ssamptot = zeros(2000,2000);
    iter = 500;
    sample_size = 400*j;

    tic
    Sdist = distmat(x);
    for i = 1:iter 
        samples = sort(randsample(2000, sample_size));
        xsamp = x(samples,:);
        Ssampdist = smpdistmat(Sdist, samples);
        idx = kcenters(Ssampdist, 5,'runs',10);
        centers = unique(idx(:,10));
        idxSampKcenters = clustermap(idx(:,10));

        Ssamptot = Ssamptot + similaritymat(idxSampKcenters, samples, 2000);
        Ssampcum = Ssamptot/i;
    end

    t_kcenters_sub_a(j) = toc
    
    tic
    idx = kcenters(Ssampcum, 5);
    centers_sub_Final(:,j) = unique(idx(:,1000));
    idxCumSampKcentersFinal(:,j) = clustermap(idx(:,1000));
    t_kcenters_sub_b(j) = toc

    t_kcenters_sub(j) = t_kcenters_sub_a(j) + t_kcenters_sub_b(j)
    voi_kcenters_sub_final(j) = varinfo(idxCumSampKcentersFinal(:,j),idxTruth)

    h(j) = figure
    scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal(:,j))
    axis equal
    hold on;
    
    for k = 1:size(centers_sub_Final(:,j),1)
        plot(x(centers_sub_Final(k,j),1),x(centers_sub_Final(k,j),2),'k+')
    end
    title(strcat('kcenters clustering derived from ensemble of ',int2str(iter),' sample sets: sample size = ',int2str(sample_size), 'voi = ',num2str(voi_kcenters_sub_final(j)), 'compute time = ', num2str(t_kcenters_sub(j)),'s'))
end
saveas(h(1),'fig7.fig')
saveas(h(2),'fig8.fig')

%% Kcenters full sampling (evaluation over iterations) %%%%
Ssamptot = zeros(2000,2000);
iter = 500;

Ssampdist = distmat(x);
for i = 1:iter
    idx = kcenters(Ssampdist, 5,'runs',1);
    centers = unique(idx(:,1));
    idxSampKcenters = clustermap(idx(:,1));

    Ssamptot = Ssamptot + similaritymat(idxSampKcenters, (1:2000)', 2000);
    Ssampcum = Ssamptot/i;
    idx = kcenters(Ssampcum, 5,'runs',100);
    centers = unique(idx(:,100));
    idxCumSampKcenters(:,i) = clustermap(idx(:,100));
    voi_kcenters_full2(i) = varinfo(idxCumSampKcenters(:,i),idxTruth)
end

h = figure
plot(voi_kcenters_full2)
title(strcat('variation of information: full sample'))
saveas(h,'fig9.fig')

%% Kcenters full sampling %%%%
Ssamptot = zeros(2000,2000);
iter = 500;

tic
Ssampdist = distmat(x);
for i = 1:iter
    idx = kcenters(Ssampdist, 5,'runs',1);
    centers = unique(idx(:,1));
    idxSampKcenters = clustermap(idx(:,1));

    Ssamptot = Ssamptot + similaritymat(idxSampKcenters, (1:2000)', 2000);
    Ssampcum = Ssamptot/i;
end

t_kcenters_full2_a = toc
    
tic
idx = kcenters(Ssampcum, 5);
centersFinal = unique(idx(:,1000));
idxCumSampKcentersFinal2 = clustermap(idx(:,1000));
t_kcenters_full2_b = toc

t_kcenters_full2 = t_kcenters_full2_a + t_kcenters_full2_b
voi_kcenters_full_final = varinfo(idxCumSampKcentersFinal2,idxTruth)

h = figure
scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal2)
axis equal
hold on;
    
for j = 1:size(centersFinal,1)
    plot(x(centersFinal(j),1),x(centersFinal(j),2),'k+')
end
title(strcat('kcenters clustering derived from ensemble of ',int2str(iter),' sample sets: sample size = ',int2str(2000), 'voi = ',num2str(voi_kcenters_full_final), 'compute time = ', num2str(t_kcenters_full2),'s'))
saveas(h,'fig10.fig')

%% Variation of information %%
h = figure
plot([1 500]', [voi_bayes voi_bayes]', 'r')
hold on
plot([1 500]', [voi_kmeans voi_kmeans]', 'g')
plot([1 500]', [voi_kcenters_full voi_kcenters_full]')
plot(voi_kcenters_sub(:,1),'k--')
plot(voi_kcenters_sub(:,2),'k:')
plot(voi_kcenters_full2,'c')
title(strcat('variation of information'))
legend('Bayes error', 'Kmeans',  'Kcenters', 'Kcenters: samples = 400', 'Kcenters: samples = 800', 'Kcenters: samples = 2000')
saveas(h,'fig11.fig')

%% Summary %%
h = figure
subplot(2,4,1)
scatter(x(:,1),x(:,2),3,idxTruth)
axis equal
title('truth clustering')

subplot(2,4,2)
scatter(x(:,1),x(:,2),3,idxBayes)
axis equal
title(strcat('Bayes error clustering: voi = ',num2str(voi_bayes,4)))

subplot(2,4,3)
scatter(x(:,1),x(:,2),3,idxKmeans)
axis equal
title(strcat('kmeans clustering: voi = ',num2str(voi_kmeans,4)))

subplot(2,4,4)
scatter(x(:,1),x(:,2),3,idxKcenters)
axis equal
hold on;

scatter(x(:,1),x(:,2),3,idxKcenters)
axis equal
hold on;

for i = 1:size(centers_full,1)
    plot(x(centers_full(i),1),x(centers_full(i),2),'k+')
end
title(strcat('kcenters clustering - full sample: voi = ',num2str(voi_kcenters_full,4), ', time = ', num2str(t_kcenters_full,4),'s'))

subplot(2,4,5)
scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal(:,1))
axis equal
hold on;
    
for k = 1:size(centers_sub_Final,1)
    plot(x(centers_sub_Final(k,1),1),x(centers_sub_Final(k,1),2),'k+')
end
title(strcat('ensemble of', int2str(iter),' sets: samples = ',int2str(400), ', voi = ',num2str(voi_kcenters_sub_final(1),4), ', time = ', num2str(t_kcenters_sub(1),4),'s'))

subplot(2,4,6)
scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal(:,2))
axis equal
hold on;
    
for k = 1:size(centers_sub_Final,1)
    plot(x(centers_sub_Final(k,2),1),x(centers_sub_Final(k,2),2),'k+')
end
title(strcat('ensemble of ',int2str(iter),' sets: samples = ',int2str(800), ', voi = ',num2str(voi_kcenters_sub_final(2),4), ', time = ', num2str(t_kcenters_sub(2),4),'s'))

subplot(2,4,7)
scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal2)
axis equal
hold on;
    
for j = 1:size(centersFinal,1)
    plot(x(centersFinal(j),1),x(centersFinal(j),2),'k+')
end
title(strcat('ensemble of ',int2str(iter),' sets: samples = ',int2str(2000), ', voi = ',num2str(voi_kcenters_full_final,4), ', time = ', num2str(t_kcenters_full2,4),'s'))

subplot(2,4,8)
plot([1 500]', [voi_bayes voi_bayes]', 'r')
hold on
plot([1 500]', [voi_kmeans voi_kmeans]', 'g')
plot([1 500]', [voi_kcenters_full voi_kcenters_full]')
plot(voi_kcenters_sub(:,1),'k--')
plot(voi_kcenters_sub(:,2),'k:')
plot(voi_kcenters_full2,'c')
title(strcat('variation of information'))
legend('Bayes error', 'Kmeans',  'Kcenters', 'Kcenters: samples = 400', 'Kcenters: samples = 800', 'Kcenters: samples = 2000')
saveas(h,'fig12.fig')

save run

%% Affinity propagation %%
tic
idx = affinprop(Ssampcum);
centersFinal = unique(idx);
idxCumSampKcentersFinal = clustermap(idx);
vicFinal = varinfo(idxCumSampKcentersFinal,idxTruth)
t = toc

figure
scatter(x(:,1),x(:,2),3,idxCumSampKcentersFinal)
axis equal
hold on;

for i = 1:size(centers,1)
    plot(xcatap(centers(i),1),xcatap(centers(i),2),'k+')
    %text(xcatap(centers(i),1),xcatap(centers(i),2),int2str(i),'HorizontalAlignment','left')
end

%% ensembles %%
for i=1:5
    
    xscat = [];
    
    for j = 1:5
        xs(:,:,j) = x((20*i-19):20*i,:,j);
        xsclust = [xs(:,:,j) j*ones(20,1)];
        xscat = [xscat; xsclust];
    end
    
    %figure
    %scatter(xscat(:,1),xscat(:,2),3,xscat(:,3))
    axis equal
    
    ys = kMeansCluster(xscat(:,1:2),5);
    %figure
    %scatter(ys(:,1),ys(:,2),3,ys(:,3))
    axis equal
    ys2 = [zeros(20*(i-1),3); ys(1:20,:); zeros(100-20*i,3); zeros(20*(i-1),3); ys(21:40,:); zeros(100-20*i,3); zeros(20*(i-1),3); ys(41:60,:); zeros(100-20*i,3); zeros(20*(i-1),3); ys(61:80,:); zeros(100-20*i,3); zeros(20*(i-1),3); ys(81:100,:); zeros(100-20*i,3)];
    Ss(:,:,i) = similaritymat2(ys2);
    %plotmx(Ss(:,:,i))
end

SsTot = zeros(500,500);

for i=1:5
    SsTot = SsTot + Ss(:,:,i);
end

SsTot = SsTot/5;
plotmx(SsTot)

S = simmatsetpref(SsTot);
idx = affinprop(S);
[centers clusters] = clustermap(idx);
xcatap = [xcat(:,1:2) clusters];
figure
scatter(xcatap(:,1),xcatap(:,2),3,xcatap(:,3))
hold on;

for i = 1:size(centers,1)
    plot(xcatap(centers(i),1),xcatap(centers(i),2),'k+')
end
