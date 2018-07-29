%GM_PHD_Create_Birth
%Last modified 2nd September 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file performs the processing on measurements to extract new targets
%and populates the birth lists (mean, weight, covariance) needed to instantiate them next iteration.

%This is not formall spelt out in Vo&Ma so I have used my best judgement to
%come up with a method to initialise targets. Targets are initialised as
%static (using the position of current measurements) and/or dynamic (using
%two generations of measurements and calculating the movement between).
%If only static targets are added, the number of new targets = the number
%of measurements. 
%If only dynamic targets are added, the number of new targets = the number of
%measurements this teration * the number of measurements last iteration
%If both static and dynamic targets are added, the number of new targets is
%equal to the sum of these.
disp('Step 7: Creating new targets from measurements, for birthing next iteration');
w_birth = [];
m_birth = [];
P_birth = [];
w_spawn = [];
m_spawn = [];
P_spawn = [];
numBirthedTargets = 0;
numSpawnedTargets = 0;

%We create targets using two generations of measurements.
%The first generation is used to calculate the velocity (dx/dt) to the
%second generation.
%The second generation gives the position.
%We also add a set of targets from the second generation but with velocity
%zero, since some may be unlinked to the first generation, but we have no
%velocity information for them.
if(k >= 2)%If only one iteration complete, cannot calculate velocity
        %Each measurement consists of 2 rows
        thisMeasRowRange = k;
        prevMeasRowRange = k-1;

        thisMeas = simMeasurementHistory{thisMeasRowRange};
        prevMeas = simMeasurementHistory{prevMeasRowRange};
    
        for j_this = 1:size(thisMeas,2)
            if(addVelocityForNewTargets == true)%If we want to add targets with initial velocities
                for j_prev = 1:1:size(prevMeas,2)%Match every pair from previous to current
                    m_this = thisMeas(:,j_this);
                    m_prev = prevMeas(:, j_prev);
                    %Calculate and add the velocity.
                    m_i = m_this;
                    v = (m_this(1:2) - m_prev(1:2)) / dt;
                    if(abs(v(1)) > MAX_V) || (abs(v(2)) > MAX_V)
                        continue;%To reduce the number of targets added, we filter out the targets with unacceptable velocities.
                    end

                    m_i = [m_i; v];

                    %Decide if the target is birthed (from birth position)
                    %or spawned (from an existing target)
                    %Initialise the weight to birth
                    birthWeight = birth_intensity(m_i);
                    %Targets can also spawn from existing targets. We will
                    %take whichever is a higher weight - birthing or
                    %spawning
                    nTargets = size(X_k, 2);
                    maxSpawnWeight = -1;
                    for targetI = 1:nTargets
                        thisWeight = spawn_intensity(m_i, X_k(:,targetI)) * X_k_w(targetI);%Spawn weight is a function of proximity to the existing target, and the weight of the existing target.
                        if(thisWeight > maxSpawnWeight)
                            maxSpawnWeight = thisWeight;
                        end
                    end
                    %Check if birthing had higher weight.
                    if(birthWeight > maxSpawnWeight)
                        %Birth the target
                        w_i = birthWeight;
                        %Initialise the covariance
                        P_i = covariance_birth;
                        w_birth = [w_birth, w_i];
                        m_birth = [m_birth m_i];
                        P_birth = [P_birth, P_i];
                        numBirthedTargets = numBirthedTargets + 1;
                    else
                        %Spawn the target
                        w_i = maxSpawnWeight;
                        %Initialise the covariance
                        P_i = covariance_spawn;
                        w_spawn = [w_spawn, w_i];
                        m_spawn = [m_spawn, m_i];
                        P_spawn = [P_spawn, P_i];
                        numSpawnedTargets = numSpawnedTargets + 1;
                    end                
                end
            end
        
            %If we want to add targets, treating them as if they are
            %static.
            if (addStaticNewTargets == true)
                %Add a static target
                m_i = thisMeas(:,j_this);
                m_i(3:4) = [0; 0];
                
                %Decide if the target is birthed (from birth position)
                %or spawned (from an existing target)
                %Initialise the weight to birth
                birthWeight = birth_intensity(m_i);
                %Targets can also spawn from existing targets. We will
                %take whichever is a higher weight - birthing or
                %spawning
                nTargets = size(X_k, 2);
                maxSpawnWeight = -1;
                for targetI = 1:nTargets
                    thisWeight = spawn_intensity(m_i, X_k(:,targetI));
                    if(thisWeight > maxSpawnWeight)
                        maxSpawnWeight = thisWeight;
                    end
                end
                %Check if birthing had higher weight.
                if(birthWeight > maxSpawnWeight)
                    %Birth the target
                    w_i = birthWeight;
                    %Initialise the covariance
                    P_i = covariance_birth;
                    w_birth = [w_birth, w_i];
                    m_birth = [m_birth m_i];
                    P_birth = [P_birth, P_i];
                    numBirthedTargets = numBirthedTargets + 1;
                else
                    %Spawn the target
                    w_i = maxSpawnWeight;
                    %Initialise the covariance
                    P_i = covariance_spawn;
                    w_spawn = [w_spawn, w_i];
                    m_spawn = [m_spawn m_i];
                    P_spawn= [P_spawn, P_i];
                    numSpawnedTargets = numSpawnedTargets + 1;
                end                 
            end
        end
end

if VERBOSE == 1
    for j = 1:numBirthedTargets
        thisM = m_birth(:,j);
        s = sprintf('Target to birth %d: %3.4f %3.4f %3.4f %3.4f Weight %3.9f', j, thisM(1), thisM(2), thisM(3), thisM(4), w_birth(j));
        disp(s);
    end
    for j = 1:numSpawnedTargets
        thisM = m_spawn(:,j);
        s = sprintf('Target to spawn %d: %3.4f %3.4f %3.4f %3.4f Weight %3.9f', j, thisM(1), thisM(2), thisM(3), thisM(4), w_spawn(j));
        disp(s);
    end
end
