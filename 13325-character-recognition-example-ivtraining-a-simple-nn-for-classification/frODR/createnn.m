function net = createnn(P,T)

alphabet = P;
targets = T;

[R,Q] = size(alphabet);
[S2,Q] = size(targets);
S1 = 10;
net = newff(minmax(alphabet),[S1 10 S2],{'logsig' 'logsig' 'logsig' },'traingdx');
net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;
net.performFcn = 'mse';         
net.trainParam.show = 20;      
net.trainParam.epochs = 800;  
net.trainParam.mc = 0.95;      
P = alphabet;
T = targets;
[net,tr] = train(net,P,T);