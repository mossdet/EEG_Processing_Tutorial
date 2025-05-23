function plot_hfo_event(time_vec, raw_sig, bp_sig, freqs, wvlt_trfm, mrk_sstart, mrk_end)
    figure(1)
    subplot(3,1,1);
    plot(time_vec, raw_sig, '-k', 'LineWidth', 0.1); hold on;
    plot(time_vec(mrk_sstart:mrk_end), raw_sig(mrk_sstart:mrk_end), '-r')
    title('Raw Signal')
    ylabel("Voltage (uV)")
    xlim([time_vec(1),time_vec(end)])
    
    subplot(3,1,2);
    plot(time_vec, bp_sig, '-k', 'LineWidth', 0.1); hold on;
    plot(time_vec(mrk_sstart:mrk_end), bp_sig(mrk_sstart:mrk_end), '-r')
    title('Bandpassed Signal')
    ylabel("Voltage (uV)")
    xlim([time_vec(1),time_vec(end)])
    
    subplot(3,1,3);
    contour(time_vec, freqs, wvlt_trfm, 'LineStyle','none', 'LineColor',[0 0 0], 'Fill','on', 'Tag', 'heatmap');
    title("Wavelet Transform")
    ylabel("Frequency (Hz)")
    xlabel("Time (s)")
    xlim([time_vec(1),time_vec(end)])

end