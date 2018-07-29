function scatter3sph(X,Y,Z,varargin)
%SCATTER3SPH (X,Y,Z) Plots a 3d scatter plot with 3D spheres
%	SCATTER3SPH is like scatter3 only drawing spheres with volume, instead
%	of flat circles, at coordinates specified by vectors X, Y, Z. All three
%	vectors have to be of the same length.
%	SCATTER3SPH(X,Y,Z) draws the spheres with the default size and color.
%	SCATTER3SPH(X,Y,Z,'size',S) draws the spheres with sizes S. If length(S)= 1
%	the same size is used for all spheres.
%	SCATTER3SPH(X,Y,Z,'color',C) draws the spheres with colors speciffied in a
%	N-by-3 matrix C as RGB values.
%	Parameter names can be abreviated to 3 letters. For example: 'siz' or 
%	'col'. Case is irrelevant.
%
% Example
% %Coordinates
%  X= 100*rand(9,1); Y= 100*rand(9,1); Z= 100*rand(9,1);
% 
% %Colors: 3 blue, 3 red and 3 green
% C= ones(3,1)*[0 0 1];
% C= [C;ones(3,1)*[1 0 0]];
% C= [C;ones(3,1)*[0 1 0]];
% 
% %Spheres sizes
% S= 5+10*rand(9,1);
% 
% figure(1);
% scatter3sph(X,Y,Z,'size',S,'color',C);
% axis equal
% axis tight
% view(125,20);
% grid ON

%-- Some checking...
if nargin < 3 error('Need at least three arguments'); return; end
if mean([length(X),length(Y),length(Z)]) ~= length(X) error ('Imput vectors X, Y, Z are of different lengths'); return; end

%-- Defaults
C= ones(length(X),1)*[0 0 1];
S= 0.1*max([X;Y;Z])*ones(length(X),1);


%-- Extract optional arguments
for j= 1:2:length(varargin)
	string= lower(varargin{j});
	switch string(1:min(3,length(string)))
		case 'siz'
			S= varargin{j+1};
			if length(S) == 1
				S= ones(length(X),1)*S;
			elseif length(S) < length(X)
				error('The vector of sizes must be of the same length as coordinate vectors (or 1)');
				return
			end

		case 'col'
			C= varargin{j+1};
			if size(C,2) < 3	error('Colors matrix must have 3 columns'); return; end
			if size(C,1) == 1
				C= ones(length(X),1)*C(1:3);
			elseif size(C,1) < length(X)
				error('Colors matrix must have the same number of rows as length of coordinate vectors (or 1)');
				return
			end

		otherwise
			error('Unknown parameter name. Allowed names: ''size'', ''color'' ');
	end
end

%-- Sphere facets
[sx,sy,sz]= sphere(20);

%-- Plot spheres
hold on
for j= 1:length(X)
	surf(sx*S(j)+X(j), sy*S(j)+Y(j), sz*S(j)+Z(j),...
		'LineStyle','none',...
		'AmbientStrength',0.4,...
		'FaceColor',C(j,:),...
		'SpecularStrength',0.8,...
		'DiffuseStrength',1,...
		'FaceAlpha',0.65,...
		'SpecularExponent',2);
end
light('Position',[0 0 1],'Style','infinit','Color',[1 1 1]);
lighting gouraud
view(30,15)

