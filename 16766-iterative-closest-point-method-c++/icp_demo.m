% icp_demo.m
% run
% >> icp_demo
% in MATLAB

% size of model/data
n_model=2000;
n_data=1300;

% model points
model=4*randn(3,n_model)-2*ones(3,n_model);
bol=(model(1,:).^2+model(2,:).^2)<2^2;
while any(not(bol))
    model(:,not(bol))=4*randn(3,sum(not(bol)))-2*ones(3,sum(not(bol)));
    bol=(model(1,:).^2+model(2,:).^2)<2^2;
end
model(:,not(bol))=4*randn(3,sum(not(bol)))-2*ones(3,sum(not(bol)));
model(3,:)=0.5*(model(1,:).^2-model(2,:).^2);
bol=(model(1,:).^2+model(2,:).^2)<0.9^2;
model(3,bol)=3.5-3.5*(1/0.9)*sqrt(model(1,bol).^2+model(2,bol).^2);

% data points
data=model(:,1:n_data);

% weights
weights=ones(1,n_data);weights=rand(1,n_data);

% Transform points in data (move away from start position).
deg=15;
v1=2*(rand-0.5)*deg*(pi/180);
v2=2*(rand-0.5)*deg*(pi/180);
v3=2*(rand-0.5)*deg*(pi/180);
TR0=[cos(v1) sin(v1) 0;-sin(v1) cos(v1) 0;0 0 1];
TR0=TR0*[cos(v2) 0 sin(v2);0 1 0;-sin(v2) 0 cos(v2)];
TR0=TR0*[1 0 0;0 cos(v3) sin(v3);0 -sin(v3) cos(v3)];
TT0=3.0*(rand(3,1)-0.5);
data=TR0*data+repmat(TT0,1,n_data);

% randvec
rndvec=uint32(randperm(n_data)-1);

% sizerand, number of point-matchings in each iteration.
sizernd=ceil(1.45*n_data);

% Number of iterations.
iter=40;

% Compile the c++ files (not nessesacily if it is already done).
try
    make
end

% Create the kd-tree, TreeRoot is the pointer to the kd-tree
[tmp, tmp, TreeRoot] = kdtree( model', []);

% Run the ICP algorithm.
[R,T]=icpCpp(model,data,weights,rndvec,sizernd,TreeRoot,iter);

% Free allocated memory for the kd-tree.
kdtree([],[],TreeRoot);



figure(1),plot3(model(1,:),model(2,:),model(3,:),'r.',data(1,:),data(2,:),data(3,:),'c.'),hold off;

% Transform the data points.
data=R*data+repmat(T,1,n_data);

figure(2),plot3(model(1,:),model(2,:),model(3,:),'r.',data(1,:),data(2,:),data(3,:),'b.'),hold off;

clear functions
