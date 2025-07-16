function [peak, TF, x_range, raw_auto,trial_auto,trail_raw_auto] = autocorr(obj,tar_spe,tar_sp,tar_digit,plot_ny,subp)
% separate trials with different speed

% tar_spe = 4;
% tar_sp = 3;
% tar_digit = 'pref';
spe_select = 'without spon';
bin = 0.001;
%==========================================================================
ts = SUread(obj,'ts');
record_t = 460;
pre = 1000;
post = 1000;
x_range = -pre:post;
pre_bin = pre/1000/bin;
post_bin = post/1000/bin;
switch tar_digit
    case 1
        trial_idx01 = 1:4:12;
        trial_idx02 = 2:4:12;
    case 2
        trial_idx01 = 3:4:12;
        trial_idx02 = 4:4:12;
    case 'pref'
        pref_d = SUread(obj,'pref_d');
        if pref_d{3}==1
            trial_idx01 = 1:4:12;
            trial_idx02 = 2:4:12;
        elseif pref_d{3}==2
            trial_idx01 = 3:4:12;
            trial_idx02 = 4:4:12;
        end
end
switch tar_sp
    case 1
        trial_idx01 = trial_idx01(1);
        trial_idx02 = trial_idx02(1);
    case 2
        trial_idx01 = trial_idx01(2);
        trial_idx02 = trial_idx02(2);
    case 3
        trial_idx01 = trial_idx01(3);
        trial_idx02 = trial_idx02(3);
end
sp = tar_spe; %1:length(spe_set)
para = SUread(obj,'parameter');
event_ts = SUread(obj,'event');
event_ts01 = event_ts{trial_idx01};
event_ts02 = event_ts{trial_idx02};
for i = 1:record_t/bin
    bin_data01(i) = length(find(ts{trial_idx01}>=(i-1)*bin & ts{trial_idx01}<i*bin));
    bin_data02(i) = length(find(ts{trial_idx02}>=(i-1)*bin & ts{trial_idx02}<i*bin));
end
h01 = bin_data01;
h02 = bin_data02;
l_sti = 0.9/bin;
spe_set = [20 40 80 160 320];

if sum(h01)==0 & sum(h02)==0
    peak = nan; TF = nan;
    line([-230 230],[0 0])
    raw_auto = zeros(1,pre_bin+1+post_bin);
    trial_auto = zeros(1,pre_bin+1+post_bin);
    for tr_temp = 1:80
        trail_raw_auto{tr_temp} = zeros(1,pre_bin+1+post_bin);
    end
