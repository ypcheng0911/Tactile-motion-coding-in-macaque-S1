load('../data/Processed_core_data.mat')

%% Figure 2A
%-- Choose the unit
units = BAread(BA_sus_resp_a1,'units'); % Can also try: BA_sus_resp_3b, BA_sus_resp_a1, BA_sus_resp_a2
unit_to_plot =  52;   % Can also try: 3b u24, a2 u18
obj = units(unit_to_plot);
figure('position',[300 300 480 420])
clearvars Fmax
Fmax = zeros(5,3);
for spe=1:5
    for sp=1:3
        subplot(5,3,sp+(spe-1)*3)
        [~,~,~,~,AveragePower,~,F0,Fmax(spe,sp),pks_freq,~,psd_all]=SU_add_noise_autocFFT(obj,spe,sp,'n','y','max',5000,1);
        TF = TF_spe_sp(spe,sp);
        
        if TF <= 20
            set(gca,'xlim',[3 105],'xtick',[TF 100],'xticklabel',{[],100}) 
        else
            [ticks,ia,~] = unique([TF 100 200 300]);
            t_label = {[],100,200,300};
            t_label = t_label(ia);
            set(gca,'xtick',ticks,'xticklabel',t_label) 
        end
        set(gca,'box','off','tickdir','out')
        hold on
        line([Fmax(spe,sp) Fmax(spe,sp)],[max(AveragePower)*1.05 max(AveragePower)*1.1],'color','r','linewidth',2)
        
        ylims = get(gca,'ylim');
        line([TF TF],ylims,'color','k','linestyle',':','linewidth',1.5)
        hold off
        
        if spe==5 && sp==1
            set(gca,'ylim',[300 500])
        end
    end
end
saveas(gcf,'../results/Fig2A.png')

%% Figure 3B, Testing Fmax of same speed across spatial periods

%-- Computation, Run each region separately, then combine the outputs for 
%-- figure generation.
%{
TF_mat = [20 10 5; 40 20 10; 80 40 20; 160 80 40; 320 160 80];
clearvars similar_Fmax_for_same_speed TF_coding_for_each_speed SP_coding TF_coding par_TF_coding par_SP_coding
for u=1:length(Fmax_a2)
%     Fmax = Fmax_3b{u};
%     Fmax = Fmax_a1{u};
    Fmax = Fmax_a2{u};
    for i=1:5
        % check for sp coding
        d2median = Fmax(i,:) - median(Fmax(i,:));
        similar_Fmax_for_same_speed{u}(i) = sum(round(abs(d2median),1) <= 3)==3;
        similar_Fmax_only2{u}(i) = sum(round(abs(d2median),1) <= 3)>=2;
        % check for tf coding
        d2tf = Fmax(i,:) - TF_mat(i,:);
        TF_coding_for_each_speed{u}(i) = sum(round(abs(d2tf),1) <= 3)==3;
        any_TF_match{u}(i) = sum(round(abs(d2tf),1) <= 3)>0;
    end
    for j=1:3
        % monotonically increasing
        strictly_increasing(j) = check_monotonity(Fmax(:,j));
        if ~strictly_increasing(j)
            omit_20and40(j) = check_monotonity(Fmax(3:5,j));
            omit_160and320(j) = check_monotonity(Fmax(1:3,j));
            omit_20and320(j) = check_monotonity(Fmax(2:4,j));
        else
            omit_20and40(j) = 0;
            omit_160and320(j) = 0;
            omit_20and320(j) = 0;
        end
    end
    if sum(strictly_increasing)>0
        check_period = 1;
        increase_type = 1;
    elseif sum(omit_20and320)>0
        check_period = 1;
        increase_type = 2;
    elseif sum(omit_160and320)>0
        check_period = 1;
        increase_type = 3;
    elseif sum(omit_20and40)>0
        check_period = 1;
        increase_type = 4;
    else
        check_period = 0;
        increase_type = nan;
    end
    
    % Define coding schemes
    if check_period==1
        switch increase_type
            case 1
                SP_coding(u) = sum(similar_Fmax_for_same_speed{u})>1;
                par_SP_coding(u) = sum(similar_Fmax_only2{u})>1;
            case 2
                SP_coding(u) = sum(similar_Fmax_for_same_speed{u}(2:4))>1;
                par_SP_coding(u) = sum(similar_Fmax_only2{u}(2:4))>1;
            case 3
                SP_coding(u) = sum(similar_Fmax_for_same_speed{u}(1:3))>1;
                par_SP_coding(u) = sum(similar_Fmax_only2{u}(1:3))>1;
            case 4
                SP_coding(u) = sum(similar_Fmax_for_same_speed{u}(3:5))>1;
                par_SP_coding(u) = sum(similar_Fmax_only2{u}(3:5))>1;
        end

        TF_coding(u) = sum(TF_coding_for_each_speed{u})>0;
        par_TF_coding(u) = sum(any_TF_match{u})>1; % coding in more than 2 speed conditions
        if TF_coding(u)==1
            SP_coding(u)=0;
            par_TF_coding(u)=0;
            par_SP_coding(u)=0;
        end
        if par_TF_coding(u)==1
            par_SP_coding(u)=0;
            % check if par_tf_coding also has sp_coding feature
            if sum((any_TF_match{u}+similar_Fmax_only2{u})==2)==0
                SP_coding(u)=0;
            else
%                 par_TF_coding(u)=0;
            end
        end
        if SP_coding(u)==1
            par_SP_coding=0;
        end
    else
        SP_coding(u) = false;
        TF_coding(u) = false;
        
        par_TF_coding(u) = sum(any_TF_match{u})>1;  % coding in more than 2 speed conditions
        par_SP_coding(u) =0;
    end
end

% coding_n_3b = [sum(TF_coding) sum(par_TF_coding) sum(SP_coding) sum(par_SP_coding)];
% coding_n_a1 = [sum(TF_coding) sum(par_TF_coding) sum(SP_coding) sum(par_SP_coding)];
coding_n_a2 = [sum(TF_coding) sum(par_TF_coding) sum(SP_coding) sum(par_SP_coding)];
%}


