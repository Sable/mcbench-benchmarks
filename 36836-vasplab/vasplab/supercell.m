function [ geo2 ] = supercell( geo1, array )
%SUPERCELL Create a supercell by replicating a geometry.
%   geometry2 = SUPERCELL(geometry1,array) generates a new geometry that is
%   an array(1) x array(2) x array(3) supercell of geometry1.
%
%   See also IMPORT_POSCAR.

    geo2 = geo1;
    geo2.coords = [];
    
    for i = 1:numel(geo1.atomcount)
      for a1 =-(array(1)-1)/2:(array(1)-1)/2
          for a2 =-(array(2)-1)/2:(array(2)-1)/2
               for a3 =-(array(3)-1)/2:(array(3)-1)/2
                  start = sum(geo1.atomcount(1:i-1))+1;
                  geo2.coords = [geo2.coords; geo1.coords(start:start+geo1.atomcount(i)-1,:)+repmat([a1 a2 a3],geo1.atomcount(i),1)];
                 
              end
          end
      end        
    end
    
    geo2.atomcount = geo1.atomcount*prod(array);
    for i = 1:3
        geo2.coords(:,i) = geo2.coords(:,i)/array(i);
        geo2.lattice(i,:) = geo2.lattice(i,:)*array(i);
    end
end

