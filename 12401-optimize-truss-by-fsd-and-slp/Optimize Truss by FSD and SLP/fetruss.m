function [k]=fetruss(el,leng,area,c,s)
%--------------------------------------------------------------
%  Purpose:
%     Compute stiffness matrices for the 2-d truss element
%     nodal dof {u_1 v_1 u_2 v_2}
%
%  Synopsis:
%     [k]=fetruss(el,leng,area,c,s)
%
%  Variable Description:
%     k - element stiffness matrix (size of 4x4)   
%     el - elastic modulus ( E )
%     leng - element length
%     area - area of truss cross-section
%----------------------------------------------------------------
% syms X1 X2 X3
k=(area*el/leng)*[c*c c*s -c*c -c*s;...
                  c*s s*s -c*s -s*s;...
                  -c*c -c*s c*c c*s;...
                  -c*s -s*s c*s s*s];