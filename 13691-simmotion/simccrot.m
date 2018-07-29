function simccrot()
motionobject = getMotionObject();
if isempty(motionobject)
    error('No Simulation Motion object started!!!');
else
motionobject.ccrot();    
end
end