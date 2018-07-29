%Voice Based Biometric System
%By Ambavi K. Patel.


function disply(rgrsn)
th=0.60;


      
   if  max(max(rgrsn))<th
             h1 = msgbox('INCORRECT','your password is','error');
       soundsc(wavread('denied.wav'),50000);

      
    uiwait(h1,1);
close(h1);
  
   else
      h1 = msgbox('CORRECT','your password is');
      soundsc(wavread('allow.wav'),50000);

      
     uiwait(h1,1);
close(h1);
   end;

