function projmat_art = comb_projmat(proj_mat1,proj_mat2)%,angles1,angles2)
projmat_art = [proj_mat1,fliplr(proj_mat2)];
end
