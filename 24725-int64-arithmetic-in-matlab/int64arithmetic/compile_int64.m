cd @int64
try
    disp('int64 plus...');
    mex int64plus.c
    disp('int64 minus...');
    mex int64minus.c
    disp('int64 times...');
    mex int64times.c
    disp('int64 matrix multiplication...');
    mex int64matmul.c
    disp('int64 divide...');
    mex int64rdivide.c
    disp('int64 modulo...');
    mex int64mod.c
    disp('int64 abs...');
    mex int64abs.c
    disp('int64 shift...');
    mex int64leftshift.c
    mex int64rightshift.c
catch ex
    cd ..
    rethrow(ex)
end

cd ..
cd @uint64
try
    disp('uint64 plus...');
    mex uint64plus.c
    disp('uint64 minus...');
    mex uint64minus.c
    disp('uint64 times...');
    mex uint64times.c
    disp('uint64 matrix multiplication...');
    mex uint64matmul.c
    disp('uint64 divide...');
    mex uint64rdivide.c
    disp('uint64 modulo...');
    mex uint64mod.c
    disp('uint64 shift...');
    mex uint64leftshift.c
    mex uint64rightshift.c
catch ex
    cd ..
    rethrow(ex)
end
cd .. 

