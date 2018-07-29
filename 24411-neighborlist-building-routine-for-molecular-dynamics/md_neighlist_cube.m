function [ nebrTab, nebrLen, ncell, id_cell] = md_neighlist_cube( ...
    x, nx, rc, srgdat, bctyp, frc)
% [nebrTab, nebrLen] = md_neighlist_cube( x, nx, rc, srgdat, bctyp, frc) %
% ----------------------------------------------------------------------
% Create neighbor list for atomic system %
% in a cubic region                      %
% WZ. Shan, 19/03/2009                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input:
%   x   : atom coords, [ px, py, pz]
%   nx  : num. of atoms, = size( x, 1)
%   rc  : cutoff radius
%   srgdat : region data [ srg_o(1:3), W, H, D]
%          :             [ srg_o(1:3), W, H, D, x, y, z] if bctyp == 2,
%          where [x, y, z] is the logical indices to specifiy if the
%          periodic boundary condition should be applied to the
%          corresponding direction, value of only 0 or 1. 
%                         ^ z
%                         |
%                         |
%                         |
%                        /-------- H --------/
%                       W |                 /|
%                      /  D                / |
%                     /---|---------------/  |
%                     |   o---------------|---   -> y
%                     |  / srg_o          |  /     
%                     | /                 | /
%                    x|/__________________|/
%   bctyp  : types of boundary, 1: free, 2: periodic, 3: reflecting
%   frc    : cell size factor( optional)
% output:
%   nebrTab : interaction pairs, [p1, p2]
%   nebrLen : size( nebrTab, 1)
%   ncell   : global cell coordinates
%   id_cell : cell coordinates

% linked cell-list
if nargin == 5
    frc = 1;
else
    frc = max( 1, frc);
end
region = srgdat( 4:6);
[ celllist, ncell, cell_offset, noffset, id_cell] = make_celllist_cube( ...
    region, 1.2*rc, x - repmat( srgdat(1:3), nx, 1), nx, frc);

% init.
maxnebr = 120 * nx;
nebrTab = zeros( maxnebr, 1);
nebrLen = 0;

% creating neighborlist based on boundary types
switch bctyp
    case 1
        % free boundary
        for k = 1:ncell(3)
            for j = 1:ncell(2)
                for i = 1:ncell(1)
                    % 1st cell
                    m1 = (k-1)*ncell(2)*ncell(1) + (j-1)*ncell(1) + i;
                    for l = 1:noffset
                        % 2nd cell
                        m2v = [ i, j, k] + cell_offset(l, :);
                        p1  = celllist( m1 + nx);
                        if all( ncell - m2v >= 0) && all( m2v > 0)
                            m2  = (m2v(3)-1)*ncell(2)*ncell(1) + ...
                                (m2v(2)-1)*ncell(1) + m2v(1);
                            p2  = celllist( m2 + nx);
                            while p1 ~= -1
                                while p2 ~= -1
                                    if m1 ~= m2 || p1 > p2
                                        d = norm( x( p1, :) - x( p2, :), 2);
                                        if d <= rc
                                            nebrLen = nebrLen + 2;
                                            if nebrLen > maxnebr
                                                errordlg( 'too many neighbors');
                                                return;
                                            end
                                            nebrTab( nebrLen - 1) = p1;
                                            nebrTab( nebrLen)     = p2;
                                        end
                                    end
                                    p2 = celllist( p2);
                                end
                                p2 = celllist( m2 + nx);
                                p1 = celllist( p1);
                            end
                        end
                    end
                end
            end
        end
    case 2
        is_pbc = logical(srgdat( 7:9));
        % periodic
        for k = 1:ncell(3)
            for j = 1:ncell(2)
                for i = 1:ncell(1)
                    % 1st cell
                    m1 = (k-1)*ncell(2)*ncell(1) + (j-1)*ncell(1) + i;
                    for l = 1:noffset
                        % 2nd cell
                        m2v = [ i, j, k] + cell_offset(l, :);
                        % warping
                        shift = zeros( 1, 3);
                        for m = 1:3
                            if is_pbc( m)
                                if m2v( m) > ncell( m)
                                    m2v( m) = 1;
                                    shift( m) = region( m);
                                elseif m2v( m) < 1
                                    m2v( m) = ncell( m);
                                    shift( m) = -region( m);
                                end                           
                            end
                        end
                        p1  = celllist( m1 + nx);    
                        if all( ncell - m2v >= 0) && all( m2v > 0)
                            m2  = (m2v(3)-1)*ncell(2)*ncell(1) + ...
                                (m2v(2)-1)*ncell(1) + m2v(1);
                            p2  = celllist( m2 + nx);
                            while p1 ~= -1
                                while p2 ~= -1
                                    if m1 ~= m2 || p1 > p2
                                        d = norm( x( p1, :) - ...
                                            x( p2, :) - shift, 2);
                                        if d <= rc 
                                            nebrLen = nebrLen + 2;
                                            if nebrLen > maxnebr
                                                disp(['number of interaction pairs'...
                                                    ' exceeds the upper limit ', ...
                                                    num2str( maxnebr)]);
                                                disp('Expanding...');
                                                maxnebr = maxnebr * 2;
                                                tmp     = zeros( maxnebr, 1);
                                                tmp( 1:nebrLen-2) = ...
                                                    nebrTab( 1:nebrLen-2);
                                                clear nebrTab
                                                nebrTab              = tmp;
                                                clear tmp;
                                                disp(['max. interaction neighbors ',...
                                                    'expanded to ', ...
                                                    num2str( maxnebr)]);
                                            end
                                            nebrTab( nebrLen - 1) = p1;
                                            nebrTab( nebrLen)     = p2;
                                        end
                                    end
                                    p2 = celllist( p2);
                                end
                                p2 = celllist( m2 + nx);
                                p1 = celllist( p1);
                            end
                        end
                    end
                end
            end
        end
    otherwise
        error( 'Unkown option');