else
    switch spe_select
        case 'with spon'
            %--
            eval(sprintf('idx_spe01 = find(para.file%02d.speed~=spe_set(sp));',trial_idx01))
            stamps_int01 = event_ts01(idx_spe01);
            h01_weight = ones(size(h01));
            eval(sprintf('idx_spe02 = find(para.file%02d.speed~=spe_set(sp));',trial_idx02))
            stamps_int02 = event_ts02(idx_spe02);
            h02_weight = ones(size(h02));
            for i = 1:length(stamps_int01)
                h01_weight(round(stamps_int01(i)/bin)+1:round(stamps_int01(i)/bin)+l_sti) = 0;
            end
            for i = 1:length(stamps_int02)
                h02_weight(round(stamps_int02(i)/bin)+1:round(stamps_int02(i)/bin)+l_sti) = 0;
            end
        case 'without spon'
            %---
            eval(sprintf('idx_spe01 = find(para.file%02d.speed==spe_set(sp));',trial_idx01))
            stamps_int01 = event_ts01(idx_spe01);
            h01_weight = zeros(size(h01));
            h01_w_trial = zeros(length(stamps_int01),length(h01));
            eval(sprintf('idx_spe02 = find(para.file%02d.speed==spe_set(sp));',trial_idx02))
            stamps_int02 = event_ts02(idx_spe02);
            h02_weight = zeros(size(h02));
            h02_w_trial = zeros(length(stamps_int02),length(h02));
            for i = 1:length(stamps_int01)
                h01_weight(round(stamps_int01(i)/bin)+1:round(stamps_int01(i)/bin)+l_sti) = 1;
                h01_w_trial(i,round(stamps_int01(i)/bin)+1:round(stamps_int01(i)/bin)+l_sti) = 1;
            end
            for i = 1:length(stamps_int02)
                h02_weight(round(stamps_int02(i)/bin)+1:round(stamps_int02(i)/bin)+l_sti) = 1;
                h02_w_trial(i,round(stamps_int02(i)/bin)+1:round(stamps_int02(i)/bin)+l_sti) = 1;
            end
    end
    new_h01 = h01.* h01_weight;
    new_h02 = h02.* h02_weight;
    trial_h01 = h01.* h01_w_trial;
    trial_h02 = h02.* h02_w_trial;
    % H01 = h01;
    H01 = new_h01;
    H02 = new_h02;
    %== separate trials with different speed
    for iii = 1:size(trial_h01,1)
        tar_H01 = trial_h01(iii,:);
        spk_idx01 = find(tar_H01~=0);
        n01 = length(spk_idx01);
        auto01=[];
        lowerlim = find(spk_idx01 < pre_bin);
        if lowerlim
            for i=lowerlim(end)+1:n01
                auto01(i,:) = tar_H01(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin);
            end
            for i=1:lowerlim
                auto01(i,:) = [zeros(1,length(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin-1)-length(1:spk_idx01(i)+post_bin-1) ) tar_H01(1:spk_idx01(i)+post_bin)];
            end
        else
            for i=1:n01
                auto01(i,:) = tar_H01(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin);
            end
        end
        %%%%
        trail_raw_auto01{iii} = auto01;
    end
    %------
    %H01
    spk_idx01 = find(H01~=0);
    n01 = length(spk_idx01);
    auto01=[];
    lowerlim = find(spk_idx01 < pre_bin);
    if lowerlim
        for i=lowerlim(end)+1:n01
            auto01(i,:) = H01(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin);
        end
        for i=1:lowerlim
            auto01(i,:) = [zeros(1,length(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin-1)-length(1:spk_idx01(i)+post_bin-1) ) H01(1:spk_idx01(i)+post_bin)];
        end
    else
        for i=1:n01
            auto01(i,:) = H01(spk_idx01(i)-pre_bin:spk_idx01(i)+post_bin);
        end
    end
    %%%%
    raw_auto01 = auto01;
    auto01(:,pre_bin:pre_bin+2) = zeros(n01,3);
    auto_plot01 = auto01(:,[1:pre_bin pre_bin+2:end]); % +1 or +2?
    %{
% figure
% try
%     plot([-pre_bin:post_bin-1]+bin*1000/2,sum(auto_plot,1))
% catch
%     plot([-pre_bin+1:post_bin-1]+bin*1000/2,sum(auto_plot,1))
% end
% xt = get(gca,'xtick');
% set(gca,'xticklabel',xt*bin*1000,'tickdir','out')
% box off
    %}
    for iii = 1:size(trial_h02,1)
        tar_H02 = trial_h02(iii,:);
        spk_idx02 = find(tar_H02~=0);
        n02 = length(spk_idx02);
        auto02=[];
        lowerlim = find(spk_idx02 < pre_bin);
        if lowerlim
            for i=lowerlim(end)+1:n02
                auto02(i,:) = tar_H02(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin);
            end
            for i=1:lowerlim
                auto02(i,:) = [zeros(1,length(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin-1)-length(1:spk_idx02(i)+post_bin-1) ) tar_H02(1:spk_idx02(i)+post_bin)];
            end
        else
            for i=1:n02
                auto02(i,:) = tar_H02(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin);
            end
        end
        %%%%
        trail_raw_auto02{iii} = auto02;
    end
    %-------------------------
    %H02
    spk_idx02 = find(H02~=0);
    n02 = length(spk_idx02);
    auto02=[];
    lowerlim = find(spk_idx02 < pre_bin);
    if lowerlim
        for i=lowerlim(end)+1:n02
            auto02(i,:) = H02(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin);
        end
        for i=1:lowerlim
            auto02(i,:) = [zeros(1,length(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin-1)-length(1:spk_idx02(i)+post_bin-1) ) H02(1:spk_idx02(i)+post_bin)];
        end
    else
        for i=1:n02
            auto02(i,:) = H02(spk_idx02(i)-pre_bin:spk_idx02(i)+post_bin);
        end
    end
    %%%%
    raw_auto02 = auto02;
    auto02(:,pre_bin:pre_bin+2) = zeros(n02,3);
    auto_plot02 = auto02(:,[1:pre_bin pre_bin+2:end]); % +1 or +2?
    %-----------
    % figure
    % try
    %     plot([-pre_bin:post_bin-1]+bin*1000/2,sum([auto_plot01; auto_plot02],1))
    % catch
    %     plot([-pre_bin+1:post_bin-1]+bin*1000/2,sum([auto_plot01; auto_plot02],1))
    % end
    % xt = get(gca,'xtick');
    % set(gca,'xticklabel',xt*bin*1000,'tickdir','out')
    % box off
    % xlim([-210 210])
    %%
    raw_auto = sum([raw_auto01;raw_auto02],1);
    trail_raw_auto = [trail_raw_auto01 trail_raw_auto02];
    trial_auto = [raw_auto01;raw_auto02];
    %     disp(raw_auto)
    %     if isempty(raw_auto)
    %         error('ttt')
    %     end
    
    auto_mean = mean(sum([auto01;auto02],1));
    auto_plot2 = sum([auto_plot01;auto_plot02],1)-auto_mean*0.85;
    % auto_plot2 = sum(auto_plot)-auto_mean;
    %---
    auto_plot2(auto_plot2<0) = 0;
    
    if strcmp(plot_ny,'y')
        if strcmp(subp,'y')
            figure
            subplot(211)
            try
                plot([-pre_bin:post_bin-1]+bin*1000/2,sum([auto_plot01; auto_plot02],1))
                %             x_range = [-pre_bin:post_bin-1];
            catch
                plot([-pre_bin+1:post_bin-1]+bin*1000/2,sum([auto_plot01; auto_plot02],1))
                %             x_range = [-pre_bin+1:post_bin-1];
            end
            set(gca,'tickdir','out')
            box off
            ylabel('spike count/bin')
            xlabel('lag (ms)')
            xlim([-230 230])
            title('autocorrelogram')
            
            subplot(212)
        end
        
        try
            plot([-pre_bin:post_bin-1]+bin*1000/2,auto_plot2)
            xtks = [-pre_bin:post_bin-1]+bin*1000/2;
        catch
            plot([-pre_bin+1:post_bin-1]+bin*1000/2,auto_plot2)
            xtks = [-pre_bin+1:post_bin-1]+bin*1000/2;
        end
        %-- 1SD
        msd = mean(auto_plot2) + std(auto_plot2);
        [pk,lc] = findpeaks(auto_plot2, 'MinPeakProminence',msd); % Threshold
        hold on
        plot(xtks(lc),pk,'or')
        shoulder = find(abs(lc-length(auto_plot2)/2)<=3);
        plot(xtks(lc(shoulder)),pk(shoulder),'ok')
        % findpeaks(smooth(auto_plot2,5))
        set(gca,'tickdir','out')
        box off
        ylabel('spike count/bin')
        xlabel('lag (ms)')
        xlim([-230 230])
    end
    msd = mean(auto_plot2) + std(auto_plot2);
    [pk,lc] = findpeaks(auto_plot2(end/2+1:end), 'MinPeakProminence',msd);
    
    %{
% max
[~,mlc] = max(pk);
maxpeak = lc(mlc);
TF = 1000/maxpeak;
title(['1st peak: ', num2str(maxpeak),'ms; aprox. freq.: ',num2str(TF),'Hz'])
    %}
    % 1st
    positive_peaks = lc(lc > 3);
    if isempty(positive_peaks)
        if strcmp(plot_ny,'y')
            title('no detected peaks')
        end
        TF = nan;
        peak = nan;
    else
        fpeak = positive_peaks(1);
        flc = min(find(lc > 3));
        [~,mlc] = max(pk.*(lc > 3));
        mpeak = lc(mlc);
        
        if flc == mlc
            if isempty(fpeak)
                if strcmp(plot_ny,'y')
                    title('no detected peaks')
                end
                TF = nan;
                peak = nan;
            else
                TF = 1000/fpeak;
                if strcmp(plot_ny,'y')
                    title(['1st peak: ', num2str(fpeak),'ms; aprox. freq.: ',num2str(TF),'Hz'])
                end
                peak = fpeak;
            end
        else
            %             if pk(mlc) > pk(flc) + msd
            %                 TF = 1000/mpeak;
            %                 title(['1st peak: ', num2str(mpeak),'ms; aprox. freq.: ',num2str(TF),'Hz'])
            %                 plot(xtks(lc(flc)+length(auto_plot2)/2),pk(flc),'ok')
            %                 plot(xtks(-lc(flc)+length(auto_plot2)/2+1),pk(flc),'ok')
            %                 peak = mpeak;
            %             else
            if isempty(fpeak)
                if strcmp(plot_ny,'y')
                    title('no detected peaks')
                end
                TF = nan;
                peak = nan;
            else
                TF = 1000/fpeak;
                if strcmp(plot_ny,'y')
                    title(['1st peak: ', num2str(fpeak),'ms; aprox. freq.: ',num2str(TF),'Hz'])
                end
                peak = fpeak;
            end
            %             end
        end
    end
