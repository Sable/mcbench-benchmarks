function IESM = IndexElementStateMatrixQPOTTS(x,caseis,state,i,j)

I=size(x,1);J=size(x,1);
if caseis==1;IESM=[state(I,J) state(I,1) state(I,2);state(1,J) state(1,1) state(1,2);state(2,J) state(2,1) state(2,2)];
elseif caseis==2;IESM=[state(I-1,J-1) state(I-1,J) state(I-1,1);state(I,J-1) state(I,J) state(I,1);state(1,J-1) state(1,J) state(1,1)];
elseif caseis==3;IESM=[state(I-1,J) state(I-1,1) state(I-1,2);state(I,J) state(I,1) state(I,2);state(1,J) state(1,1) state(1,2)];
elseif caseis==4;IESM=[state(I,J-1) state(I,J) state(I,1);state(1,J-1) state(1,J) state(1,1);state(2,J-1) state(2,J) state(2,1)];
elseif caseis==5;IESM=[state(I-1,j-1) state(I-1,j) state(I-1,j+1);state(I,j-1) state(I,j) state(I,j+1);state(1,j-1) state(1,j) state(1,j+1)];
elseif caseis==6;IESM=[state(i-1,J-1) state(i-1,J) state(i-1,1);state(i,J-1) state(i,J) state(i,1);state(i+1,J-1) state(i+1,J) state(i+1,1)];
elseif caseis==7;IESM=[state(I,j-1) state(I,j) state(I,j+1);state(1,j-1) state(1,j) state(1,j+1);state(2,j-1) state(2,j) state(2,j+1)];
elseif caseis==8;IESM=[state(i-1,J) state(i-1,1) state(i-1,2);state(i,J) state(i,1) state(i,2);state(i+1,J) state(i+1,1) state(i+1,2)];
elseif caseis==9;IESM=[state(i-1,j-1) state(i-1,j) state(i-1,j+1);state(i,j-1) state(i,j) state(i,j+1);state(i+1,j-1) state(i+1,j) state(i+1,j+1)];
end