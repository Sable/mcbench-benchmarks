function [qlt, scl, rot, xpk, ypk] = gfht(src, patt, rhorange, thetarange, kwidth, varargin)
%
% [qlt, scl, rot, varargout] = GFHT(src, patt, rhorange, thetarange, kwidth, varargin)
% This function implements the generalized fuzzy Hough transform looking 
% for the best pattern mathing on the source image.
%
% src:      source image (bitmap)
% patt:     R-table including the points for the searched pattern
% rhorange: value range for the radius of the pattern
% thetarange: value range for the angle of rotation of the pattern
% kwidth:   kernel width to be considered for the fuzzy transform. It is
%           centered on the feature line to get the fuzzy Hough accumulator
% varargin{1}: debug flag
% qlt:      quality ratio estimated for the best match
% scl:      best pattern scale (rho) for the best match
% rot:      best pattern rotation angle (theta) for the best match
% xpk:      x-axis coordinate for the center of the best matching pattern
% ypk:      y-axis coordinate for the center of the best matching pattern
%
% Copyright (c) 2010 by Pau Micó

dbflag = false;
if nargin > 5
    dbflag = varargin{1}; % debug flag
end

I = imread([src '.bmp']);
I = adapthisteq(I, 'NumTiles',[3 3], 'ClipLimit',0.015, ...
      'Distribution','uniform', 'Range','full');                            % histogram equalization
thr = [0 (mean(I(:))-double(min(I(:))))/double(max(I(:)))];
E = edge(I, 'canny', thr, 1.5);
E = cedge(E, 8);                                                            % clears unimportant edges

if mod(kwidth, 2) == 0
    kwidth = kwidth + 1;
end
fuzz = ones(kwidth, kwidth);
fdim = floor(kwidth/2);
for i = 2:fdim+1
    fuzz(i:end-i+1, i:end-i+1) = i;
end

if dbflag
    hdl = figure;
end
x = patt(:,1);
y = patt(:,2);
xpk = [];
ypk = [];
acc = [];
scl = [];
rot = [];
qlt = [];
% mmatch = [];
[theta, rho] = cart2pol(x, y);
[Ey Ex] = find(E == true);
for r = 1:length(rhorange)
    rho1 = rho * rhorange(r);
    for t = 1:length(thetarange)
        theta1 = theta + thetarange(t);
        [x1, y1] = pol2cart(theta1, rho1);
        x1 = round(x1);
        y1 = round(y1);
        pad = max(max(abs([x1 y1])));
        accum = padarray(zeros(size(E)), [pad+fdim pad+fdim]);
        for i=1:length(Ex)
            for j=1:length(patt)
                x0 = Ex(i) - x1(j) + pad + fdim;
                y0 = Ey(i) - y1(j) + pad + fdim;
                accum(y0-fdim:y0+fdim,x0-fdim:x0+fdim) = ...
                    accum(y0-fdim:y0+fdim,x0-fdim:x0+fdim) ...
                    + fuzz;
            end
        end
        pks = houghpeaks(accum);                                       % finding local maxima
        xpk = [xpk; pks(1,2)- pad - fdim];
        ypk = [ypk; pks(1,1)- pad - fdim];
        acc = [acc; accum(pks(1,1),pks(1,2))];
        scl = [scl; rhorange(r)];
        rot = [rot; thetarange(t)];
        
%         % quality estimator 1: we obtain all the possible pixels for the pattern
%         % we suppose the maximum fuzzy kernel value for the patt points
%         % and the minimum (1) for the other points
%         cpatt = [x1 y1; x1(1) y1(1)]; % circular buffer: we repeat the first point at the end
%         newpatt = [];
%         for w = 1:length(cpatt)-1
%             [slp, int, pxs] = pline(cpatt(w,:), cpatt(w+1,:), cpatt(w,:), cpatt(w+1,:));
%             newpatt = [newpatt; pxs(1:end-1,:)];
%         end
%         mmatch = [mmatch; (length(newpatt) - length(patt)) + length(patt) * (fdim + 1)]; % perfect matching
        
        if dbflag
            figure(hdl);
            plot([x; x(1)], [y; y(1)], 'x-r'); hold on;
            plot([x1; x1(1)], [y1; y1(1)], '.-b', 'LineWidth',2); hold off;
            axis ij;
            axis([min([x; x1]) max([x; x1]) min([y; y1]) max([y; y1])]);
            title('patterns');
            legend('original', 'transformed', 'Location', 'BestOutside');
            % click(accum, 'HT space');
        end
    end
end
if dbflag
    close(hdl);
end


[sacc, ind] = sortrows(acc, -1);
xpk = xpk(ind(1));
ypk = ypk(ind(1));
scl = scl(ind(1));
rot = rot(ind(1));
mmatch = length(patt)*sum(diag(fuzz));                                      % perfect fuzzy matching (maximum match)
qlt = ceil(100 * (sacc(1) / mmatch));

% plots
click(255*uint8(E)+I, [src ' - gfHt (' num2str(qlt) '%)']);
hold on;
plot(xpk, ypk, '.r', 'LineWidth',2);
rho1 = rho * scl;
theta1 = theta + rot;
[x1, y1] = pol2cart(theta1, rho1);
plot([x1; x1(1)] + xpk, [y1; y1(1)] + ypk, '.-r', 'LineWidth',2);
hold off;