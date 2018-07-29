function [varargout]=tricontf(varargin);
% TRICONT  Filled contours data on a triangular mesh
%     [CS,h]=TRICONTF(X,Y,M,Z) takes the mesh specified by points
%     (X,Y), with heights Z, and the  Nx3 triangulation M (where
%     each row gives the indexes into X/Y vectors of the triangle
%     corners), and make filled contours.    
%
%     TRICONTF(...,LEVELS) fills contours at the specified levels.
%     
%   
%     TRICONTF(...,LINESPEC) takes line style and colour
%     parameters for the lines.
%
%     [CS,h] are the inputs needed by CLABEL, but if you want
%     labelled contours you are better off doing something like
%     
%
%     [CS,h]=TRICONTF(...);
%     set(h,'edgecolor','none');
%     hold on;
%     [CS,h]=TRICONT(...);
%     hold off
%     clabel(CS,h)
%
%     since the CS and h returned by TRICONTF contain boundary 
%     information which is not usually required for labelling.
%     
%     The advantage of using TRICONTF over the GRIDDATA method is the
%     the triangulation is already specified (and may be non-convex
%     as well as containing holes), and the contours are also exact
%     on the triangulation (no weird boundary jaggies). However,
%     LINEAR finite elements are assumed.
%     
%     Note - unlike contourf, TRICONTF will not
%     work 'properly' with NaN values in Z - if you
%     have bad data remove those triangles from M!
%
%     See also TRICONT
%
%     Rich Pawlowicz (rpawlowicz@eos.ubc.ca)  March/2013
%


% Copy a bunch of lines from contourf
error(nargchk(4,9,nargin,'struct'));
[cax,args,nargs] = axescheck(varargin{:});


cax = newplot(cax);
 
% Check for empty arguments.
for i = 1:nargs
  if isempty(args{i})
    error('MATLAB:contourf:EmptyInput','Input argument is empty');
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


% Closed contours are made up of a) contours through the
% interior, and b) curves around the grid boundaries (there
% can be interior "islands" in an FEM mesh too).  The
% general strategy is to get a bunch of line segments, and
% then join them into continuous curves.

% First, get all the interior contours (this is pretty fast)
% but don't draw anything yet; this also does some checking
% on M to make sure triangles are oriented.

[Xp,Yp,M,Zp,nv,CS,xx,yy,zz]=tricont(args{1:nin});
nCS=[find(isnan(CS(2,:))) size(CS,2)+1];
lCS=CS(1,nCS(1:end-1));

% Don't fill contours below the lowest level specified in nv.
% To fill all contours, specify a value of nv lower than the
% minimum of the surface. 
i = find(isfinite(Zp));
minz = min(Zp(i));
maxz = max(Zp(i));
draw_min=0;
if any(nv <= minz),
  draw_min=1;
end


% Second step - get all the boundary curves. 

BS=findboundary(M);
iBS=find(isnan(BS));

  
% Third step:
% Once we have interior and boundary curves, join *them* together.
% However, we have to have separate boundary curves for every
% level, because we need only the parts of the boundary where the
% interior is higher than that level.


fCS=NaN(2,size(CS,2)+size(BS,2));iCS=1;
ncurves = 0;
I = [];
Area=[];levs=[];

