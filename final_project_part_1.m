%% Final project part 1
% Prepared by John Bernabei and Brittany Scheid

% One of the oldest paradigms of BCI research is motor planning: predicting
% the movement of a limb using recordings from an ensemble of cells involved
% in motor control (usually in primary motor cortex, often called M1).

% This final project involves predicting finger flexion using intracranial EEG (ECoG) in three human
% subjects. The data and problem framing come from the 4th BCI Competition. For the details of the
% problem, experimental protocol, data, and evaluation, please see the original 4th BCI Competition
% documentation (included as separate document). The remainder of the current document discusses
% other aspects of the project relevant to BE521.

%% Extract dataglove and ECoG data  (0 points)
% Using the data file given to us 
%(note some channel nums are different than iEEG
load('final_proj_part1_data.mat')

% fs for ecog and dg data
sampleRate = 1000; % Hz

% Load training ecog and dataglove data from each of three patients
s1_ecog = train_ecog{1};
s2_ecog = train_ecog{2};
s3_ecog = train_ecog{3};

s1_dg = train_dg{1};
s2_dg = train_dg{2};
s3_dg = train_dg{3};

% Split data into a train and test set (use at least 50% for training)
% there is 5 mins of data
    % trials are 4 seconds long 
    % (2 seconds of stimuli + 2 seconds of rest) = 4000 samples/trial
    
    % Use first 40 trials for training 
    % Use last 35 trials for testing
    
    % There are 75 trials in total
    % 53.3% of data is for training
    
% Subject 1
% ECOG
s1_ecog_Train = s1_ecog(1:40*4000,1:end);
s1_ecog_Test = s1_ecog((40*4000 + 1):end,1:end);
% DG
s1_dg_Train = s1_dg(1:40*4000,1:end);
s1_dg_Test = s1_dg((40*4000 + 1):end,1:end);

% Subject 2
% ECOG
s2_ecog_Train = s2_ecog(1:40*4000,1:end);
s2_ecog_Test = s2_ecog((40*4000 + 1):end,1:end);
% DG
s2_dg_Train = s2_dg(1:40*4000,1:end);
s2_dg_Test = s2_dg((40*4000 + 1):end,1:end);

% Subject 3
% ECOG
s3_ecog_Train = s3_ecog(1:40*4000,1:end);
s3_ecog_Test = s3_ecog((40*4000 + 1):end,1:end);
% DG
s3_dg_Train = s3_dg(1:40*4000,1:end);
s3_dg_Test = s3_dg((40*4000 + 1):end,1:end);

%% Visualize ECG data
% picked one representative channel that was cleaned
figure
hold on
len = 3000;
plot(1:len, s1_ecog_Train(1:len,1))
plot(1:len,filter_data(s1_ecog_Train(1:len,1)))
legend('Original','Cleaned');
xlabel('Time (ms)'); ylabel('Voltage (\muV)');
    set(gca,'linewidth',2); set(gca,'FontSize',14)
    box off; set(0,'DefaultAxesFontName','Arial'); 
%%
% There are 300,000 samples in the raw ECOG data files. The number of
% samples are same across the subjects. However the number of channels in
% the ECOG data between the samples vary: S1 - 61 channels, S2 - 46
% channels, S3 - 64 channels
%% Get Features & Create R matrix
% run getWindowedFeats_release function
% run create_R_matrix (within getWindowedFeats)

[feat_S1, R_S1_train] = getWindowedFeats(s1_ecog_Train,1000,0.100,0.0500);
[feat_S2, R_S2_train] = getWindowedFeats(s2_ecog_Train,1000,0.100,0.0500);
[feat_S3, R_S3_train] = getWindowedFeats(s3_ecog_Train,1000,0.100,0.0500);

%% Train classifiers (8 points)
% Classifier 1: Get angle predictions using optimal linear decoding. That is, 
% calculate the linear filter (i.e. the weights matrix) as defined by 
% Equation 1 for all 5 finger angles.

%adjust Y matrix to proper size (cannot downsample bc not even divisor of samples)
Y_S1 = resample(s1_dg_Train,length(feat_S1),length(s1_dg_Train));
Y_S2 = resample(s2_dg_Train,length(feat_S2),length(s2_dg_Train));
Y_S3 = resample(s3_dg_Train,length(feat_S3),length(s3_dg_Train));

%calculate f matrix
f_S1 = mldivide(R_S1_train,Y_S1);
f_S2 = mldivide(R_S2_train,Y_S2);
f_S3 = mldivide(R_S3_train,Y_S3);

%get testing data R matrices
[~, R_S1_test] = getWindowedFeats(s1_ecog_Test,1000,0.100,0.0500);
[~, R_S2_test] = getWindowedFeats(s2_ecog_Test,1000,0.100,0.0500);
[~, R_S3_test] = getWindowedFeats(s3_ecog_Test,1000,0.100,0.0500);

%predict angles
pred_S1 = R_S1_test*f_S1;
pred_S2 = R_S2_test*f_S2;
pred_S3 = R_S3_test*f_S3;

% Try at least 1 other type of machine learning algorithm, you may choose
% to loop through the fingers and train a separate classifier for angles 
% corresponding to each finger
%% Linear Regression Classifer for High Density Data (fitrlinear)
%  svm based classifier

% Patient 1
% Obtain Features for Test Set
[s1_featTest, ~] = getWindowedFeats(s1_ecog_Test,1000,0.100,0.0500);

% Obtain Angles for Test Set
Y_S1_test = resample(s1_dg_Test,length(s1_featTest),length(s1_dg_Test));

% Setting up variables
TrainPred_S1 = zeros(length(Y_S1),5);
TestPred_S1 = zeros(length(Y_S1_test),5);

for i = 1:5
    % Model Training
    Model= fitrlinear(feat_S1, Y_S1(:,i));
    
    % Predictions of Training Set
    TrainPred_S1(:,i) = predict(Model, feat_S1);
    
    % Predictions of Testing Set
    TestPred_S1(:,i)= predict(Model, s1_featTest);
end

%%
% Patient 2
% Obtain Features for Test Set
[feat_S2_Test, R_S2_Test] = getWindowedFeats(s2_ecog_Test,1000,0.100,0.0500);

% Obtain Angles for Test Set
Y_S2_Test = resample(s2_dg_Test,length(feat_S2_Test),length(s2_dg_Test));

% Setting up variables
TrainPred_S2 = zeros(length(Y_S2),5);
TestPred_S2 = zeros(length(Y_S2_Test),5);

for i = 1:5
    % Model Training
    Model= fitrlinear(feat_S2, Y_S2(:,i));
    
    % Predictions of Training Set
    TrainPred_S2(:,i) = predict(Model, feat_S2);
    
    % Predictions of Testing Set
    TestPred_S2(:,i)= predict(Model, feat_S2_Test);
end

%%
% Patient 3
% Obtain Features for Test Set
[feat_S3_Test, R_S3_Test] = getWindowedFeats(s3_ecog_Test,1000,0.100,0.0500);

% Obtain Angles for Test Set
Y_S3_test = resample(s1_dg_Test,length(feat_S3_Test),length(s3_dg_Test));

% Setting up variables
TrainPred_S3 = zeros(length(Y_S3),5);
TestPred_S3 = zeros(length(Y_S3_test),5);

for i = 1:5
    % Model Training
    Model= fitrlinear(feat_S3, Y_S3(:,i));
    
    % Predictions of Training Set
    TrainPred_S3(:,i) = predict(Model, feat_S3);
    
    % Predictions of Test Set
    TestPred_S3(:,i)= predict(Model, feat_S3_Test);
end

% Try a form of either feature or prediction post-processing to try and
% improve underlying data or predictions.
%some possible ways to improve this method would be to take into account
%the time delay within the data glove vs ecog data

%coudl also try randomizing the trial data instead of using a continuous
%stream of data
%% Correlate data to get test accuracy and make figures (2 point)

% Calculate accuracy by correlating predicted and actual angles for each
% finger separately. Hint: You will want to use zohinterp to ensure both 
% vectors are the same length.

pred_S1_interp = resample(pred_S1,length(s1_dg_Test),length(pred_S1));
pred_S2_interp = resample(pred_S2,length(s2_dg_Test),length(pred_S2));
pred_S3_interp = resample(pred_S3,length(s3_dg_Test),length(pred_S3));

for i = 1:size(pred_S1,2)
    corr_S1(i) = corr(pred_S1_interp(:,i),s1_dg_Test(:,i));
end
for i = 1:size(pred_S2,2)
    corr_S2(i) = corr(pred_S2_interp(:,i),s2_dg_Test(:,i));
end
for i = 1:size(pred_S3,2)
    corr_S3(i) = corr(pred_S3_interp(:,i),s3_dg_Test(:,i));
end

% Calculating Correlation between Predicted and Actual
pred_S1_test_interp = resample(TestPred_S1,length(s1_dg_Train),length(TestPred_S1));
pred_S2_test_interp = resample(TestPred_S2,length(s2_dg_Train),length(TestPred_S2));
pred_S3_test_interp = resample(TestPred_S3,length(s3_dg_Train),length(TestPred_S3));

for i = 1:size(TestPred_S1,2)
    corr_S1_test(i) = corr(pred_S1_test_interp(:,i),s1_dg_Train(:,i));
end
for i = 1:size(TestPred_S2,2)
    corr_S2_test(i) = corr(pred_S2_test_interp(:,i),s2_dg_Train(:,i));
end
for i = 1:size(TestPred_S3,2)
    corr_S3_test(i) = corr(pred_S3_test_interp(:,i),s3_dg_Train(:,i));
end