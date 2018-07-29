function caseis = EdgeBoundaryWrapQPOTTS(i,j,x)
ijinside=1;
if i==1 & j==1;caseis=1;ijinside=0;end;
if i==size(x,1) & j==size(x,1);caseis=2;ijinside=0;end;
if i==size(x,1) & j==1;caseis=3;ijinside=0;end;
if i==1 & j==size(x,1);caseis=4;ijinside=0;end;
if i==size(x,1) & j~=1;if j~=size(x,1);caseis=5;ijinside=0;end;end;
if j==size(x,1) & i~=1;if i~=size(x,1);caseis=6;ijinside=0;end;end;
if i==1 & j~=1;if j~=size(x,1);caseis=7;ijinside=0;end;end;
if j==1 & i~=1;if i~=size(x,1);caseis=8;ijinside=0;end;end;
if ijinside==1;caseis=9;end;