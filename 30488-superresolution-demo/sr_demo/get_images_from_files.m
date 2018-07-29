function files=get_images_from_files(prefix, suffix, frange);

id=1;
for imid=frange
    files{id}=imread(sprintf('%s%d.%s',prefix,imid,suffix));
    id=id+1;
    imid
end