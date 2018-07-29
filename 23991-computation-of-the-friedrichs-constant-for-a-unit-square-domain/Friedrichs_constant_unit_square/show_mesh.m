function show_mesh(elements,coordinates)
if (size(elements,2)==3)
    X=reshape(coordinates(elements',1),size(elements,2),size(elements,1));
    Y=reshape(coordinates(elements',2),size(elements,2),size(elements,1));
    %hold on
    fill(X,Y,[0.3 0.3 0.9]);

    % X=reshape(coordinates(elements4',1),size(elements4,2),size(elements4,1));
    % Y=reshape(coordinates(elements4',2),size(elements4,2),size(elements4,1));
    % fill(X,Y,[0.3 0.3 0.9]);
    % hold off
else
    tetramesh(elements,coordinates,'FaceAlpha',1);%camorbit(20,0);
end


