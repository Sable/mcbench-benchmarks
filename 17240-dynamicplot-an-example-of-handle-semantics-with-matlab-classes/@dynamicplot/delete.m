% delete(obj)
%  Deletes the dynamic plot and marks the object as "invalid".
%  Any future methods called with OBJ will generate an error.
%
function delete(s)
s.checkValidity();

disp('dynamic plot delete called');
tobj = s.getTimerObject();
stop(tobj);
delete(tobj);

fh = s.getFigureHandle();
delete(fh);

s.setValidity(false);

