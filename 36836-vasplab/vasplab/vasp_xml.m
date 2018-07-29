function [ result ] = vasp_xml( filename, param )
%VASP_XML Import data from a vasprun.xml file.
%   result = VASP_XML(filename,param) imports specified data from a
%   vasprun.xml file. param is a string which specifies which data should
%   be imported. Allowed values are:
%
%    'energy': energy of the last optimization step.
%    'all-energies': energy at each optimization step.
%    'nkpoints': number of k-points.
%    'volume': volume of the cell in the last optimization step.
%    'vbm-occ': valence band maximum, as determined by occupancies.
%    'cbm-occ': conduction band minimum, as determined by occupancies.
%    'vbm': valence band maximum, as determined by band-filling.
%    'cbm': conduction band minimum, as determined by band-filling.
%    'all-forces': array of forces on ions during all optimization steps.
%    'eigenvalues': array of eigenvalues.
%    'occupancies': array of occupancies.
%    'kpoints-reciprocal': coordinates of k-points in the reciprocal basis.
%    'kpoints-cartesian': coordinates of k-points in Cartesian coordinates.
%    'basis': array whose rows are the lattice vectors.
%    'dos': density of states.
%    'edos': energy at each DOS bin.
%    'pdos': partial density of states.
%    'chemical-symbols': cell array containing chemical symbols of each ion.
%    'natoms': vector containing number of ions of each type.
%    'Z': array containing valence number of each ion type.
%    'nelect': total number of electrons.
%    'ispin': 1 = non-spin-polarized, 2 = spin-polarized
%
%   n.b.: VASP_XML may run slowly if the xml file is large. In some
%   cases, it may be necessary to increase the heap space for the Java VM.
%   Read more on the <a href="matlab: 
%   web('http://www.mathworks.com/support/solutions/en/data/1-18I2C/')">MathWorks website</a>.


