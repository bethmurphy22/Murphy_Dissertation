function idx = dryseasonidx(ds_s,ds_e,month)

% assigns idx a value of 1 for the wet season and a value of 2 for the dry
% season

% ds_s = number corresponding to the month where dry season starts
%          Ex: September is 9, January is 1

% ds_e = number corresponding to the month where dry season ends

% month = array storing numeric month value for each day of data
% Should already be defined based on the porton of data being used
% for calibration

% create variable to store idx
idx = ones(length(month),1);

if ds_s > ds_e % if the beginning of the dry season is at a later month than the end
    ds_1 = ds_s:12; % first part is start:12th month (December)
    ds_2 = 1:ds_e; % second part is 1st month (january):end
    ds = [ds_2 ds_1]; % overall dry season is the combination
else % if numeric value of beginning of season is before end
    ds = ds_s:ds_e; % Season is start to end
end

for i = 1:numel(ds) % for each month in the dry season
    dryseason = find(month == ds(i)); % index days corresponding to those months
    idx(dryseason) = 2; % set idx equal to 2
end

end

