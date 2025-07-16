function SU_Raster_3balls(obj,tar_digit)
if nargin < 2
    tar_digit = SUread(obj,'pref_d');
    tar_digit = tar_digit{3};
end
switch tar_digit
    case 1
        trial_idx01_set = 1:4:12;
        trial_idx02_set = 2:4:12;
    case 2
        trial_idx01_set = 3:4:12;
        trial_idx02_set = 4:4:12;
    case 'pref'
        pref_d = SUread(obj,'pref_d');
        if pref_d{3}==1
            trial_idx01_set = 1:4:12;
            trial_idx02_set = 2:4:12;
        elseif pref_d{3}==2
            trial_idx01_set = 3:4:12;
            trial_idx02_set = 4:4:12;
        end
end
speed_color=[1 2 3; 1 65 34; 1 120 65; 0 180 96; 0 240 127]; % Green gradient 4
% sp_text = [1 2 4];

figure('position',[200 200 1200 250])
for tar_sp=1:3
    subplot(1,3,tar_sp)
    switch tar_sp
        case 1
            trial_idx01 = trial_idx01_set(1);
            trial_idx02 = trial_idx02_set(1);
        case 2
            trial_idx01 = trial_idx01_set(2);
            trial_idx02 = trial_idx02_set(2);
        case 3
            trial_idx01 = trial_idx01_set(3);
            trial_idx02 = trial_idx02_set(3);
    end
    %--- load SU info
    para = SUread(obj,'parameter');
    eval(sprintf('filename01 = para.file%02d.file_id;',trial_idx01));
    eval(sprintf('filename02 = para.file%02d.file_id;',trial_idx02));
%     sp_mm = sp_text(tar_sp);
    sp_mm = filename01(strfind(filename01,'sg')+2);
    %--- event
    event_ts = SUread(obj,'event');
    event_ts01 = event_ts{trial_idx01};
    event_ts02 = event_ts{trial_idx02};
    %--- signal
    ts = SUread(obj,'ts');
    tar_ts01 = ts{trial_idx01};
    tar_ts02 = ts{trial_idx02};
    record_t = 460;
    bin = 0.001;
    h01 = hist(tar_ts01,[0:bin:record_t-bin]);
    h02 = hist(tar_ts02,[0:bin:record_t-bin]);
    
    %--- PSD parameters
    spe_set = [20 40 80 160 320];
    dir_set = -135:45:180;
    
    %--on+sus
    pre_bin = -0.3/bin;
    post_bin = 1.3/bin;
    
    % event_n = 200;
    %--- plot figure: 2 by 4 chart of PSD under 8 scanning directions
    
    
    
    for spe = 1:5  %tar_spe %1:length(spe_set)
        tar_spe=spe;
        eval(sprintf('idx_spe01 = find(para.file%02d.speed==spe_set(spe));',trial_idx01))
        eval(sprintf('idx_spe02 = find(para.file%02d.speed==spe_set(spe));',trial_idx02))
        for drct = 1:8
            eval(sprintf('idx_dir01 = find(para.file%02d.direction==dir_set(drct));',trial_idx01))
            stamps_int01 = event_ts01(intersect(idx_dir01,idx_spe01));
            eval(sprintf('idx_dir02 = find(para.file%02d.direction==dir_set(drct));',trial_idx02))
            stamps_int02 = event_ts02(intersect(idx_dir02,idx_spe02));
            %--- Multitaper
            %         spe_Y_loop = zeros(length(stamps_int01)+length(stamps_int02),n);
            raster_loop = zeros(1,abs(pre_bin)+post_bin);
            for i = 1:length(stamps_int01)
                raster_temp = h01(round(stamps_int01(i)/bin)+pre_bin+1:round(stamps_int01(i)/bin)+post_bin);
                raster_loop(i,:) = raster_temp;
            end
            for i = 1:length(stamps_int02)
                raster_temp = h02(round(stamps_int02(i)/bin)+pre_bin+1:round(stamps_int02(i)/bin)+post_bin);
                raster_loop(i+length(stamps_int01),:) = raster_temp;
            end
            %--- average & storage
            Raster{drct} = raster_loop;
        end
        
        for drct = 1:8
            hold on
            R = Raster{drct};
            for j = 1:size(R,1)
                rate = find(R(j,:)>0);
                for k = rate
                    line([k k]-300/(bin*1000), [0+(-1.2)*j -1+(-1.2)*j]-(drct-1)*10-(spe-1)*80,'color',speed_color(spe,:)/256)
                end
            end
            
        end
    end
    ylim([-401 0])
    xlim([-300 1300]/(bin*1000))
    %         ylim([0 10])
%     ylabel('trial')
    ylabel([])
    xlabel('time (ms)')
    set(gca,'tickdir','out','box','off','ytick',-401:80:0,'yticklabel',[],'xtick',[0 1000],'fontsize',16)
    title([sp_mm,' mm ball'])
end
end