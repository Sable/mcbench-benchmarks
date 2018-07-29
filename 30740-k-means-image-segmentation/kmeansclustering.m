function [clusters, result_image, clusterized_image] = kmeansclustering(im,  k)

%histogram calculation
img_hist = zeros(256,1);
hist_value = zeros(256,1);

for i=1:256
	img_hist(i)=sum(sum(im==(i-1)));
end;
for i=1:256
	hist_value(i)=i-1;
end;
%cluster initialization
cluster = zeros(k,1);
cluster_count = zeros(k,1);
for i=1:k
	cluster(i)=uint8(rand*255);
end;

old = zeros(k,1);
while (sum(sum(abs(old-cluster))) >k)
	old = cluster;
	closest_cluster = zeros(256,1);
	min_distance = uint8(zeros(256,1));
	min_distance = abs(hist_value-cluster(1));

	%calculate the minimum distance to a cluster
	for i=2:k
		min_distance =min(min_distance,  abs(hist_value-cluster(i)));
	end;

	%calculate the closest cluster
	for i=1:k
		closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
	end;

	%calculate the cluster count
	for i=1:k
		cluster_count(i) = sum(img_hist .*(closest_cluster==i));
	end;


	for i=1:k
		if (cluster_count(i) == 0)
			cluster(i) = uint8(rand*255);
		else
			cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
        end;
	end;
	
end;
imresult=uint8(zeros(size(im)));
for i=1:256
	imresult(im==(i-1))=cluster(closest_cluster(i));
end;

clustersresult=uint8(zeros(size(im)));
for i=1:256
	clustersresult(im==(i-1))=closest_cluster(i);
end;

clusters = cluster;
result_image = imresult;
clusterized_image = clustersresult;
end