
function unbreakxaxis(breakInfo)
    
    delete(breakInfo.leftAxes);
    delete(breakInfo.rightAxes);
    delete(breakInfo.breakAxes);
    delete(breakInfo.annotationAxes);
    
    for i = 1:numel(breakInfo.invisibleObjects)
        set(breakInfo.invisibleObjects(i),'Visible','on');
    end

end