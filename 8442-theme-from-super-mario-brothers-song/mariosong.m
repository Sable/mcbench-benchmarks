%mysong.m :  mario brother's theme song..   programming: James Humes
%transcription: Stewart Bozarth

warning off

t = 0.17;
%intro
%keyst = [ 56 56 0 56 0 52 56 0 59 0 0 47 0 0 ];
%tdur = [t t t t t t t t t t 2*t t t 2*t ];
%bass
%keysb = [ 30 30 0 30 0 30 30 0 47 0 0 35 0 0];
%bdur = [ t t t t t t t t t t 2*t t t 2*t];
%alto
%keysa= [ 46 46 0 46 0 46 46 0 51 0 0 47 0 0 ];
%adur = [ t t t t t t t t t t 2*t t t 2*t];

%first part
%treble
% keyst = [ 52 0 47 0 44 0 0 49 0 51 0 50 49 0 47 0 56 0 59 0 61 0 57 59 0 56 0 52 54 51 0 ];
% tdur = [ t 2*t t 2*t t t t t t t t t t t  (2/3)*t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t];
% %bass
% keysb = [ 35 0 32 0 28 0 0 33 0 35 0 34 33 0 28 0 40 0 44 0 45 0 42 44 0 40 0 37 39 35 0 ];
% bdur = [ t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t];
% %alto
% keysa = [ 44 0 40 0 35 0 0 40 0 42 0 41 40 0 40 0 47 0 51 0 52 0 49 51 0 49 0 56 45 42 0];
% adur = [ t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t];


%breakdown
%treble
%keyst = [0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 59 58 57 54 0 56 0 64 0 64 64 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 55 0 0 54 0 52 0 0 0  ];
%tdur = [ 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t ];
%bass
%keysb = [ 28 0 35 0 40 0 33 0 40 40 40 33 0 28 0 32 0 35 40 0 57 0 57 57 0 35 0 28 0 35 0 40 0 33 0 40 40 40 33 0 0 36 0 0 38 0 40 0 35 35 0 28 0];
%bdur = [ t 2*t t 2*t t t t 2*t t t t t t t 2*t t 2*t t t t t t t t t t t t 2*t t 2*t t t t 2*t t t t t t 2*t t t t t 2*t t 2*t t t t t t];
%alto
%keysa = [ 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 56 55 54 51 0 52 0 59 0 59 59 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 48 0 0 45 0 44 0 0 0];
%adur = [2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t];

%bringback
%treble
%keyst = [52 52 0 52 0 52 54 0 56 52 0 49 47 0 0 52 52 0 52 0 52 54 56 0 0 52 52 0 52 0 52 54 0 56 52 0 49 47 0 0         56 52 0 47 0 48 0 49 57 0 57 49 0 0 51 0 61 0 61 0 61 0 59 0 57 0 56 52 0 49 47 0 0 56 52 0 47 0 48 0 49 57 0 57 49 0 0 47 57 0 57 57 0 56 0 54 0 52 0 0 0];
%tdur = [ t t t t t t t t t t t t t t 2*t t t t t t t t t 4*t 4*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t t t t t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t 2*t 4*t];
%bass
%keysb = [ 24 0 31 0 36 0 35 0 28 0 23 0 24 0 31 0 36 0 35 0 28 0 23 0 24 0 31  0 36 0 35 0 28 0 23 0    28 0 34 35 0 40 0 33 0 33 0 40 40 33 0 30 0 33 35 0 39 0 35 0 35 0 40 40 35 0 28 0 34 35 0 40 0 33 0 33 0 40 40 33 0 35 0 35 35 0 37 0 39 0 40 0 35 0 28 0 0];
%bdur = [ t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t  t 2*t t 2*t t t t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t t t 2*t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t];
%alto
%keysa = [ 48 48 0 48 0 48 50 0 47 44 0 44 40 0 0 48 48 0 48 0 48 50 47 0 0 48 48 0 48 0 48 50 0 47 44 0 44 40 0 0         52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 0 57 0 57 0 57 0 57 0 54 0 52 49 0 45 44 0 0 52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 54 0 54 54 0 52 0 51 0 47 44 0 44 40 0 0];
%adur = [t t t t t t t t t t t t t t 2*t t t t t t t t t 4*t 4*t t t t t t t t t t t t t t t 2*t       t t t t 2*t t t t t t t t t 2*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t t t t t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t];

