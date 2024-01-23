function [subLLV]=make_LLV(subLes)

% assumes subLes is 0-1 smoothed isometric 2mm MNI space mask

% load in atlas
[~, roi_img] = read_nifti('combined_moriFan_2mm.nii.gz');
roi_img(1:46,:,:)=0; % left hemisphere only 

rois = setdiff(unique(roi_img), 0);

% load in labels
roiLbls=readtable('combined_moriFan_lbls.txt');
roiLbls=roiLbls{ismember(roiLbls{:,1},rois),2}; 

% get volume of each ROI
roi_img = roi_img(:);
rois = setdiff(unique(roi_img), 0);
nrois = length(rois);
roivol = zeros(nrois, 1);
for r = 1:nrois
  roivol(r) = sum(roi_img == rois(r));
end

% compare subject lesion to each ROI and divide by its size
subLLV=nan(1,nrois);
subLes=subLes(:);
for r = 1:nrois
    subLLV(r) = sum(subLes .* (roi_img == rois(r))) / roivol(r);
end

% put into nicely formatted table
subLLV=array2table(subLLV,'VariableNames',roiLbls);