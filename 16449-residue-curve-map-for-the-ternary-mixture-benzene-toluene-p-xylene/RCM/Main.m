% Author: Housam Binous

% Residue Curve Map Computation Using Matlab

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

% Reference :
% M. F. Doherty and M. F. Malone, Conceptual Design of Distillation
% Systems, New York: McGraw-Hill, 2001.

h=figure(1);

line([0 1],[1 0])

axis([0 1 0 1])

hold on

button = questdlg('do you want to draw a residue curve',...
    '','yes','no','yes');

while (button(1)=='y') 
    
[x y]=ginput(1);

if x<0  
    x=max(x,0); 
end;

if y<0 
    y=max(0,y); 
end;

if y+x>1  
    y=min(1-x,y); 
end;

opts = odeset('Mass','M','MassSingular','yes');

[t X]=ode15s('RCM1',[0 10],[x y 1-x-y 350],opts);

plot(X(:,1),X(:,2),'r')

[t X]=ode15s('RCM2',[0 10],[x y 1-x-y 350],opts);

plot(X(:,1),X(:,2),'r')  

button = questdlg('do you want to draw a residue curve','',...
    'yes','no','yes');

end

close(h)

