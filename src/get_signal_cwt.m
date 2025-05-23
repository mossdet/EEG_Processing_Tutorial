function [freqs, absCFS] = get_signal_cwt(fs, signal)
    %% Get the Morlet Wavelet transform from the first channel, time window of second 10 to 11
    wavelet_low_freq_limit = 80;
    wavelet_high_freq_limit = 500;
    [cfs,freqs, coi] = cwt(signal, 'amor', fs, 'FrequencyLimits',[wavelet_low_freq_limit wavelet_high_freq_limit]);
    absCFS = abs(cfs);
end