function amanatidesWooAlgorithm(origin, direction, grid3D, verbose)
% A fast and simple voxel traversal algorithm through a 3D space partition (grid)
% proposed by J. Amanatides and A. Woo (1987).
%
% Input:
%    origin.
%    direction.
%    grid3D: grid dimensions (nx, ny, nz, minBound, maxBound).
% Author: 
%    Jesús P. Mena-Chalco.

    if (verbose)
        figure;
        hold on;
        text(origin(1), origin(2), origin(3), 'origin');
        plot3(origin(1), origin(2), origin(3), 'k.', 'MarkerSize', 15);
        quiver3(origin(1), origin(2), origin(3), direction(1), direction(2), direction(3), 30);
        
        vmin = grid3D.minBound';
        vmax = grid3D.maxBound';
        BoxVertices = [vmax(1) vmin(2) vmin(3); vmax(1) vmax(2) vmin(3); vmin(1) vmax(2) vmin(3); vmin(1) vmax(2) vmax(3); vmin(1) vmin(2) vmax(3); vmax(1) vmin(2) vmax(3); vmin; vmax ];
        BoxFaces = [1 2 3 7; 1 2 8 6; 1 6 5 7; 7 5 4 3; 2 8 4 3; 8 6 5 4];
        h = patch('Vertices',BoxVertices,'Faces',BoxFaces,'FaceColor','yellow');
        set(h, 'FaceAlpha', 0.1);

        view(60,30);
        axis tight;
        xlabel('x');
        ylabel('y');
        zlabel('z');
        grid on;
    end;
        
    [flag, tmin] = rayBoxIntersection(origin, direction, grid3D.minBound, grid3D.maxBound);

    if (flag==0)
        disp('\n The ray does not intersect the grid');
    else
        if (tmin<0)
            tmin = 0;
        end;

        start   = origin + tmin*direction;
        boxSize = grid3D.maxBound-grid3D.minBound;
        
        if (verbose)
            plot3(start(1), start(2), start(3), 'r.', 'MarkerSize', 15);
        end;
        
        x = floor( ((start(1)-grid3D.minBound(1))/boxSize(1))*grid3D.nx )+1;
        y = floor( ((start(2)-grid3D.minBound(2))/boxSize(2))*grid3D.ny )+1;
        z = floor( ((start(3)-grid3D.minBound(3))/boxSize(3))*grid3D.nz )+1;               

        if (x==(grid3D.nx+1));  x=x-1;  end;
        if (y==(grid3D.ny+1));  y=y-1;  end;            
        if (z==(grid3D.nz+1));  z=z-1;  end;
        
        if (direction(1)>=0)
            tVoxelX = (x)/grid3D.nx;
            stepX = 1;
        else
            tVoxelX = (x-1)/grid3D.nx;
            stepX = -1;  
        end;
        
        if (direction(2)>=0)
            tVoxelY = (y)/grid3D.ny;
            stepY = 1;
        else
            tVoxelY = (y-1)/grid3D.ny;
            stepY = -1;
        end;
        
        if (direction(3)>=0)
            tVoxelZ = (z)/grid3D.nz; 
            stepZ = 1;
        else
            tVoxelZ = (z-1)/grid3D.nz;
            stepZ = -1;  
        end;
                
        voxelMaxX  = grid3D.minBound(1) + tVoxelX*boxSize(1);
        voxelMaxY  = grid3D.minBound(2) + tVoxelY*boxSize(2);
        voxelMaxZ  = grid3D.minBound(3) + tVoxelZ*boxSize(3);

        tMaxX      = tmin + (voxelMaxX-start(1))/direction(1);
        tMaxY      = tmin + (voxelMaxY-start(2))/direction(2);
        tMaxZ      = tmin + (voxelMaxZ-start(3))/direction(3);
        
        voxelSizeX = boxSize(1)/grid3D.nx;
        voxelSizeY = boxSize(2)/grid3D.ny;
        voxelSizeZ = boxSize(3)/grid3D.nz;        
        
        tDeltaX    = voxelSizeX/abs(direction(1));
        tDeltaY    = voxelSizeY/abs(direction(2));
        tDeltaZ    = voxelSizeZ/abs(direction(3));
                
        while ( (x<=grid3D.nx)&&(x>=1) && (y<=grid3D.ny)&&(y>=1) && (z<=grid3D.nz)&&(z>=1) )

            if (verbose)
                fprintf('\nIntersection: voxel = [%d %d %d]', [x y z]);
                
                t1 = [(x-1)/grid3D.nx, (y-1)/grid3D.ny, (z-1)/grid3D.nz ]';
                t2 = [  (x)/grid3D.nx,  (y)/grid3D.ny,    (z)/grid3D.nz ]';        

                vmin = (grid3D.minBound + t1.*boxSize)';
                vmax = (grid3D.minBound + t2.*boxSize)';

                smallBoxVertices = [vmax(1) vmin(2) vmin(3); vmax(1) vmax(2) vmin(3); vmin(1) vmax(2) vmin(3); vmin(1) vmax(2) vmax(3); vmin(1) vmin(2) vmax(3); vmax(1) vmin(2) vmax(3); vmin; vmax ];
                smallBoxFaces    = [1 2 3 7; 1 2 8 6; 1 6 5 7; 7 5 4 3; 2 8 4 3; 8 6 5 4];
 
                h = patch('Vertices', smallBoxVertices, 'Faces', smallBoxFaces, 'FaceColor', 'blue', 'EdgeColor', 'white');
                set(h,'FaceAlpha',0.2);
            end;
            
            % ---------------------------------------------------------- %
            % check if voxel [x,y,z] contains any intersection with the ray
            %
            %   if ( intersection )
            %       break;
            %   end;
            % ---------------------------------------------------------- %
            
            if (tMaxX < tMaxY)
                if (tMaxX < tMaxZ)
                    x = x + stepX;
                    tMaxX = tMaxX + tDeltaX;
                else
                    z = z + stepZ;
                    tMaxZ = tMaxZ + tDeltaZ;
                end;
            else
                if (tMaxY < tMaxZ)
                    y = y + stepY;
                    tMaxY = tMaxY + tDeltaY;             
                else
                    z = z + stepZ;
                    tMaxZ = tMaxZ + tDeltaZ;
                end;
            end;
        end;        
     end;
end
