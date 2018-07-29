function [ D, img ] = SiftFeatures (vertex, faces, normals, detectedPts, scale)
%SiftFeatures create mesh sift features

D = [];
for point = detectedPts'  
    %[ img ] = create_depth_image( vertex, faces, vertex(point,:), normals(point,:), Umax(:,point)', scale(point) );
    pix = 21;
    support = pix / scale(point);

    vv = repmat(vertex(point,:), length(vertex),1);
    dd = sqrt(sum((vv-vertex).^2,2));
    vvv = vertex(dd<scale(point),:);
    [coeff] = princomp(vvv);
    
    
    
    FV.vertices = vertex;
    FV.faces = faces;

    eyevec = FV.vertices(point,:) + scale(point) * normals(point,:);
    cent = FV.vertices(point,:);

    FV.modelviewmatrix= create_lookat_matrix(eyevec, cent, coeff(:,1)');%Umax(:,point)');
    FV.projectionmatrix=eye(4,4);
    FV.viewport = [-(support-pix)/2,-(support-pix)/2,support,support];
    
    I = zeros (pix,pix,6); 
    I(:,:,5)=Inf; % Background depth 

    FV.enableshading=1;
    FV.enabletexture=0;
    FV.culling=0;
    FV.enabledepthtest=1;
    
    J=renderpatch(I,FV); 

    img = J(:,:,5);
    img1 = img;
    
    
    img(11,11) = (img(11,10) + img(11,12) + img(10,11) + img(12,11))/4;
    
    mm = max(img(img<Inf));
    mm2 = max(max(img));
    if (~isempty (mm) && mm2 == Inf)
        img(img==Inf) = mm;
    end
    
    img = img * 10;

    [Ix, Iy] = vl_grad(img) ;
    mod = sqrt(Ix.^2 + Iy.^2) ;
    ang = atan2(Iy,Ix) ;
    grd = shiftdim(cat(3,mod,ang),2) ;
    grd = single(grd) ;
    f = [10 10 2 0]';

    d = double(vl_siftdescriptor(grd, f)) ;
    
    img = rot90(img,2);

    [Ix, Iy] = vl_grad(img) ;
    mod = sqrt(Ix.^2 + Iy.^2) ;
    ang = atan2(Iy,Ix) ;
    grd = shiftdim(cat(3,mod,ang),2) ;
    grd = single(grd) ;
    f = [10 10 2 0]';

    d = d + double(vl_siftdescriptor(grd, f)) ;
    D = [D d];

end

