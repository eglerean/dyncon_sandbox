close all
clear all

%% the below should be run before:
% mkdir external
% cd extrnal
% system('git clone https://github.com/macshine/coupling/')
% cd ..

%% running the MTD coupling method http://www.sciencedirect.com/science/article/pii/S1053811915006849
addpath('external/coupling/')
Nsubj=2;
WINSIZE=10; % no temporal smoothing if WINSIZE = 1
maps=cbrewer('qual','Set1',9);

for s =1:Nsubj
    load(['data/subj' num2str(s) '.mat']);
    % variable roits
    mtdts=coupling(roits,WINSIZE);
    figure(10)
    roi_i=3; % ACC
    roi_j=9; % PCUN
    plot(squeeze(mtdts(roi_i,roi_j,:)),'Color',maps(s,:))
    hold on
end
   

