%if rand<0.5
    % ensert to empty way
    ew=find(weae);
    ew1=ew(randi(length(ew))); % way to inset
    eggsp(1,ew1)=true;
    orv=[orv  ew1];
    move=false;
%else
   % just_move;
%end