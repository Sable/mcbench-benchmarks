function MouseDownCallback(obj, event)
%function MouseDownCallback(obj, event, S_TRG)
% MouseDownCallback
% F. Andrianasy, Sam14Aug2010, 02h07

global S_TRG 

% -----------------------------------------------
% Si le curseur est dans le triangle
% alors active la gestion du mouvement de souris
% en branchant la fonction callback
% -----------------------------------------------
[CurPt, id_target] = cursor_inside_Triangle(S_TRG);

% id_target is > 0 whenever the cursor is inside the Triangle
if isempty(get(gcf, 'WindowButtonMotionFcn')) && (id_target > 0)

   % Toggle activate the mouse move management
    set(gcf, 'WindowButtonMotionFcn', {@MouseMoveCallback})
    
    % Then MouseMoveCallback to move immediately to the new target
    MouseMoveCallback    
    
else
    % Freeze the mouse move handling
    set(gcf, 'WindowButtonMotionFcn', [])
    
end
