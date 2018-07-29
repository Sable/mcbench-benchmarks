function l = F_transfer_l(F,l,e)

l = F*cross(e,l);
l = l/norm(l(1:2));