end
%{
%-- Supplementary Figure: verification of sampling
%-- Sample: area 2 unit 39

Hspe1 = new_h01;
xlMax = 423000;
xlMax = 20000;
figure('position',[680 150 560 840])
subplot(611)
plot(h01)
box off
ylim([0 1.5])
xlim([0 xlMax])
xl = get(gca,'xtick');
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')
subplot(612)
plot(Hspe1)
box off
ylim([0 1.5])
xlim([0 xlMax])
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')
subplot(613)
plot(Hspe2)
box off
ylim([0 1.5])
xlim([0 xlMax])
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')
subplot(614)
plot(Hspe3)
box off
ylim([0 1.5])
xlim([0 xlMax])
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')
subplot(615)
plot(Hspe4)
box off
ylim([0 1.5])
xlim([0 xlMax])
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')
subplot(616)
plot(Hspe5)
box off
ylim([0 1.5])
xlim([0 xlMax])
set(gca,'tickdir','out','ytick',[],'xticklabel',xl/1000)
xlabel('time (sec)')

subplot(611)
title('raw rate histogram')
subplot(612)
title('speed = 20 m/s')
subplot(613)
title('speed = 40 m/s')
subplot(614)
title('speed = 80 m/s')
subplot(615)
title('speed = 160 m/s')
subplot(616)
title('speed = 320 m/s')
%}
end
