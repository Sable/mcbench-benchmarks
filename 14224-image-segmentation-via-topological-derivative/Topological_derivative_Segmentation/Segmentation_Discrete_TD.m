function [ imOut ] = Segmentation_Discrete_TD( imIn, rho, cls, perc, clsOpt, Tol)
% Segmentation_Discrete_TD segmentates an image using the Discrete
% Topological Derivative algorithm. The main idea behind this algorithm is
% to compute the topological derivative for an appropriate functional 
% and a perturbation given by changing the class that a particular
% pixel is segmented in from one class to another in the set cls. This derivative is used 
% as an indicator function to find the best class that each pixels should be 
% classified in (see references in 'references.txt' file).
% The associated parameters are:
% imIn = Image to be segmented.
% rho = used to weigth both terms in the cost function.
% cls = The classes to segment the image, it might be either the number of
% classes or the classes itself.
% perc = (Optional) Percentage of pixels to be reclassified in each
% iteration.
% optCls = (Optional) true to optimize classes values.
% Tol = (Optional) A small values used to stop the algorithm
% 
% LNCC - Laboratório Nacional de Computação Científica.
% Petrópolis, RJ, Brazil, March 2007.
% 
% Permission to use for evaluation purposes is granted provided that 
% proper acknowledgments are given. For a commercial licence, contact 
% nacho@lncc.br or feij@lncc.br.
% 
% This software comes with no warranty, expressed or implied. By way of
% example, but not limitation, we make no representations of warranties
% of merchantability or fitness for any particular purpose or that the
% use of the software components or documentation will not infringe any
% patents, copyrights, trademarks, or other rights.
% 
% The remaining files are copyright Ignacio Larrabide. Permission is
% granted to use the material for noncommercial and research purposes.
% 

    disp('Image segmentation based on the discrete topological derivative.');
% Total number of finite elements in the image. Mesh nodes are centered in
% the image pixels centers.
	[n,m] = size(imIn);
    imIn = double(imIn);
    if ~exist('rho')
        rho = 0.85;
    end
    if ~exist('cls')
        cls = 3;
    end
    mn = min(min(imIn));
    mx = max(max(imIn));
    if (mn - mx)==0
        error('Image has no information to be segmented!.');
    end
    if length(cls) == 1
        clsVals = mn:(mx-mn)/(cls-1):mx;
        cls = clsVals;
    end
    if ~exist('perc')
        perc = 0.5;
    end
    if ~exist('optCls')
        optCls = true;
    end
    if ~exist('Tol')
        Tol = 0.1;
    end
    if optCls
        clsOrg = cls;
    end
% Normailize image and classes values to [0, 1]
    v = Normalize(imIn, mx, mn);
    cls = Normalize(cls, mx, mn);
% Initial guess    
    u = cls(1) * ones(n, m);
% COmpute the total variation for the initial guess.
    [fcTmp, DT] = TotalVariation(u, v, rho, cls);
    minGT = min(min(min(DT)));
    it = 1;
    fc = [inf, fcTmp];
    disp('Iterative process started...');
	while (abs(fc(it+1)-fc(it))>Tol || minGT < 0)
% Fixed point algorithm
        [GT, ind] = min(DT, [], 3);
        gradconfC = reshape(GT, n*m, 1);
        indCol = reshape(ind, n*m, 1);
        [gradSort,jSort] = sort(gradconfC);
% Find the pixels that have negative dtopological derivative.
        j = find(gradconfC < 0);
        Nchange = round(length(j) * perc);
% Take the class that produced the smaller value for each pixel.
        u(jSort(1:Nchange)) = cls(indCol(jSort(1:Nchange)));
% Optimize the classes values?
        if optCls
            u = (u * (mx - mn)) + mn;
            cls = (cls * (mx - mn)) + mn;
            [ clsN, vsN] = AdjustClassesValuesDisc( cls, u, imIn);
            u = Normalize( vsN, mx, mn);
            cls = Normalize( clsN, mx, mn);
        end
% Compute the total variation for the current segmented image.
        [fcTmp, DT] = TotalVariation(u, v, rho, cls);
        minGT = min(min(min(DT)));
%         deltaFC = abs(fcout(length(fcout)) - fcoutTmp);
        fc = [fc, fcTmp];
        if ~mod(it,5)
            disp(sprintf('Currently at iteration %d.',it));
        end
        it = it + 1;
    end
% Restore original intensities.    
    u = (u * (mx - mn)) + mn;
    cls = (cls * (mx - mn)) + mn;
    imOut = uint8(u);
    disp(sprintf('Done in %d iterations.',it - 1));
    if optCls
        disp('Class values optimization was used, initial classes values:');
        disp(clsOrg);
        disp('Optimized values');
        disp(cls);
    end


function [fc, DT] = TotalVariation(u, v, rho, cls)
	[n,m] = size(u);
% old contains the (v-u)^2, used later for the topological derivative
% computation.
	old = reshape((v-u).*(v-u), n, m, 1); 
% DT initially zero.
	DT = zeros(n, m, length(cls)); 
	DistanceVariation = zeros(n, m, length(cls)); 
% Compute the sensitivity of changing, for each pixel, from class i to c.
	c = 1; 
	for i = cls
