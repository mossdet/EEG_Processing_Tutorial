function cnsldtMtgList = getAvailableScalpMtgLabels(unipLabels, goalBipLabels)
    mtgLabelsTemp = lower(goalBipLabels);
    unipLabels = lower(unipLabels);

    % Find out how many of the goal mtgs are really present in the data
    cnsldtMtgList = {};
    for mi = 1:size(mtgLabelsTemp,1)
        montageName = mtgLabelsTemp{mi};
        chA = montageName(1:strfind(montageName, '-')-1);
        chB = montageName(strfind(montageName, '-')+1:end);
        chAIdx = find(ismember(unipLabels, chA));
        chBIdx = find(ismember(unipLabels, chB));
        if not(isempty(chAIdx) || isempty(chBIdx))
            mtgEntree = {goalBipLabels{mi}, chAIdx, chBIdx};
            cnsldtMtgList = [cnsldtMtgList; mtgEntree];
        end
    end
    nrMtgs = size(cnsldtMtgList,1);
end