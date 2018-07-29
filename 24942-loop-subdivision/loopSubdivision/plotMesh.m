function plotMesh(vertices, faces)
    hold on;
    trimesh(faces', vertices(1,:), vertices(2,:), vertices(3,:));
    colormap gray(1);
    axis tight;
    axis square; 
    axis off;
    view(3);
end