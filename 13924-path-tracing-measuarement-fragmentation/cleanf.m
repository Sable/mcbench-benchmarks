%script cleanf
if I(i,j)|~I(i-1,j)|~I(i+1,j)
  return
end
if I(i,j+1)&I(i,j-1)
    I(i,j)=1;
    return
end
if (~I(i,j+1))&I(i-1,j+1)...
    &I(i+1,j+1)...
    &I(i-1,j-1)>0&I(i+1,j-1)>0
    I(i,j)=1;
end
