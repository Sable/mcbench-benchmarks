function [ind, label] = drawline(p1,p2,image_size)
%DRAWLINE Returns the geometric space (matrix indices) occupied by a line segment 
%in a MxN matrix.  Each line segment is defined by two endpoints.
%
%   IND = DRAWLINE(P1, P2, IMAGE_SIZE) returns the matrix indices
%   of the line segment with endpoints p1 and p2. 
%   If both points are out of the image boundary no line is drawn and an error will appear. 
%   If only one of the endpoints is out of the image boundary a line is still drawn.
% 
%       ARGUMENT DESCRIPTION:
%                       P1 - set of endpoints (Nx2). ([row column; ...])
%                       P2 - set of endpoints that connect to p1 (Nx2). ([row column; ...])
%               IMAGE_SIZE - vector containing image matrix dimensions,
%                            where the first element is the number of rows
%                            and the second element is the number of
%                            columns.
%
%       OUTPUT DESCRIPTION:
%                      IND - matrix indices occupied by the line segments.
%                    LABEL - label tag of each line drawn (from 1 to N).
%
% 
%       1
%    1 _|_ _ _ _> COLUMNS
%       |_|_|_|_
%       |_|_|_|_
%       |_|_|_|_
%       V
%      ROWS
% 
%   Example
%   -------------
%   BW = zeros(250,250);
%   p1 = [10 10; 23 100; -14 -40];
%   p2 = [50 50; 90 100;  50  50];
%   [ind label] = drawline(p1,p2,[250 250]); % OR ...drawline(p2,p1,...
%   BW(ind) = label;
%   figure, imshow(BW,[])
% 
% See also line, ind2sub.

% Credits:
% Daniel Simoes Lopes
% ICIST
% Instituto Superior Tecnico - Universidade Tecnica de Lisboa
% danlopes (at) civil ist utl pt
% http://www.civil.ist.utl.pt/~danlopes
%
% June 2007 original version.

% Input verification.
if max(size(p1) ~= size(p2))
    error('The number of points in p1 and p2 must be the same.')
end
if length(size(image_size)) ~= 2
    error('Image size must be bi-dimensional.')
end

% Cicle for each pair of endpoints.
ind = [];
label = [];
for line_number = 1:size(p1,1)
    
    % Point coordinates.
    p1r = p1(line_number,1);   p1c = p1(line_number,2);
    p2r = p2(line_number,1);   p2c = p2(line_number,2);
    
    % Image dimension.
    M = image_size(1); % Number of rows.
    N = image_size(2); % Number of columns.
    
    % Boundary verification.
    % A- Both points are out of range.
    if  ((p1r < 1 || M < p1r) || (p1c < 1 || N < p1c)) && ...
        ((p2r < 1 || M < p2r) || (p2c < 1 || N < p2c)),
        error(['Both points in line segment nº ', num2str(line_number),...
                ' are out of range. New coordinates are requested to fit',...
                ' the points in image boundaries.']) 
    end
    
    % Reference versors.
    % .....r..c.....
    eN = [-1  0]';
    eE = [ 0  1]';
    eS = [ 1  0]';
    eW = [ 0 -1]';
    
    % B- One of the points is out of range.
    if (p1r < 1 || M < p1r) || (p1c < 1 || N < p1c) || ...
       (p2r < 1 || M < p2r) || (p2c < 1 || N < p2c),
        % ....Classify the inner and outer point.
        if     (p1r < 1 || M < p1r) || (p1c < 1 || N < p1c)
            out = [p1r; p1c];  in = [p2r; p2c];
        elseif (p2r < 1 || M < p2r) || (p2c < 1 || N < p2c)
            out = [p2r; p2c];  in = [p1r; p1c];
        end
        % Vector defining line segment.
        v = out - in;
        aux = sort(abs(v)); aspect_ratio = aux(1)/aux(2);
        % Vector orientation.
                      north = v'*eN;
        west  = v'*eW;              east  = v'*eE;
                      south = v'*eS;
        % Increments.
        deltaNS = [];
        if north > 0, deltaNS = -1; end
        if south > 0, deltaNS =  1; end
        if isempty(deltaNS), deltaNS = 0; end
        deltaWE = [];
        if east > 0, deltaWE =  1; end
        if west > 0, deltaWE = -1; end
        if isempty(deltaWE), deltaWE = 0; end
        % Matrix subscripts occupied by the line segment.
        if abs(v(1)) >= abs(v(2))
            alpha(1) = in(1); beta(1) = in(2);
            iter = 1;
            while (1 <= alpha(iter)) && (alpha(iter) <= M) && ...
                    (1 <=  beta(iter)) && (beta(iter)  <= N),
                alpha(iter+1) = alpha(iter) + deltaNS;              % alpha grows throughout the column direction.
                beta(iter+1)  = beta(iter)  + aspect_ratio*deltaWE; % beta grows throughout the row direction.
                iter = iter + 1;
            end
            alpha = round(alpha(1:end-1)); beta = round(beta(1:end-1));
            ind = cat(2,ind,sub2ind(image_size,alpha,beta));
            label = cat(2,label,line_number*ones(1,max(size(alpha))));     
        end
        % ... 
        if abs(v(1)) < abs(v(2))
            alpha(1) = in(2); beta(1) = in(1);
            iter = 1;
            while (1 <= alpha(iter)) && (alpha(iter) <= N) &&...
                    (1 <=  beta(iter)) && (beta(iter)  <= M),
                alpha(iter+1) = alpha(iter) + deltaWE;              % alpha grows throughout the row direction.
                beta(iter+1)  = beta(iter)  + aspect_ratio*deltaNS; % beta grows throughout the column direction.
                iter = iter + 1;
            end
            alpha = round(alpha(1:end-1)); beta = round(beta(1:end-1));
            ind = cat(2,ind,sub2ind(image_size,beta,alpha));
            label = cat(2,label,line_number*ones(1,max(size(alpha))));     
        end
        clear alpha beta
        continue
    end
    % C- Both points are in range.
    in = [p1r; p1c];  out = [p2r; p2c]; % OR in = p2; out = p1;
    % Vector defining line segment.
    v = out - in;
    aux = sort(abs(v)); aspect_ratio = aux(1)/aux(2);
    % Vector orientation.
                  north = v'*eN;
    west  = v'*eW;              east  = v'*eE;
                  south = v'*eS;
    % Increments.
    deltaNS = [];
    if north > 0, deltaNS = -1; end
    if south > 0, deltaNS =  1; end
    if isempty(deltaNS), deltaNS = 0; end
    deltaWE = [];
    if east > 0, deltaWE =  1; end
    if west > 0, deltaWE = -1; end
    if isempty(deltaWE), deltaWE = 0; end
    % Matrix subscripts occupied by the line segment.
    row_range = sort([p1r p2r]);
    col_range = sort([p1c p2c]);
    if abs(v(1)) >= abs(v(2))
        alpha(1) = in(1); beta(1) = in(2);
        iter = 1;
        while (row_range(1) <= alpha(iter)) && (alpha(iter) <= row_range(2)) && ...
                (col_range(1) <=  beta(iter)) && (beta(iter)  <= col_range(2)),
            alpha(iter+1) = alpha(iter) + deltaNS;              % alpha grows throughout the column direction.
            beta(iter+1)  = beta(iter)  + aspect_ratio*deltaWE; % beta grows throughout the row direction.
            iter = iter + 1;
        end
        alpha = round(alpha(1:end-1)); beta = round(beta(1:end-1));
        ind = cat(2,ind,sub2ind(image_size,alpha,beta));
        label = cat(2,label,line_number*ones(1,max(size(alpha))));
    end
    % ... 
    if abs(v(1)) < abs(v(2))
        alpha(1) = in(2); beta(1) = in(1);
        iter = 1;
        while (col_range(1) <= alpha(iter)) && (alpha(iter) <= col_range(2)) &&...
                (row_range(1) <=  beta(iter)) && (beta(iter)  <= row_range(2)),
            alpha(iter+1) = alpha(iter) + deltaWE;              % alpha grows throughout the row direction.
            beta(iter+1)  = beta(iter)  + aspect_ratio*deltaNS; % beta grows throughout the column direction.
            iter = iter + 1;
        end
        alpha = round(alpha(1:end-1)); beta = round(beta(1:end-1));
        ind = cat(2,ind,sub2ind(image_size,beta,alpha));
        label = cat(2,label,line_number*ones(1,max(size(alpha))));
    end
    clear alpha beta
    continue
end