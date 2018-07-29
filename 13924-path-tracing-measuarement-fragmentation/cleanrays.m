function I=cleanrays(J);
%Rays (1 pixel width line) deletion
I=J;
[si,sj]=size(I);

for k=1:2 
  for j=2:sj-1
    for i=2:si-1  
      cleanf
    end
  end
  I=I';
  for j=2:si-1
    for i=2:sj-1  
      cleanf
    end
  end
  I=I';
  if k==2
    I=rot90(I,2);
    for j=2:sj-1
      for i=2:si-1
        cleanf
      end
    end
    I=I';
    for j=2:si-1
      for i=2:sj-1
        cleanf
      end
    end   
    I=I';
    I=rot90(I,-2);
  end %k==2
  if k==1
    for j=2:sj-1
      for i=2:si-1  
        cleanf1 
      end
    end
    I=I'; 
    for j=2:si-1
      for i=2:sj-1  
        cleanf1
      end
    end
    I=I';
  end %if k==1
end %for k=1:2
for j=2:sj-2
  for i=2:si-1  
    if (~I(i,j))&I(i,j-1)&I(i,j+1)...
        &(~I(i,j+2))&I(i-1,j)...
        &I(i-1,j+1)&(~I(i+1,j))...
        &I(i+1,j-1)&(~I(i+1,j+1))
      I(i,j)=1;
    end
  end
end
