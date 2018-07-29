function direct(q1,q2,q3,q4,q5,q6)

% % % GIVEN JOINT VARIABLES

d=[335   0   0   -295    0   -80];
a=[75    270 90  0   0   0];
 
% % TRANSFORMATION MATRIX 1.
q1=ger(handles.slider1,'Value');
T1=[    cos(q1)     0       -sin(q1) a(1)*cos(q1)
        sin(q1)     0       -cos(q1) a(1)*sin(q1)   
        0           -1          0       d(1)
        0           0           0        1      ];

% % TRANSFORMATION MATRIX 2.    
q2=ger(handles.slider1,'Value');
T2=[    cos(q2)     -sin(q2)    0   a(2)*cos(q2)
        sin(q2)     cos(q2)     0   a(2)*sin(q2)
        0               0       1       0
        0               0       0       1   ];
    

% % TRANSFORMATION MATRIX 3.        
q3=ger(handles.slider1,'Value');
T3=[    cos(q3)         0    sin(q3)   a(3)*cos(q3)
        sin(q3)         0    -cos(q3)   a(3)*sin(q3)
        0               0       0       0
        0               0       0       1   ];
% % TRANSFORMATION MATRIX 4.    
q4=ger(handles.slider1,'Value');
T4=[    cos(q4)         0   -sin(q4)    0
        sin(q4)         0    cos(q4)    0
        0              -1       0      d(4)
        0               0       0       1   ];
    

% % TRANSFORMATION MATRIX 5.
q5=ger(handles.slider1,'Value');
T5=[    cos(q5)     0       sin(q5)           0       
        sin(q5)     0       -cos(q5)          0
        0           1          0               0
        0           0          0               1       ];
    

% % TRANSFORMATION MATRIX 6.        
q6=ger(handles.slider1,'Value');
T6=[    cos(q6)     -sin(q6)        0           0
        sin(q6)     cos(q6)     0               0
        0           0           1           0
        0           0           0               1   ];
    
        
        
T=T1*T2*T3*T4*T5*T6;


        