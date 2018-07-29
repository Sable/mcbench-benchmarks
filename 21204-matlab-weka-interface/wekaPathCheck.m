function bool = wekaPathCheck()
%Add the line 'C:\program files\Weka-3-5\weka.jar' to the classpath.txt
%file and restart matlab. Replace '3-5' as necessary depending on the
%version. (To edit, type 'edit classpath.txt').
%
    bool = true;
    w = strfind(javaclasspath('-all'),'weka.jar');
    if(isempty([w{:}]))
        bool = false;
        fprintf('\nPlease add weka.jar to the matlab java class path.\n');
        help wekaPathCheck;
    end
end