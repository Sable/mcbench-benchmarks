
HH = findobj(gcf,'Tag','p1'); 
p1 = str2num(get(HH,'String')); 
HH = findobj(gcf,'Tag','p2'); 
p2 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p3'); 
p3 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p4'); 
p4 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p5'); 
p5 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p6'); 
p6 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p7'); 
p7 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p8'); 
p8 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p9'); 
p9 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p10'); 
p10 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','p11'); 
p11 = str2num(get(HH,'String'));

%********

HH = findobj(gcf,'Tag','d1'); 
d1 = str2num(get(HH,'String')); 
HH = findobj(gcf,'Tag','d2'); 
d2 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d3'); 
d3 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d4'); 
d4 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d5'); 
d5 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d6'); 
d6 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d7'); 
d7 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d8'); 
d8 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d9'); 
d9 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d10'); 
d10 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d11'); 
d11 = str2num(get(HH,'String'));
%******
HH = findobj(gcf,'Tag','d101'); 
d101 = str2num(get(HH,'String')); 
HH = findobj(gcf,'Tag','d2'); 
d102 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d103'); 
d103 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d104'); 
d104 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d105'); 
d105 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d106'); 
d106 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d107'); 
d107 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d108'); 
d108 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d109'); 
d109 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d110'); 
d110 = str2num(get(HH,'String'));
HH = findobj(gcf,'Tag','d111'); 
d111 = str2num(get(HH,'String'));

%*******



data=[ d1  d101   p1
       d2  d102   p2
       d3  d103   p3
       d4  d104   p4
       d5  d105   p5
       d6  d106   p6
       d7  d107   p7
       d7  d107   p7
       d8  d108   p8
       d9  d109   p9
       d10 d110  p10
       d11 d111  p11 ];
   
 P= data(:,3);
 Dt=data(:,2)-data(:,1);
 W=P'*Dt;
 pavg=W/sum(Dt);
 pk=max(P);
 lf=(pavg/pk)*100;
 f=data(:,2);
barcycle(data);
Units = ' %';  
% Get the Handle for the load factor Tag 
HH = findobj(gcf,'Tag','lf'); 
% Set the string for the object TFinal 
set(HH,'String',[num2str(lf) Units]) 



Units1 = 'MW';  
% Get the Handle for the Average power Tag 
HH = findobj(gcf,'Tag','pavg'); 
% Set the string for the object average power 
set(HH,'String',[num2str(pavg) Units1]) 
 
% Get the Handle for the peak power  Tag 
HH = findobj(gcf,'Tag','pk'); 
% Set the string for the object peak power
set(HH,'String',[num2str(pk) Units1]) 

xlabel('Time,Hr')
ylabel('P,MW')



