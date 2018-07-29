function result = getMotionObject()
objectname = findobj('name','Stepper Motor Simulator');
result =get(objectname,'UserData');

end