for l=1:length(nv),   % For each level

  
  lvlBS=NaN(2,length(CS)+length(BS)+50);jBS=1;

  iCSlvl=find(lCS==nv(l));
  if any(iCSlvl),
  
     % Create a structure with all the lines at level
     % nv(k). First add the interior contours
     

     for k=1:length(iCSlvl),
       nseg=nCS(iCSlvl(k)+1)-nCS(iCSlvl(k))-1;
       level=CS(1,nCS(iCSlvl(k)));
       xseg=CS(1,nCS(iCSlvl(k))+[1:nseg]);
       yseg=CS(2,nCS(iCSlvl(k))+[1:nseg]);
       lvlBS(:,jBS+[0:nseg])=[ nv(l) xseg ; NaN yseg ];
       jBS=jBS+1+nseg;
     end;   
  end;
  
     % Now look through all the boundaries, and for each boundary segment
     % take only the parts that are higher than nv(l). In general we will
     % have to interpolate to get the first and last position of the curve,
     % except when it it as the beginning or end of a boundary curve.
     
     for k=1:length(iBS)-1,
       Bseg=BS(iBS(k)+1:iBS(k+1)-1);
       id=Zp(Bseg)>nv(l);
             
       segstart=find(diff(id)== 1)+1;
       if id(1)==1,segstart=[1;segstart]; end;
       segend=  find(diff(id)==-1);
       if id(end)==1,segend=[segend;length(Bseg)]; end;

       for m=1:length(segstart),
	 if segstart(m)==1,  % First point is above...
	   xstart=[];
	   ystart=[];
	 else                % ...otherwise interpolate it
	   xstart=(Xp(Bseg(segstart(m)))*(nv(l)-Zp(Bseg(segstart(m)-1))) + Xp(Bseg(segstart(m)-1))*(Zp(Bseg(segstart(m)))-nv(l)) )./(Zp(Bseg(segstart(m)))-Zp(Bseg(segstart(m)-1)));
	   ystart=(Yp(Bseg(segstart(m)))*(nv(l)-Zp(Bseg(segstart(m)-1))) + Yp(Bseg(segstart(m)-1))*(Zp(Bseg(segstart(m)))-nv(l)) )./(Zp(Bseg(segstart(m)))-Zp(Bseg(segstart(m)-1)));
	 end;
	 if segend(m)==length(Bseg),  % Last point is above....
	   xend=[];
	   yend=[];
	 else;               % ...otherwise interpolate it.
	   xend=(Xp(Bseg(segend(m)+1))*(nv(l)-Zp(Bseg(segend(m)    ))) + Xp(Bseg(segend(m)    ))*(Zp(Bseg(segend(m)+1))-nv(l)) )./(Zp(Bseg(segend(m)+1))-Zp(Bseg(segend(m)    ))) ;
	   yend=(Yp(Bseg(segend(m)+1))*(nv(l)-Zp(Bseg(segend(m)    ))) + Yp(Bseg(segend(m)    ))*(Zp(Bseg(segend(m)+1))-nv(l)) )./(Zp(Bseg(segend(m)+1))-Zp(Bseg(segend(m)    )));
	 end; 
         xseg=[ xstart , Xp(Bseg(segstart(m):segend(m)))' , xend ];
         yseg=[ ystart , Yp(Bseg(segstart(m):segend(m)))' , yend ];
	 lvlBS(:,jBS+[0:length(xseg)])=[ nv(l) xseg ; NaN yseg ];
         jBS=jBS+1+length(xseg);
        end;
      end;
      lvlBS(:,jBS+1:end)=[];
          
      ii=find(isnan(lvlBS(2,:)));
 
 
      % Now, apply the line joing algorithm *again* to put the different curves together
      % into a bunch of closed curves.

      % Begin and end of all line segments
      x2=[lvlBS(1,ii(1:end-1)+1) ; lvlBS(1,ii(2:end)-1) ];
      y2=[lvlBS(2,ii(1:end-1)+1) ; lvlBS(2,ii(2:end)-1) ];
    
      iZ=ones(1,size(x2,2));
      iN=1;
      iZ(iN)=0;
      seg=iN;
      rev1=1;rev2=2;  % keeps track of which direction to add points
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
            seg=seg(end:-1:1); % Reverse the segment list
            rev1=2;rev2=1;
	  else         % we *have* searched backwards, and it really is the end
	    xseg=[];yseg=[];
	    for k=1:length(seg),
	      xseg=[lvlBS(1,ii(seg(k))+1:ii(seg(k)+1)-1) xseg];
	      yseg=[lvlBS(2,ii(seg(k))+1:ii(seg(k)+1)-1) yseg];
	    end;

	    fCS(:,iCS)=[nv(l);length(xseg)];
	    fCS(:,iCS+[1:length(xseg)])=[xseg ;yseg];

            % need these stats later
	    ncurves = ncurves + 1;
            levs(ncurves)=nv(l);
            I(ncurves) = iCS;
            Area(ncurves)=sum( diff(xseg).*(yseg(1:end-1)+yseg(2:end))/2 );

	    iCS=iCS+1+length(xseg);

            iN=find(iZ,1); % ...and go find the next unused segment
	    seg=iN;
            iZ(iN)=0;
            rev1=1;rev2=2;   % ...and search forward.
	  end;		
	end;
      end; 

   
end;
fCS(:,iCS:end)=[];


% OK, now we have all the closed curves formed.


% Plot patches in order of decreasing size. This makes sure that
% all the levels get drawn, not matter if we are going up a hill or
% down into a hole. When going down we shift levels though, you can
% tell whether we are going up or down by checking the sign of the
% area (since curves are oriented so that the high side is always
% the same side). Lowest curve is largest and encloses higher data
% always.

% The areas of 'interior holes' will be the same at all
% levels, as will any levels that go all around the outside (which will
% happen if there are interior valleys, which causes a problem (this 
% didn't happen in contourf because boundary-finding was
% done differently) so we use sortrows to make sure the highest level
% gets drawn on top for positive areas (i.e. hills), but the lowest
% level gets drawn on top for NEGATIVE areas (holes).

%[FA,IA]=sort(-abs(Area));  
[FA,IA]=sortrows([-abs(Area)' (sign(Area).*levs)']);

% below here code is basically identical to contourf


if ~ishold(cax),
    view(cax,2);
    set(cax,'Box','on','Layer','top');
    grid(cax,'off')
end

fig = ancestor(cax,'figure');
H=[];

% This is the colour for holes
if ~ischar(get(cax,'color'))
  bg = get(cax,'color');
else
  bg = get(fig,'color');
end

if isempty(col)
  edgec = get(fig,'defaultsurfaceedgecolor');
else
  edgec = col;
end
if isempty(lin)
  edgestyle = get(fig,'defaultpatchlinestyle');
else
  edgestyle = lin;
end

 
for jj=IA',
  nl=fCS(2,I(jj));
  lev=fCS(1,I(jj));
  if (lev ~= minz || draw_min ),
    xp=fCS(1,I(jj)+(1:nl));  
    yp=fCS(2,I(jj)+(1:nl));
    clev = lev;           % color for filled region above this level
    if (sign(Area(jj)) ~=sign(Area(IA(1))) ),
      kk=find(nv==lev);
      kk0 = 1 + sum(nv<=minz) * (~draw_min);
      if (kk > kk0)
        clev=nv(kk-1);    % in valley, use color for lower level
      elseif (kk == kk0)
        clev=NaN;
      else 
        clev=NaN;         % missing data section
        lev=NaN;
      end
    end

    if (isfinite(clev)),
      H=[H;patch(xp,yp,clev,'facecolor','flat','edgecolor',edgec, ...
              'linestyle',edgestyle,'userdata',lev,'parent',cax)];
    else
      H=[H;patch(xp,yp,clev,'facecolor',bg,'edgecolor',edgec, ...
              'linestyle',edgestyle,'userdata',fCS(1,I(jj)),'parent',cax)];
    end
  end;
end;

% Contourf strips out bnoundary points but I can't be bothered - if you
% want labelled contours you should really follow a tricontf call with
% a tricont call.
  
varargout={fCS,H};

%-----------------------------------------------------------------
function BS=findboundary(M);
% Finds the curves that make up the
% boundary of a triangulation
%
% First, examining ALL 2 point line segments in M 
% to see if they are contained in one or
% two triangles in the mesh! This is slow.
%
lenM=size(M,1);

 
%Bseg=NaN(2,lenM);iB=1;
%
%pat=[1 2;  % Edge indices in order when triangles 
%     2 3;  % are arranged CW
%     3 1];
%for k=1:lenM,
% for l=1:3,
%    [id,jid]  =find( (      M==M(k,pat(l,1))) );
%    [id2,jid2]=find( (M(id,:)==M(k,pat(l,2))) );
%    if length(id2)==1,
%      Bseg(:,iB)=M(k,pat(l,:))';
%      iB=iB+1;
%    end;
% end;
%end;
%Bseg(:,iB:end)=[];

 
% Try another way - this works MUCH MUCH faster
% (can be many orders of magnitude faster for large
% problems!), but will fail if the mesh is screwy
% (i.e. edges do not appear ONLY one or two times
% in the whole list of triangles()

% Put all the triangle edges in a list
alledge=[ M(:,[1 2]) ; M(:,[2 3]) ; M(:,[3 1]) ];

% put rows in increasing numerical order, then sort
% so the rows will either be unique edges, or pairs
% of edges
[sortedge,I]=sortrows(sort(alledge,2));
% Now identify the boundaries between pairs and
% unique edges - the diff will == 0 between 
% pairs of identical edges
chges=[1;any(diff(sortedge)~=0,2);1];
% so find places where we have 1s one after another,
% since this marks a transition through a unique
% edge
ibdy=find(diff(chges)==0);
% ...and now get the original rows, before the
% numerical sorting
Bseg=alledge(I(ibdy),:)'; % back to original list
 
% Now I join all the individual boundary segments
% into a smaller number of actual curves using the
% follow foward/follow backward algorithm, all curves
% should traverse with the interior to their right.

BS=NaN(1,length(Bseg)+50);iBS=1;  % preallocate
iZ=ones(1,size(Bseg,2));  % flag to tell me if a line segment has not been added
                        % to a line
iN=1;
iZ(iN)=0;
seg=iN;
rev1=1;rev2=2;  % keeps track of which direction to add points
                % (differs if I am going forward or backward from a point)
while any(iN),

  % Any line segments with the same endpoint that aren't used?
  iN=find( Bseg(rev1,:)==Bseg(rev2,iN) & iZ ,1);

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
      xseg=[Bseg(2,seg),Bseg(1,seg(end))];  % make up the line

      BS(iBS+[0:length(xseg)])=[NaN xseg(end:-1:1) ];
      iBS=iBS+1+length(xseg);

      iN=find(iZ,1); % ...and go find the next unused segment
      seg=iN;
      iZ(iN)=0;
      rev1=1;rev2=2;   % ...and search forward.
    end;		
  end;
end; 
BS(iBS+1:end)=[];


