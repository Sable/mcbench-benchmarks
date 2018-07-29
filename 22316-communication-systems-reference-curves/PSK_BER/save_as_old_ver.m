function save_as_old_ver(ver_num)
    mdlFiles = dir('*.mdl');
    for k=1:length(mdlFiles)
        tempName = mdlFiles(k).name;
        sysNames{k} = regexprep(tempName,'.mdl','');
        load_system(sysNames{k})
    end
    newNames = strcat(sysNames, ['_' ver_num]);
    t = save_system(sysNames, newNames, 'SaveAsVersion', ver_num);
    close_system(sysNames)
    
        