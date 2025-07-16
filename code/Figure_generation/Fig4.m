newcolors = [.6 .7 .9; 0.8 .9 .6; 1 .7 .7;.9 .9 .5; .7 .7 .7];
sp = 1:5;
sp_eb = [1:5;1:5;1:5];
tf = [3:7;2:6;1:5];
sp_label = {'20','40','80','160','320'};
tf_label = {'5','10','20','40','80','160','320'};

%% Rearrange the sample units (Figure 4A)
figure('position',[50 50 1450 540])

pos_trend = [15.0667   12.5333   11.7333
   20.4000   22.2667   16.1333
   25.7333   30.6667   28.4000
   22.1333   31.7333   35.3333
   24.4000   31.6000   42.5333]'; % real data - 3b u30
sem = [2.5995    1.2912    0.7647
    2.8531    2.1133    2.3132
    3.1867    2.7968    1.9276
    2.1701    1.7977    1.8352
    2.3938    2.1040    1.7379]';
subplot(251)
errorbar(sp_eb',pos_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
ylabel('firing rate (Hz)')
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 48])
% title('type 1 - positive trend','color',newcolors(1,:))
xlabel('speed (mm/s)')
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #330','color',[.6 .6 .6],'fontsize',16)

subplot(256)
errorbar(tf',pos_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
ylabel('firing rate (Hz)')
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 48])
xlabel('temporal frequency (Hz)')

pos_trend = [0.5333    1.0667         0
    3.7333    4.1333    0.1333
   10.8000   10.4000    1.6000
   16.9333   17.0667   11.2000
   21.6000   19.4667   24.4000]'; % area 2, u31
sem = [0.2948    0.3875         0
    0.9491    0.8061    0.1333
    1.8693    1.6245    0.7901
    1.2579    2.2470    2.6007
    1.9656    3.5288    1.5782]';

