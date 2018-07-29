function c = subsasgn(b,index,val)

c=b;

if index.type=='.'

 switch index.subs
  case 'x0'
    c.x0=val;
    k=1;
  case 'x1'
    c.x1=val;
    k=1;
  case 'x2'
    c.x2=val;
    k=1;
  case 'x3'
    c.x3=val;
    k=1;
  case 'y0'
    c.y0=val;
    k=1;
  case 'y1'
    c.y1=val;
    k=1;
  case 'y2'
    c.y2=val;
    k=1;
  case 'y3'
    c.y3=val;
    k=1;
  case 'ax'
    c.ax=val;
    k=2;
  case 'bx'
    c.bx=val;
    k=2;
  case 'cx'
    c.cx=val;
    k=2;
  case 'ay'
    c.ay=val;
    k=2;
  case 'by'
    c.by=val;
    k=2;
  case 'cy'
    c.cy=val;
    k=2;
 end

 if k==1
  c=recalculate_coeffs(c);
 else
  c=recalculate_points(c);
 end

else
 error('Usage id b.fieldname=something');
end

 
