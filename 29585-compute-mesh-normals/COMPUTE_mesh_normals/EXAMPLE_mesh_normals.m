
%Read an stl mesh:
[coordVERTICES] = READ_stl('sample.stl');

%Compute the normals for each facet of the mesh:
[coordNORMALSnew,coordVERTICESnew] = COMPUTE_mesh_normals(coordVERTICES);

%Save the mesh to a new stl file:
WRITE_stl('sample2.stl',coordVERTICESnew,coordNORMALSnew)

%Plot the mesh with the normals:
figure;
PLOT_3D_stl_patch(coordVERTICESnew,coordNORMALSnew)
