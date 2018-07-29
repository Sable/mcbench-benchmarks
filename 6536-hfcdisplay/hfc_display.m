% Gaussian log processor. Draws the hyperfine tensors and their eigenaxes.
% The program is very sensitive to the file structure. Make sure you give it
% the original Gaussian output.
%
% Every ellipsoid is drawn in the following way:
%
% 1.	A unit sphere in a Cartesian space is scaled by abs(Axx) in the x direction,
%       abs(Ayy) in the y direction and abs(Azz) in the z direction, where Axx, Ayy, Azz
%       are the eigenvalues of the dipolar tensor in units of milliTesla. The sphere is 
%       painted in groovy reddish colours and made translucent.
%
% 2.	A set of axes is drawn inside the sphere with red axis for positive eigenvalues 
%       and blue for negative ones.
%
% 3.	The sphere is translated to the point of corresponding atom and rotated into 
%       the molecular frame.
%
% There certainly is a more mathematically consistent way of representing the anisotropy
% of a tensor, that is, when for negative eigenvalues the ellipsoid is actually pulled
% inside out through zero and the resulting plot looks like (and may be shown to be related
% to) a superposition of Y2k spherical harmonics. It was found however, that with this
% faithful representation the picture gets cluttered and far less easy to comprehend.
% Since the hyperfine tensor itself operates in a six-dimensional spin space, which
% fundamentally has no classical analog, the details of its representation in Cartesian
% space are a matter of convenience. 
%
% Usage: hfc_display('output_file')
%
% kuprov@physchem.ox.ac.uk

function hfc_display(output_file)

%Reading the file.
A=textread(output_file, '%s','delimiter','\n');

%Parsing file.
for n=1:length(A)
   if strcmp(deblank(A(n)),'Input orientation:')==1
      disp('Input orientation found. Using unless standard orientation found.'); k=n+5; m=1;
      while strcmp(deblank(A(k)),'---------------------------------------------------------------------')~=1
         S=eval(['[' char(A(k)) ']']); atoms(m,:)=S(4:6); k=k+1; m=m+1;
      end
      natoms=m-1;
   end
   if strcmp(deblank(A(n)),'Standard orientation:')==1
      disp('Standard orientation found.'); k=n+5; m=1;
      while strcmp(deblank(A(k)),'---------------------------------------------------------------------')~=1
         S=eval(['[' char(A(k)) ']']); atoms(m,:)=S(4:6); k=k+1; m=m+1;
      end
      natoms=m-1;
   end
   if strcmp(deblank(A(n)),'Isotropic Fermi Contact Couplings')==1
      disp('Isotropic Fermi contact couplings found.');
      for k=1:natoms
         S=char(A(n+1+k)); S=eval(['[' S(20:end) ']']); iso_hfc(k)=S(3);
      end          
   iso_hfc=iso_hfc';   
   end
   if strcmp(deblank(A(n)),'Anisotropic Spin Dipole Couplings in Principal Axis System')==1
      disp('Anisotropic spin dipole couplings found.');
      for k=1:natoms
         baa=A(n+4*k+1); baa=char(baa); baa=eval(['[' baa(4:end) ']']); Baa(k)=baa(3); aa_axis(k,:)=baa(5:7);
         bbb=A(n+4*k+2); bbb=char(bbb); bbb=eval(['[' bbb(14:end) ']']); Bbb(k)=bbb(3); bb_axis(k,:)=bbb(5:7);
         bcc=A(n+4*k+3); bcc=char(bcc); bcc=eval(['[' bcc(4:end) ']']); Bcc(k)=bcc(3); cc_axis(k,:)=bcc(5:7);
      end
   end
end

isotropic=[(1:natoms)', iso_hfc]
axialities=abs([(1:natoms)', (2*Bcc'-Baa'-Bbb')])
rhombicities=abs([(1:natoms)', (Baa'-Bbb')])

%Drawing the molecule.
close; hold on;
for n=1:natoms
    for k=1:natoms
        if norm(atoms(n,:)-atoms(k,:))<1.6
            plot3([atoms(n,1) atoms(k,1)],[atoms(n,2) atoms(k,2)],[atoms(n,3) atoms(k,3)],'k-','LineWidth',3);
        end
    end
end
plot3(atoms(:,1),atoms(:,2),atoms(:,3),'.','MarkerSize',20);
drawnow;

%Drawing the hyperfine tensors.
set(gcf,'Renderer','OpenGL');
light('Position',[-2,2,20]);
light('Position',[10,10,10]);
colormap hot; shading interp; lighting phong;
k=4; n=2^k-1; theta=pi*(-n:2:n)/n; phi=(pi/2)*(-n:2:n)'/n;
X=cos(phi)*cos(theta); Y=cos(phi)*sin(theta); Z=sin(phi)*ones(size(theta));
for n=1:natoms
    coords=[reshape(X*(Baa(n)+iso_hfc(n))/10,1,length(phi)*length(theta));reshape(Y*(Bbb(n)+iso_hfc(n))/10,1,length(phi)*length(theta));...
            reshape(Z*(Bcc(n)+iso_hfc(n))/10,1,length(phi)*length(theta))];
    new_coords=[aa_axis(n,:)' bb_axis(n,:)' cc_axis(n,:)']*coords;
    Xd=reshape(new_coords(1,:),length(phi),length(theta))+atoms(n,1);
    Yd=reshape(new_coords(2,:),length(phi),length(theta))+atoms(n,2);
    Zd=reshape(new_coords(3,:),length(phi),length(theta))+atoms(n,3);
    Cd = Z; p(n)=surf(Xd,Yd,Zd,Cd,'FaceAlpha',0.5,'EdgeAlpha',0.1);
    vector_a=aa_axis(n,:)*(Baa(n)+iso_hfc(n))/10;
    vector_b=bb_axis(n,:)*(Bbb(n)+iso_hfc(n))/10;
    vector_c=cc_axis(n,:)*(Bcc(n)+iso_hfc(n))/10;
    col_a='r-'; col_b='r-'; col_c='r-';
    if (Baa(n)+iso_hfc(n))<0
        col_a='b-';
    end
    if (Bbb(n)+iso_hfc(n))<0
        col_b='b-';
    end
    if (Bcc(n)+iso_hfc(n))<0
        col_c='b-';
    end
    plot3([atoms(n,1)-vector_a(1) atoms(n,1)+vector_a(1)],[atoms(n,2)-vector_a(2) atoms(n,2)+vector_a(2)],[atoms(n,3)-vector_a(3) atoms(n,3)+vector_a(3)],col_a,'LineWidth',1);
    plot3([atoms(n,1)-vector_b(1) atoms(n,1)+vector_b(1)],[atoms(n,2)-vector_b(2) atoms(n,2)+vector_b(2)],[atoms(n,3)-vector_b(3) atoms(n,3)+vector_b(3)],col_b,'LineWidth',1);
    plot3([atoms(n,1)-vector_c(1) atoms(n,1)+vector_c(1)],[atoms(n,2)-vector_c(2) atoms(n,2)+vector_c(2)],[atoms(n,3)-vector_c(3) atoms(n,3)+vector_c(3)],col_c,'LineWidth',1);
end
axis square; axis tight; axis equal; 