%ending
%treble
%keyst = [52 0 47 0 44 0 49 51 49 48 50 47 47];
%tdur = [t 2*t t 2*t t t (4/3)*t (4/3)*t (4/3)*t  (4/3)*t (4/3)*t (4/3)*t (8*t)+.000001];
%bass
%keysb = [35 0 32 0 28 0 33 29 28 ];
%bdur = [t 2*t t 2*t t t 4*t 4*t 8*t];
%alto
%keysa = [44 0 40 0 35 0 45 45 44 42 44];
%adur = [t 2*t t 2*t t t 4*t 4*t t t 6*t];





% whole song
keyst = [  56 56 0 56 0 52 56 0 59 0 0 47 0 0                         52 0 47 0 44 0 0 49 0 51 0 50 49 0 47 0 56 0 59 0 61 0 57 59 0 56 0 52 54 51 0      52 0 47 0 44 0 0 49 0 51 0 50 49 0 47 0 56 0 59 0 61 0 57 59 0 56 0 52 54 51 0                   0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 59 58 57 55 0 56 0 64 0 64 64 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 55 0 0 54 0 52 0 0 0           0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 59 58 57 55 0 56 0 64 0 64 64 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 55 0 0 54 0 52 0 0 0                 52 52 0 52 0 52 54 0 56 52 0 49 47 0 0 52 52 0 52 0 52 54 56 0 0 52 52 0 52 0 52 54 0 56 52 0 49 47 0 0          56 56 0 56 0 52 56 0 59 0 0 47 0 0          56 52 0 47 0 48 0 49 57 0 57 49 0 0 51 0 61 0 61 0 61 0 59 0 57 0 56 52 0 49 47 0 0 56 52 0 47 0 48 0 49 57 0 57 49 0 0 47 57 0 57 57 0 56 0 54 0 52 0 0 0 52 0 47 0 44 0 49 51 49 48 50 48 47];
tdur = [  t t t t t t t t t t 2*t t t 2*t             t 2*t t 2*t t t t t t t t t t t  (2/3)*t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t      t 2*t t 2*t t t t t t t t t t t  (2/3)*t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t             2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t              2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t               t t t t t t t t t t t t t t 2*t t t t t t t t t 4*t 4*t t t t t t t t t t t t t t t 2*t                     t t t t t t t t t t 2*t t t 2*t               t t t t 2*t t t t t t t t t 2*t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t t t t t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t 2*t 4*t        t 2*t t 2*t t t (4/3)*t (4/3)*t (4/3)*t  (4/3)*t (4/3)*t (4/3)*t (8*t) ];

keysb = [   30 30 0 30 0 30 30 0 47 0 0 35 0 0         35 0 32 0 28 0 0 33 0 35 0 34 33 0 32 0 40 0 44 0 45 0 42 44 0 40 0 37 39 35 0          35 0 32 0 28 0 0 33 0 35 0 34 33 0 32 0 40 0 44 0 45 0 42 44 0 40 0 37 39 35 0              28 0 35 0 40 0 33 0 40 40 40 33 0 28 0 32 0 35 40 0 57 0 57 57 0 35 0 28 0 35 0 40 0 33 0 40 40 40 33 0 0 36 0 0 38 0 40 0 35 35 0 28 0               28 0 35 0 40 0 33 0 40 40 40 33 0 28 0 32 0 35 40 0 57 0 57 57 0 35 0 28 0 35 0 40 0 33 0 40 40 40 33 0 0 36 0 0 38 0 40 0 35 35 0 28 0              24 0 31 0 36 0 35 0 28 0 23 0 24 0 31 0 36 0 35 0 28 0 23 0 24 0 31  0 36 0 35 0 28 0 23 0          30 30 0 30 0 30 30 0 47 0 0 35 0 0                28 0 34 35 0 40 0 33 0 33 0 40 40 33 0 30 0 33 35 0 39 0 35 0 35 0 40 40 35 0 28 0 34 35 0 40 0 33 0 33 0 40 40 33 0 35 0 35 35 0 37 0 39 0 40 0 35 0 28 0 0         35 0 32 0 28 0 33 29 28                ];
bdur = [  t t t t t t t t t t 2*t t t 2*t           t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t          t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t       t 2*t t 2*t t t t 2*t t t t t t t 2*t t 2*t t t t t t t t t t t t 2*t t 2*t t t t 2*t t t t t t 2*t t t t t 2*t t 2*t t t t t t          t 2*t t 2*t t t t 2*t t t t t t t 2*t t 2*t t t t t t t t t t t t 2*t t 2*t t t t 2*t t t t t t 2*t t t t t 2*t t 2*t t t t t t              t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t t 2*t t 2*t t t  t 2*t t 2*t t t         t t t t t t t t t t 2*t t t 2*t             t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t t t 2*t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t         t 2*t t 2*t t t 4*t 4*t 8*t  ];

