function [TrainErr, TestErr, feature_training,feature_testing] = map_FNPAQR(feature_training,class_training,feature_testing,class_testing)
class_training=grp2idx(class_training);
class_testing=grp2idx(class_testing);
[feature_training,ps] = mapminmax(feature_training',0,1);feature_training=feature_training';
feature_testing = mapminmax('apply',feature_testing',ps)';
%%
options.ReducedDim = max(class_training)-1;
[eigvector]=FNPAQR(feature_training, class_training,options);
feature_training = feature_training * eigvector;
feature_testing = feature_testing * eigvector;
%%
TrainPredict = classify(feature_training,feature_training,class_training,'quadratic');
TestPredict = classify(feature_testing,feature_training,class_training,'quadratic');
TrainErr = sum(TrainPredict ~= class_training)/length(class_training)*100;
TestErr = sum(TestPredict ~= class_testing)/length(class_testing)*100;