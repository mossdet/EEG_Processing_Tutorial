%% get filtered signals
%% Filter order must be an even number
function [bpSignal] = getBandpassedSignal(samplingRate, order, lw, hw,signal)
    assert(mod(order,2) == 0, "FIR filter order must be a pair number!") 
    filterDelay = order/2;
    h = fir1(order/2, [lw/(samplingRate/2) hw/(samplingRate/2)], 'bandpass'); % 'low' | 'bandpass' | 'high' | 'stop' | 'DC-0' | 'DC-1'
    bpSignal = filter(h, 1, flip(signal));
    bpSignal = filter(h, 1, flip(bpSignal));
    bpSignal(1:filterDelay) = bpSignal(filterDelay+1);
    bpSignal(end-filterDelay:end) = bpSignal(end-filterDelay-1);
end