
function [poly ph] = contourfill(x,y, z, lev, varargin)

%
% [poly ph] = contourfill(x,y, z, lev, varargin)
%
% Fills area between TWO contour levels specified in vector 'lev'
%
% poly = cell array with x,y-coordinates of the closed-contour-paths
% ph   = handles to plot objects created by function fill
%
%
% Example:
%
% lev = [0.5 2];
% z  = peaks(100);
% figure(234); clf; hold on;
% contourfill([],[], z'       , lev, 'facecolor', 'b', 'facealpha', 0.3 ); 
% contourfill([],[], flipud(z), lev, 'facecolor', 'g', 'facealpha', 0.3 ); 
% contourfill([],[], fliplr(z), lev, 'facecolor', 'r', 'facealpha', 0.3 ); 
%
% Lukas Chvatal, March 2013 
%

    currentaxes = gca;
    currentfig  = gcf;
    
    fgh = figure('visible', 'off');
    %a = axes('parent', fgh);

    [c,h]=contourf(x,y, z, lev(1:2) ); 
    
    ch=get(h, 'children');
    levlist = cell2mat(get(ch(:), 'cdata'));    
    xdata = get(ch(:), 'xdata');
    ydata = get(ch(:), 'ydata');
    close(fgh);
    axes(currentaxes);
    figure(currentfig);
    
    
    irow = find(levlist==lev(1))';
    jrow = find(levlist==lev(2)  |  isnan(levlist) )';
    
    poly = cell(length(irow), 2);
    ph   = 0*irow;
        
    % closing regions
    pos = 1;
    for i = irow
    
        xout = xdata{i};
        yout = ydata{i};
        
        % regions which will be cut
        for j = jrow
            
            if(ch(j)==0) 
                continue;
            end;
                
            xin  = xdata{j};
            yin  = ydata{j};
            
            if( inpolygon(xin(1), yin(1),  xout,yout) )
                
                [xout, yout] = joinpaths(xout,yout, xin,yin );
                ch(j) = 0;
                                
            end;
            
        end;    
                
        ph(pos) = fill(xout, yout, '', 'edgecolor', 'none', varargin{:} );
        set(ph(pos), varargin{:} );
        poly{pos,1} = xout;
        poly{pos,2} = yout;
    end;
            
end


function [xjoined, yjoined] = joinpaths(xout,yout, xin,yin)

    % ensure column orientation
    xout = xout(:);
    yout = yout(:);
    xin  = xin(:);
    yin  = yin(:);
       
    %
    % find closest pair of points
    % (this is not so necessary, as no edgelines would be drawn)
    %
    dx = repmat( xout, [1 length(xin)]) - repmat(xin', [length(xout) 1]);
    dy = repmat( yout, [1 length(yin)]) - repmat(yin', [length(yout) 1]);
    dd = sqrt(dx.*dx+dy.*dy);
    [~,indmin] = min(dd(:));
    [i1,i0] = ind2sub(size(dd), indmin);
        
    if(i1==length(xout))
        i1 = 1;
    end;
        
% plot(xout,yout, 'b.-');
% plot(xin,yin, 'r.-');
% plot(xin(i0), yin(i0), 'ro');
% plot(xout(i1), yout(i1), 'bo');

    if(i0==1 | i0==length(xin) )
        xins = flipud(xin);
        yins = flipud(yin);
    else        
        xins = [ xin(i0:(-1):2);  xin(end:(-1):i0) ];
        yins = [ yin(i0:(-1):2);  yin(end:(-1):i0) ];
    end;
  
    xjoined = [ xout(1:i1);  xins;  xout(i1:end) ];
    yjoined = [ yout(1:i1);  yins;  yout(i1:end) ];
    
end

