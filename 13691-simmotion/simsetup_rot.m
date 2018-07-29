function simsetup_rot
motionobject = getMotionObject();
if isempty(motionobject)
   testmotion;
   motionobject = getMotionObject();   
end
end