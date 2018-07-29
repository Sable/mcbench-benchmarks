%%% By: Tung Yuen Lau (a.k.a. boyexex)
%%% Email: boyexex@gmail.com
%%% University of Illinois at Urbana-Champaign (UIUC)
%%% Current version only accepty image stack of gray-scale images
%%% im_stack is a 3D array of the image stack

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%****~~~~                               ~~~~****%%%%%%
%%%***~~~                                         ~~~***%%%
%%%     ---        ---       ++++++ ** **               %%%
%%%   /          /     \       ++   ** ** @@ # ###  @@  %%%
%%%  |      --  |       |      ++   ** **    ##   #     %%%
%%%  |       |  |       |      ++   ** ** @@ #    # @@  %%%
%%%   \     /    \     /       ++   ** ** @@ #    # @@  %%%
%%%     ---        ---       ++++++ ** ** @@ #    # @@  %%%
%%%***~~~                                         ~~~***%%%
%%%%%%****~~~~                               ~~~~****%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = Image_stack_viewer( im_stack )

    FG.im = im_stack;
    % Adjust window size for image stack
    % Adjust values of a and b (bounded by "%------") iteratively
    % Until it fits your screen
    [w h d] = size(FG.im);
    FG.POI = [round(w/2);round(h/2);round(d/2)];
    aspect_ratio = (h/w);
    if aspect_ratio >= 1
        %------
        a = 700;
        %------
        b = round((a)/aspect_ratio);
        pad = 30+round((b/w)*d);
    else
        %------
        b = 700;
        %------
        a = round((b)*aspect_ratio);
        pad = 30+round((a/h)*d);
    end

    
    % Display xy plane
    FG.xyz_im = figure('units','pixels',...
                      'position',[20 200 a+pad b+pad],...
                      'name','Loaded image stack',...
                      'numbertitle','off',...
                      'resize','on');
    set(FG.xyz_im,'resize','on');
    FG.xyz_im.xy = axes;
    im(1) = subimage(FG.im(:,:,round(d/2)));
    set(FG.xyz_im.xy,'units','pixels','position',[pad-10 10 a b]);
    axis off;
    
    % Add image point to define ROI position
    P1 = impoint(gca,FG.POI(2),FG.POI(1));
    fcn1 = makeConstrainToRectFcn('impoint',...
        get(FG.xyz_im.xy,'XLim'),get(FG.xyz_im.xy,'YLim'));
    setPositionConstraintFcn(P1,fcn1);

    
    % Display xz plane
    FG.xyz_im.xz = axes;
    im(2) = subimage(squeeze(FG.im(:,round(h/2),:)));
    set(FG.xyz_im.xz,'units','pixels','position',[10 10 round((b/w)*d) b]);
    axis off;
    
    % Add image point to define ROI position
    P2 = impoint(gca,FG.POI(3),FG.POI(1));
    fcn2 = makeConstrainToRectFcn('impoint',...
        get(FG.xyz_im.xz,'XLim'),get(FG.xyz_im.xz,'YLim'));
    setPositionConstraintFcn(P2,fcn2);


    % Display yz plane
    FG.xyz_im.yz = axes;
    im(3) = subimage(squeeze(FG.im(round(w/2),:,:))');
    set(FG.xyz_im.yz,'units','pixels','position',[pad-10 b+20 a round((a/h)*d)]);
    axis off;
    
    % Add image point to define ROI position
    P3 = impoint(gca,FG.POI(2),FG.POI(3));
    fcn3 = makeConstrainToRectFcn('impoint',...
        get(FG.xyz_im.yz,'XLim'),get(FG.xyz_im.yz,'YLim'));
    setPositionConstraintFcn(P3,fcn3);


    % Update images if ROI position is changed
    addNewPositionCallback(P1,@update_POI1);
    addNewPositionCallback(P2,@update_POI2);
    addNewPositionCallback(P3,@update_POI3);


        % Update images (xz and yz) if ROI on xy plane is changed
        function update_POI1(varargin)
            loc = getPosition(P1);
            loc(1) = min(loc(1),h);
            loc(1) = max(loc(1),1);
            loc(2) = min(loc(2),w);
            loc(2) = max(loc(2),1);
            FG.POI(1) = loc(2); FG.POI(2) = loc(1);


%             axes(FG.xyz_im.xy);


            axes(FG.xyz_im.xz);
            delete(im(2));
            im(2) = subimage(squeeze(FG.im(:,round(FG.POI(2)),:)));
            axis off;
            P2 = impoint(gca,FG.POI(3),FG.POI(1));
            addNewPositionCallback(P2,@update_POI2);
            setPositionConstraintFcn(P2,fcn2);


            axes(FG.xyz_im.yz);
            delete(im(3));
            im(3) = subimage(squeeze(FG.im(round(FG.POI(1)),:,:))');
            axis off;
            P3 = impoint(gca,FG.POI(2),FG.POI(3));
            addNewPositionCallback(P3,@update_POI3);
            setPositionConstraintFcn(P3,fcn3);

        end
    
        % Update images (xy and yz) if ROI on xz plane is changed
        function update_POI2(varargin)
            loc = getPosition(P2);
            loc(1) = min(loc(1),d);
            loc(1) = max(loc(1),1);
            loc(2) = min(loc(2),w);
            loc(2) = max(loc(2),1);
            FG.POI(3) = loc(1); FG.POI(1) = loc(2);


            axes(FG.xyz_im.xy);
            delete(im(1));
            im(1) = subimage(squeeze(FG.im(:,:,round(FG.POI(3)))));
            axis off;
            P1 = impoint(gca,FG.POI(2),FG.POI(1));
            addNewPositionCallback(P1,@update_POI1);
            setPositionConstraintFcn(P1,fcn1);


%             axes(FG.xyz_im.xz);


            axes(FG.xyz_im.yz);
            delete(im(3));
            im(3) = subimage(squeeze(FG.im(round(FG.POI(1)),:,:))');
            axis off;
            P3 = impoint(gca,FG.POI(2),FG.POI(3));
            addNewPositionCallback(P3,@update_POI3);
            setPositionConstraintFcn(P3,fcn3);
        end
    
        % Update images (xy and xz) if ROI on yz plane is changed
        function update_POI3(varargin)
            loc = getPosition(P3);
            loc(1) = min(loc(1),h);
            loc(1) = max(loc(1),1);
            loc(2) = min(loc(2),d);
            loc(2) = max(loc(2),1);
            FG.POI(2) = loc(1); FG.POI(3) = loc(2);


            axes(FG.xyz_im.xy);
            delete(im(1));
            im(1) = subimage(squeeze(FG.im(:,:,round(FG.POI(3)))));
            axis off;
            P1 = impoint(gca,FG.POI(2),FG.POI(1));
            addNewPositionCallback(P1,@update_POI1);
            setPositionConstraintFcn(P1,fcn1);


            axes(FG.xyz_im.xz);
            delete(im(2));
            im(2) = subimage(squeeze(FG.im(:,round(FG.POI(2)),:)));
            axis off;
            P2 = impoint(gca,FG.POI(3),FG.POI(1));
            addNewPositionCallback(P2,@update_POI2);
            setPositionConstraintFcn(P2,fcn2);


%             axes(FG.xyz_im.yz);
        end
end