% In DT(:,:,c) we have the first term of the sensitivity (distance between 
% classes intensities).
        new = reshape((v-i).*(v-i), n, m, 1);
        DistanceVariation(:,:,c) = new - old;
        c = c + 1;
	end
% How many neighbour have the same class?.       
% the variables hold (by pixel):
% NeighboursVariation = Qtt of neighbours different for each class.
	[NeighboursVariation, nNeighs] = NeighsVariation(u, v, cls);
% Compute the topological derivative.
	DT = (rho) * DistanceVariation + (1-rho) * NeighboursVariation;
% Compute the cost function value.
	fd = rho * sum(sum(old));
	fb = (1-rho) * sum(sum(nNeighs));
	fc = fb + fd;

function [NeighboursVariation, nNeighs] = NeighsVariation(u, v, cls)

% nNeighsCls = for each class, how many neighbour of that class.
% nNeighs = Qtt of neighbours of the same class.
	[n,m] = size(v); 
% For each pixel, the number of neighbours with the same class.	
	nNeighs = zeros(size(v)); 
% Neighbours with the same class for each class.
	nNeighsCls = zeros(n, m, length(cls));
% Look to the right.
	tmp = 2*max(max(abs(u)))*ones(size(v)); 
	tmp(:,1:m-1) = u(:,2:m); 
% For each class.
	c = 1;
	for i = cls
        I = find(tmp~=i); 
        tmp2 = zeros(size(v)); 
        tmp2(I) = 1; 
        nNeighsCls(:,:,c) = nNeighsCls(:,:,c) + tmp2;
        c = c + 1; 
	end
	tmp(:,1:m-1) = u(:,1:m-1) - tmp(:,1:m-1); 
	I = find(tmp~=0); 
% Add one to the cell if the neighbour to the right is of the same class.
	nNeighs(I) = nNeighs(I) + 1;
% Look to the left.
	tmp = 2*max(max(abs(u)))*ones(size(v));
	tmp(:,2:m) = u(:,1:m-1);
% For each class.
	c = 1;
	for i = cls
        I = find(tmp~=i); 
        tmp2 = zeros(size(v)); 
        tmp2(I) = 1; 
        nNeighsCls(:,:,c) = nNeighsCls(:,:,c) + tmp2;
        c = c + 1; 
	end
	tmp(:, 2:m) = u(:, 2:m) - tmp(:, 2:m); 
	I = find(tmp~=0); 
% Add one to the cell if the neighbour to the left is of the same class.
	nNeighs(I) = nNeighs(I)+1;
% Look up.
	tmp = 2*max(max(abs(u)))*ones(size(v)); 
	tmp(1:n-1,:) = u(2:n,:); 
% For each class.
	c = 1;
	for i = cls
        I = find(tmp~=i); 
        tmp2 = zeros(size(v)); 
        tmp2(I) = 1; 
        nNeighsCls(:,:,c) = nNeighsCls(:,:,c) + tmp2;
        c = c + 1; 
	end
	tmp(1:n-1,:) = u(1:n-1,:) - tmp(1:n-1,:); 
	I = find(tmp~=0); 
% Add one to the cell if the neighbour up is of the same class.
	nNeighs(I) = nNeighs(I) + 1;
% Look down.
	tmp = 2*max(max(abs(u)))*ones(size(v)); 
	tmp(2:n,:) = u(1:n-1,:); 
% For each class.
	c = 1;
	for i = cls
        I = find(tmp~=i); 
        tmp2 = zeros(size(v)); 
        tmp2(I) = 1; 
        nNeighsCls(:,:,c) = nNeighsCls(:,:,c) + tmp2;
        c = c + 1; 
	end
	tmp(2:n,:) = u(2:n,:)-tmp(2:n,:); 
	I = find(tmp~=0); 
% Add one to the cell if the neighbour down is of the same class.
	nNeighs(I) = nNeighs(I)+1;
% For each class.
	c = 1; 
% Save in NeighboursVariation the number of neighbours that have a
% different class.
	for i = cls
        NeighboursVariation(:,:,c) = nNeighsCls(:,:,c) - nNeighs;
        c = c + 1; 
	end
	NeighboursVariation = NeighboursVariation / 4;
    
    
function [ cn , un] = AdjustClassesValuesDisc( co, us, v)
% AdjustClassesValues Adjust classes values in each iteration.
    cn = [];
    for c = co
        fcvd = inf; fcvi = inf;
        cl = c; ci = c;
        fcvo = sum(sum((us-v).*(us-v)));
        cl =  min(min(us));
        if c > min(min(us))-1
            cl =  c - 1;
            tmp = us;
            I = find(tmp==c);
            tmp(I) = cl;
            fcvd = sum(sum((tmp-v).*(tmp-v)));
        end
        ci =  max(max(us));
        if c < max(max(us))+1
            ci =  c + 1;
            tmp = us;
            I = find(tmp==c);
            tmp(I) = ci;
            fcvi = sum(sum((tmp-v).*(tmp-v)));
        end
        
        fct   = [fcvd, fcvo, fcvi];
        ct    = [  cl,    c,   ci];
        [m,i] = min(fct);        
        cn    = [cn ct(i)];
    end

    % salvo en un la imagem con los valores de las nuevas clases
    un = us;
    for i= 1:length(co)
        I = find (us==co(i));
        un(I) = cn(i);
    end

function v = Normalize(u,max,min)
    v = (u - min)./(max - min);