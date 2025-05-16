%% Setup library paths and initialize fieldtrip
disp('Startup');
[thisFilePath,~,~] = fileparts(mfilename('fullpath'));
cd(thisFilePath);
run('src/startupScript.m');

%% Define path to EEG file
eegFilepath = 'C:/Users/HFO/Documents/Postdoc_Calgary/Research/Physiological_HFO/Anonymized_EDFs/HFOHealthy1monto2yrs/Physio_Pat_103.edf';

%% Read header and channel labels
eeg_hdr = ft_read_header(eegFilepath);
fs = eeg_hdr.Fs; % save sampling rate to a variable, it will be needed very often
assert(fs > 1000, "Sampling Frequency is below 1000 Hz, this is insufficient to work with HFOs")
availableRefLabels = eeg_hdr.label;
eeg_time = (0:eeg_hdr.nSamples-1)/fs; % Create an array containin the times from each sample

%% Read raw data with the referential montage
eeg_test_referential_data = ft_read_data(eegFilepath, 'begsample', 1, 'endsample', fs*60);

%% define which montages will be created
longBipolarLabels = {'Fp1-F7'; 'F7-T7'; 'T7-P7'; 'P7-O1'; 'F7-T3'; 'T3-T5'; 'T5-O1';...
    'Fp2-F8'; 'F8-T8'; 'T8-P8'; 'P8-O2'; 'F8-T4'; 'T4-T6'; 'T6-O2'; 'Fp1-F3'; 'F3-C3'; 'C3-P3';...
    'P3-O1'; 'Fp2-F4'; 'F4-C4'; 'C4-P4'; 'P4-O2'; 'FZ-CZ'; 'CZ-PZ'};

%% Map the EEG channels to the desired bipolar montage
scalp_montage_info = getAvailableScalpMtgLabels(availableRefLabels, longBipolarLabels);
assert(~isempty(scalp_montage_info), "No Scalp channels found in the EEG!");

%% Convert referential signals to bipolar signals
mtg_data = generateMontageSignals(eeg_test_referential_data, scalp_montage_info);

%% Apply FIR bandpass filter to first channel
chann_signal = mtg_data(1,:);
lw = 80; % low cutoff frequency in Hz
hw = 500; % high cutoff frequency in Hz
order = 256; % order must be a pair number
chann_signal_bandpassed = getBandpassedSignal(fs, order, lw, hw, chann_signal);

%% Get the Morlet Wavelet transform from the first channel, time window of second 10 to 11
wavelet_low_freq_limit = 80;
wavelet_high_freq_limit = 500;
[cfs,frqs, coi] = cwt(chann_signal, 'amor', fs, 'FrequencyLimits',[wavelet_low_freq_limit wavelet_high_freq_limit]);
absCFS = abs(cfs);

%% Plot raw, bandpassed and spectrogram from second 10 to 11
samples_selection = 10*fs:11*fs-1;
time_sel = eeg_time(samples_selection);
raw_sig_sel = chann_signal(samples_selection);
bp_sig_sel = chann_signal_bandpassed(samples_selection);
spect_sel = absCFS(:, samples_selection);

figure(1)
subplot(3,1,1);
plot(time_sel, raw_sig_sel, '-k', 'LineWidth', 0.1)
title('Raw Signal')
ylabel("Voltage (uV)")

subplot(3,1,2);
plot(time_sel, bp_sig_sel, '-k', 'LineWidth', 0.1)
title('Bandpassed Signal')
ylabel("Voltage (uV)")

subplot(3,1,3);
contour(time_sel, frqs, spect_sel, 'LineStyle','none', 'LineColor',[0 0 0], 'Fill','on', 'Tag', 'heatmap');
title("Wavelet Transform")
ylabel("Frequency (Hz)")
xlabel("Time (s)")


