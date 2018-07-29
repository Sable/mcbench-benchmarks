% Some tests for the ISODD function.

% Test vector and correct answer.
test_vector = 0:9;
aa = logical([0 1 0 1 0 1 0 1 0 1]);

% First simplest test.
try
    a1 = isodd(test_vector);
    if all(a1==aa)
        disp('Test 1 passed.');
    else
        disp('*** Test 1 failed. ***');
    end
catch me
    disp('*** Test 1 failed, an unexpected error was raised! ***');
end

% Other data types, positive and negative numbers.
try
    a1 = isodd(int8(test_vector-4));
    a2 = isodd(int16(test_vector-4));
    a3 = isodd(int32(test_vector-4));
    a4 = isodd(int64(test_vector-4));
    a5 = isodd(single(test_vector-4));
    a6 = isodd(double(test_vector-4));
    a7 = isodd(uint8(test_vector));
    a8 = isodd(uint16(test_vector));
    a9 = isodd(uint32(test_vector));
    a10 = isodd(uint64(test_vector));
    if all(a1==aa) && all(a2==aa) && all(a3==aa) && all(a4==aa) && ...
            all(a5==aa) && all(a6==aa) && all(a7==aa) && all(a8==aa) && ...
            all(a9==aa) && all(a10==aa)
        disp('Test 2 passed.');
    else
        disp('*** Test 2 failed. ***');
    end
catch me
    disp('*** Test 2 failed, an unexpected error was raised! ***');
end

% The "weird numbers".
try
    a1 = isodd(int8(-2^7));
    a2 = isodd(int16(-2^15));
    a3 = isodd(int32(-2^31));
    a4 = isodd(int64(-2^63));
    if ~a1 && ~a2 && ~a3 && ~a4
        disp('Test 3 passed.');
    else
        disp('*** Test 3 failed. ***');
    end
catch me
    disp('*** Test 3 failed, an unexpected error was raised! ***');
end

% Too large numbers.
try
    isodd(1e20);
    disp('*** Test 4 failed, no error was raised! ***');
catch me
    disp('Test 4 passed.');
end
try
    isodd(single(1e10));
    disp('*** Test 5 failed, no error was raised! ***');
catch me
    disp('Test 5 passed.');
end

% Special numbers where we want an error raised.
try
    isodd(1.1);
    disp('*** Test 6 failed, no error was raised! ***');
catch me
    disp('Test 6 passed.');
end
try
    isodd(Inf);
    disp('*** Test 7 failed, no error was raised! ***');
catch me
    disp('Test 7 passed.');
end
try
    isodd(-Inf);
    disp('*** Test 8 failed, no error was raised! ***');
catch me
    disp('Test 8 passed.');
end
try
    isodd(NaN);
    disp('*** Test 9 failed, no error was raised! ***');
catch me
    disp('Test 9 passed.');
end
try
    isodd(complex(sqrt(2), sqrt(2)));
    disp('*** Test 10 failed, no error was raised! ***');
catch me
    disp('Test 10 passed.');
end
try
    isodd(single([1e15 0 ; 0 0]));
    disp('*** Test 11 failed, no error was raised! ***');
catch me
    disp('Test 11 passed.');
end
