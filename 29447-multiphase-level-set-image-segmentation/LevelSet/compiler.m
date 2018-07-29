function compiler()

mex -g Seg2_Stim.c levelset.c Img_new.c gauss_seg.c gauss_vect_part_seg.c gauss_vect_seg.c gamma_seg.c ker_part_seg.c ker_seg.c levelutil.c mean_clust_seg.c mean_part_seg.c mean_seg.c mean_vect_seg.c;
