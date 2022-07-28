clc
clear;
close all;
addpath("functions\")
%% '================ Written by Farhad AbedinZadeh ================'
%                                                                  %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
%% Normal Data

path='G:\Matlab O Python\Matlab\8\code\dataset\B\*.txt' ;  
files=dir(path);

for i = 1:length(files)
    fn = [path(1:end-5) files(i,1).name];
    Input_test=load(fn);
    
    %%Denoise
    signal = Input_test;
    wavename ='db10'; %WaveName
    level = 4;
    [D1,D2,D3,D4,D5,D6,D7,D8,A8] = wavelatdecompp(signal,level,wavename);

    %Make Features Vector
    f1=FMD(D5);
    f2=FMD(D6);
    f3=FMD(D7);
    f4=FMN(D5);
    f5=FMN(D6);
    f6=FMN(D7);
    f7=FR(D5);
    f8=FR(D6);
    f9=FR(D7);
    f10=WL(D5);
    f11=WL(D6);
    f12=WL(D7);
    
    Feature_Normal(i,:)=[f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12];
    
end
    
% save('Feautre_Normal.mat','Feature_Normal');

%% Abnormal Data %Epilepsy


path='G:\Matlab O Python\Matlab\8\code\dataset\E\*.txt' ;  
files=dir(path);

for i = 1:length(files)
    fn = [path(1:end-5) files(i,1).name];
    Input_test=load(fn);
    
    %%Denoise
    signal = Input_test;
    wavename ='db10'; %WaveName
    level = 4;
    [D1,D2,D3,D4,D5,D6,D7,D8,A8] = wavelatdecompp(signal,level,wavename);

    
    %Make Features Vector
    f1=FMD(D5);
    f2=FMD(D6);
    f3=FMD(D7);
    f4=FMN(D5);
    f5=FMN(D6);
    f6=FMN(D7);
    f7=FR(D5);
    f8=FR(D6);
    f9=FR(D7);
    f10=WL(D5);
    f11=WL(D6);
    f12=WL(D7);
    
    Feature_Epilepsy(i,:)=[f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12];
    
end
    
%% Creating Input & Output

Input=[Feature_Normal;Feature_Epilepsy];
Output=[zeros(length(Feature_Normal),1);ones(length(Feature_Epilepsy),1)];
% TrainingData=[Input,Output];

%% k-fold cross validation

k=5;
% % % % Create a cvpartition object that defined the folds
c1 = cvpartition(Output,'Kfold',k);

for i=1:k
% % % % % Create a training set
Input_test = Input(training(c1,i),:);
Label_test = Output(training(c1,i),:);
% % % % % % test set
Input_train=Input(test(c1,i),:);
Laebl_train=Output(test(c1,i),:);

% svmmdl=fitcsvm(x,y,'Solver','SMO');
svmmdl=fitcsvm(Input_test,Label_test,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

% svmmdl=fitcsvm(x,y,'Solver','SMO');
output=predict(svmmdl,Input_train);
% figure()
% plotconfusion(v',output')
% title('SVM classifier Confusion Matrix')


[c,cm,ind,per] = confusion(Laebl_train',output');

tp=cm(1,1);
fp=cm(1,2);
fn=cm(2,1);
tn=cm(2,2);
acc=(tp+tn)/(tp+fp+fn+tn);
spec=(tn)/(fp+tn);
sens=(tp)/(tp+fn);


acc_kfold_svm(i,:)=acc;
spec_kfold_svm(i,:)=spec;
sens_kfold_svm(i,:)=sens;
[~,~,~,AUC] = perfcurve(Laebl_train',output',1);
auc_kfold_svm(i,:)=AUC;


end


K=["k=1";"k=2";"k=3";"k=4";"k=5";"Mean";"std"];
Acc=[acc_kfold_svm*100;mean(acc_kfold_svm);std(acc_kfold_svm)];
Spec=[spec_kfold_svm*100;mean(spec_kfold_svm);std(spec_kfold_svm)];
Sens=[sens_kfold_svm*100;mean(sens_kfold_svm);std(sens_kfold_svm)];
Result_SVM=table(K,Acc,Spec,Sens);

%% 

% Input_test = Input';
% t = Output';
% 
% % Choose a Training Function
% % For a list of all training functions type: help nntrain
% % 'trainlm' is usually fastest.
% % 'trainbr' takes longer but may be better for challenging problems.
% % 'trainscg' uses less memory. Suitable in low memory situations.
% trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
% 
% % Create a Pattern Recognition Network
% hiddenLayerSize = 4;
% net = patternnet(hiddenLayerSize, trainFcn);
% 
% % Setup Division of Data for Training, Validation, Testing
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 5/100;
% 
% % Train the Network
% [net,tr] = train(net,Input_test,t);
% 
% % Test the Network
% Label_test = net(Input_test);
% e = gsubtract(t,Label_test);
% performance = perform(net,t,Label_test)
% tind = vec2ind(t);
% yind = vec2ind(Label_test);
% percentErrors = sum(tind ~= yind)/numel(tind);
% 
% % View the Network
% % view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% %figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, ploterrhist(e)
% figure, plotconfusion(t,Label_test)
% %figure, plotroc(t,y)
% net.divideParam.trainRatio = 80/100;
% 
% 
% 
%                                  
%                                
