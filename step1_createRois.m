clear all
close all

addpath(genpath('/m/nbe/scratch/braindata/shared/toolboxes/bramila//bramila'));
basepath='/m/nbe/scratch/braindata/eglerean/tomi/dynconn/';
files=dir([basepath 'emotion_masks/*.nii'])

R=length(files);

% combine all rois as indexed single volume
roivol=zeros(91,109,91);
for c=1:R;
    disp(files(c).name)
    nii=load_nii([basepath 'emotion_masks/' files(c).name]);
    roivol=roivol+c*nii.img;
    labels{c,1}=strrep(files(c).name,'.nii','');
end

save_nii(make_nii(roivol,[2 2 2]),'roimask.nii');

cfg=[];
cfg.roimask='roimask.nii';
cfg.labels=labels;
cfg.imgsize=[91 109 91];
rois = bramila_makeRoiStruct(cfg);
save testrois rois

% create ROIs time series for each subject
mkdir('data')
infiles={
    [basepath 'V2/epi_preprocessed.nii']
    [basepath 'V3/epi_preprocessed.nii']
    };

for s=1:length(infiles)
    cfgtemp=[];
    cfgtemp.infile=infiles{s};
    cfgtemp.rois=rois;
    cfgtemp.usemean=1;
    disp(['Extracting ROIs timeseries for ' cfgtemp.infile])
    roits=bramila_roiextract(cfgtemp);
    save(['data/subj' num2str(s)],'roits') 
end


