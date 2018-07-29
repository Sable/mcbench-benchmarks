function [operator_pt]=pt(operator, partition, dimensions)
%returns the partial transpose of the operator 'operator' with respect to 
%the particles indicated by a one in the binary vector 'partition'.
%the optional parameter 'dimensions' includes the dimensions of the systems
%in array form. per default, it is assumed that each system is a qubit.

%otherwise, number of systems is given by the length of 'dimensions'
n=size(partition);
n=n(2);

if (nargin == 2) 
    %if 'dimensions' are not given, assume qubits, i.e. always dimension 2
    dimensions = 2*ones(1,n);
else
    %throw an error if 'partion' and 'dimensions' have different length
    if (max(size(partition) ~= size(dimensions))==1)
        error('partition array and dimensions have different length');
    end
end

%throw an error if 'operator' is not a square matrix
opdims=size(operator);
if (opdims(1) ~= opdims(2))
    error('first argument is no square matrix');
end

%throw an error if 'operator' is not hermitian (within a certain precision)
if (max(max(abs(ctranspose(operator)-operator))) > 1e-12)
    error('first argument is not hermitian');
end

%throw an error if any value in 'dimensions' is smaller than two
if (min(dimensions)<2)
    error('dimensions must be larger than 1');
end


if (max(dimensions)==min(dimensions))
    %if all particles have the same dimension, we can simply use another
    %numerical system, e.g. the binary system. this speeds things up when
    %compared to the case in which the systems have different dimensions
    
    %obtain the dimensionality of each system (equals the first system's
    %dimensionsality, since all are the same)
    dim = dimensions(1);
    
    %throw an error if operator dimensions do not match the length of
    %'partition'
    if (opdims(1) ~= dim^n)
        error('operator dimensions do not match the partition array');
    end
    
    %******************* this is the main part *******************
    %start with the zero matrix to build up the partially transposed
    %operator
    oppt = zeros(dim^n,dim^n);
    
    %define the identity on the space of 'operator'
    id=eye(size(operator));
    
    for rowind=1:opdims(1) %loop through rows ...
        for colind=(rowind+1):opdims(2) %... and columns of the operator
                               %due to hermiticity and invariance of trace 
                               %under partial transpose, only loop through 
                               %upper right half
            col=dec2base(colind-1,dim,n); %determine current row and ...
            row=dec2base(rowind-1,dim,n); %column index in the base given by
                                      %'dimensions'
            
            %determine new row and column index by transposing the systems
            %indicated by 'partition'
            
            %for the new column index, take the ith digit from col if 
            %partition(i) is zero. if partition(i) is one, take the ith
            %digit of row ...
            newcol=transpose((1-partition(:)).*str2num(col(:))+partition(:).*str2num(row(:)));
            %... and vice versa for the new row index
            newrow=transpose((1-partition(:)).*str2num(row(:))+partition(:).*str2num(col(:)));
            
            %note that newrow and newcol are row vectors. therefore,
            %convert them into strings and drop the white spaces
            newcol=strrep(num2str(newcol),' ','');
            newrow=strrep(num2str(newrow),' ','');
            
            %convert row and column index back into the decimal system
            newcolind=base2dec(newcol,dim)+1;
            newrowind=base2dec(newrow,dim)+1;
            
            %add the matrix element on its new place to oppt 
            oppt=operator(rowind,colind)*(id(:,newrowind)*id(newcolind,:))+oppt;
        end
    end
    
    %add elements due to hermiticity
    oppt=oppt+ctranspose(oppt);
    %add diagonal elements (which did not change through the partial
    %transposition)
    oppt = oppt + diag(diag(operator));
    
else 
    %if the system has different dimensions, the program is a bit more complex
    %and slower
    
    %throw an error if operator dimensions do not match the length of
    %'partition'
    if (opdims(1) ~= prod(dimensions))
        error('operator dimensions do not match the partition array');
    end
    
    %******************* this is the other main part *******************
    
    %start with the zero matrix to build up the partially transposed
    %operator
    oppt = zeros(size(operator));
    
    %define the identity on the space of 'operator'
    id=eye(size(operator));
    %define the n x n - identity
    idnxn=eye(n,n);
    
    %to loop through all matrix elements of 'operator', we need to create
    %the indices strings of the basis vectors in the usual notation. now, 
    %however, the different digits run from zero to the corresponding 
    %system's dimension (minus one), which differs from system to system.
    indices=zeros(n,1); %first index has only zeros
    
    for k=1:opdims(1) %loop through whole matrix 'operator'
        inddims=size(indices); 
        last = indices(:,inddims(2)); %get the last index string

        for l=n:-1:1 %loop through digits of last index string
            if (last(l) < dimensions(l)-1) %the first digit from the right
                                           %which is still smaller than the
                                           %dimension (minus one) ...
                newvec=last+idnxn(:,l); %... must be increased by one ...
                newvec=newvec.*(vertcat(ones(l,1),zeros(n-l,1))); % ... and
                                       %all digits to the right set to zero
                indices=horzcat(indices,newvec); %append new index string
                break;
            end
        end
    end
        
    for rowind=1:opdims(1) %loop through rows ...
        for colind=(rowind+1):opdims(2) %... and columns of the operator
                               %due to hermiticity and invariance of trace 
                               %under partial transpose, only loop through 
                               %upper right half
            col=indices(:,colind); %write current row and ...
            row=indices(:,rowind); %column index as index string.
                                   %this time, row and col are column
                                   %vectors
            
            %determine new row and column index by transposing the systems
            %indicated by 'partition'
            
            %for the new column index, take the ith digit from col if 
            %partition(i) is zero. if partition(i) is one, take the ith
            %digit of row ...
            newcol=transpose((1-partition(:)).*col(:)+partition(:).*row(:));
            %... and vice versa for the new row index
            newrow=transpose((1-partition(:)).*row(:)+partition(:).*col(:));
            
            %since newrow and newcol are row vectors denoting an index
            %string, we need to convert them back to a decimal number that
            %denotes the element's new position
            newcolind=find(ismember(transpose(indices),newcol,'rows'));
            newrowind=find(ismember(transpose(indices),newrow,'rows'));
           
            %add the matrix element on its new place to oppt 
            oppt=operator(rowind,colind)*(id(:,newrowind)*id(newcolind,:))+oppt;
        end
    end
    
    %build the partial transpose of 'operator'
    %elements that used to be in the upper right half
    %oppt=full(sparse(colarray,rowarray,valarray,dim^n,dim^n,((dim^n)^2)/2-(dim^n)/2));
    %add elements due to hermiticity
    oppt=oppt+ctranspose(oppt);
    %add diagonal elements (which did not change through the partial
    %transposition)
    oppt = oppt + diag(diag(operator));
end

operator_pt=oppt;