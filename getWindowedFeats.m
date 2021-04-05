function [all_feats, R]=getWindowedFeats(raw_data, fs, winLen, winDisp)
    %
    % getWindowedFeats_release.m
    %
    % Instructions: Write a function which processes data through the steps
    %               of filtering, feature calculation, creation of R matrix
    %               and returns features.
    %
    %               Points will be awarded for completing each step
    %               appropriately (note that if one of the functions you call
    %               within this script returns a bad output you won't be double
    %               penalized)
    %
    %               Note that you will need to run the filter_data and
    %               get_features functions within this script. We also 
    %               recommend applying the create_R_matrix function here
    %               too.
    %
    % Inputs:   raw_data:       The raw data for all patients
    %           fs:             The raw sampling frequency (in Hz)
    %           window_length:  The length of window (in seconds)
    %           window_overlap: The overlap in window (in seconds)
    %
    % Output:   all_feats:      All calculated features
    %           R matrix:       R matrix via function call to create_R_mat
    %
%% Your code here (3 points)

% First, filter the raw data
filtData = filter_data(raw_data);

% Then, loop through sliding windows
    % Within loop calculate feature for each segment (call get_features)
xLen = length(filtData);
numwins = ((xLen / fs) - (winLen - winDisp)) / (winDisp);

%need in terms of samples for changing index
winLenSize = winLen * fs; 
winDispSize = winDisp * fs;

start = 1;
%must adjust for matlab starting @ 1
ending = start + winLenSize - 1; 

featureData = [];

for i = 1:numwins+1
    sample = filtData(start:ending,:);
    [returnedFeats, numFeats]= get_features(sample,fs);
    featureData(i,:) = returnedFeats;
    start = start + winDispSize;
    ending = ending + winDispSize;
end

% Finally, return feature matrix
all_feats = featureData;

R = create_R_matrix(featureData, numFeats, 3); %MUST CHANGE THIS AS NUM FEATS IN GET FEATURES CHANGES
      %for future use, consider adding a getNumFeats function or return it
      %in get_features function

end