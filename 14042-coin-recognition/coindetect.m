function  f=coindetect(rad);

if rad>100
    f=1;
elseif (68<rad) & (rad<69)
    f=5;
elseif (76<rad) & (rad<77)
    f=10;
elseif (85<rad) & (rad<86)
    f=25;
elseif (95<rad) & (rad<96)
    f=50;
else
    f=0;
end   

   