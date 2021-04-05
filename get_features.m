function [features, numFeats] = get_features(clean_data,fs)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate features.
    %               Please create 4 OR MORE different features for each channel.
    %               Some of these features can be of the same type (for example, 
    %               power in different frequency bands, etc) but you should
    %               have at least 2 different types of features as well
    %               (Such as frequency dependent, signal morphology, etc.)
    %               Feel free to use features you have seen before in this
    %               class, features that have been used in the literature
    %               for similar problems, or design your own!
    %
    % Input:    clean_data: (samples x channels)
    %           fs:         sampling frequency
    %
    % Output:   features:   (1 x (channels*features))
    %           numFeats:   number of features being calculated
    % 
%% Your code here (8 points)

features = [];
for i = 1:size(clean_data,2) %#cols in matrix (channels)
    %compute variance
    features(1,end+1) = var(clean_data(:,i));
    
    %compute energy
    features(1,end+1) = sum(clean_data(:,i).^2);
    
    %compute shannon entropy
    features(1,end+1) = wentropy(clean_data(:,i),'shannon');
    
    %compute line length
    features(1,end+1) = sum(abs(diff(clean_data(:,i))));  
    
    %compute mean voltage
    features(1,end+1) = mean(clean_data(:,i));  
    
    %find num maxima + minima
    %features(1,end+1) = length(findpeaks(clean_data(:,i))) + length(findpeaks(-1*clean_data(:,i))); 
    %this is so slow
end

numFeats = length(features)/size(clean_data,2);

%features = [variance energy entropy lineLen extrema]

%%%%TIME DOMAIN%%%%
%variance
%energy
%shannon entropy
%line length
%# of maxima and minima
%RMS amplitude
%kurtosis
%hjorth parameters
%autocorrelation?

%%%%FREQUENCY DOMAIN%%%%
%total power (0-12Hz or 1-47?)
%peak frequency of spectrum
%spectral edge density (80, 90, 95)
%power and normalized power


end

