function makeLineHighlightable(h,highlightPoints)
% MAKELINEHIGHLIGHTABLE sets line objects to increase width when clicked
%
% MAKELINEHIGHLIGHTABLE sets the ButtonDownFcn of lines or line children
% of axes so that when the line is clicked the line width is increased or
% decreased. when the line is clicked again the line width returns to the
% original value.
%
% MAKELINEHIGHLIGHTABLE(H,HIGHLIGHTPOINTS): H is a line or axes handle or a vector of line and/or axes handles
%                        HIGHLIGHTPOINTS(optional) is the number of points to
%                        increase (or decrease) the line width when the line is clicked. If not
%                        supplied the default value is 2.
% 
% MAKELINEHIGHLIGHTABLE(H,0): turns off the highlightable ButtonDownFcn for the line handles in H.                      
%  Examples: 
%  h = plot(1:10,rand(10));
%  makeLineHighlightable(h) %increase line width by 2 when clicked
%  a = get(h(1),'Parent');
%  makeLineHighlightable(a,5); %increase by 5 all lines in the axes
%  makeLineHighlightable(h(1:5),0); %turn off the first 5 lines highlighting
%  makeLineHighlightable(a,0); %turn off all the lines highlighting
%
% Revisions: 11/13/07- Other lines turn off when line is highlighted
 
    %check input argument number
    error(nargchk(1, 2, nargin, 'struct')); 
    
    %default points to highlight
    if nargin < 2 
        highlightPoints = 2;
    end %if
    
    %parse input handles
    lineHdls = parseHandles(h);
    if isempty(lineHdls)
        return;
    end %if
    
    %check validity of highlight points
    highlightPoints = checkHighlightPoints(highlightPoints);
    
    %turn off highlighting if highlight points value == 0
    if highlightPoints == 0
        turnOffHighlight(lineHdls);
        return;        
    end %if
    
    %set up variables to hold highlight state and original line widths
    highlightState = false(size(lineHdls));
    originalWidth = get(lineHdls,'LineWidth');
    if ~iscell(originalWidth)
        originalWidth = {originalWidth};
    end %if
    
    %set the callback
    set(lineHdls,'ButtonDownFcn',@toggleHighlight);
    
    function toggleHighlight(src,varargin)
        %callback function for the line ButtonDownFcn
        [inList,listIdx] = ismember(src,lineHdls);        
        if inList
            set(lineHdls,{'LineWidth'},originalWidth);
            if highlightState(listIdx) %already turned on
                set(src,'LineWidth',originalWidth{listIdx});
                highlightState = false(size(lineHdls));
            else %turned off
                curWidth = get(src,'LineWidth');
                set(src,'LineWidth', max([0.5,curWidth+highlightPoints]));   
                highlightState(listIdx) = true;
            end %if
            
        end %if
    end %
end %makeLineHighlightable

function lineHdls = parseHandles(h)
    %note here we don't want to find lines that are part of hggroups for
    %example- if you wanted to get ALL lines lineHdls =
    %findobj(h,'Type','line') might do.
    lineHdls = findobj(findobj(h(ishandle(h)),'flat','Type','line','-or','Type','axes'),'Type','line');
    if isempty(lineHdls)
        warning('makeLineHighlightable:noInputLineHandles', ... 
      'There are no line handles in input array.');
    end %if        
end %parseHandles

function highlightPoints = checkHighlightPoints(highlightPoints)
    if ~isnumeric(highlightPoints) || ~isreal(highlightPoints)
        error('makeLineHighlightable:invalidHighlightPoints', ... 
      'The highlight points must a real numeric value.');
    end %if
    
    if (abs(highlightPoints) < 0.5) && highlightPoints ~= 0
          warning('makeLineHighlightable:smallHighlightPoints', ... 
      'abs(Highlight Points) < 0.5 may not produce a visible change.');
    end%if
   
    highlightPoints = highlightPoints(1);
end %parseHighLightPoints

function turnOffHighlight(lineHdls)
    for i = 1:length(lineHdls) %trying to get all the button down functions at once seems to give odd results
        bdFunction = get(lineHdls(i),'ButtonDownFcn');
        if isa(bdFunction,'function_handle') && isequal(func2str(bdFunction),'makeLineHighlightable/toggleHighlight')
            set(lineHdls(i),'ButtonDownFcn','');
        end %if
    end %for
end %turnOffHighlight

