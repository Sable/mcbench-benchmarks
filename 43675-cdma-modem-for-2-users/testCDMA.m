%this is how you can use the function CDMAmodem.m in your code

clc;
close all;
user1in=[1,0,0,1,1,0,0,1,1,0]; %only bindary sequences with user and user2 having same lengths
user2in=[1,1,0,0,0,1,1,1,1,0];
display(user1in);display(user2in);
[opuser1,opuser2]=CDMAmodem(user1in,user2in,10);%change snr to -5 and see what happens!
display(opuser1);display(opuser2);
if(user1in==opuser1)
    display('user1 has transmitted data successfully');
else
    display('user1 has transmitted data with errors');
end

if(user2in==opuser2)
    display('user2 has transmitted data successfully');
else
    display('user2 has transmitted data with errors');
end