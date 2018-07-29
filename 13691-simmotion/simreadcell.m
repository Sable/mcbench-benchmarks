function result = simreadcell(cellnumber)
result = 0;
motionobject = getMotionObject();
if isempty(motionobject)
    error('No Simulation Motion object started!!!');
else
result = motionobject.readcell(cellnumber);    
end
end