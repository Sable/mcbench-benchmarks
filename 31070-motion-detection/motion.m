function im = motion(A,B)

    i =A;
%  figure(1),imshow(i)
    i=255*uint8(edge(rgb2gray(i),'canny'));
   
  
    j = B;
%  figure(2),imshow(j)
    j=255*uint8(edge(rgb2gray(j),'canny'));
   
    im=imabsdiff(i,j);




