%% setthispar. function och lokala var...

param = get(gcbo,'tag');                
value = get(gcbo,'string');             
eval([param '=' num2str(value) ';']);