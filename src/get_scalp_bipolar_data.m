function [fs, nr_samples, mtg_labels, mtg_data] = get_scalp_bipolar_data(eegFilepath)

    %% Read header and channel labels
    eeg_hdr = ft_read_header(eegFilepath);
    fs = eeg_hdr.Fs; % save sampling rate to a variable, it will be needed very often
    nr_samples = eeg_hdr.nSamples;
    assert(fs > 1000, "Sampling Frequency is below 1000 Hz, this is insufficient to work with HFOs")
    availableRefLabels = eeg_hdr.label;
    
    %% Read raw data with the referential montage
    eeg_referential_data = ft_read_data(eegFilepath, 'begsample', 1, 'endsample', eeg_hdr.nSamples);
    
    %% define which montages will be created
    longBipolarLabels = {'Fp1-F7'; 'F7-T7'; 'T7-P7'; 'P7-O1'; 'F7-T3'; 'T3-T5'; 'T5-O1';...
        'Fp2-F8'; 'F8-T8'; 'T8-P8'; 'P8-O2'; 'F8-T4'; 'T4-T6'; 'T6-O2'; 'Fp1-F3'; 'F3-C3'; 'C3-P3';...
        'P3-O1'; 'Fp2-F4'; 'F4-C4'; 'C4-P4'; 'P4-O2'; 'FZ-CZ'; 'CZ-PZ'};
    
    %% Map the EEG channels to the desired bipolar montage
    scalp_montage_info = getAvailableScalpMtgLabels(availableRefLabels, longBipolarLabels);
    assert(~isempty(scalp_montage_info), "No Scalp channels found in the EEG!");
    
    %% Convert referential signals to bipolar signals
    mtg_labels = scalp_montage_info(:,1);
    mtg_data = generateMontageSignals(eeg_referential_data, scalp_montage_info);
end