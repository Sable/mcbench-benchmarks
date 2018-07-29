function varargout = draw_clline(fig, pts, clr, cl, varargin)
% varargout = draw_clline(fig, pts, clr, cl, varargin)
% draws boundaries of polygonal lines into picture matrix (figure)
% cl == 0 not closed, cl == 1 closed but no centroid, cl == 2 closed and centroid
% varargin = 'bndry' then varargout = bndry

    a = size(pts, 1);
    b = size(pts, 2);
    if b == 2
        % closed contour?
        if cl == 1 || cl == 2
            % first point = last point
            pts(a+1, :) = pts(1, :);
            a = a+1;
            plus = 14; % number of points needed for the cross
        else
            plus = 0;
        end

        % NOP needed and Vector
        NOPs = zeros(a-1,1);
        m = zeros(a-1,2);
        dy = pts(2:a,1)-pts(1:a-1,1);
        dx = pts(2:a,2)-pts(1:a-1,2);
        NOPs = ceil(max(abs([dy,dx]),[],2));
        NOP = sum(NOPs);
        Bndry = zeros(NOP+plus, 2);

        % Lines 
        now = 1;
        for s = 1:a-1
            g = (0:NOPs(s)-1)';
            Bndry(now:now-1+NOPs(s), 1) = pts(s,1)+dy(s)/NOPs(s).*g;
            Bndry(now:now-1+NOPs(s), 2) = pts(s,2)+dx(s)/NOPs(s).*g;
            now = now+NOPs(s);
        end

        % Cross on Centroid
        mat = [-3,-2,-1,0,1,2,3];
        if cl == 2
            cent = [mean(Bndry(:,1)), mean(Bndry(:,2))];
            Bndry(NOP+1:NOP+7, 1) = cent(1)+mat(1:7);
            Bndry(NOP+1:NOP+7, 2) = cent(2);
            Bndry(NOP+8:NOP+14, 1) = cent(1);
            Bndry(NOP+8:NOP+14, 2) = cent(2)+mat(1:7);
        end

        if nargin > 4
            if strcmp(varargin, 'bndry');
                varargout = {Bndry};
            else
                error('varargin not known')
            end 
        else
            varargout = {draw_bndry(fig, Bndry(:,1), Bndry(:,2), clr)};
        end
    end
end


