function simcwrot()
motionobject = getMotionObject();
if isempty(motionobject)
    error('No Simulation Motion object started!!!');
else
motionobject.cwrot();    
end

end