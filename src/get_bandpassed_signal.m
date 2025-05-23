function bp_signal = get_bandpassed_signal(fs, signal)
    lw = 80; % low cutoff frequency in Hz
    hw = 500; % high cutoff frequency in Hz
    order = 256; % order must be a pair number
    bp_signal = getBandpassedSignal(fs, order, lw, hw, signal);
end