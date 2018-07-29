% The Routh-Hurwitz method for determining the stability of a system from
% characteristic polynomial.

% The method Routh_H requires the characteristic polynomial as input and
% has the Routh-Hurwitz array as exit and characteristics of stability.

% J. Sebastian Palacio
% jpalac13@eafit.edu.co


function Routh_H(pol)

syms e;                          % e: epsilon, which defines the symbolic variable 
                                 % that is used if is necessary to take limit 
n           = length(pol);       % n = 1 + order of transfer function
cols        = floor((n+1)/2);    % number of columns of the array
Table       = zeros(n,cols);     % Routh-Hurwitz array
unstable   = false;             
critices_est = false;             
limits      = false;             
rows       = [];                
simetric_poles = 0;            % number of simetric poles of the transfer function

if mod(n,2) == 0
    decrease = 1;
else
    decrease = 0;
end

% Assesses the necessary condition
if pol > 0
    % All the characteristic polynomial coefficients are positive
    necesary_cond = true;
else
    necesary_cond = false;
end

for i = 1:n
    Table(2-mod(i,2),floor((i+1)/2)) = pol(i);
end

colms = cols - 1;
for row = 3 : n
    for col = 1 : colms
        var = Table(row-1,1);
        if ~isnumeric(Table(row-1,1))
            var = str2num(char(Table(row-1,1)));
            % Change the data type of variable "var" from symbolic to numeric.
        end
        % Assesses the special conditions, one zero in the first column or
        % a complete row of zeros.
        if  var == 0
            if sum(Table(row-1,:)~=0) == 0
                % All elements of the row are zero
                aux  = zeros(1,cols);
                % The vector aux will serve to derive the auxiliary
                % polynomial to determine the coefficients that will
                % replace the row of zeros.
                cont = 1;
                for j = n - row + 2 : -2 : 1
                    aux(cont) = j;
                    cont = cont + 1;
                end
                Table(row-1,:) = Table(row-2,:).*aux;
                critices_est       = true;
                simetric_poles  = simetric_poles + (n - row + 2);
                rows = [rows (row-1)];
            else
                % The first element of the row is zero.
                % Change the zero by 'e'
                Table = vpa(Table);
                Table(row-1,1) = e;
                limits = true;
            end
        end
        aux_Matrix   = [Table(row-2:row-1,1),Table(row-2:row-1,col+1)];
        determinant = det(aux_Matrix);

        if isnumeric(determinant)
            determinant = roundn(determinant,-8);
        end
        
        Table(row,col) = - determinant/Table(row-1,1);
    end
    if decrease > 0
        decrease = decrease - 1;
    else
        if colms ~= 1
            colms = colms -1;
        end
        decrease = 1;
    end
end

if limits
    Table  = cell(limit(Table,e,0,'right'));
    Table1 = zeros(n,cols);
    for k = 1 : cols
        Table1(:,k) = str2num(char(Table(:,:,k)));
    end
    Table = Table1;
end

% Assesses the sufficient condition
if sum(Table(:,1) <= 0) == 0
    % All elements in the first column of the array are not negative
    sufficient_cond = true;
else
    sufficient_cond = false;
end

% Reporting results

fprintf('---------------------------------------------------------------------------------- ');
fprintf('\n                                      RESULTS                                   \n');
fprintf('---------------------------------------------------------------------------------- ');

% Reporting the necessary and sufficient conditions
if ~necesary_cond
    fprintf('\n    Not satisfied with the necessary condition.');
end

if ~sufficient_cond
    fprintf('\n    Not satisfied with the sufficient condition.');
    signs   = Table(:,1) >=  0;
    poles_RSP = 0;
    for i = 1 : n - 1
        if signs(i,1) ~= signs(i+1,1)
            poles_RSP = poles_RSP + 1;
        end
    end
    if poles_RSP > 0
        unstable = true;
    end
end

% Reporting the stability of the system
if unstable
    fprintf('\n    The system is unstable and has %i pole(s) in the RSP. \n',poles_RSP);
elseif critices_est
    fprintf('\n    The system is critically stable and has %i pole(s) in the imaginary axis . \n', simetric_poles);
else
    fprintf('\n    The system is stable. All of its poles are in the LSP.\n');
end
if isvector(rows)
    fprintf('    There were rows of zeroes in the array in the row(s) %i.\n',rows);
end
fprintf('---------------------------------------------------------------------------------- \n');

print_arrayRH(Table);

%**************************************************************************

function print_arrayRH(Matriz)

[n cols] = size(Matriz);
spaces  = '           ';
m        = 12;
if mod(n,2) == 0
    decrease = 1;
else
    decrease = 0;
end
fprintf('\n  ROUTH-HURWITZ ARRAY \n\n');
for k = 1 : n
    if (n-k) > 9
        separator = ' | ';
    else
        separator = '  | ';
    end
    fprintf(['    s^',num2str(n-k),separator])
    for j = 1:cols
        aux = num2str(Matriz(k,j));
        tam = length(aux);
        left = floor((m-tam)/2);
        rigth = m - tam - left;
        fprintf([spaces(1:left),aux,spaces(1:rigth),' | ']);
    end
    fprintf('\n')
    if decrease > 0
        decrease = decrease - 1;
    else
        if cols ~= 1
            cols = cols -1;
        end
        decrease = 1;
    end
end
