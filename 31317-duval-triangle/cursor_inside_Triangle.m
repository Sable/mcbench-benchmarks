function [CurPt, id_target] = cursor_inside_Triangle(S_TRG)

% F. Andrianasy, Sam14Aug2010, 02h56

    CurPt = get(gca, 'CurrentPoint');
    id_target = 0;
    for i = 2: length(S_TRG)
        inside = inpolygon( CurPt(1, 1), ...
                            CurPt(1, 2), ...
                            S_TRG(i).polygon(1, :), ...
                            S_TRG(i).polygon(2, :) );
        if (inside > 0)
            id_target = i;
            return
        end
        
    end
    
