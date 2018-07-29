function [phi,p]=houghparabola(Imbinary,centrox,centroy,pmin,pmax)
%HOUGHPARABOLA - detects parabola with specific vertex in a binary image.
%
%Comments:
%       Function uses Standard Hough Transform to detect parabola in a 
%       binary image. According to the Hough Transform, each pixel in image
%       space corresponds to a parabola in Hough space and vise versa. This
%       function uses the representation of parabola: 
%       [(y-centroy)*cos(phi)-(x-centrox)*sin(phi)]^2=...
%               ...=4*p*[(y-centroy)*sin(phi)+(x-centrox)*cos(phi)]
%       to detect parabola in binary image.
%       Upper left corner of image is the origin of coordinate system.
%
%Usage: [phi,p] = houghparabola(Imbinary,centrox,centroy,pmin,pmax)
%
%Arguments:
%       Imbinary - a binary image. image pixels that have value equal to 1 
%                  are interested pixels for HOUGHPARABOLA function.
%       centrox  - column coordinates of the parabola vertex.
%       centroy  - row coordinates of the parabola vertex.
%       pmin     - minimum possible value of the distance p between the 
%                  vertex and focus of the parabola.
%       pmax     - maximum possible value of the distance p between the 
%                  vertex and focus of the parabola.
%                  
%
%Returns:
%       phi      - angle of the detected parabola in polar coordinates
%       p        - distance between vertex and focus of the detected
%                  parabola.
%
%Written by :
%       Clara Isabel Sánchez
%       Biomedical Engineering Group
%       ETS Ingenieros de Telecomunicaciones
%       University of Valladolid,Spain
%       csangut@gmail.com
%
%August 6,2007      - Original version


vector_p=linspace(-pmax,pmax);
vector_phi=linspace(0,2*pi-(2*pi/100));
Accumulator = zeros([length(vector_phi),length(vector_p)]);
[y,x] = find(Imbinary);

%Voting
for i = 1:length(x)
   for j= 1:length(vector_phi)
       Y=y(i)-centroy;
       X=x(i)-centrox;
       angulo=vector_phi(j);
       numerador=(Y*cos(angulo)-X*sin(angulo))^2;
       denominador=4*(X*cos(angulo)+Y*sin(angulo));
       if denominador~=0
           p=numerador/denominador;
           
           if abs(p)>pmin&abs(p)<pmax&p~=0
               indice=find(vector_p>=p);
               indice=indice(1);
               Accumulator(j,indice) = Accumulator(j,indice)+1;
           end
       end
   end
end

% Finding local maxima in Accumulator
maximo=max(max(Accumulator));
[idx_phi,idx_p]=find(Accumulator==maximo);
p=vector_p(idx_p);
phi=vector_phi(idx_phi);
