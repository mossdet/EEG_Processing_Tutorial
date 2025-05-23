%% Setup library paths and initialize fieldtrip
disp('Startup');
[thisFilePath,~,~] = fileparts(mfilename('fullpath'));
cd(thisFilePath);
run('src/startupScript.m');

%% Define path to EEG file
[eegs_dir, annots_dir, eeg_files] = physio_patients_ls();

for fi = 1:length(eeg_files)
    eegFilepath = strcat(eegs_dir, eeg_files{fi});
    eegFilepath = eegFilepath{1};
    annotsFilepath = strcat(annots_dir, eeg_files{fi});
    annotsFilepath = replace(annotsFilepath, '.edf', '.edf_best_performer_detections.mat');

    assert(isfile(eegFilepath), strcat("EEG File not found: ", eegFilepath));
    assert(isfile(annotsFilepath), strcat("Annotations File not found: ", annotsFilepath));

    %% Load EEG data
    % get sampling rate (fs), nr_samples, mtg_labels and mtg_data
    [fs, nSamples, mtg_labels, mtg_data] = get_scalp_bipolar_data(eegFilepath); 
    eeg_time = (0:nSamples-1)/fs; % Create an array containing the times from each sample    


    %% Load HFO detections data
    hfo_dets = load(annotsFilepath);

    %% Iterate through EEG channels
    for chidx = 1:length(mtg_labels)

        eeg_ch = mtg_labels{chidx};
        disp(strcat("Processing channel", eeg_ch));

        % Process the eeg signal from this channel
        ch_raw_signal = mtg_data(chidx,:);
        [freqs, wvlt_trnsfm] = get_signal_cwt(fs, ch_raw_signal);
        ch_bp_signal = get_bandpassed_signal(fs, ch_raw_signal);


        % Select HFO events in this channel
        sel_hfo = cellfun(@(x) strcmpi(x, eeg_ch), string(hfo_dets.Channel), 'UniformOutput', true)>0;
        nr_ch_hfo = sum(sel_hfo);
        ch_hfo_events_start = hfo_dets.StartSample(sel_hfo);
        ch_hfo_events_end= hfo_dets.EndSample(sel_hfo);

        % Loop through each hfo events from this channel
        plot_ok = 1;
        for hfo_idx = 1:nr_ch_hfo
            % Extract hfo event's signal and wavelet transform
            hfo_start = ch_hfo_events_start(hfo_idx);
            hfo_end = ch_hfo_events_end(hfo_idx);
            hfo_center = int32(mean([hfo_start, hfo_end]));
            hfo_bp_signal = ch_bp_signal(hfo_start:hfo_end);
            hfo_wavelet_trnsfm = wvlt_trnsfm(:, hfo_start:hfo_end);
            hfo_time = eeg_time(hfo_start:hfo_end);

            % Compute the features for each hfo event

            % Max amplitude
            max_amplitude = max(hfo_bp_signal)-min(hfo_bp_signal);

            % Peak frequency
            [max_val, max_idx] = max(mean(hfo_wavelet_trnsfm,2));
            peak_freq = freqs(max_idx);

            if plot_ok
                pss = hfo_center-int32(fs/2);
                pse= pss+fs-1;
                mss = int32(fs/2)-(hfo_center-hfo_start);
                mse = int32(fs/2)+(hfo_end-hfo_center);
                if pss>1 && pse<=nSamples                    
                    plot_hfo_event(eeg_time(pss:pse), ch_raw_signal(pss:pse), ch_bp_signal(pss:pse), freqs, wvlt_trnsfm(:, pss:pse), mss, mse)
                end
            end
        end
    end
end