% to do:
% add forces, all-energies, all-eigenvalues, all-volumes, kpoints,
% ncalcs, nbands, basis, rec basis
% what happens to ispin with noncolinear calcs?
% give warnings or errors when requested data isn't in file

    import javax.xml.xpath.*
    factory = XPathFactory.newInstance;
    xpath = factory.newXPath;

    node = xmlread(filename);
    
    switch param
        case 'ispin'
            str = 'modeling/parameters/separator[@name=''electronic'']/separator[@name=''electronic spin'']/i[@name=''ISPIN'']/text()';
            expression = xpath.compile(str);
            result = str2double(expression.evaluate(node, XPathConstants.STRING));
        case 'energy'
            str = 'modeling/calculation[last()]/energy/i[@name=''e_wo_entrp'']/text()';
            expression = xpath.compile(str);
            result = str2double(expression.evaluate(node, XPathConstants.STRING)); % E0 from last iteration
        case 'all-energies'
            str = 'count(modeling/calculation)';
            expression = xpath.compile(str);
            ncalcs = expression.evaluate(node, XPathConstants.NUMBER);
            result = zeros(1,ncalcs);
            for i = 1:ncalcs
                str = sprintf('modeling/calculation[%d]/energy/i[@name=''e_wo_entrp'']/text()',i);
                expression = xpath.compile(str);
                result(i) = str2double(expression.evaluate(node, XPathConstants.STRING)); % E0 from last iteration
            end
        case 'nkpoints'
            str = 'count(modeling/kpoints[1]/varray[@name=''kpointlist'']/v)';
            expression = xpath.compile(str);
            result = expression.evaluate(node, XPathConstants.NUMBER); % nubmer of k-points
        case 'volume'
            str = 'modeling/structure[@name=''finalpos'']/crystal/i[@name=''volume'']/text()';
            expression = xpath.compile(str);
            result = str2double(expression.evaluate(node, XPathConstants.STRING)); % cell volume
        case 'vbm-occ'
            eigenvalues = vasp_xml(filename, 'eigenvalues');
            occupancies = vasp_xml(filename, 'occupancies');            
            occupied = eigenvalues(occupancies==1);
            result = max(max(occupied));
            partially_occupied = eigenvalues(rem(occupancies,1)~=0);
            if numel(partially_occupied) > 0 
                fprintf 'WARNING: system is not insulating\n';
            end
        case 'cbm-occ'
            eigenvalues = vasp_xml(filename, 'eigenvalues');
            occupancies = vasp_xml(filename, 'occupancies');            
            occupied = eigenvalues(occupancies==0);
            result = min(min(occupied));
            partially_occupied = eigenvalues(rem(occupancies,1)~=0);
            if numel(partially_occupied) > 0 
                fprintf 'WARNING: system is not insulating\n';
            end            
        case 'vbm'
            eigenvalues = vasp_xml(filename, 'eigenvalues');
            nelect = vasp_xml(filename, 'nelect');
            eigenvalues = reshape(eigenvalues,size(eigenvalues,1),[]);
            eigenvalues = sort(eigenvalues,2);
            ispin = vasp_xml(filename, 'ispin');
            result = max(eigenvalues(:,nelect/(3-ispin)));
        case 'cbm'
            eigenvalues = vasp_xml(filename, 'eigenvalues');
            nelect = vasp_xml(filename, 'nelect');
            eigenvalues = reshape(eigenvalues,size(eigenvalues,1),[]);
            eigenvalues = sort(eigenvalues,2);
            ispin = vasp_xml(filename, 'ispin');
            result = min(eigenvalues(:,nelect/(3-ispin)+1));
        case 'all-forces'
            str = 'count(modeling/structure[@name=''initialpos'']/varray[@name=''positions'']/v)';
            expression = xpath.compile(str);
            natoms = expression.evaluate(node, XPathConstants.NUMBER); 
            
            str = 'count(modeling/calculation)';
            expression = xpath.compile(str);
            ncalcs = expression.evaluate(node, XPathConstants.NUMBER);  

            result = zeros(natoms, 3, ncalcs);
            for calc = 1:ncalcs                 
                for atom = 1:natoms
                    str = ['modeling/calculation[' num2str(calc) ']/varray[@name=''forces'']/v[' num2str(atom) ']/text()'];
                    
                    expression = xpath.compile(str);
                    %result(atom,:,calc) = str2num(expression.evaluate(node, XPathConstants.STRING));
                    result(atom,:,calc) = str2num(expression.evaluate(node, XPathConstants.STRING));                                        
                end
            end          
        case 'eigenvalues'
            str = 'count(modeling/kpoints[1]/varray[@name=''kpointlist'']/v)';
            expression = xpath.compile(str);           
            nkpoints = expression.evaluate(node, XPathConstants.NUMBER);
                      
            str = 'modeling/parameters/separator[@name=''electronic'']/i[@name=''NBANDS'']/text()';
            expression = xpath.compile(str);
            nbands = str2double(expression.evaluate(node, XPathConstants.STRING));
                
            ispin = vasp_xml(filename, 'ispin');
            
            result = zeros(nkpoints,nbands,ispin);
            for kpoint = 1:nkpoints
                for band = 1:nbands
                    for spin = 1:ispin
                    str = ['modeling/calculation[last()]/eigenvalues/array/set/set[@comment=''spin ' num2str(spin) ''']/set[' num2str(kpoint) ']/r[' num2str(band) ']/text()'];
                    expression = xpath.compile(str);
                    data = str2num(expression.evaluate(node, XPathConstants.STRING));
                    result(kpoint,band,spin) = data(1);           
                    end
                end
            end
            result = sort(result,2);
         case 'occupancies'
             % these should be sorted by energy!
            str = 'count(modeling/kpoints[1]/varray[@name=''kpointlist'']/v)';
            expression = xpath.compile(str);           
            nkpoints = expression.evaluate(node, XPathConstants.NUMBER);
                      
            str = 'modeling/parameters/separator[@name=''electronic'']/i[@name=''NBANDS'']/text()';
            expression = xpath.compile(str);
            nbands = str2double(expression.evaluate(node, XPathConstants.STRING));
                
            str = 'modeling/parameters/separator[@name=''electronic'']/separator[@name=''electronic spin'']/i[@name=''ISPIN'']/text()';
            expression = xpath.compile(str);
            ispin = str2double(expression.evaluate(node, XPathConstants.STRING));
            
            result = zeros(nkpoints,nbands,ispin);
            for kpoint = 1:nkpoints
                for band = 1:nbands
                    for spin = 1:ispin
                    str = ['modeling/calculation[last()]/eigenvalues/array/set/set[@comment=''spin ' num2str(spin) ''']/set[' num2str(kpoint) ']/r[' num2str(band) ']/text()'];
                    expression = xpath.compile(str);
                    data = str2num(expression.evaluate(node, XPathConstants.STRING));
                    result(kpoint,band,spin) = data(2);           
                    end
                end
            end
        case 'kpoints-reciprocal'
            str = 'count(modeling/kpoints[1]/varray[@name=''kpointlist'']/v)';
            expression = xpath.compile(str);           
            nkpoints = expression.evaluate(node, XPathConstants.NUMBER);
            
            result = zeros(nkpoints,3);
            for kpoint = 1:nkpoints
                str = ['modeling/kpoints/varray[@name=''kpointlist'']/v[' num2str(kpoint) ']'];
                expression = xpath.compile(str);           
                result(kpoint,:) = str2num(expression.evaluate(node, XPathConstants.STRING));
            end          
        case 'kpoints-cartesian'
            kpoints = vasp_xml(filename,'kpoints-reciprocal');
            recbasis = zeros(3);
            
            for i = 1:3
                str = ['modeling/structure[@name=''finalpos'']/crystal/varray[@name=''rec_basis'']/v[' num2str(i) ']'];
                expression = xpath.compile(str);           
                recbasis(i,:) = str2num(expression.evaluate(node, XPathConstants.STRING));
            end         
            result = kpoints*recbasis;
        case 'basis'
            result = zeros(3);
            for i = 1:3
                str = ['modeling/structure[@name=''finalpos'']/crystal/varray[@name=''basis'']/v[' num2str(i) ']'];
                expression = xpath.compile(str);           
                result(i,:) = str2num(expression.evaluate(node, XPathConstants.STRING));
            end         
        case 'dos'
            str = 'modeling/parameters/separator[@name=''electronic'']/separator[@name=''electronic spin'']/i[@name=''ISPIN'']/text()';
            expression = xpath.compile(str);
            ispin = str2double(expression.evaluate(node, XPathConstants.STRING));
     
            str = 'modeling/parameters/separator[@name=''dos'']//i[@name=''NEDOS'']/text()';
            expression = xpath.compile(str);
            nedos = str2double(expression.evaluate(node, XPathConstants.STRING));
            
            result = zeros(nedos,ispin);
            
            for spin = 1:ispin
                for i = 1:nedos
                    str = ['modeling/calculation[last()]/dos/total/array/set/set[@comment=''spin ' num2str(spin) ''']/r[' num2str(i) ']/text()'];
                    expression = xpath.compile(str);                  
                    buffer = str2num(expression.evaluate(node, XPathConstants.STRING));               
                    result(i,spin) = buffer(2); % DOS
                end
            end
        case 'edos'
            str = 'modeling/parameters/separator[@name=''dos'']//i[@name=''NEDOS'']/text()';
            expression = xpath.compile(str);
            nedos = str2double(expression.evaluate(node, XPathConstants.STRING)); 
            result = zeros(nedos,1);
            for i = 1:nedos
                str = ['modeling/calculation[last()]/dos/total/array/set/set[@comment=''spin 1'']/r[' num2str(i) ']/text()'];
                expression = xpath.compile(str);
                buffer = str2num(expression.evaluate(node, XPathConstants.STRING));               
                result(i) = buffer(1); % DOS
            end
      case 'pdos'
            str = 'modeling/parameters/separator[@name=''electronic'']/separator[@name=''electronic spin'']/i[@name=''ISPIN'']/text()';
            expression = xpath.compile(str);
            ispin = str2double(expression.evaluate(node, XPathConstants.STRING));
     
            str = 'modeling/parameters/separator[@name=''dos'']//i[@name=''NEDOS'']/text()';
            expression = xpath.compile(str);
            nedos = str2double(expression.evaluate(node, XPathConstants.STRING));
            
            str = 'count(modeling/calculation[last()]/dos/partial/array/set/set)';
            expression = xpath.compile(str);
            natoms = expression.evaluate(node, XPathConstants.NUMBER);
            
            nentries = 9; % number of projected spherical harmonics
            result = zeros(nedos,ispin,natoms,nentries);
            
            for atom = 1:natoms
                for spin = 1:ispin
                    for i = 1:nedos
                        str = ['modeling/calculation[last()]/dos/partial/array/set/set[@comment=''ion ' num2str(atom) ''']/set[@comment=''spin ' num2str(spin) ''']/r[' num2str(i) ']/text()'];
                        expression = xpath.compile(str);
                        buffer = str2num(expression.evaluate(node, XPathConstants.STRING));                        
                        buffer = reshape(buffer,[1 1 1 nentries+1]);
                        result(i,spin,atom,:) = buffer(2:end); % PDOS
                    end
                end
            end
        case 'chemical-symbols'
            str = 'modeling/atominfo/atoms';
            expression = xpath.compile(str);
            natoms = str2double(expression.evaluate(node, XPathConstants.STRING));
            result = cell(1,natoms);        
            for i = 1:natoms
                str = ['modeling/atominfo/array[@name=''atoms'']/set/rc[' num2str(i) ']/c[1]'];
                expression = xpath.compile(str);
                result{i} = expression.evaluate(node, XPathConstants.STRING);                
            end
        case 'natoms'          
            str = 'modeling/atominfo/array[@name=''atomtypes'']/set/rc';
            expression = xpath.compile(str);
            data = expression.evaluate(node, XPathConstants.NODESET);
            result = zeros(1,data.getLength);
            for atomtype = 0:(data.getLength-1)
               result(atomtype+1) = str2double(data.item(atomtype).item(0).item(0).getTextContent); % # of atoms of this type
            end
        case 'Z'          
            str = 'modeling/atominfo/array[@name=''atomtypes'']/set/rc';
            expression = xpath.compile(str);
            data = expression.evaluate(node, XPathConstants.NODESET);
            result = zeros(1,data.getLength);
            for atomtype = 0:(data.getLength-1)
                 result(atomtype+1) = str2double(data.item(atomtype).item(3).item(0).getTextContent); % # of valence electrons
            end     
        case 'nelect'
            str = 'modeling/parameters/separator[@name=''electronic'']/i[@name=''NELECT'']/text()';
            expression = xpath.compile(str);
            result = str2double(expression.evaluate(node, XPathConstants.STRING));
    end
end

