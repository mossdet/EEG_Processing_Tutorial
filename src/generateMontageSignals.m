function mtgSignals = generateMontageSignals(referentialSignals, montage_info)
    nrSamples = size(referentialSignals,2);

    nrMtgs = size(montage_info,1);
    mtgSignals = zeros(nrMtgs, nrSamples);
    for mi = 1:nrMtgs
        sigA = referentialSignals(montage_info{mi,2},:);
        sigB = referentialSignals(montage_info{mi,3},:);
        mtgSignal = sigA - sigB;
        mtgSignals(mi,:) = mtgSignal;
    end
end