function display(b)
% function display(b)

if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end

disp('coefficients:');
s=sprintf('\tax=%e\tbx=%e\tcx=%e\tx0=%e\r\tay=%e\tby=%e\tcy=%e\ty0=%e\n',...
    b.ax,b.bx,b.cx,b.x0,b.ay,b.by,b.cy,b.y0);
disp(s);
s=sprintf('points:\n  x0=%g\ty0=%g\n  x1=%g\ty1=%g\n  x2=%g\ty2=%g\n  x3=%g\ty3=%g\n',...
	b.x0,b.y0,b.x1,b.y1,b.x2,b.y2,b.x3,b.y3);
disp(s);
