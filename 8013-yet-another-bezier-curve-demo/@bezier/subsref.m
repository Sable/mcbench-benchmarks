function v=subsref(c,index)

v=[];

if index.type=='.'

 switch index.subs
  case 'x0'
    v=c.x0;
  case 'x1'
    v=c.x1;
  case 'x2'
    v=c.x2;
  case 'x3'
    v=c.x3;
  case 'y0'
    v=c.y0;
  case 'y1'
    v=c.y1;
  case 'y2'
    v=c.y2;
  case 'y3'
    v=c.y3;
  case 'ax'
    v=c.ax;
  case 'bx'
    v=c.bx;
  case 'cx'
    v=c.cx;
  case 'ay'
    v=c.ay;
  case 'by'
    v=c.by;
  case 'cy'
    v=c.cy;
 end

else
 error('Usage id b.fieldname');
end