subplot(252)
errorbar(sp_eb',pos_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 48])
% title('type 1 - positive trend','color',newcolors(1,:))
xlabel('speed (mm/s)')
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #231','color',[.6 .6 .6],'fontsize',16)

subplot(257)
errorbar(tf',pos_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 48])
xlabel('temporal frequency (Hz)')

inverted = [33.8667   41.6000   21.4667
   43.6000   52.9333   26.5333
   44.6667   61.7333   44.8000
   42.4000   60.2667   56.5333
   44.0000   46.8000   61.2000]';  % real data - 3b u10
sem =[4.0108    4.2667    2.7502
    4.8648    3.8183    3.4624
    4.3010    6.0583    3.5344
    4.3854    5.2051    4.7420
    4.8929    6.2268    4.5344]';

subplot(253)
errorbar(sp_eb',inverted',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 75])
% title('type 2 - inverted V','color',newcolors(2,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #310','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')

subplot(258)
errorbar(tf',inverted',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 75])
xlabel('temporal frequency (Hz)')

inverted = [0.1333    1.7333    2.0000
    1.8667    2.9333    3.3333
    1.2000    5.0667    6.0000
    1.2000    7.4667    8.8000
    0.8000    6.5333    8.9333]';  % area 1 u31
sem = [
    0.1333    0.7963    0.4554
    0.8000    1.2220    0.5352
    0.5425    1.0480    0.5352
    0.5425    1.4767    1.1453
    0.4532    1.5832    1.4613]';

subplot(254)
errorbar(sp_eb',inverted',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 12])
% title('type 2 - inverted V','color',newcolors(2,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #131','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')

subplot(259)
errorbar(tf',inverted',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 12])
xlabel('temporal frequency (Hz)')
saveas(gcf,'../results/Fig4A_1st_row.png')

%%%%
figure('position',[50 50 1450 540])

neg_trend = [6.2667   10.8000   24.0000
    1.3333    4.9333   19.8667
    4.4000    6.2667   18.9333
    3.6000    5.6000   15.4667
    4.2667    5.0667   13.3333]';  % real data - a1 u38
sem = [3.1367    3.5414    2.4585
    0.8195    1.5782    2.2701
    1.7894    2.4184    2.9535
    1.4340    1.3742    2.5701
    1.0667    2.3077    1.9975]';

subplot(251)
errorbar(sp_eb',neg_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 33])
% title('type 3 - negative trend','color',newcolors(3,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #138','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
ylabel('firing rate (Hz)')

subplot(256)
errorbar(tf',neg_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 33])
xlabel('temporal frequency (Hz)')
ylabel('firing rate (Hz)')

v = [5.0667    9.8667   11.7333
    5.3333    7.0667    8.5333
    5.2000    6.9333    6.4000
    7.4667    8.5333    4.1333
   14.0000   14.8000    4.6667]';  % real data - 3b u49
sem =[0.7647    1.1102    1.6123
    1.1244    1.7104    1.4360
    0.5778    1.1556    1.2539
    0.5692    1.3799    0.8988
    0.3583    1.2325    1.7011]';

subplot(253)
errorbar(sp_eb',v',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 23])
% title('type 4 - V-shaped','color',newcolors(4,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #349','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
subplot(258)
errorbar(tf',v',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 23])
xlabel('temporal frequency (Hz)')

neg_trend = [6.2667   21.3333   21.6000
    5.6000   17.8667   16.5333
    5.8667   18.6667   16.8000
    6.5333   18.1333   17.0667
    7.8667   14.2667   15.4667]'; % area 3b u47
sem = [0.4889    2.3264    4.7570
    0.6828    1.3363    2.9960
    0.4949    1.7328    3.3033
    0.9625    2.2853    3.1789
    0.8766    0.7180    1.9696]';

subplot(252)
errorbar(sp_eb',neg_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 28])
% title('type 3 - negative trend','color',newcolors(3,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #347','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
subplot(257)
errorbar(tf',neg_trend',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 28])
xlabel('temporal frequency (Hz)')

v = [13.0667   11.8667    7.7333
   12.6667   11.3333    6.6667
   11.8667    9.6000    6.5333
   12.9333   11.6000   12.0000
   13.8667   12.1333   11.7333]'; % area 1 u14
sem = [ 2.3247    2.3472    1.8195
    2.4119    2.7559    2.5376
    2.3303    1.8086    3.4164
    3.8235    1.8545    3.7765
    2.9561    2.1171    3.1727]';

subplot(254)
errorbar(sp_eb',v',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 23])
% title('type 4 - V-shaped','color',newcolors(4,:))
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #114','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
subplot(259)
errorbar(tf',v',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 23])
xlabel('temporal frequency (Hz)')
saveas(gcf,'../results/Fig4A_2nd_row.png')

%%%%
figure('position',[50 50 1450 540])
other = [4.8000   17.0667   10.2667
    7.0667   13.4667   11.8667
    6.1333   14.4000   15.0667
    5.4667   11.2000   12.0000
    5.6000    9.3333    4.9333]';  % real data - 3b u42
sem = [1.1624    1.9250    1.7219
    1.4477    1.2000    2.2788
    0.8709    2.1755    2.5067
    1.0027    1.8877    2.2044
    0.9280    1.1067    0.8900]';

subplot(251)
errorbar(sp_eb',other',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 28])
% title('type 5 - other','color',newcolors(5,:))
% legend('1 mm','2 mm','4 mm','box','off','color','none')
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #342','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
ylabel('firing rate (Hz)')
subplot(256)
errorbar(tf',other',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 28])
xlabel('temporal frequency (Hz)')
ylabel('firing rate (Hz)')



other = [34.2667    6.6667   16.5333
   35.8667    9.6000   21.0667
   30.4000    9.0667   20.6667
   31.2000   10.9333   18.2667
   18.1333   12.2667   10.5333]';  % area 1 u57
sem=[3.9405    1.0328    2.8611
    3.8152    1.7756    4.9042
    2.9535    1.8940    5.3306
    2.2767    2.9401    3.8235
    2.3702    1.7075    1.5581]';

subplot(252)
errorbar(sp_eb',other',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 6])
set(gca,'xtick',1:5,'xticklabel',sp_label)
ylim([0 52])
% title('type 5 - other','color',newcolors(5,:))
% legend('1 mm','2 mm','4 mm','box','off','color','none')
ylims = get(gca,'ylim');
text(0.5,ylims(2)*0.9,'unit #157','color',[.6 .6 .6],'fontsize',16)
xlabel('speed (mm/s)')
subplot(257)
errorbar(tf',other',sem','o-','linewidth',2)
set(gca,'box','off','tickdir','out','linewidth',1.5,'fontsize',16)
xlim([0 8])
set(gca,'xtick',1:7,'xticklabel',tf_label)
ylim([0 52])
xlabel('temporal frequency (Hz)')
saveas(gcf,'../results/Fig4A_3rd_row.png')

%% Proportions in each area (Figure 4B)
cat_n_3b = [15 13 1 9 2];
cat_n_a1 = [18 5 4 17 4];
cat_n_a2 = [25 5 0 8 1];
cat_n_all = [cat_n_3b/40;cat_n_a1/48;cat_n_a2/39]*100;
newcolors = [.6 .7 .9; 0.8 .9 .6; 1 .7 .7;.9 .9 .5; .7 .7 .7];

figure; colororder(newcolors);
bar(cat_n_all)
legend('positive trend','inverted V','negative trend','V-shaped','other','location','eastoutside','box','off','color','none')
set(gca,'box','off','tickdir','out','xticklabel',{'area 3b','area 1','area 2'},'linewidth',1.5,'fontsize',18)
ylabel('proportion (%)')
text(0.7,.8*100,'(n = 40)','fontsize',16)
text(1.7,.8*100,'(n = 48)','fontsize',16)
text(2.7,.8*100,'(n = 39)','fontsize',16)
ylim([0 1.1*80])
set(gca,'ytick',0:0.2*100:.6*100)
saveas(gcf,'../results/Fig4B.png')
