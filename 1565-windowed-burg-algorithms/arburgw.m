function varargout= arburgw( x, p, ventana)
%ARBURGW   AR parameter estimation via windowed-Burg method.
%   A = ARBURGW(X,ORDER,WINDOW) returns the polynomial A corresponding to the
%   AR parametric signal model estimate of vector X using windowed-Burg's method.
%   ORDER is the model order of the AR system. WINDOW is the Matlab window 
%   function name we want to use for windowing the algorithm errors, e.g., 
%   'boxcar' is the same that use the classic burg method, and 'hamming' is 
%   the solution proposed by Swingler(For others possibilities, see reference).
%   If no window is specified, the algorithm use the boxcar.
%
%   [A,E] = ARBURGW(...) returns the final prediction error E (the variance
%   estimate of the white noise input to the AR model).
%
%   [A,E,K] = ARBURGW(...) returns the vector K of reflection 
%   coefficients (parcor coefficients).
%
%   See also PBURG, PBURGW, ARMCOV, ARCOV, ARYULE, LPC, PRONY.

%	 Ref: J. G. Proakis y D. G. Manolakis, "Tratamiento Digital de Señales,
%			principios, algoritmos y aplicaciones", 1997, chapter 12.
%        (This book has several English versions)
%   Author(s): J. de la Torre Peláez
%   $Revision: 1 $  $Date: 2002/04/01 14:13:37 $
% SPANISH HELP AT THIS SCRIPT END.

%1 - Revisión de los parámetros de entrada/Input Parameters Revision--------------------------------------->>
error(nargchk(2,3,nargin));
if isempty(p),
   error('Model order is needed.');%Necesita indicar el orden del modelo
end;
if nargin < 3, ventana='boxcar'; end; %Ventana rectangular/Right-angled Window

%2 - Inicialización de los parámetros/Parameters Initialization-------------------------------------------->>
x  = x; 
N  = length(x);
fi_t = x(2:end);%Vector truncado de errores de predicción hacia adelante/Forward prediction errors truncated vector
gi_t = x(1:end-1);%Vector truncado de errores de predicción hacia atrás/Backward prediction errors truncated vector
a  = 1;%Inicialización del vector de estimas de los coeficientes {ak} del filtro AR/ {ak}=AR filter coefficientes vector initialization
	Epsilon = x*x'/N; %(Epsilon0)(Error de mín. cuadrados)/(Min. square error)
K = zeros(p,1); %Estima de los coeficientes de reflexión/Reflection coefficients Estimate

%3 - Cálculo de las estimas de K, E, {ak}/ K, E {ak} Evaluation-------------------------------------------->>
%-----Procedimiento Iterativo/Iterative Algorithm---------------------------------------------------------->>
for i=1:p,
   %Cálculo de la ventana/Window evaluation:
   %Haciéndolo como sigue, puedo usar cualquier ventana que este
   %implementada como una función Matlab:
   %Using this way, I can use whatever function I want, if it is built with Matlab:
   vent=['v=' ventana '(length(fi_t));'];
   eval(vent);
   v=v(:)'; %Para convertirlo a fila(tanto si era columna como fila)/Convert to row.

   K(i)=-((v.*fi_t)*gi_t')/(((v.*fi_t) * fi_t'  +  (v.*gi_t) * gi_t')/2);%Con ventana/Using window
   %K(i)=-(fi_t*gi_t')/((fi_t * fi_t'  +  gi_t * gi_t')/2); %Sin ventana(=con ventana cuadrada)/No Window(=Rectangular window)
   
   a = [a;0] + K(i) * [0;flipud(conj(a))]; %Actualización de los {ak} / {ak} Actualization
   
   fi_t_nuevo= 		  fi_t	+	K(i) * gi_t;
   gi_t_nuevo= K(i)' * fi_t  +			 gi_t;
   fi_t= fi_t_nuevo(2:end);
   gi_t= gi_t_nuevo(1:end-1);
   
   Epsilon(i+1) = (1-K(i)*K(i)')*Epsilon(i);%error de mín. cuadrados/min. square error
end; %for i=1:p-1,
%-----------------------------<<------------Fin del procedimiento Iterativo/Iterative Algorithm ends here.

%Argumentos de salida/Output arguments:
a = a(:).'; % Los polinomios se dan como filas por convenio/By convention all polynomials are row vectors
varargout{1} = a;
if nargout >= 2
   E=Epsilon(end);
   varargout{2} = E;
end
if nargout >= 3
   varargout{3} = K(:);
end

%VERSIÓN ESPAÑOLA DE LA AYUDA:
%ARBURGW   Estimacion de los parametros AR usando el algoritmo de Burg Enventanado.
%   A = ARBURGW(X,ORDER,WINDOW) devuelve el polinomio A correspondiente a la
%   estimacion del modelo parametrico de la señal guardada en el vector X, usando
%   el algoritmo de Burg enventanado. ORDER es el orden del modelo AR. WINDOW es el
%   nombre de la funcion Matlab que quiere usarse para enventanar los errores del
%   algoritmo, p. ej. 'boxcar' es lo mismo que usar el algoritmo clasico de Burg
%   (arburg.m), y 'hamming' es la solucion propuesta por Swingler(ver la ayuda para
%   saber mas sobre el enventanado).
%   Si no se especifica ninguna ventana, el algoritmo presupone la rectangular(boxcar).
%
%   [A,E] = ARBURGW(...) devuelve el error final de prediccion E,(la estimacion de 
%   la varianza del ruido blanco que se aplicaria a la entrada del modelo AR).
%
%   [A,E,K] = ARBURGW(...) devuelve el vector K de los coeficientes de reflexion.
%
%   Vea tambien PBURG, PBURGW, ARMCOV, ARCOV, ARYULE, LPC, PRONY.

