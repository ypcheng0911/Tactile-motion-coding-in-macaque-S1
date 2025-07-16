load('../data/Processed_core_data.mat')

%-- Choose the brain area
%-- Run 3b (sup fig 5), a1 (sup fig 6) & a2 (sup fig 7)separately
area = '3b'; % 3b, a1, a2
plot_opt = 'raw'; % 'raw' 'norm'
eval(sprintf('units = BAread(BA_sus_resp_%s,''units'');',area)) 
ball_color=[0 0.45 0.74; 0.85 0.33 0.1; 0.93 0.69 0.13]; 
plot_fig = 'n'; % 'y', 'n'
log_opt = 'n'; % 'y', 'n'
max_dir_eFR={};
sig_sp_list = zeros(1,length(units));
sig_ball_list = zeros(1,length(units));
anova_sig_list = zeros(7,length(units));
min_loc=[];
max_loc=[];
for unit_to_plot = 1:length(units)
    obj = units(unit_to_plot);
    pref_d = SUread(obj,'pref_d');
    SUr = SUanova(obj);
    anova_r = SURread(SUr,'results');
    eval(sprintf('p_all = anova_r.p_f%d;',pref_d{3}))
    p_sp_anova = p_all(2); %speed
    p_ball_anova = p_all(3); %ball
    
    sig_sp_list(unit_to_plot) = p_sp_anova < 0.01;
    sig_ball_list(unit_to_plot) = p_ball_anova < 0.01;
    anova_sig_list(:,unit_to_plot) = p_all < 0.01;
    
    [r_sp,r_tf,p_sp,p_tf,~,~,max_dir,eFR] = SU_eFRvSPvTF_corr(obj,'max_dir',plot_fig,log_opt);
    cond_eFR = reshape(mean(eFR(max_dir,:,:,:),4),5,3);
    std_eFR = reshape(std(eFR(max_dir,:,:,:),0,4),5,3);
    sem_eFR = std_eFR/ (10)^0.5;
    [~,max_idx] = max(mean(cond_eFR,2));
    [~,min_idx] = min(mean(cond_eFR,2));
    max_loc(unit_to_plot) = max_idx;
    min_loc(unit_to_plot) = min_idx;
    
    switch plot_opt 
        case 'raw'
    % raw firing rate
    max_dir_eFR{unit_to_plot} = cond_eFR;
    max_dir_std_eFR{unit_to_plot} = std_eFR;
    max_dir_sem_eFR{unit_to_plot} = sem_eFR; 
        case 'norm'
    % normalized to maximum
    max_dir_eFR{unit_to_plot} = cond_eFR/max(cond_eFR(:))*100;
    end
end
type1 = find(min_loc==1 & max_loc==5); % linear positive
type2 = find(min_loc==1 & max_loc~=5); % inverted u/v
type3 = find(min_loc==5 & max_loc==1); % linear negative
type4 = find(min_loc==2| min_loc==3| min_loc==4); % u/v
type5 = setdiff(1:length(units),[type1 type2 type3 type4]); % other

x1=[];x2=[];x3=[];
sp_sig_u = find(sig_sp_list==1);

clearvars type1_x1 type1_x2 type1_x3 type2_x1 type2_x2 type2_x3 type3_x1 type3_x2 type3_x3 type4_x1 type4_x2 type4_x3 type5_x1 type5_x2 type5_x3  
n1=1;n2=1;n3=1;n4=1;n5=1;
for unit_to_plot = 1:length(sp_sig_u)
    type = [ismember(sp_sig_u(unit_to_plot),type1);...
    ismember(sp_sig_u(unit_to_plot),type2);...
    ismember(sp_sig_u(unit_to_plot),type3);...
    ismember(sp_sig_u(unit_to_plot),type4);...
    ismember(sp_sig_u(unit_to_plot),type5)];
    
    switch find(type==1)
        case 1
            type1_x1(:,n1) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,1);
            type1_x2(:,n1) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,2);
            type1_x3(:,n1) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,3);
            n1=n1+1;
        case 2
            type2_x1(:,n2) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,1);
            type2_x2(:,n2) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,2);
            type2_x3(:,n2) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,3);
            n2=n2+1;
        case 3
            type3_x1(:,n3) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,1);
            type3_x2(:,n3) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,2);
            type3_x3(:,n3) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,3);
            n3=n3+1;
        case 4
            type4_x1(:,n4) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,1);
            type4_x2(:,n4) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,2);
            type4_x3(:,n4) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,3);
            n4=n4+1;
        case 5
            type5_x1(:,n5) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,1);
            type5_x2(:,n5) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,2);
            type5_x3(:,n5) = max_dir_eFR{sp_sig_u(unit_to_plot)}(:,3);
            n5=n5+1;
    end
