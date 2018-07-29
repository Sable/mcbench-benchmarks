function updatesprite(state,dxn,action,iter,loc)

global A
global H
global mario

maxdims = [32 17];

if numel(mario.state(state).dxn(dxn).action(action).iter)>=iter
	xindx	= [mario.state(state).dxn(dxn).action(action).iter(iter).lbound(1):   mario.state(state).dxn(dxn).action(action).iter(iter).ubound(1)];
	yindx	= [mario.state(state).dxn(dxn).action(action).iter(iter).ubound(2):-1:mario.state(state).dxn(dxn).action(action).iter(iter).lbound(2)];
	clipdim	= [length(yindx) length(xindx)];
	z		= double(A(yindx,xindx));
	hoffset = floor((maxdims(2)-clipdim(2))/2);
	set(H,'FaceAlpha',0);
	for i=1:clipdim(1)		%rows
		ydata	= loc(2)+[-1 1 1 -1 -1]+i;
		for j=1:clipdim(2)	%cols
			xdata	= loc(1)+[-1 -1 1 1 -1]+j;
			if z(i,j)>0,
				
				set(H(i,j+hoffset),'XData',xdata,'YData',ydata,'CData',z(i,j),'FaceAlpha',1);
			end;
		end;
	end;
end;