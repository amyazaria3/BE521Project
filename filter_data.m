function clean_data = filter_data(raw_eeg)
%% IMPORTANT - download WAVELET TOOLBOX
    %
    % filter_data_release.m
    %
    % Description: The main sources of EEG noise is from eye movement (EOG), ECG
    % and muscle movement (EMG). Given that the data should be maintained
    % in the time domain as closely as possible and to remove these
    % artifacts only when they occur (they do not occur regular intervals),
    % we decided to use an adaptive approach where we decompose the EEG
    % into intervals that we analyze separately and use wavelet filters to
    % remove the corresponding artifacts
    %
    % Input:    raw_eeg (samples x channels)
    %
    % Output:   clean_data (samples x channels)
    % 
%% Your code here (2 points) 
[x, y] = size(raw_eeg);
clean_data = zeros(x, y);

for c = 1:y
    clean_data(:,c) = cmddenoise(raw_eeg(:,c),'db3',5);
end

end