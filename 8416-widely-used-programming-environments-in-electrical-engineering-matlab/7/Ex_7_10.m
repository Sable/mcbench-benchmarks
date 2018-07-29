		% Evaluarea functiei date pe domeniul considerat 
[X,Y]=meshgrid(-3.75:0.2:3.5);
Z=peaks(X,Y);
		% Lansarea comenzii mesh destinata reprezentarii grafice dorite
mesh(X,Y,Z)