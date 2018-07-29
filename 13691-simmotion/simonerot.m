function simonerot()
motionobject = getMotionObject();
if isempty(motionobject)
    error('No Simulation Motion object started!!!');
else
motionobject.onerot();    
end

end