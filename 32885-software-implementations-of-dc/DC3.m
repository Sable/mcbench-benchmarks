clear;
clc;
start=clock;
id=1;
switch id
  case 1
        Da='4k2_far-d2.txt';                    % 4-400
  case 2
        Da='iris-d4.txt';                       % 3-150
  case 3
        Da='yeast-d7.txt';                      % 5-384
  case 4
        Da='pima-indians-diabetes-d8.txt';      % 2-768   
  case 5
        Da='image-210-d19.txt';                 % 7-210
  case 6
        Da='movement-d90.txt';                  % 15-360
  case 7
        Da='sonar-d60.txt';                     % 2-208
  case 8
        Da='artificial-d7.txt';              		% 10-5109
  case 9
        Da='auto-mpg-d7.txt';                   % 3-393
  case 10
        Da='vowel-d10.txt';                     % 11-990
  case 11
        Da='pima-1536-d8.txt';                  % 2-1536
  case 12
        Da='pima-2000-d8.txt';                  % 2-2000
  case 13
        Da='pima-2500-d8.txt';                  % 2-2500
  case 14
        Da='pima-3072-d8.txt';                  % 2-3072
  case 15
        Da='pima-4000.txt';											% 2-4000
  case 16
        Da='waveform-d21.txt';               		% 3-5000
end
Data=load(Da);
ddd=size(Data,2);
cn=(Data(:,1));
K=max(cn); 
r=K;
A=Data(:,2:ddd);
row=size(A,1);
col=size(A,2);
clear Data ddd
Dist = similarity_euclid(A);
S_Matrix=(zeros(row,row)-Dist);
for kk=1:row,
    for kkk=1:row,
        if Dist(kk,kkk)==0&kk~=kkk,
            Dist(kk,kkk)=0.000001;
        end
    end
end
center=(1:1:row)';
[SD,II]=sort(Dist); 
SD=(zeros(row,row))-(SD');
II=II';
E=zeros(1,1);
R=SD(:,1:r);
E= sum(R,2);     
[new_center,cl]=update_centers(SD,II,E,K,row,center);
fprintf('Elapsed time: %g sec\n',etime(clock,start));
fprintf('F1=%f\n',evalf(cn,cl));
