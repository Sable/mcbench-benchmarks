function MouseMoveCallback(obj, event)
%function MouseMoveCallback(obj, event, S_TRG)
% F. Andrianasy, Ven13Aug2010, 22h25
    
global TRG_SCALE
global S_TRG 
global A
global B
global UserData

    %debug
    %disp(sprintf('.. inside %s', mfilename))

    % -----------------------------------------------
    % Verifier si le curseur est dans le Triangle
    % Recupere la position du curseur
    % -----------------------------------------------
    [CurPt, id_cible] = cursor_inside_Triangle(S_TRG);
    if id_cible == 0
        return
    end
    x_CurPt = CurPt(1, 1);
    y_CurPt = CurPt(1, 2);


    % -----------------------------------------------
    % Premier passage dans CETTE fonction
    % Initialisation de divers handles
    % -----------------------------------------------
    %UserData = get(gcf, 'UserData');
    if strcmp(UserData.state, 'STATE_0')
        
        UserData.hplot = [];
        UserData.h_La = [];
        UserData.h_Lb = [];
        UserData.h_Lc = [];
        
        UserData.state = 'STATE_1';
        %set(gcf, 'UserData', UserData) 
    end

    % -----------------------------------------------
    % Premier passage dans CETTE fonction
    % Initialisation de hplot, handle du point central
    % Singleton 
    % -----------------------------------------------
    hplot = UserData.hplot;
    if isempty(hplot)
        hplot = plot(x_CurPt, y_CurPt, 'ow');
        set(hplot, 'MarkerSize', 10);
        
        UserData.hplot = hplot;
        %set(gcf, 'UserData', UserData) 
    end
    
    
    % -----------------------------------------------
    % Bouge le point a son nouvel emplacement
    % Mettre a jour la position du point cible
    % -----------------------------------------------
    set(hplot, 'XData', x_CurPt, 'YData', y_CurPt);
    
    
    % -----------------------------------------------
    % Amelioration contraste et visibilite
    % Changer la couleur du point sentral
    % selon la couleur du polygone
    % -----------------------------------------------
    switch id_cible
        case {2, 6, 7}                          % Polygones de couleur claires                
            set(hplot, 'Color', [0 0 0]);       
        otherwise
            set(hplot, 'Color', [1 1 1]);
    end



    % Conversion en corrdonnees a,b,c
    abc_CurPt = to_ABC([x_CurPt, y_CurPt]');
    
    % Calcul des points d'intesection 
    % avec les 3 axes a, b, c, du triangle
    a = abc_CurPt(1); 
    b = abc_CurPt(2); 
    c = abc_CurPt(3);
    
    abc_ntrsc_a = [a, 0, (TRG_SCALE - a)]'; 
    abc_ntrsc_b = [(TRG_SCALE - b), b, 0]'; 
    abc_ntrsc_c = [0, (TRG_SCALE - c), c]';
    
    % Conversion en coordonnees xy
    %     xy_ntrsc_a = to_XY(abc_ntrsc_a, A, B);
    %     xy_ntrsc_b = to_XY(abc_ntrsc_b, A, B);
    %     xy_ntrsc_c = to_XY(abc_ntrsc_c, A, B);
    % Version vectorisee
    xy = to_XY ( [abc_ntrsc_a  abc_ntrsc_b  abc_ntrsc_c], A, B);
    xy_ntrsc_a = xy(:, 1);
    xy_ntrsc_b = xy(:, 2);
    xy_ntrsc_c = xy(:, 3);
    
    % Singleton
    %UserData = get(gcf, 'UserData');
    h_La = UserData.h_La;  
    h_Lb = UserData.h_Lb; 
    h_Lc = UserData.h_Lc;  
    
    if isempty(h_La)
        h_La = line([x_CurPt xy_ntrsc_a(1)], [y_CurPt xy_ntrsc_a(2)]);
        set(h_La, 'erase', 'xor', 'LineStyle', ':', 'Marker', 'o', 'Color', 'k')
        set(h_La, 'MarkerSize', 5)
        set(h_La, 'LineWidth', 2)
        
        UserData.h_La = h_La;
        %set(gcf, 'UserData', UserData)
    end
    
    if isempty(h_Lb)
        h_Lb = line([x_CurPt xy_ntrsc_b(1)], [y_CurPt xy_ntrsc_b(2)]);
        set(h_Lb, 'erase', 'xor', 'LineStyle', ':', 'Marker', 'o', 'Color', 'k')
        set(h_Lb, 'MarkerSize', 5)
        set(h_Lb, 'LineWidth', 2)
        
        UserData.h_Lb = h_Lb;
        %set(gcf, 'UserData', UserData)
    end
    
    if isempty(h_Lc)
        h_Lc = line([x_CurPt xy_ntrsc_c(1)], [y_CurPt xy_ntrsc_c(2)]);
        set(h_Lc, 'erase', 'xor', 'LineStyle', ':', 'Marker', 'o', 'Color', 'k')
        set(h_Lc, 'MarkerSize', 5)
        set(h_Lc, 'LineWidth', 2)
        
        UserData.h_Lc = h_Lc;
        %set(gcf, 'UserData', UserData)
    end
    
    % -----------------------------------------------
    % Mise a jour lignes d'intersection avec 3 axes
    % -----------------------------------------------
    set(h_La,'XData',[x_CurPt xy_ntrsc_a(1)], 'YData', [y_CurPt xy_ntrsc_a(2)]);
    set(h_Lb,'XData',[x_CurPt xy_ntrsc_b(1)], 'YData', [y_CurPt xy_ntrsc_b(2)]);
    set(h_Lc,'XData',[x_CurPt xy_ntrsc_c(1)], 'YData', [y_CurPt xy_ntrsc_c(2)]);
    
    
    % -----------------------------------------------
    % Mise a jour affichage valeurs courantes
    % -----------------------------------------------
     h_Ta = UserData.h_Ta;  
     h_Tb = UserData.h_Tb;  
     h_Tc = UserData.h_Tc;  
     
     str_Lbla = UserData.str_Lbla;  
     str_Lblb = UserData.str_Lblb;  
     str_Lblc = UserData.str_Lblc;  
    
     set(h_Ta, 'string', [str_Lbla(2:end) ' = ' sprintf('%.1f%%', a)] );
     set(h_Tb, 'string', [str_Lblb(2:end) ' = ' sprintf('%.1f%%', b)] );
     set(h_Tc, 'string', [str_Lblc(2:end) ' = ' sprintf('%.1f%%', c)] );
     
     
     
    % -----------------------------------------------
    % Real-Time Diagnosis ...
    % -----------------------------------------------
    h_r = UserData.h_r;
    h_tDiag = UserData.h_tDiag;
    
    set(h_tDiag, 'String', S_TRG(id_cible).comment ); 
    
    tDiagxt = get(h_tDiag, 'Extent');   
    rPos = get(h_r, 'Pos');
    rPos(1) = tDiagxt(1)-10;
    set(h_r, 'Pos', rPos)
    
    set(h_r, 'FaceColor', S_TRG(id_cible).Color)
    set(h_r, 'Visible', 'on')

    
    