function test
load trimesh2d;
zfe   = zeros(numel(xfe),1);
nodes = [xfe,yfe,zfe];
triangles = trife;
filename  = 'testSTL.stl';
writeSTL(nodes,triangles,filename);
%% 100k nodes and triangles test(~17MB stl file)
nodesOneM          = rand(100000,3);
trianglesOneM      = ones(100000,3);
trianglesOneM(:,2) = 2;
trianglesOneM(:,3) = 3;
filenameOneM       = 'test100k.stl';
a                  = clock;
writeSTL(nodesOneM,trianglesOneM,filenameOneM);
b                  = clock;
time               = b-a;
    %machine performance
    %http://www.mathworks.com/help/matlab/ref/bench.html(LU 0.54, FFT 0.651,
    %output for my machine:ODE 0.2263, Sparse 0.7735, 2D 1.4288, 3D 1.24)

end