pg0   = upper(strtrim(get(h_pg0,'String')));
si    = str2num(get(h_si,'String'));
depth = str2num(get(h_depth,'String'));
time  = str2num(get(h_time,'String'));
if isempty(pg0)
    set(h_pg1,'String','');
    rnt = 0;
else
    pg1 = surfaceinterval(pg0,si);
    set(h_pg1,'String',pg1);
    rnt = repetitivedive(pg1,depth);
end
set(h_rnt,'String',rnt);
set(h_abt,'String',time);
tbt = rnt + time;
set(h_tbt,'String',tbt);
pg2 = endofdive(depth,tbt);
set(h_pg2,'String',pg2);
if pg2 == 'X'
    set(h_comment,'String','You have exceeded non-decompression limits');
else
    set(h_comment,'String','');
end