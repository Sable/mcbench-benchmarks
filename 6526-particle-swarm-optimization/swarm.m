function swarm
warning off MATLAB:divideByZero
%%%  Script Particle Swarm Optimization
%%%  Author: Ivan Candelas del Toro
%%%  e-mail: ivanct@gmail.com
%%%%%
%  Control variables
%%%%%
  global numberOfParticles;
  numberOfParticles = 40;
  global numberOfNeighbors;
  numberOfNeighbors = 4;
  maxIterations = 1000;
  
  %% Limites para cambio de localización
  global deltaMin;
  deltaMin = -4.0;
  global deltaMax;
  deltaMax = 4.0;
  
  %% individuality and sociality
  iWeight = 2.0;
  iMin = 0.0;
  iMax = 1.0;
  sWeight = 2.0;
  sMin = 0.0;
  sMax = 1.0;
  %%%%%%%%%%%
  %% Related variables to the problem space solutions
  %%%%%%%%%%%
  initialFitness = -100000;
  targetFitness = 0;
  global dimensions;
  dimensions = 4;
  %%%% Program Start
  global particles;
  
  for p = 1:numberOfParticles
    for d = 1:dimensions
      particles(p).next(d) = randint(1,10); %%%%%%%%%%%%%%%%%
      particles(p).velocity(d) = randint(deltaMin,deltaMax); %%%%%%%%%%%
      particles(p).current(d) = particles(p).next(d);
    end
    
    particles(p).bestSoFar = initialFitness;
  end
  
  for p = 1:numberOfParticles
    neighborVector = getNeighborIndexVector(p,numberOfNeighbors);
    for n = 1:numberOfNeighbors
      particles(p).neighbor(n) = neighborVector(n);
    end
  end
  
  iterations = 0;
  tic
  while iterations <= maxIterations
    
    for p = 1:numberOfParticles     
      for d = 1:dimensions
	particles(p).current(d) = particles(p).next(d);
      end
      
      fitness = test(p);
      
      if fitness > particles(p).bestSoFar;
	particles(p).bestSoFar = fitness;
	for d = 1:dimensions
	  particles(p).best(d) = particles(p).current(d);
	end
      end
      
      if fitness == targetFitness
	X=particles(p).current(1)
	Y=particles(p).current(2)
	Z=particles(p).current(3)
        W=particles(p).current(4)
        total_time=toc
	disp('Success!!');
        return
      end
      
    end
    
    for p = 1:numberOfParticles
      n = getNeighborIndexWithBestFitness(p);
      for d = 1:dimensions
	iFactor = iWeight * randint(iMin,iMax); %%%%%%%%%%%%%%
	sFactor = sWeight * randint(sMin,sMax); %%%%%%%%%%%%%
	pDelta(d) = particles(p).best(d) - particles(p).current(d);
	nDelta(d) = particles(n).best(d) - particles(p).current(d);
	
	delta = (iFactor * pDelta(d)) + (sFactor * nDelta(d));
	delta = particles(p).velocity(d) + delta;
	
	particles(p).velocity(d) = constrict(delta);
	particles(p).next(d) = particles(p).current(d) + particles(p).velocity(d);
	
      end
    end
    
    iterations = iterations + 1
  end
  disp('Failure');
%%%%%%%%%%
%%% Support Functions
%%%%%%%%%%
%%-------------
function fitness = test(p)
  global particles;
  x = particles(p).current(1);
  y = particles(p).current(2);
  z = particles(p).current(3);
  w = particles(p).current(4);
  
  f = 5 * (x^2) + 2 * (y^3) - (z/w)^2 + 4;
  
  if ( x * y ) == 0 
    n = 1;
  else
    n = 0;
  end
  
  fitness = 0 - abs(f) - n;
  
%%-------------
function d = constrict(delta)
  global deltaMin;
  global deltaMax;
  if delta < deltaMin
    d = deltaMin;
    return
  end
  if delta > deltaMax
    d = deltaMax;
    return
  end
  d = delta;
  
%%--------
function p = getNeighborIndex(pindex,n)
  global numberOfParticles;
  global dimensions;
  global particles;
  dista=zeros(1,numberOfParticles);
  for i = 1:numberOfParticles
    suma = 0;
    for d = 1:dimensions
      suma = suma + (particles(pindex).current(d) - particles(i).current(d))^2;
    end
    dista(i)=sqrt(suma);
  end
  [X,I] = sort(dista);
  p = I(n);

%%--------
function p = getNeighborIndexVector(pindex,n)
  global numberOfParticles;
  global dimensions;
  global particles;
  dista=zeros(1,numberOfParticles);
  for i = 1:numberOfParticles
    suma = 0;
    for d = 1:dimensions
      suma = suma + (particles(pindex).current(d) - particles(i).current(d))^2;
    end
    dista(i)=sqrt(suma);
  end
  [X,I] = sort(dista);
  p = I(1:n);

  
%%---------
function p = getNeighborIndexWithBestFitness(pindex)
  global dimensions;
  global particles;
  global numberOfNeighbors;
  fit = zeros(1,4);
  for d = 1:numberOfNeighbors;
    fit(d) = test(particles(pindex).neighbor(d));
  end
  [X,I] = sort(fit);
  p = particles(pindex).neighbor(I(1));
  
  
%%-------------
%
%return a random integer between min and max
%
function num = randint(min,max)
  array = min:max;
  index = mod(floor(rand(1)*1000),size(array,2))+1;
  num = array(index);
