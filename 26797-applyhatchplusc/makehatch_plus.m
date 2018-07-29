function A = makehatch_plus(hatch,n)
%MAKEHATCH_PLUS Predefined hatch patterns
%
% Modification of MAKEHATCH to allow for selection of matrix size. Useful whe using 
%   APPLYHATCH_PLUS with higher resolution output.
%
% input (optional) N    size of hatch matrix (default = 6)
%
%  MAKEHATCH_PLUS(HATCH,N) returns a matrix with the hatch pattern for HATCH
%   according to the following table:
%      HATCH        pattern
%     -------      ---------
%        /          right-slanted lines
%        \          left-slanted lines
%        |          vertical lines
%        -          horizontal lines
%        +          crossing vertical and horizontal lines
%        x          criss-crossing lines
%        .          single dots
%
%  By default the lines are of uniform thickenss. hatch patterns line
%  thickness can be modified using a direct call to MAKEHATCH_PLUS using
%  the following syntax: makehatch_plus('HHn',m) where;
%       HH 	the hatch character written twice, '//', '\\', '||', '--', '++'
%       n   integer number for thickness
%       m   integer number for the matrix size (n<=m)
%   Ex. makehatch_plus('\\4',9)
%
%  See also: APPLYHATCH_PLUS and APPLYHATCH_PLUSC

%  By Ben Hinkle, bhinkle@mathworks.com
%  This code is in the public domain. 

% Modified Brian FG Katz    8-aout-03
% Modified Brian FG Katz    21-sep-11
%   Variable line thickness

if nargin == 1, n = 6; end
n=round(n);

if length(hatch)>1,
    if length(hatch)==2,
        thick = n;
    else
        thick = str2num(hatch(3:end))    ;
        if thick > n,
            warning('APPLYHATCH_PLUS: hatch thicnkess thicker than hatch cell size, truncating.')
            thick = n;
        elseif thick < 0,
            warning('APPLYHATCH_PLUS: hatch thicnkess less than zero, ignoring.')
            thick = n;
        elseif thick == n,
            warning('APPLYHATCH_PLUS: hatch thicnkess equals cell size, will result in solid fill.')
        end
        hatch = hatch(1:2);
    end
end

A=zeros(n);
switch (hatch)
 case '/'
  A = fliplr(eye(n));
 case '\'
  A = eye(n);
 case '|'
  A(:,1) = 1;
 case '-'
  A(1,:) = 1;
 case '+'
  A(:,1) = 1;
  A(1,:) = 1;
 case 'x'
  A = eye(n) | fliplr(diag(ones(n-1,1),-1));
 case '.'
  A(1:2,1:2)=1;
 case '\\'
     for LOOP1=0:ceil((n- 1 - (n-thick) )/2),
         for LOOP2=1:n,
             cur_id = LOOP1+LOOP2;
             if cur_id > n,
                 cur_id = cur_id-n;
             end
             A(cur_id,LOOP2)=1;
         end;
     end;
     for LOOP1=0:floor((n- 1 - (n-thick) )/2),
         for LOOP2=1:n,
             cur_id = LOOP1+LOOP2;
             if cur_id > n,
                 cur_id = cur_id-n;
             end
             A(LOOP2,cur_id)=1;
         end;
     end;
 case '//'
     A = makehatch_plus(['\\' num2str(thick)],n);
     A = fliplr(A);
 case '||'
     A(:,1:thick)=1;
 case '--'
     A(1:thick,:)=1;
 case '++'
     A(:,1:thick)=1;
     A(1:thick,:)=1;
 otherwise
  error(['Undefined hatch pattern "' hatch '".']);
end