function fig = draw_circ(fig, circ, clr, cen)
% fig = draw_circ(fig, circ, clr, cen)
% draws boundaries of circle into picture matrix (figure)
% fig = draw_circ(fig, circ, clr, cen)
% cen == 1 cross on centroid

if size(circ, 2) < 3, error('Circle must be specified with y, x & r.'); end
if ~circ(3) > 0, error('r must be greater than zero.'); end


    NOP = round(1.5*pi*circ(3));  
    Bndry = zeros(NOP+14*cen, 2);
    mat = [-3,-2,-1,0,1,2,3];
    THETA = linspace(0,2*pi, NOP); 
    RHO = ones(1, NOP)*circ(3)/2;
    [Bndry(1:NOP, 1), Bndry(1:NOP, 2)] = pol2cart(THETA,RHO);
    Bndry(1:NOP, 1) = Bndry(1:NOP, 1) + circ(1);
    Bndry(1:NOP, 2) = Bndry(1:NOP, 2) + circ(2);
    
    if cen == 1
    % Cross on Centroid
        Bndry(NOP+1:NOP+7, 1) = circ(1)+mat(1:7);
        Bndry(NOP+1:NOP+7, 2) = circ(2);
        Bndry(NOP+8:NOP+14, 1) = circ(1);
        Bndry(NOP+8:NOP+14, 2) = circ(2)+mat(1:7);
    end    
    fig = draw_bndry(fig, Bndry, clr);
    
end


