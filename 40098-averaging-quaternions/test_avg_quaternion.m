
% A simple test function to evaluate the output
% This function optionally compares the result with rotqrmean from voicebox
% If you have voicebox of course.
%
% Tolga Birdal
%
function []=test_avg_quaternion()

% Generate a random quaternion and duplicate it
qinit=rand(4,1);
Q=repmat(qinit,1,10);

% apply small perturbation to the quaternions 
perturb=0.004;
Q2=Q+rand(size(Q))*perturb;

% Take the average using this method and Voicebox's rotqrmean

USEVOICEBOX=0;

Qavg=avg_quaternion_markley(Q')
Qavg2=avg_quaternion_markley(Q2')

if (USEVOICEBOX)
    disp('Using voicebox');
    QavgVB=rotqrmean(Q)
    QavgVB2=rotqrmean(Q2)
else
    disp('Not using voicebox');
end

end