%-- Create figure (Figure 3)
coding_n_3b = [10 17 0.2 0.2]; % Change 0 to 0.2 for visualization
coding_n_a1 = [4 13 0.2 1];    % Change 0 to 0.2 for visualization
coding_n_a2 = [2 19 0.2 0.2];  % Change 0 to 0.2 for visualization

figure
b = bar([coding_n_3b/55; coding_n_a1/58; coding_n_a2/45]*100);
b(1).FaceColor = [0.3 0.9 0.3];
b(2).FaceColor = [0.7 0.9 0.7];
b(3).FaceColor = [0.9 0.3 0.3];
b(4).FaceColor = [0.9 0.7 0.7];
legend('TF coding','TF-like coding','SP coding','SP-like coding','location','eastoutside','box','off')
set(gca,'box','off','tickdir','out','xticklabel',{'area 3b','area 1','area 2'},'fontsize',20,'linewidth',1.5)
ylabel('proportion (%)')
saveas(gcf,'../results/Fig3B.png')

%% Figure 5

%-- Choose the unit
units = BAread(BA_sus_resp_3b,'units'); 
unit_to_plot =  24;   % Can also try: 3b u24, a2 u18
obj1 = units(unit_to_plot);

units = BAread(BA_sus_resp_a2,'units'); 
unit_to_plot =  18;   % Can also try: 3b u24, a2 u18
obj2 = units(unit_to_plot);

obj_to_plot = [obj1 obj1 obj2 obj2];
spe_to_plot = [2 5 1 2];
sp_to_plot = [3 3 2 2];

figure
for o = 1:4
    subplot(2,2,o)
    spe = spe_to_plot(o);
    sp = sp_to_plot(o);
    [~,~,~,~,AveragePower,~,F0,Fmax(spe,sp),pks_freq,~]=SU_add_noise_autocFFT(obj_to_plot(o),spe,sp,'n','y','max',5000,1);
    TF = TF_spe_sp(spe,sp);
    hold on
    ylims = get(gca,'ylim');
    line([TF TF],ylims,'color','k','linestyle',':','linewidth',2)
    line([Fmax(spe,sp) Fmax(spe,sp)],[max(AveragePower)*1.05 max(AveragePower)*1.08],'color','r','linewidth',2)
    for i=1:3
        line([TF/(2^i) TF/(2^i)],ylims,'color',[0.7 0.7 0.7],'linestyle',':','linewidth',1.5)
    end
    for i=2:10
        line([TF*i TF*i],ylims,'color',[0.7 0.7 0.7],'linestyle',':','linewidth',1.5)
    end
    if o==1||o==3
        set(gca,'xlim',[0 130])
    end
    xlims = get(gca,'xlim');
    ylims = get(gca,'ylim');
    text(xlims(2)*0.5,(ylims(2)-ylims(1))*0.7+ylims(1),['F_0 = ',num2str(TF),' Hz'],'fontsize',18)
    set(gca,'tickdir','out','fontsize',18,'linewidth',1.5)
    xlabel('frequency (Hz)')
    ylabel('PSD (dB)')
end
saveas(gcf,'../results/Fig5.png')


%% Figure 6A (based on Figure 2A)
units = BAread(BA_sus_resp_a1,'units');
unit_to_plot =  52;
obj = units(unit_to_plot);
figure('position',[300 300 480 420])
clearvars Fmax
Fmax = zeros(5,3);
for spe=1:5
    for sp=1:3
        subplot(5,3,sp+(spe-1)*3)
        [~,~,~,~,AveragePower,~,F0,Fmax(spe,sp),pks_freq,~,psd_all]=SU_add_noise_autocFFT(obj,spe,sp,'n','y','max',5000,1);
        TF = TF_spe_sp(spe,sp);
        
        
        if TF <= 20
            set(gca,'xlim',[3 105],'xtick',[TF 100],'xticklabel',{[],100}) 
        else
            [ticks,ia,~] = unique([TF 100 200 300]);
            t_label = {[],100,200,300};
            t_label = t_label(ia);
            set(gca,'xtick',ticks,'xticklabel',t_label) 
        end
        if spe==5 && sp==1
            set(gca,'ylim',[300 500])
        end
        ylims = get(gca,'ylim');

        line([TF TF],ylims,'color','k','linestyle',':','linewidth',2)
        line([Fmax(spe,sp) Fmax(spe,sp)],[max(AveragePower)*1.05 max(AveragePower)*1.08],'color','r','linewidth',2)
        for i=1:3
            line([TF/(2^i) TF/(2^i)],ylims,'color',[0.7 0.7 0.7],'linestyle',':','linewidth',1.5)
        end
        for i=2:10
            line([TF*i TF*i],ylims,'color',[0.7 0.7 0.7],'linestyle',':','linewidth',1.5)
        end
        line([TF TF],ylims,'color','k','linestyle',':','linewidth',1.5)
        hold off
        
    end
end
saveas(gcf,'../results/Fig6A.png')