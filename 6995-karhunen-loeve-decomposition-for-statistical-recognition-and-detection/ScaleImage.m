function out=ScaleImage(in)
in_min=min(min(in));
in_max=max(max(in));

out = (in-in_min)/ (in_max-in_min);

