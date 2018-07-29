function taille = imgsize(adresse)

M=imread(adresse);
taille = size(M);

if length(taille) ==2
    taille(3) = 1;
end