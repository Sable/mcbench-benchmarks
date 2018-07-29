% Copyright 2009 - 2010 The MathWorks, Inc.
% Loading the test data
% Note that we are tracking an object whose positions are recorded 
% as x and y coordinates in a Cartesian space
load position.mat
hold; grid;
for idx = 1: numPts
z = position(:,idx);
plot(z(1), z(2), 'bx');
axis([-1 1 -1 1]);
end
hold;
%% This algorithm predicts the position of a moving object based on 
% its past values. It uses a Kalman filter estimator. 
% Kalman filter is a recursive adaptive filter that estimates 
% the state of a dynamic system from a series of 
% noisy measurements. It has a broad range of application in 
% signal and imge processing, control design, 
% and computational finance
% Let's run the script ObjTrack.m to see how Kalman filter 
% gradually estimates and tracks  a moving object. 
ObjTrack01(position)
%% In this example, by assuming a zero initial condition 
% ( no knowledge of the position of the object in the past) 
% Kalman filter iteratively and adaptively estimates and tracks 
% the object. This is depicted by the green circular traces 
% as outputs  of the Kalman estimator superimposed 
% on the input positions vectors depicted by blue x traces.
% Note that there are 3 sudden shifts in position and every time
% Kalman filter re-adjusts and tracks the object after few iterations
edit ObjTrack01
%% Let's look at the Kalman filter function
% Note that the Kalman estimator computes the position vector 
% by computing and updating the Kalman state vector. 
% We define the state vector as a 6-by-1 column vector 
% that includes position (x and y) velocity (Vx Vy) and 
% acceleration (Ax and Ay) measurements in a 2-dimensional 
% Cartesian space. Based on the classical laws of motion:
% X = X0 + Vx*t 
% Y = Y0 + Vy*t 
% Vx = Vx0 + Ax*t
% Vy = Yy0 + Ay*t 
% Note how these laws of motion are reflected in the Kalman 
% state transion matrix A:
% x=[X Y Vx Vy Ax Ay]' %% state vector
% x=A*x;               %% recursive estimation
% dt=1;
% A=[ 1 0 dt 0 0 0;... %% state transion matrix
%     0 1 0 dt 0 0;...
%     0 0 1 0 dt 0;...
%     0 0 0 1 0 dt;...
%     0 0 0 0 1 0 ;...
%     0 0 0 0 0 1 ];
% Note how by writing only 10 lines of MATLAB code, 
% we implement the Kalman estimator as if you are writing
% the mathematical formula. This is power of MATLAB!
%% Version 1 Scalar Kalman filter 
% input: one sample 
% output: one sample
edit kalman01.m
%% Let us now genearte C code for the kalman filter
% First we run the emlmex command to see weather there is any 
% function or operator in this function that is not compliant with the 
% Embedded MATLAB subset
z = position(:,1);
emlmex -eg {z} kalman01.m
%% Now that the kalman filter is compliant, Is the 
% calling function (ObjTrack01) compliant with Embedded MATLAB subset?
emlmex -eg {position} ObjTrack01.m
%% No,it contains unsupported visualization function
% How do we make it complaint with the embedded MATLAB subset?
% Notice eror messages when complaining due to the use of plotting
% functions. We now showcase use of eml.extrinsic that declare
% visualization functions to be extrinsic and instruct Embedded MATLAB 
% not to compile them.
edit ObjTrack02.m
%% Notice how the non-supported plotting functions now 
% do not take part in compilation and thus no more eror messages
emlmex -eg {position} ObjTrack02.m
%% Since this function kalman.m is consistent with 
% Embedded MATLAB subset, let us now use the emlc command to
% automatically genearte C source code for this functioon
emlc -eg {z} kalman01.m -c -T RTW -report
%% Here we note and explain the following features:
% 1. MATLAB is an untyped language, C is strictly typed. 
% So we use -eg option to set the (data type, size and complexity) of the
% input variable to the function based on an example variable 
% availbale in MATLAB workspace (in this case varaiable name is z). 
% Based on the properties of this variable, 
% Embeded MATLAB sets and infers the data type, size and complexity of 
% all internal variables to the function, declares them and generate C code.
% 2. -c option indicates we just want to see the C source code
% 3. -T RTW option says generate embeddable C-code and 
% 4. -report option says generate a compilation report.
% Now browse and explain the organization of Compilation report
%% Now we want to showcase how in many cases we can 
% accelerate the execution speed of a function running a large data set
% by using emlmex command that compiled the function into a MEX function. 
% Use of emlmex not only verifies the compliance with the Embedded MATLAB
% subset but it may potentialy accelrate the execution speed of some algorithms
% specially if the algorithm is fixed-point
%% First run the kalman algorithm with 100,000 samples without 
% using emlmex to compile it to a mex function
delete *.mexw32
which kalman01
%% Use tic; toc; to record how much time it takes for processing 
% 100K samples of data in this case 
SIZE=100000;
Z=rand(2,SIZE);
tic;
for i=1:SIZE
    z=Z(:,i);
    y=kalman01(z);
