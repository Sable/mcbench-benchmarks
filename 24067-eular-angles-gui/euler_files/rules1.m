function rules1
global x y z alpha

xn=str2num(get(x,'String'));
yn=str2num(get(y,'String'));
zn=str2num(get(z,'String'));

alphan=str2num(get(alpha,'String'));

rules(xn,yn,zn,alphan);
