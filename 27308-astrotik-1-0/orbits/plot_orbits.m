% ASTROTIK by Francesco Santilli
% R2BP (Restricted Two Bodies Problem)
%
% Usage: plot_orbits(orbits)
%        plot_orbits(orbits,f012)
%        plot_orbits(orbits,[],mode)
%        plot_orbits(orbits,[],[],colors)
%        plot_orbits(orbits,[],[],[],names)
%        plot_orbits(orbits,[],[],[],[],ha)
%        [h,ha] = plot_orbits(...)
%
% where: orbit(k,1:5) = [p e i o w] = 3d orbit elements
%        orbit(k,1:3) = [p e w]     = 2d orbit elements
%           p = semi-latus rectum [L] (p>0)
%           e = eccentricity [-] (e>=0)
%           i = inclinaion [rad]
%           o = raan [rad]
%           w = argument of perifocus [rad]
%        f012(k,:) = [f0 f1 f2] = now/start/end true anomalies [rad]
%                                 (-pi<f1<f0<f2<3*pi) (NaN for auto)
%        mode(k) = graphical highlight [logical]
%        colors(k,:) = [R G B] plot color (0-1)
%        names(k,:) = orbit string name
%        h(k,:) = plot handles
%        ha = axes handle

function [h,ha] = plot_orbits(orbits,f012,mode,colors,names,ha)

    if (nargin < 1) || (nargin > 6)
        error('Wrong number of input arguments.')
    end
    
    [K,D] = check(orbits,2);
        
    if nargin < 6
        ha = 0;
    elseif isempty(ha)
        ha = 0;
    end
    
    if nargin < 5
        names = [ones(K,1)*'Orbit ' num2str((1:K)')];
    elseif isempty(names)
        names = [ones(K,1)*'Orbit ' num2str((1:K)')];
    end
    
    if nargin < 4
        colors = hsv(K);
    elseif isempty(colors)
        colors = hsv(K);
    end
                
    if nargin < 3
        mode = false(K,1);
    elseif isempty(mode)
        mode = false(K,1);
    end
    
    if nargin < 2
        f012 = nan(K,3);
    elseif isempty(f012)
        f012 = nan(K,3);
    end
    
    check(f012,2)
    check(colors,2)
    check(ha,0)
    
    if ~(D==3 || D==5)
        error('Wrong size of input arguments.')
    end
    d3 = (D==5);
    
    if ~(isa(mode,'logical'))
        error('Wrong class of input arguments.')
    end
            
    if ~(length(mode)==K && all(size(f012) == [K 3])...
            && all(size(colors) == [K 3]))
        error('Wrong size of input arguments.')
    end
    
    if ~all(all(colors>=0 & colors<=1))
        error('Wrong color format.')
    end
    
    f0 = mod(f012(:,1)+pi,2*pi)-pi;
    f12 = f012(:,2:3);
    if any(-pi>f12(:,1) | f12(:,1)>f0 | f0>f12(:,2) | f12(:,2)>3*pi)
        error('-pi < f1 < f0 < f2 < 3*pi')
    end
    
    p = orbits(:,1);
    e = orbits(:,2);
    if d3
        w = orbits(:,5);
    end
    
    if any(p <= 0)
        error('p must be a stricly positive value.')
    end
    
    if any(e < 0)
        error('e must be a positive value.')
    end
    
    for k = 1:K
        if e(k)>1
            fmax = acos(-1/e(k));
            if (f12(k,1)<-fmax || f12(k,2)>fmax || f0(k)<-fmax || f0(k)>fmax)
                error('f012 out of the hyperbolic range.')
            end
        end
    end
        
    % plot resolution
    ra = zeros(1,K);
    for k = 1:K
        if e(k)<1
            ra(k) = p(k)/(1-e(k));
        end
    end
    z = max( max(p)*2, max(ra)*1.1 );
    d = z*2;
    dz = z/1000;
                
    % graphic settings
    if ~ha
        hf = figure('name','Orbits Plot');
        if d3
            set(hf,'Color','k')
            plot3(0,0,0,'oy');
            zlabel('x_{3} [L]');
            if all(all(isnan(f12)))
                axis([-z z -z z -z z]);
            end
        else
            plot(0,0,'oy');
            if all(all(isnan(f12)));
                axis([-z z -z z]);
            end
        end
        hold on
        ha = gca;
        set(ha,'Color','k');
        xlabel('x_{1} [L]');
        ylabel('x_{2} [L]');
    end
    
    N = nan(1,3);
    h = zeros(K,7+2*d3);
    for k = 1:K
        
        % optimazed true anomalies
        if isnan(f12(k,1))
            if e(k)<1
                f1 = -pi;
            elseif e(k)>=1
                f1 = -acos((p(k)/d-1)/e(k));
            end
        else
            f1 = f12(k,1);
        end
        if isnan(f12(k,2))
            f2 = -f1;
        else
            f2 = f12(k,2);
        end
        ff = f1;
        f = ff;
        while ff < f2
            df = dz/p(k)*(1+e(k)*cos(ff));
            ff = ff+df;
            f(end+1) = ff;
        end
        f(end) = f2;
        
        % positions computation
        Xp = N; Xa = N; X0 = N; X1 = N; X2 = N;
        X = f2x(orbits(k,:),f);
        if (f0(k)>=f1) && (f0(k)<=f2)
            X0 = f2x(orbits(k,:),f0(k));
        end
        if ((0>=f1) && (0<=f2)) || ((2*pi>=f1) && (2*pi<=f2))
            Xp = f2x(orbits(k,:),0);
        end
        if (e(k)<1) && ( ((pi>=f1) && (pi<=f2)) || (f1==-pi) || (f2==3*pi))
            Xa = f2x(orbits(k,:),pi);
        end
        if d3
            XA = N; XD = N;
            fA = mod(-w(k)+pi,2*pi)-pi;
            fD = mod(-w(k),2*pi)-pi;
            if ((fA>=f1) && (fA<=f2)) || ((fA+2*pi>=f1) && (fA+2*pi<=f2))
                XA = f2x(orbits(k,:),fA);
            end
            if ((fD>=f1) && (fD<=f2)) || ((fD+2*pi>=f1) && (fD+2*pi<=f2))
                XD = f2x(orbits(k,:),fD);
            end
        end
        if ~isnan(f12(k,1))
            X1 = X(1,:);
        end
        if ~isnan(f12(k,2))
            X2 = X(end,:);
        end
        
        % plot
        if d3
            h(k,1) = plot3(ha,X(:,1),X(:,2),X(:,3));
            h(k,2) = plot3(ha,X1(1),X1(2),X1(3),'>');
            h(k,3) = plot3(ha,X2(1),X2(2),X2(3),'<');
            h(k,4) = plot3(ha,Xa(1),Xa(2),Xa(3),'o');
            h(k,5) = plot3(ha,Xp(1),Xp(2),Xp(3),'o');
            h(k,6) = plot3(ha,X0(1),X0(2),X0(3),'*');
            h(k,7) = plot3(NaN,NaN,NaN,'o-');
            h(k,8) = plot3(ha,XA(1),XA(2),XA(3),'^');
            h(k,9) = plot3(ha,XD(1),XD(2),XD(3),'v');
        else
            h(k,1) = plot(ha,X(:,1),X(:,2));
            h(k,2) = plot(ha,X1(1),X1(2),'>');
            h(k,3) = plot(ha,X2(1),X2(2),'<');
            h(k,4) = plot(ha,Xa(1),Xa(2),'o');
            h(k,5) = plot(ha,Xp(1),Xp(2),'o');
            h(k,6) = plot(ha,X0(1),X0(2),'*');
            h(k,7) = plot3(NaN,NaN,NaN,'o-');
        end
        if mode(k)
            set(h(k,:),'Color','w');
            set(h(k,1),'LineWidth',1);
            set(h(k,2:3),'Marker','o');
            set(h(k,4:end),'Visible','off');
        else
            set(h(k,:),'Color',colors(k,:));
            set(h(k,2:end),'MarkerSize',5);
            set(h(k,5),'MarkerFaceColor',colors(k,:));
        end
        
    end
    
    leg = legend(h(:,7),names,'Location','BestOutside');
    set(leg,'TextColor','w')
    axis equal

end