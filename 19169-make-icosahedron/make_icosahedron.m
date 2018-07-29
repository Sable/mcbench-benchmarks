function [ x, y, z, TRI]=make_icosahedron(f, r, sphere, make_plot, faceopaque)
% % Syntax;
% % 
% % [ x, y, z, TRI]=make_icosahedron(f, r, mic_r, make_plot , faceopaque);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program makes an icosahedron of f frequency of type 2 (using midpoints)
% % f is restricted to the even numbers because odd frequency icosahedra do
% % not have a cutting plane.  
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % f is the frequency of the icosahedron.  
% %                Default frequency is 2, which is a typical icosahedron.
% %                f is rounded up to the nearest even integer.  
% % 
% % r is the radius of the icosahedron. Default radius is 1.
% % 
% % sphere = 1; makes a sphere.  Otherwise a hemisphere is output.  
% %             default is a sphere
% %
% % make_plot = 1; makes a 3d plot of the icosahedron.  
% %                Default is to not make a plot.
% % 
% % faceopaque =1; makes the faces of the icosahedron opaque.  
% %                Default is faces transparent.
% % 
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x,y,and z are row vector of the x, y, and z coordinates of the   
% % icosahedron nodes. 
% % 
% % TRI is the triangularization of the icosahedron nodes. 
% % 
% % 
% % ***********************************************************
% % 
% Example
%
% f=2; 
% r=4;
% sphere = 1;
% make_plot=1;
% faceopaque=0;
%
% [ x, y, z, TRI]=make_icosahedron(f, r, sphere, make_plot, faceopaque);
%
% f=10; 
% r=4;
% sphere = 0;
% make_plot=1;
% faceopaque=0;
%
% [ x, y, z, TRI]=make_icosahedron(f, r, sphere, make_plot, faceopaque);
%
% %
% % ***********************************************************
% % 
% % List of Subprograms
% % 
% % 1)  icosahedron_nodes
% % 2)       spherical_to_rectangular
% % 3)       spherical_angle_ed
% % 4)  build_icosa
% % 5)       rotate_transform2
% % 6)       shift_theta
% % 7)  splat 
% % 8)  make_sphere
% % 9)  
% % 
% % ***********************************************************
% % 
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 6   March   2008  added comments
% % 
% % modified 7   March   2008  added examples
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

if nargin < 1  || isempty(f) || logical(f < 2)
    f=2;
end

f=round(f);
if f < 2 
    f=2;
end

if isequal(mod(f, 2), 1)
    f=2*ceil(f/2);
end

if nargin < 2  || isempty(r) || logical(r < 0) || ~isnumeric(r)
    r=1;
end

if nargin < 3  || ~isequal(sphere, 1)
    sphere=0;
end

if nargin < 4  || ~isequal(make_plot, 1)
    make_plot=0;
end

if nargin < 5  || ~isequal(faceopaque, 1)
    faceopaque=0;
end

[x2, y2, z2, it]=icosahedron_nodes(f, r);

[x, y, z]=build_icosa(x2, y2, z2);

[rho, theta, phi]=spherical_angle_ed(x, y, z);

[x10, y10, z10]=splat(rho, theta, phi);

TRI = delaunay(x10, y10);
    
if sphere == 1
    [TRI, x, y, z]=make_sphere(TRI, x, y, z);
end

if make_plot ==1
    figure(10);
    if faceopaque == 1
        h=trisurf(TRI,x,y,z, 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
    else
        h=trisurf(TRI,x,y,z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1],'LineWidth', 1 );
    end
    axis equal;

    xlabel('x-axis (m)', 'Fontsize', 16');
    ylabel('y-axis (m)', 'Fontsize', 16');
    zlabel('z-axis (m)', 'Fontsize', 16');
    title( ['Microphone Structure Struts and Nodes'], 'Fontsize', 16');

    axis equal;
    grid off;

end
    
