function [R]=create_R_matrix(features, numFeats, N_wind)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate R matrix.             
    %
    % Input:    features:   (samples x (channels*features))
    %           numFeat:    Number of features per channel used
    %           N_wind:     Number of windows to use
    %
    % Output:   R:          (samples x (N_wind*channels*features))
    % 
%% Your code here (5 points)
%appending first two feature rows together
fullFeat(1:2,:)=features(1:2,:);
fullFeat(3:size(features,1)+2,:)=features;

%calculating total channel numbers
numChannels=size(fullFeat,2)/numFeats;

N = N_wind;
for i=1:numChannels
    for j=1:numFeats
        for k=1:N
            R(:,(i-1)*N*numFeats+(j-1)*N+k)=fullFeat(k:(size(fullFeat,1)-N+k),(i-1)*numFeats+j);
        end
    end
end

%adding column of ones
R=[ones(size(R,1),1), R];
end