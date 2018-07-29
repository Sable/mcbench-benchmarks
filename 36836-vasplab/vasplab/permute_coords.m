function [ geometry index ] = permute_coords( geometry1, geometry2 )
%PERMUTE_COORDS Permute ions in a geometry to match another geometry.
%   [geometry,index] = PERMUTE_COORDS(geometry1,geometry2) returns a
%   geometry that is the same as geometry1 except that the order of the
%   ions has been permuted to match geometry2. That is, the ions of
%   geometry1 are reordered such that the ith ion is the ion which is
%   closest to the ith ion of geometry2.
%
%   This function is useful for setting up NEB calculations. If all ions
%   stay at their original site, PERMUTE_COORDS will generally provide the
%   correct permutation. This is also true if only one ion moves to a 
%   different site (e.g. vacancy migration). However, if more than one ion
%   moves to a different site, the results may be unexpected.
%
%   See also IMPORT_POSCAR, INTERPOLATE_POSCAR.

    reference = geometry2.coords;
    coords = geometry1.coords;
    lattice = geometry1.lattice;

    natoms = size(reference,1);
    
    A = repmat(reference,[1 1 natoms]);
    B = repmat(coords,[1 1 natoms]);
    B = permute(B,[3 2 1]);
    C = mod(B-A+0.5,1)-0.5;
    C = cellfun(@(x) sqrt(sum((lattice'*x').^2)), num2cell(C,2),'UniformOutput',true);
    C = squeeze(C); % distance matrix
    index = cellfun(@(x) find(x==min(x),1), num2cell(C,2));
    new_coords = coords(index,:);
    
    if size(index,1)~=size(unique(index),1)
        p = sort(index);
        p = p(diff(p)==0); % index of doubled atom
        if max(size(p))==1    
            j = find(index==p); % indexes of atoms which map to doubled atom 
            for i = 1:size(index,1)
               n = sum(index==i);
               if n==0
                  q = i; % index of the lost atom
               end
            end
            fprintf('One-atom migration detected.\n');
            if(C(p,j(1))<C(p,j(2)))
                new_coords(j(2),:)=coords(q,:);
                fprintf('Mapping atom %d (%f %f %f) to atom %d (%f %f %f)\n',j(2),reference(j(2),:),q,coords(q,:));
            else
                new_coords(j(1),:)=coords(q,:); 
                fprintf('Mapping atom %d (%f %f %f) to atom %d (%f %f %f)\n',j(1),reference(j(1),:),q,coords(q,:));         
            end               
            fprintf('Please check that this is correct.\n'); 
        else   
            fprintf('Warning: some atoms were lost\n')
            for i = p';
               j = find(index==i); 
               for jj = j';
               fprintf('%d (%f %f %f)',jj,reference(jj,:))
               fprintf('-> %d (%f %f %f)\n',i,coords(i,:))
               end
            end
            for i = 1:size(index,1)
               n = sum(index==i);
               if n==0
                  fprintf('%d (%f %f %f) was lost\n',i,coords(i,:))
               end
            end
        end
    end
    
    geometry = geometry1;
    geometry.coords = new_coords;
    
end

