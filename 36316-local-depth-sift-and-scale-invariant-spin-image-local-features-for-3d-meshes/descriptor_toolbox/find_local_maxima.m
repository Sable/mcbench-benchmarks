function maxima = find_local_maxima (faces, vertex, diff)
W = compute_mesh_weight(vertex,faces,'combinatorial');
len2 = length(W);
maxima = {};
diffarr = cell2mat(diff);
[oct_max, oct_inds] = max(diffarr');

maxima = find_local_maxima_tag(oct_inds, diffarr, W )';
%tic; maxima2 = find_local_maxima_taga(oct_inds, diff, W )';toc

end



