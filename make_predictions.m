%function [predicted_dg] = make_predictions(test_ecog)

% INPUTS: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.

% OUTPUTS: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)

% Run time: The script has to run less than 1 hour. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%LOAD DATA%%%%%%%%%%%%%%%%%%%%%%%%%
% load('raw_training_data.mat');
% for i = 1:length(train_ecog)
%     clean_train_ecog{i,1} = filter_data(train_ecog{i});
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%GET FEATS, MAKE R%%%%%%%%%%%%%%%%%%%%%
% for i = 1:length(clean_train_ecog)
%     [allFeat{i,1},R{i,1}] = getWindowedFeats(clean_train_ecog{i}, 1000, 0.10, 0.05);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%MAKE PREDICTIONS%%%%%%%%%%%%%%%%%%%%%%%%%
% % downsample dataglove
% for i = 1:length(train_dg)
%     Y{i,1} = resample(train_dg{i},length(allFeat{i}),length(train_dg{i}));
% end
% %get matrix
% for i = 1:length(Y)
%     B{i,1} = mldivide(R{i},Y{i});
% end

% get testing data
for i = 1:length(test_ecog)
    [~,R_test{i,1}] = getWindowedFeats(test_ecog{i}, 1000, 0.10, 0.05);
end

%matrix multiplication
for i = 1:length(R_test)
    preds{i,1} = R_test{i}*B{i};
end

%interpolation
for i = 1:length(preds)
    resampled_preds{i,1} = resample(preds{i},length(test_ecog{i}),length(preds{i}));
    
    %zero-pad preds
    %preds{i} = [zeros(100,5); preds{i}; zeros(100,5)];
    
    %interp_preds{i,1} = spline(linspace(0,length(preds{i})/1000,length(preds{i}))',preds{i}',linspace(0,length(test_ecog{i})/1000,length(test_ecog{i}))');
end

%end

