function alpha = calculateNoiseType(readings)
%this function calculates the dominate noise type at a given tau value.
%variable d is to track number of difference oppperations for identifying
%noise types **************. d should start at 0 and go no higher than 2
%(not sure purpose of d at this point).

%the following is the algorithm for calculating noise type
done = 0;
d = 0;
z = readings;

while done == 0
    
    r1 = rOneCalculation(z);
    
    delta = r1 / (r1 + 1); 
    
    if d >= 0 && (delta < .25 || d >= 2)
        p = -2*(delta+d);
        alpha = p + 2; %for time data
        done = 1;
    else
        z = calculateDiffArray(z);
        d = d + 1;
    end
end