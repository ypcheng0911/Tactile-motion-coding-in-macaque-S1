load('../data/Processed_core_data.mat')

xticks = [5 10 20 40 80 160 320];
speed = [20 40 80 160 320;20 40 80 160 320;20 40 80 160 320];
temporal_frequency = [20 40 80 160 320;10 20 40 80 160; 5 10 20 40 80];

%% Figure 2C&D, Sample unit only
u = 52;
figure('position',[200 200 600 450])
loglog(temporal_frequency',Fmax_a1{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('temporal frequency (Hz)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
box off
saveas(gcf,'../results/Fig2D.png')

figure('position',[200 200 600 450])
loglog(speed',Fmax_a1{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('speed (mm/s)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
box off
saveas(gcf,'../results/Fig2C.png')

%-- Batch processing
%{
%% Area 1
for u=1:length(Fmax_a1)
%%
figure('position',[200 200 600 450])
loglog(temporal_frequency',Fmax_a1{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('temporal frequency (Hz)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('temporal frequency')
box off
saveas(gcf,sprintf('loglog_Fmax_TF_%s_a1u%d.png',a1_names{u},u))


figure('position',[200 200 600 450])
loglog(speed',Fmax_a1{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('speed (mm/s)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('speed')
box off
saveas(gcf,sprintf('loglog_Fmax_SP_%s_a1u%d.png',a1_names{u},u))

close all
end

%% Area 2
for u=1:length(Fmax_a2)
%%
figure('position',[200 200 600 450])
loglog(temporal_frequency',Fmax_a2{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('temporal frequency (Hz)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('temporal frequency')
box off
saveas(gcf,sprintf('loglog_Fmax_TF_%s_a2u%d.png',a2_names{u},u))


figure('position',[200 200 600 450])
loglog(speed',Fmax_a2{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([2 360],[2 360],'linestyle','--','color','k')
hold off
xlabel('speed (mm/s)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[2 360],'ylim',[2 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('speed')
box off
saveas(gcf,sprintf('loglog_Fmax_SP_%s_a2u%d.png',a2_names{u},u))

close all
end

%% Area 3b
for u=1:length(Fmax_3b)
%%
figure('position',[200 200 600 450])
loglog(temporal_frequency',Fmax_3b{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([3 360],[3 360],'linestyle','--','color','k')
hold off
xlabel('temporal frequency (Hz)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[3 360],'ylim',[3 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('temporal frequency')
box off
saveas(gcf,sprintf('loglog_Fmax_TF_%s_3bu%d.png',b3_names{u},u))


figure('position',[300 200 600 450])
loglog(speed',Fmax_3b{u},'linewidth',4,'marker','.','markersize',40)
hold on
loglog([3 360],[3 360],'linestyle','--','color','k')
hold off
xlabel('speed (mm/s)')
ylabel('Fmax (Hz)')
set(gca,'xlim',[3 360],'ylim',[3 360],'xtick',xticks,'ytick',xticks,'fontsize',28,'tickdir','out')
% title('speed')
box off
saveas(gcf,sprintf('loglog_Fmax_SP_%s_3bu%d.png',b3_names{u},u))

close all
end
%}