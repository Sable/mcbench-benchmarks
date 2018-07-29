function [varargout]=tricont(varargin);
% TRICONT  Contours data on a triangular mesh
%     [CS,h]=TRICONT(X,Y,M,Z) takes the mesh specified by  points
%     (X,Y), with heights Z, and the  Nx3 triangulation  M (where each
%     row gives the indexes into X/Y vectors of  the triangle corners),
%     and contours it.
%
%     TRICONT(...,LEVELS) plots contours at the
%     specified levels.
%   
%     TRICONT(...,LINESPEC) takes line style and colour parameters 
%     for the lines.
%
%     [CS,h] are the inputs needed by CLABEL.
%
%     The advantage of using TRICONT over the GRIDDATA  method is the
%     the triangulation is already specified (and may be non-convex as
%     well as containing holes), and the contours are also exact on the
%     triangulation (no weird boundary jaggies). However, LINEAR finite
%     elements are assumed.
%
%  See also TRICONTF
%
% Rich Pawlowicz (rpawlowicz@eos.ubc.ca)  March/2013
%



error(nargchk(4,7,nargin,'struct'));
[cax,args,nargs] = axescheck(varargin{:});

cax = newplot(cax);

% Check for empty arguments.
for i = 1:nargs,
  if isempty(args{i})
    error(id('EmptyInput'),'Input matrix is empty');
  end
end

% Trim off the last arg if it's a string (line_spec).
nin = nargs;
if ischar(args{end})
  [lin,col,mark,msg] = colstyle(args{end}); %#ok
  if ~isempty(msg), error(msg); end %#ok
  nin = nin - 1;
else
  lin = '';
  col = '';
end

if isempty(col) % no color spec was given
  colortab = get(cax,'colororder');
  mc = size(colortab,1);
end

if nargout==0 | nargout==2,
  plotcall=1;
else
  plotcall=0;
end;

[Xp,Yp,M,Zp]=deal(args{1:4});

i=find(isfinite(Zp));
minz=min(Zp(i));
maxz=max(Zp(i));

if nargs>=5,
  nv=sort(args{5});
  CS=contourc([minz maxz ; minz maxz],nv);
else
  CS=contourc([minz maxz ; minz maxz]);
end;

if plotcall,
  nv=[];
else  
  nv = minz; % Include minz so that the contours are totally filled 
end;
ii = 1;
while (ii < size(CS,2)),
    nv=[nv CS(1,ii)];
    ii = ii + CS(2,ii) + 1;
end
  
  
       
%%%------------That's the setup done!
   
% Now, make up all the triangles

