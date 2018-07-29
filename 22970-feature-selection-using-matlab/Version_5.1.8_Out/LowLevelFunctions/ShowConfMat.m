%------------------------------------------------------------------
%--------- Show Conf Mat ------------------------------------------
%------------------------------------------------------------------

function ShowConfMat(ConfMatOpt)
disp('Stimulus\Response | Anger | Happiness | Neutral | Sadness | Surprise');
disp('--------------------------------------------------------------------');
disp(sprintf('Anger                  %4.2f     %4.2f      %4.2f     %4.2f      %4.2f ',    ConfMatOpt(1,1), ConfMatOpt(1,2), ConfMatOpt(1,3), ConfMatOpt(1,4),  ConfMatOpt(1,5)));
disp(sprintf('Happiness              %4.2f     %4.2f      %4.2f     %4.2f      %4.2f ', ConfMatOpt(2,1), ConfMatOpt(2,2), ConfMatOpt(2,3), ConfMatOpt(2,4),  ConfMatOpt(2,5)));
disp(sprintf('Neutral                %4.2f     %4.2f      %4.2f     %4.2f      %4.2f ',    ConfMatOpt(3,1), ConfMatOpt(3,2), ConfMatOpt(3,3), ConfMatOpt(3,4),  ConfMatOpt(3,5)));
disp(sprintf('Sadness                %4.2f     %4.2f      %4.2f     %4.2f      %4.2f ',  ConfMatOpt(4,1), ConfMatOpt(4,2), ConfMatOpt(4,3), ConfMatOpt(4,4),  ConfMatOpt(4,5)));
disp(sprintf('Surprise               %4.2f     %4.2f      %4.2f     %4.2f      %4.2f ',    ConfMatOpt(5,1), ConfMatOpt(5,2), ConfMatOpt(5,3), ConfMatOpt(5,4),  ConfMatOpt(5,5)));
disp('------------------------------------------------------------------------------');
return