function clipboardData = clipboardpaste(format)
    %clipboardpaste v0.1.3
    %   Usage:
    %       clipboardData = clipboardpaste(format)
    %
    %   Input Arguments:
    %       format (optional)
    %           Requested image format. If the clipboard contains an image,
    %           then the image will be automatically set to format. Valid
    %           formats are:
    %               'png'
    %               'jpg' (or 'jpeg')
    %               'tif' (or 'tiff')
    %               'bmp'
    %               'gif'
    %               'ico'
    %               'cur'
    %               'pnm'
    %               'ppm'
    %               'pbm'
    %               'ras'
    %               'xwd'
    %               'fts'/'fits'
    %
    %           By default, the format is 'png'.
    %
    %   Output Arguments:
    %       clipboardData
    %           Struct representing the data on the clipboard. It has three
    %           fields:
    %               (1) primaryType: String denoting which kind of data was
    %               retrieved from the clipboard. It can be one of several
    %               possibilities:
    %                   -- 'text'
    %                   -- 'binary'
    %
    %               (2) subType: String denoting specifically which kind of
    %               data was retrieved from the clipboard. It can be one of
    %               several possibilities:
    %                   -- 'url'
    %                   -- 'image'
    %                   -- 'plain-text'
    %                   -- 'email'
    %
    %               (3) data: Data from the clipboard. This can be of
    %               several types, depending on the primaryType/subType
    %               combination:
    %                   -- 'text'/'url': A string denoting a URL
    %                   -- 'text'/'email': A string denoting an email
    %                   address
    %                   -- 'text'/'plain-text': A string
    %                   -- 'binary'/'image': An image of the specified
    %                   format (uint8 array). It is viewable by using the
    %                   command imshow()
    %
    %   Description:
    %       Retrieves data from the clipboard. The clipboard data may be of
    %       several types and it is encapsulated in a self-describing
    %       structure. This function is based on clipboardimage, by Saurabh
    %       Kumar, saurabhkumar_@rediffmail.com, with heavy modifications to
    %       address various cross-platform issues.
    %
    %   Example:
    %       First, copy something on to the clipboard. Say that you copy
    %       the number 14584 onto the clipboard.
    %       >> clipData = clipboardpaste %now paste it into the workspace
    %       clipData =
    %
    %                  data: '14584'
    %           primaryType: 'text'
    %               subType: 'plain-text'
    %       >> data = clipData.data; %get the actual data from the clipboard
    %
    %   =======================
    %   Written by Bryan Raines on May 5, 2008
    %   Last updated on May 6, 2008.
    %   Email: rainesb@ece.osu.edu
    %
    %   See also clipboard.

    usesXClipboard = isunix && ~strcmpi(computer, 'mac');

    if usesXClipboard
        if isempty(get(0,'DefaultFigureXDisplay'))
            error('MATLAB:clipboard:NoXDisplay', 'There is no X display set.');
        end
    else
        err = javachk('awt', 'Clipboard access');
        if (~isempty(err))
            error('MATLAB:clipboard:UnsupportedPlatform', err.message);
        end
    end

    clipboardData     = [];
    error(nargchk(0,1,nargin));

    if nargin < 1
        format = 'png';
    end

    try
        tKit                =       java.awt.Toolkit.getDefaultToolkit();
        clipboardHandle     =       tKit.getSystemClipboard();
        reqObj              =       java.lang.Object;
        clipboardContents   =       clipboardHandle.getContents(reqObj); %get all objects on clipboard
        Dflavor             =       clipboardContents.getTransferDataFlavors();

        %Go through the various DataFlavors until you find one that is
        %recognized
        for ii = 1:length(Dflavor)
            dataType = char(Dflavor(ii).getMimeType);

            switch dataType
                case 'image/x-pict; class=java.io.InputStream'
                    imarray = clipboardContents.getTransferData(Dflavor(ii));
                    clipboardData = encapsulateImageData(getImageFromClipboardData(imarray,format));
                    break;
                    
                case 'image/x-java-image; class=java.awt.Image'
                    imarray = clipboardContents.getTransferData(Dflavor(ii));
                    clipboardData = encapsulateImageData(getImageFromClipboardData(imarray,format));
                    break;

                case 'application/x-java-file-list; class=java.util.List'
                    fileList = clipboardContents.getTransferData(Dflavor(ii));
                    clipboardData = encapsulateFileListData(fileList);
                    break;

                case 'application/x-java-url; class=java.net.URL'
                    urlText = char(clipboardContents.getTransferData(Dflavor(end))');
                    urlText = strtrim(urlText);

                    if isURLType(urlText)
                        if isImageType(urlText)
                            clipboardData = encapsulateImageData(downloadImage(urlText,format));
                        else
                            clipboardData = encapsulateURLData(urlText);
                        end
                        break;
                    end

                case 'application/x-java-serialized-object; class=java.lang.String'
                    textData = char(clipboardContents.getTransferData(Dflavor(ii)));
                    textData = strtrim(textData);

                    if isURLType(textData)
                        clipboardData = encapsulateURLData(textData);
                    elseif isEmailType(textData)
                        [tf emailAddress] = isEmailType(textData);
                        clipboardData = encapsulateEmailData(emailAddress);
                    else
                        clipboardData = encapsulatePlainTextData(textData);
                    end

                    break;
            end
        end
    catch
        disp('Error occurred in retrieving clipboard data');
    end
end

%=========== Encapsulate Clipboard Data in a clipboardStruct ===========
function clipboardData = encapsulateImageData(data)
    clipboardData.data = data;
    clipboardData.primaryType = 'binary';
    clipboardData.subType = 'image';
end

function clipboardData = encapsulateURLData(data)
    clipboardData.data = data;
    clipboardData.primaryType = 'text';
    clipboardData.subType = 'url';
end

function clipboardData = encapsulatePlainTextData(data)
    clipboardData.data = data;
    clipboardData.primaryType = 'text';
    clipboardData.subType = 'plain-text';
end

function clipboardData = encapsulateEmailData(data)
    clipboardData.data = data;
    clipboardData.primaryType = 'text';
    clipboardData.subType = 'email';
end

function clipboardData = encapsulateFileListData(data)
    fileListArray = data.toArray;

    for ii = 1:length(fileListArray)
        fileList{ii,1} = char(fileListArray(ii).toString);
    end

    clipboardData.data = fileList;
    clipboardData.primaryType = 'text';
    clipboardData.subType = 'file-list';
end

%=========== Determine Clipboard Data Type ===========
function tf = isImageType(textData)
    [var1 var2 ext] = fileparts(textData); %determine the file type
    imageTypes = {'.png','.jpg','.tif','.tiff','.bmp','.gif'};
    tf = any(strcmpi(imageTypes,ext));
end

function tf = isURLType(textData)
    %if the text just starts with www, then attach http:// as a prefix
    if ~isempty(regexp(textData,'^www','once'))
        textData = ['http://' textData];
    end

    %If the text starts with a protocol, then assume that it is a URL
    protocols = {'http','ftp','https','vnc','smb','file','irc'};

    for ii = 1:length(protocols)
        tf(ii) = ~isempty(regexp(textData,['^' protocols{ii}], 'once' ));
    end

    tf = any(tf);
end

function [tf emailAddress] = isEmailType(textData)
    emailAddress = regexp(textData,'^(mailto:)*(?<email>[\w\-\_\.]+@[\w\.\-\_]+)','tokens','once');
    tf = ~isempty(emailAddress);
    if tf
        emailAddress = emailAddress{2};
    end
end

%=========== Get Image from Clipboard ===========
function clipboardData = getImageFromClipboardData(imarr,format)
    %Grabs an image from the clipboard
    filename = [tempname '.' format];

    if ismac
        theImage = getImageFromPictStream(imarr);
    else
        theImage = imarr;
    end
    filehandle = java.io.File(filename);
    javax.imageio.ImageIO.write(theImage,format,filehandle);
    clipboardData = imread(filename);
    delete(filename);
end

function clipboardData = downloadImage(urlText,format)
    %Grabs an image by downloading it using the URL from the clipboard
    imarray = imread(urlText);
    filename = [tempname '.' format];
    imwrite(imarray,filename);
    clipboardData = imread(filename);
    delete(filename);
end

function awtImage = getImageFromPictStream(inputstream)
    %Exists for Mac OS X compabilibility. Requires Quicktime for Java to be
    %properly installed.

    %Check if QT for Java is installed
    try
        quicktime.QTSession.isInitialized();
    catch
        warning('Quicktime for Java is not installed.'); %#ok<WNTAG>
    end

    baos = java.io.ByteArrayOutputStream();

    isc = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
    isc.copyStream(inputstream,baos);
    baos.close;

    imgBytes = typecast(baos.toByteArray,'uint8');
    imgBytes = [cast(zeros(512,1),'uint8'); imgBytes];

    if ~quicktime.QTSession.isInitialized()
        quicktime.QTSession.open();
    end

    handle = quicktime.util.QTHandle(imgBytes);
    gi = quicktime.std.image.GraphicsImporter(quicktime.util.QTUtils.toOSType('PICT'));
    gi.setDataHandle(handle);
    qdRect = gi.getNaturalBounds();
    gid = quicktime.app.view.GraphicsImporterDrawer(gi);
    qip = quicktime.app.view.QTImageProducer(gid,java.awt.Dimension(qdRect.getWidth(),qdRect.getHeight()));
    awtImage = java.awt.Toolkit.getDefaultToolkit.createImage(qip);
    awtImage = getBufImage(awtImage);
end

function bufImage = getBufImage(clipboardContents)
    %Creates a rendered (buffered) image from an OSX image data flavor
    ww = clipboardContents.getWidth;
    hh = clipboardContents.getHeight;

    bufImage = java.awt.image.BufferedImage(ww,hh,java.awt.image.BufferedImage.TYPE_INT_RGB);

    g2 = bufImage.createGraphics;
    g2.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION,...
        java.awt.RenderingHints.VALUE_INTERPOLATION_BILINEAR);
    g2.drawImage(clipboardContents,0,0,ww,hh,[]);
    g2.dispose();
end

function tf = ismac
    %Detect if the computer is a Mac for versions before R2007a
    tf = strcmpi(computer,'mac');
end