keysa = [ 46 46 0 46 0 46 46 0 51 0 0 47 0 0          44 0 40 0 35 0 0 40 0 42 0 41 40 0 40 0 47 0 51 0 52 0 49 51 0 49 0 56 45 42 0          44 0 40 0 35 0 0 40 0 42 0 41 40 0 40 0 47 0 51 0 52 0 49 51 0 49 0 56 45 42 0            0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 56 55 54 51 0 52 0 59 0 59 59 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 48 0 0 45 0 44 0 0 0            0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 56 55 54 51 0 52 0 59 0 59 59 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 48 0 0 45 0 44 0 0 0              48 48 0 48 0 48 50 0 47 44 0 44 40 0 0 48 48 0 48 0 48 50 47 0 0 48 48 0 48 0 48 50 0 47 44 0 44 40 0 0          46 46 0 46 0 46 46 0 51 0 0 47 0 0           52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 0 57 0 57 0 57 0 56 0 54 0 52 49 0 45 44 0 0 52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 54 0 54 54 0 52 0 51 0 47 44 0 44 40 0 0           44 0 40 0 35 0 45 45 44 42 44                 ];
adur = [  t t t t t t t t t t 2*t t t 2*t        t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t               t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t            2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t                2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t          t t t t t t t t t t t t t t 2*t t t t t t t t t 4*t 4*t t t t t t t t t t t t t t t 2*t        t t t t t t t t t t 2*t t t 2*t               t t t t 2*t t t t t t t t t 2*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t t t t t  (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t          t 2*t t 2*t t t 4*t 4*t t t 6*t              ];

keysd = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 2 0 0 0 0 0 0 0 0 0   ];
ddur = [  t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t t/2 t/2 t t t     ];



 fs = 11025;
 xt = zeros(1, sum(tdur)*fs+1);
 xb = zeros(1, sum(bdur)*fs+1);
 xa = zeros(1, sum(adur)*fs+1);
 xd = zeros(1, sum(ddur)*fs+1);
 
 n1=1;
 for kk = 1:length(keyst)
     keynum=keyst(kk);
     tone=note(keyst(kk), tdur(kk));
     n2=n1 + length(tone)-1;
     xt(n1:n2) = xt(n1:n2) + tone;
     n1 = n2;
 end
 
 n1 = 1;
 for kk = 1:length(keysb)
    keynum=keysb(kk);
    tone=note(keysb(kk), bdur(kk));
    n2=n1 +length(tone)-1;
    xb(n1:n2) = xb(n1:n2) + tone;
    n1=n2;
end

n1=1;
for kk = 1:length(keysa)
    keynum=keysa(kk);
    tone=note(keysa(kk), adur(kk));
    n2=n1 +length(tone)-1;
    xa(n1:n2) = xa(n1:n2) + tone;
    n1=n2;
end

 n1=1;
  for kk = 1:length(keysd)
      keynum=keysd(kk);
      tone=note(keysd(kk), ddur(kk));
      n2=n1 + length(tone)-1;
      xd(n1:n2) = xd(n1:n2) + tone;
      n1 = n2;
  end
  
 

%the "mixing board"

xx=xa+xb+xt+xd;
soundsc(xx, fs)