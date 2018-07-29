function Writing(M, adresse)

M=transposer(M);
imwrite(uint8(M), adresse);
