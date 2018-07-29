function  saveTex( outfile, matrices, name )
% function for exporting MatLab matrices to a LaTeX file in inline math
% environment as an array
% Input: 
%   matrices:   Cellarray of matrices
%   name: cellarray of names of each matrix as a string
%   outfile:    outfilename
%
% Authors: E. Boergens, A. Sausen
% Date: 19.07.2013


fid = fopen( outfile, 'w');
for a = 1:length(matrices)
    fprintf(fid, '%s\n', strcat(name{a}, '='));
    fprintf(fid, '%s', '$\left[\begin{array}');
    A = matrices{a};
    [n,m] = size(A);
    fprintf(fid, '%s\n', strcat('{', repmat('c',1, m), '}')); 
    for i = 1: n
        for j = 1:m
            fprintf(fid, '%f', A(i,j));
            if j<m
                fprintf(fid, '%s', '&');
            end
        end
        fprintf(fid, '%s\n', '\\');
    end
    
    fprintf(fid, '%s\n\n', '\end{array} \right] $');

end
fclose(fid);
end
