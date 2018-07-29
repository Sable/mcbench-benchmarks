function [CurPt, id_target] = cursor_inside_Patches(S_TRG)
% This acts basically as wrapper for the inpolygon function 
% CurPt - current cursor coordinates
% id_target - polydon id within matrix of structures S_TRG
%   S_TRG acts like a micro dstabase 
%   and holds crucial data about the polygons 

% Sam14Aug2010, 20h10 - Duplique de cursor_inside_Triangle(S_TRG)
% F. Andrianasy, Sam14Aug2010, 20h10

    CurPt = get(gca, 'CurrentPoint');
    % x_CurPt = CurPt(1, 1);
    % y_CurPt = CurPt(1, 2);
    % disp(sprintf('[%.1f, %.1f]', x_CurPt, y_CurPt) )
    
    % On ne check pas le grand triangle, 
    % l'indice i = 2..
    % On arrete de checker des qu'on a trouve un inside > 0
    % L'id du patch cuble (id_target) est recupere 
    %get(S_TRG(i).handle, 'XData'), ...
    %get(S_TRG(i).handle, 'YData') );
    id_target = 0;
    for i = 2: length(S_TRG)
        inside = inpolygon( CurPt(1, 1), ...
                            CurPt(1, 2), ...
                            S_TRG(i).polygon(1, :), ...
                            S_TRG(i).polygon(2, :) );
        if (inside > 0)
            % S_TEMP = S_TRG(i);
            % disp( sprintf('[%d, %s, %s]', S_TEMP.id, S_TEMP.name, S_TEMP.comment) );
            id_target = i;
            %break
            return
        end
    end
    