end
type_txt = {'positive trend','inverted V','negative trend','V-shpaed','other'};

%% Figure generation
figure('position',[50 50 1320 400])
for i=1:5
    try
        % Speed
        subplot(2,6,i)
        eval(sprintf('scatter(repelem([1:5]'',1,n%d-1),type%d_x1,10,ball_color(1,:),''o'')',i,i))
        hold on
        eval(sprintf('scatter(repelem([1:5]'',1,n%d-1),type%d_x2,10,ball_color(2,:),''x'')',i,i))
        eval(sprintf('scatter(repelem([1:5]'',1,n%d-1),type%d_x3,10,ball_color(3,:),''*'')',i,i))

        eval(sprintf('errorbar(1:5,mean(type%d_x1,2),std(type%d_x1,0,2)/(length(type%d_x1)^0.5),''color'',ball_color(1,:),''linewidth'',2)',i,i,i))
        eval(sprintf('errorbar(1:5,mean(type%d_x2,2),std(type%d_x2,0,2)/(length(type%d_x2)^0.5),''color'',ball_color(2,:),''linewidth'',2)',i,i,i))
        eval(sprintf('errorbar(1:5,mean(type%d_x3,2),std(type%d_x3,0,2)/(length(type%d_x3)^0.5),''color'',ball_color(3,:),''linewidth'',2)',i,i,i))   
        
        hold off
        set(gca,'xlim',[0 6],'box','off','tickdir','out','xtick',1:5,'xticklabel',[20 40 80 160 320],'linewidth',1)
        eval(sprintf('title([type_txt{i},'' (n='',num2str(n%d-1),'')''])',i))
        xlabel('scanning speed (mm/s)')
        if i==1
            switch plot_opt
                case 'raw'
                    ylabel('firing rate (Hz)')
                case 'norm'
                    ylabel('normalized firing rate (%)')
            end
        end
        
        % TF
        subplot(2,6,i+6)
        eval(sprintf('scatter(repelem([3:7]'',1,n%d-1),type%d_x1,10,ball_color(1,:),''o'')',i,i))
        hold on
        eval(sprintf('scatter(repelem([2:6]'',1,n%d-1),type%d_x2,10,ball_color(2,:),''x'')',i,i))
        eval(sprintf('scatter(repelem([1:5]'',1,n%d-1),type%d_x3,10,ball_color(3,:),''*'')',i,i))
        
        eval(sprintf('errorbar(3:7,mean(type%d_x1,2),std(type%d_x1,0,2)/(length(type%d_x1)^0.5),''color'',ball_color(1,:),''linewidth'',2)',i,i,i))
        eval(sprintf('errorbar(2:6,mean(type%d_x2,2),std(type%d_x2,0,2)/(length(type%d_x2)^0.5),''color'',ball_color(2,:),''linewidth'',2)',i,i,i))
        eval(sprintf('errorbar(1:5,mean(type%d_x3,2),std(type%d_x3,0,2)/(length(type%d_x3)^0.5),''color'',ball_color(3,:),''linewidth'',2)',i,i,i))
            
        hold off
        set(gca,'xlim',[0 8],'box','off','tickdir','out','xtick',1:7,'xticklabel',[5 10 20 40 80 160 320],'linewidth',1)
        xlabel('temporal frequency (Hz)')
        if i==1
            switch plot_opt
                case 'raw'
                    ylabel('firing rate (Hz)')
                case 'norm'
                    ylabel('normalized firing rate (%)')
            end
        end
             
    catch
        subplot(2,6,i)
        eval(sprintf('title([type_txt{i},'' (n='',num2str(n%d-1),'')''])',i))
        axis off
        subplot(2,6,i+6)
        axis off
    end
end
subplot(2,6,6)
histogram(max_loc(intersect(type2,sp_sig_u)))
set(gca,'xlim',[1 5],'xtick',2:4,'xticklabel',[40 80 160],'box','off','tickdir','out','linewidth',1)
ylabel('number of unit')
xlabel('scanning speed (mm/s)')
title('response peak - type 2')

subplot(2,6,12)
histogram(min_loc(intersect(type4,sp_sig_u)))
set(gca,'xlim',[1 5],'xtick',2:4,'xticklabel',[40 80 160],'box','off','tickdir','out','linewidth',1)
ylabel('number of unit')
xlabel('scanning speed (mm/s)')
title('response trough - type 4')
% saveas(gcf,fullfile(save_dir,[plot_opt,'_',area,'_fr_vs_speed_wHisto.png']))
