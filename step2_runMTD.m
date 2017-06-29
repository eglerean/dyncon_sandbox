close all
clear all

%% the below should be run before:
% mkdir external
% cd extrnal
% system('git clone https://github.com/macshine/coupling/')
% cd ..
basepath='/m/nbe/scratch/braindata/eglerean/tomi/dynconn/';

behav_infiles=[
    {[basepath 'V2/arousal_regressors.mat']} {[basepath 'V2/valence_regressors.mat']}
    {[basepath 'V3/arousal_regressors.mat']} {[basepath 'V3/valence_regressors.mat']}
    ];


%% running the MTD coupling method http://www.sciencedirect.com/science/article/pii/S1053811915006849
addpath('external/coupling/')
Nsubj=2;
WINSIZE=4; % no temporal smoothing if WINSIZE = 1
maps=cbrewer('qual','Set1',9);

load testrois
for r=1:length(rois)
    labels{r}=rois(r).label;
end

for s =1:Nsubj
    load(['data/subj' num2str(s) '.mat']);
    % variable roits
    mtdts=coupling(roits,WINSIZE);
    figure(10)
    roi_i=3; % ACC
    roi_j=9; % PCUN
    plot(squeeze(mtdts(roi_i,roi_j,:)),'Color',maps(s,:))
    hold on
    
    % load the subject's regressors
    for av=1:2 % aro and valence
        temp=load(behav_infiles{s,av});
        for roi_i=1:11
            for roi_j=(roi_i+1):11
                adj(roi_i,roi_j,av)=corr(temp.R(:,1),squeeze(mtdts(roi_i,roi_j,:)));
                adj(roi_j,roi_i,av)=adj(roi_i,roi_j,av);
            end
        end
        figure(100*av+s)
        h=imagesc(adj(:,:,av),[-.2 .2])
        colorbar
        title(behav_infiles{s,av})
        set(gca,'YTick',[1:length(labels)])
        set(gca,'XTick',[1:length(labels)])
        set(gca,'YTickLabel',labels)
        set(gca,'XTickLabel',labels,'XTickLabelRotation',90)
    end
    
end
figure(10)
legend('Subject 1','Subject 2')   
xlabel('Time [TRs]')
ylabel('Dyn Fun Coupling (z-scores)')
title('Dynamic Functional Coupling between ACC and PCUN for two subjects')


