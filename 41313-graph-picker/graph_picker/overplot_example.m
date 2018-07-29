%this shows an example of using the "get axes" information from graph_picker

im=imread('example_graph.jpg');%load image
%display('identify reference points in graph picker and ''get axes''');
%[tmp]=graph_picker(im);


figure
image(im);%this is the same image that was used for graph_picker
axis off
h_imax=axes;%get handle to current axes
X=[2.722513e-01 8.272251e-01 1.204188e+00 1.612565e+00 2.146597e+00 2.774869e+00 3.591623e+00 4.219895e+00 ];%sample data
Y=[4.821429e+00 8.928571e+00 1.696429e+01 2.767857e+01 3.142857e+01 2.946429e+01 3.232143e+01 3.732143e+01 ];
plot(X,Y,'ob');
axis([-2.129e+00 6.055e+00 -1.191e+01 5.744e+01]);%this comes from graph_picker
set(h_imax,'color','none');%turn off background color
grid on