xx=[ Xp(M(:,[1 2 3 1])')];
yy=[ Yp(M(:,[1 2 3 1])')];
zz=[ Zp(M(:,[1 2 3 1])')];

% orient all triangles so the points go CW (Area>0)
% If I do this now, it makes orienting the lines
% easier later

Area=sum( diff(xx).*(yy(1:3,:)+yy(2:4,:))/2 );
iA=Area<0;
xx(:,iA)=xx([4 3 2 1],iA);
yy(:,iA)=yy([4 3 2 1],iA);
zz(:,iA)=zz([4 3 2 1],iA);
M(iA,:)=M(iA,[3 2 1]);


% preallocate generously for speed 
lenM=size(M,1);
CS=NaN(2,lenM*ceil(length(nv)/2));iCS=1;
handles=NaN(1,lenM); ihandles=1;

% Now loop over all levels
for k=1:length(nv),

 
  zal=zz>nv(k);
  
  % Create a 4xN matrix with 1's where we cross the level - since first and
  % 4th row of zal are the same it has to happen in the middle of each column
  % if it happens anywhere.
  id=[diff(zal)~=0;zeros(1,lenM)];

  % All the crossings
  Fi=find(id(:));
  
  if any(Fi), % If there are contours at this level....

    % This first part is fast
    % Contour is a straight line between the intersections on bounding edges
    Xl=(xx(Fi).*(nv(k)-zz(Fi+1)) + xx(Fi+1).*(zz(Fi)-nv(k)))./(zz(Fi)-zz(Fi+1));
    Yl=(yy(Fi).*(nv(k)-zz(Fi+1)) + yy(Fi+1).*(zz(Fi)-nv(k)))./(zz(Fi)-zz(Fi+1));

    x2=reshape(Xl,2,length(Xl)/2);
    y2=reshape(Yl,2,length(Yl)/2);


    % Change order to make sure that high side is on the LEFT of all
    % line segments (enumerate cases to see why this is needed)
    % (I want things to end up with high n the right, and it is easier
    % to start this way becauase the joining algorithm reverses everything)
    iz=find(zz(1,any(id))>nv(k));  
    x2(:,iz)=x2([2 1],iz);
    y2(:,iz)=y2([2 1],iz);

    if nargout==0,    % Just draw things as fast as possible if there are no outputs
      x3=[x2;NaN(1,size(x2,2))];
      y3=[y2;NaN(1,size(x2,2))];
      if isempty(col) && isempty(lin),
        hh=patch('xdata',x2,'ydata',y2,...
                 'cdata',nv(k)+[zeros(size(x2))]',...
                 'facecolor','none','edgecolor','flat',...
                 'userdata',nv(k)); 
      else
        hh=line(x3(:),y3(:),'userdata',nv(k));  
      end;      
      handles(ihandles)=hh;
      ihandles=ihandles+1;
    else

    % Now this takes a while - I have to join all the little
    % line segments together into long lines

      iZ=ones(1,size(x2,2));  % flag to tell me if a line segment has not been added
                              % to a line

      iN=1;
      iZ(iN)=0;
      seg=iN;
      rev1=1;rev2=2;  % keeps track of which direction to add points
                      % (differs if I am going forward or backward from a point)
      while any(iN),

        % Any line segments with the same endpoint that aren't used?
        % Use == for real numbers because the end points are calculated using
        % the same formula and hence should be exactly the same
        iN=find( x2(rev1,:)==x2(rev2,iN) & y2(rev1,:)==y2(rev2,iN) & iZ,1);

        if any(iN),  % If yes...
          seg=[seg iN];  % Add it to the segment list...
          iZ(iN)=0;      % ...and mark it used
        else         % If none...
          if rev1==1;  % If we haven't searched backwards yet
            iN=seg(1);  % Take the other end of the lines
          %  iZ(iN)=0;
            seg=seg(end:-1:1); % Reverse the segment list
            rev1=2;rev2=1;
          else         % we *have* searched backwards, and it really is the end
            xseg=[x2(2,seg),x2(1,seg(end))];  % make up the line
            yseg=[y2(2,seg),y2(1,seg(end))];


            if plotcall, 
               CS(:,iCS)=[nv(k);length(xseg)];
               CS(:,iCS+[1:length(xseg)])=[xseg ;yseg];
               iCS=iCS+1+length(xseg);

               if isempty(col) && isempty(lin),
                 hh=patch('xdata',[xseg NaN],'ydata',[yseg NaN],...
                          ... %%%'zdata',nv(k)+[zeros(size(xseg)) NaN],...
                          'cdata',nv(k)+[zeros(size(xseg)) NaN],...
                          'facecolor','none','edgecolor','flat',...
                          'userdata',nv(k)); 
               else
                 hh=line(xseg,yseg,'userdata',nv(k)); %pause;
               end;

               handles(ihandles)=hh;
               ihandles=ihandles+1;

            else
               CS(:,iCS)=[nv(k);NaN];
               CS(:,iCS+[1:length(xseg)])=[xseg ;yseg];
               iCS=iCS+1+length(xseg);
              % hh=line(xseg,yseg,'userdata',levels(k)); %pause;
            end;

            iN=find(iZ,1); % ...and go find the next unused segment
            seg=iN;
            iZ(iN)=0;
            rev1=1;rev2=2;   % ...and search forward.
          end;          
        end;
      end; 
    end;
  end;
end;

% remove the preallocated NaNs  
CS(:,iCS:end)=[];


% Deal with setting colors and linetypes
if plotcall,

   handles(ihandles:end)=[];
 
   if isempty(col) && ~isempty(lin)
     % set linecolors - all LEVEL lines should be same color
 
     ncon = length(nv);    % number of unique levels
     if ncon > mc    % more contour levels than colors, so cycle colors
                     % build list of colors with cycling
       ncomp = round(ncon/mc); % number of complete cycles
       remains = ncon - ncomp*mc;
       one_cycle = (1:mc)';
       index = one_cycle(:,ones(1,ncomp));
       index = [index(:); (1:remains)'];
       colortab = colortab(index,:);
     end
     for i = 1:length(handles)
       lvl=get(handles(i),'userdata');
       set(handles(i),'linestyle',lin,'color',colortab(lvl==nv,:));
     end
   else
     if ~isempty(lin)
       set(handles,'linestyle',lin);
     end
     if ~isempty(col)
       set(handles,'color',col);
     end
   end

   if ~ishold(cax)
     view(cax,2);  
     set(cax,'Box','on');
     grid(cax,'off')
   end
   
   if nargout==1,
     varargout=CS;
   elseif nargout==2,
     varargout={CS,handles};
   elseif nargout==9,
     varargout={Xp,Yp,M,Zp,nv,CS,xx,yy,zz};
   end;    

else

  varargout={Xp,Yp,M,Zp,nv,CS,xx,yy,zz};


end;









 
