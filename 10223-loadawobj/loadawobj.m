function [V,F3,F4]=loadawobj(modelname,opts)
% loadawobj
% Load an Wavefront/Alias obj style model. Will only consider polygons with 
% 3 or 4 vertices.
% Programme will also ignore normal and texture data. It will also ignore any
% part of the obj specification that is not a polygon mesh, ie nurbs, these
% deficiencies can probably be remedied relatively easily
%
% [v,f3,f4]=loadawobj(modelname)
%
% To come, s=loadawobj(modelname) where s is a structure
% s should contain containing texture coords, vertex norms, vn, sub
% ranges g3 and g4, and possibly even faces > 4
%
% See also Anders Sandberg's vertface2obj.m and saveobjmesh.m
% 
% there is still a good chance that obj files will not load. I
% would be grateful for any reports and examples of those that fail.
%
% W.S. Harwin, University Reading, 2006,2010.
% Matlab BSD license
% thanks also to Doug Hackett


version=0.2;
if nargin <1 
  disp('specify model name')
end


fid = fopen(modelname,'r');
if (fid<0)
  error(['can not open file: ' modelname]);
  return ;
end

vnum=1;
f3num=1;
f4num=1;
vtnum=1;
vnnum=1;
g3num=1;
g4num=1;
Vtmp=[];

% Line by line passing of the obj file

while ~feof(fid)
  Ln=fgets(fid);
  Ln=removespace(Ln);
  objtype=sscanf(Ln,'%s',1);
  l=length(Ln);
  if l==0  % isempty(s) ; 
%    disp(['empty' Ln]);
    continue
  end
%  disp(Ln)
  Lyn=Ln; %temp hack
  switch objtype
    case '#' % comment
      disp(Ln);
    case 'v' % vertex
      v=sscanf(Ln(2:end),'%f');
      Vtmp(:,vnum)=v;
      vnum=vnum+1;
    case 'vt'	% textures
      if vtnum==1 
        disp(Ln);
        vtnum=vtnum+1;
      end
    case 'g' % sub mesh
      disp(Ln);
%      if f3num > g3num(end);
      g3num=[g3num f3num];
%      if f4num> g4num(end)
      g4num=[g4num f4num];
    case 'mtllib' % material library
        disp(Ln);
    case 'usemtl' % use this material name
        disp(Ln);
    case 'l' % Line
        disp(Ln);
    case 's' %smooth shading across polygons
        disp(Ln);
    case 'vn' % normals
      if vnnum==1 
        disp(Ln);
        vnnum=vnnum+1;
      end
    case 'f' % faces
      nvrts=length(findstr(Ln,' ')); % spaces as a predictor of n vertices
      slashpat=findstr(Ln,'/');
      nslash=length(slashpat);
      if nslash >1 % dblslash can be 0, 1 or >1
        dblslash=slashpat(2)-slashpat(1); else dblslash=0; 
      end
      Ln=Ln(3:end); % get rid of the f
      if nslash == 0 % Face = vertex
%        disp('-v');
        f1=sscanf(Ln,'%f');
      elseif nslash == nvrts && dblslash>1 % Face = v/tc
%        disp('-v/tc');
        data1=sscanf(Ln,'%f/%f');
        if nvrts == 3 
          f1=data1([1 3 5]);
          tc1=data1([2 4 6]);
        end
        if nvrts == 4;
          f1=data1([1 3 5 7]);
          tc1=data1([2 4 6 8]);
        end
      elseif nslash == 2*nvrts && dblslash==1 % v//n
%        disp('-v//n');
        data1=sscanf(Ln,'%f//%f');
        if nvrts == 3 
          f1=data1([1 3 5]);
          vn1=data1([2 4 6]);
          Vn3(:,f3num)=f1;
        end
        if nvrts == 4;
          f1=data1([1 3 5 7]);
          vn11=data1([2 4 6 8]);
          Vn4(:,f4num)=f1;
        end
      elseif nslash == 2*nvrts && dblslash>1 % v/tc/n
%        disp('-v/tc/n');
        data1=sscanf(Ln,'%f/%f/%f');
        if nvrts == 3
          f1=data1([1 4 7]);
          tc1=data1([2 5 8]);
          vn1=data1([3 6 9]);
          Vn3(:,f3num)=f1;
        end
        if nvrts == 4;
          f1=data1([1 4 7 10]);
          tc1=data1([2 5 8 11]);
          vn1=data1([3 6 9 12]);
          Vn4(:,f4num)=f1;
        end
      end
% Now put the data into the array(s)
      if nvrts == 3
          F3(:,f3num)=f1;
          f3num=f3num+1;
      elseif nvrts ==4
          F4(:,f4num)=f1;
          f4num=f4num+1;
      else
          warning(sprintf('v nvrts=%d %s',nvrts, Ln));
      end       
    otherwise 
%      if ~strcmp(Lyn,char([13 10])) % carriage return
%        if ~ all(Lyn == ' ') % ignore lines with only space
          disp(['unprocessed-' Ln '-']); % see what has not been processed
%          double(Ln)
          %        end
%      end
    end
  
end

fclose(fid);



% plot if no output arguments are given
if nargout ==0
  if exist('F3','var') 
    patch('Vertices',Vtmp','Faces',F3','FaceColor','g');
  end
  if exist('F4','var')
    patch('Vertices',Vtmp','Faces',F4','FaceColor','b');
  end
  axis('equal')
  clear Vtmp F3 F4
end

if nargout >=2 
  V=Vtmp;
  if ~ exist('F3','var') 
    warning('No 3 element faces')
    F3=[];
  end
  if nargout ==3
    if ~ exist('F4','var') 
      warning('No 4 element faces')
      F4=[];
    end
  end
end

if nargout ==1 
  V.v=Vtmp;
  V.f3=F3;
  if exist('F4','var')
    V.f4=F4;end
  V.g3=g3num;
  V.g4=g4num;
  if exist('Vn3','var')
    V.Vn3=Vn3;  end
  if exist('Vn4','var')
    V.Vn4=Vn4;  end
end


function Lyn=removespace(Lyn)
% A not an elegant way to remove
% surplus space
Lyn=strtrim(Lyn);
Lyn=strrep(Lyn,'       ',' '); % 8-2 .. 12-6  
Lyn=strrep(Lyn,'    ',' '); % 5-2 6-3 4-1
Lyn=strrep(Lyn,'  ',' '); % 3-2 2-1
Lyn=strrep(Lyn,'  ',' '); 
Lyn=strrep(Lyn,char([13 10]),''); % remove cr/lf 
Lyn=strrep(Lyn,char([10]),''); % remove lf 