end
nebrTab( nebrLen + 1:end) = [];

nebrTab = [ nebrTab( 1:2:end), nebrTab( 2:2:end)];
nebrLen = nebrLen / 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ celllist, ncell, cell_offset, noffset, id_cell] = ...
    make_celllist_cube( region, rc, atom, natom, frc)
% create celllist, further used for neighborlist %
% WZ. Shan                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input:
%   region: region data [ W, H, D]
%   rc    : cutoff radius of atomic potential
%   atom  : [ x y z] of atoms
%   natom : num. of atoms
%   frc   : cell size factor
% output:
%   celllist: link-list of atoms in cells
%   ncell   : num. of cells
%   cell_offset : offset of neighboring cells
%   noffset     : num. of offset
%   id_cell     : cell coordinates

cell_offset = [ 0, 0, 0;
    1, 0, 0;
    1, 1, 0;
    0, 1, 0;
    -1, 1, 0;
    0, 0, 1;
    1, 0, 1;
    1, 1, 1;
    0, 1, 1;
    -1, 1, 1;
    -1, 0, 1;
    -1, -1, 1;
    0, -1, 1;
    1, -1, 1];
noffset     = 14;

% build cell list
ncell = floor( region / rc / frc);

% cell index for each atom
id_cell = floor( atom / rc / frc) + 1;
id_cell( id_cell( :, 1) > ncell(1), 1) = ncell(1);
id_cell( id_cell( :, 1) < 1, 1)        = 1;
id_cell( id_cell( :, 2) > ncell(2), 2) = ncell(2);
id_cell( id_cell( :, 2) < 1, 2)        = 1;
id_cell( id_cell( :, 3) > ncell(3), 3) = ncell(3);
id_cell( id_cell( :, 3) < 1, 3)        = 1;

% celllist, initialize
celllist = -1 * ones( natom + prod( ncell), 1);

% assign celllist
for i = 1:natom
    % linear index
    c = (id_cell( i, 3)-1) * ncell(1) * ncell(2) + ...
        (id_cell( i, 2)-1) * ncell(1)+...
        id_cell(i, 1) + natom;

    % insert at the head of the linked list
    celllist(i) = celllist(c);
    celllist(c) = i;
end