end;
toc;
%% Second run the kalman algorithm with 100,000 samples WITH 
% using emlmex to compile it to a mex function
emlmex -eg {z} kalman01.m
which kalman01
%% Use tic; toc; to record how much time it takes for processing 100K
% samples
SIZE=100000;
Z=rand(2,SIZE);
tic;
for i=1:SIZE
    z=Z(:,i);
    y=kalman01(z);
end;
toc;
%% Notice a 3 times acceleration of the speed of the execution of this
% function just by using the emlmex function 
%% Version 3 Variable size Vector (Packet based)
% Kalman filter 
% input: a variable-sized vector 
% output: sanme size as inoput
edit ObjTrack03.m
%% Variable-size data
% Let us now genearte C code for the packet-based 
% kalman filter. First we run the emlmex command to see weather there is any 
% function or operator in this function that is not compliant with the
% Embedded MATLAB subset
N=100;
z = position(1:2,1:N);
eg_z=emlcoder.egs(z,[2 N]);
emlmex -eg {eg_z} kalman03.m
%% Let us run the compiled version to make sure
% the generated C code can properly handle packets of diferent sizes.
% By examining ObjTrack03.m we see that we are calling kalman03.m with
% 7 different (x-y) pairs of varying sizes ranging from 2x10 to 2x100 
which kalman03
ObjTrack03
%% Since this function kalman.m is consistent with 
% Embedded MATLAB subset, let us now use the emlc command to
% automatically genearte C source code for this function
% We use the maximum size of 2x100 as the upper bound for compilation to C
% and use the emlcoder.egs to indicate the maximum size of the input
% variable z.
N=100;
z = position(1:2,1:N);
eg_z=emlcoder.egs(z,[2 N]);
emlc -eg {eg_z} kalman03.m -c -T RTW -report
%% Here we note and explain the following features:
% 1. The genearted C code has just enough extra code to make it flexible
% for any size input from 2x1 to 2x100.
% 2. We showcase emlcoder.egs and explain how it works
% 3. We explain how easy it is to make an algorithm be flexible relative to
% input size:
% We show that in the function at line 36, we had o explicitly index 
% the input variable z (instead of z(:,i) -> z(1:2,i) to make explicit
% which portion of variable size input us being processed at that line
%% Fixed-point data: Look at the fixed-point Kalman estimator function
% It differs from the floating-point algorithm kalman.m 
% by declaring the internal variables as fixed-point 
% using the fi constructor. The variable declaration (where most changes are) are separated 
% from the algorithm part, which remains mostly the same relative to the
% floating point algorithm.
edit kalman04.m
%% To convert algorithm to fixed-point, you need to set numeric type
% of the fixed-point input data and specify a set of global fimath
% properties. 
% As of R2009b, you can specify accumulator ad product data types
% of all intermediate variables globally, which makes the task 
% of fixed-point programming easier.
%% Look at the syntax of setting the global fimath properties
% Before setting the global fimath we have the default values 
resetglobalfimath
fimath
%% Now note that I am using a helper functin myglobalfimath.m 
% to globaly set the fixed-point math properties of all variables in MATLAB workspace.
edit myglobalfimath.m
%% 
% I want to set a global fimath properties such that SpecifyPrecision Mode is used 
% for setting the Sum and Product properties, accumulators and products 
% internal variables have a wordlength of 32 bits, with 20 bits for their fractional part,
% 11 bits integer part and 1 bit for sign
myglobalfimath(20);
fimath
%% Notice how it can take a long time to run fixed-point function 
% without using emlmex to accelerate execution speed
% In my machine about 7 seconds for 1000 samples
delete *.mexw32
which kalman04
SIZE=1000;
Z=fi(rand(2,SIZE));
tic;
for i=1:SIZE
    z=Z(:,i);
    y=kalman04(z);
end;
toc;
%% Now you can accelerate the execution speed of fixed-point 
% and in most cases even floating-point functionsby using the
% emlmex function of Fixed-Point Toolbox. It generates C code automatically
% from the MATLAB function and compiles it into MEX code. 
% It will run faster. Only catch is that the kalman_fixpt.m 
% must use the subset of MATLAB language allowing automatic 
% MATLAB to C translation. The Embedded MATLAB subset 
z = Z(:,1);
emlmex -eg {z} kalman04.m
%% Run the same function and notice the acceleration
% In my machine it run around 0.3 seconds a 20x acceleration
myglobalfimath(20);
which kalman04
SIZE=1000;
Z=fi(rand(2,SIZE));
tic;
for i=1:SIZE
    z=Z(:,i);
    y=kalman04(z);
end;
toc;
%% Now generate C source code from your fixed-point Kalman filter 
% by uising the emlc command of the Real Time Workshop
% When you use the -report option it creates a link to an HTML report
% showing the automatically generated C code as kalman_fixpt.c
% Note that all variables are statically defined as native integers and 
% all scaling functions are defined before the main C function  
emlc -eg {z} kalman04.m -c -T RTW -report
%% Clean up
delete *.mexw32
clear mex

