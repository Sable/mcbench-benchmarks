function [ detectedPts, scale ] = dog(  vertex, faces, num_octaves, params )
%vertex, faces
%num_octaves - number of octaves to use (20 works fine)
%params.sigscale - dog scaling method. default is good
%params.ExcludeBoundery - exclude boundary vertices from detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('params','var')
    params = [];
end

if ~isfield(params,'sigscale')
    params.sigscale = 0;
end
if ~isfield(params,'ExcludeBoundery')
    params.ExcludeBoundery = 1;
end

%dog find geometry difference of gaussians features
  
    ss = size(vertex);
    if (ss(1) == 3)
        vertex = vertex';
    end
    
%create ocataves
    %W = my_euclidean_distance(triangulation2adjacency(faces),vertex);
    W = triangulation2adjacency(faces);
    W = W + speye(length(vertex));

    W = spdiags(1./sum(W,2),0,length(vertex),length(vertex))*W;
    vertex2=vertex;
    for ind = 1:num_octaves
        vertex2 = (W*vertex2);
        octaves {ind} = vertex2;
        if (ind > 1)
            diff{ind} =  sum((octaves{ind - 1} - vertex2)'.^2)';
        else
            diff{ind} =  sum((vertex - vertex2)'.^2)';
        end
        ds(ind) = sum(diff{ind});
        if (params.sigscale == 1)
            diff{ind} = diff{ind}*ind;
        elseif (ds(ind) > 0)
            diff{ind} = diff{ind}/ds(ind);
        end
    end

    detectedPts = find_local_maxima(faces,vertex2,diff);
   
    D = my_euclidean_distance(triangulation2adjacency(faces),vertex);
    d = sum(D);
    w = sum(triangulation2adjacency(faces));
   scale = full((d./w)');
   if (params.ExcludeBoundery)
       boundary = find_boundary_vertex(faces);
       for k = 1:length(detectedPts)
           detectedPts{k} = setdiff(detectedPts{k}, boundary);           
       end
   end   
  %detectedPts{1} = {};
   %detectedPts{2} = {};
%    a = sum(abs(vertex - repmat([5.92 -63.36 -596.2],length(vertex),1)),2)<0.1;
% b = sum(abs(vertex - repmat([-111.4 -35.49 -580.7],length(vertex),1)),2)<0.1;
% detectedPts = {};
% detectedPts{1}  = [find(a) find(b)];
 end

function W = my_euclidean_distance(A,vertex)

if size(vertex,1)<size(vertex,2)
    vertex = vertex';
end

[i,j,s] = find(sparse(A));
d = sqrt(sum( (vertex(i,:) - vertex(j,:)).^2, 2));
W = sparse(i,j,d);  

end
