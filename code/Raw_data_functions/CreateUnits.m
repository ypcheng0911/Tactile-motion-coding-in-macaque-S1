% create single unit object from plx files
% Create RecordingSite objects as well.
clear
close all
clc

%-- parameters
obj_save_loc = '../results';
% mkdir(obj_save_loc)
sub = 'c2i';
r_site = 'site1_depth2';
abrv_site = [sub,'_',r_site([1,5,7,12])];
pre_bin=500;
post_bin=1500;
dirs=[-135 -90 -45 0 45 90 135 180];
%---------------------------------------------
folder = '../data';
files = dir(fullfile(folder,'*.plx'));
u_list = Unit_loading_list(abrv_site,1);  % tolerate or not
ch_vec = u_list(:,1);
unit_vec = u_list(:,2);

waves = {};
ts_all = {};
raster = {};
Trial_all = struct();
psth = {};
for f=1:size(files,1)
    filename = files(f).name;
    %-- plx_info
    ch_list{f}=ch_vec;
    unit_list{f}=unit_vec;    
    u_name={'a','b','c','d'};
    %-- load parameters
    clearvars Trial
    load(fullfile(folder,[filename(1:end-8),'_TrialInfo.mat']))
    sp_vec=Trial.speed;
    dir_vec=Trial.direction;
    ball_type=unique(Trial.BallType);
    ball_type=ball_type{1}(1:3);
    sp_dir=[sp_vec',dir_vec'];
    Trial.file_id = filename;
    eval(sprintf('Trial_all.file%02d = Trial;',f))
    if ~ismember(size(sp_dir),[200,2],'row')
        error('Matrix size error.')
    end
    [B,index] = sortrows(sp_dir);
    %-- event
    channel=67;
    unit=1;
    [event_n, ~, event_ts, ~] = plx_waves(filename, channel, unit);     
    for u=1:length(ch_vec)
        channel=ch_vec(u);
        unit=unit_vec(u);
        %-- plx_waves
        [~, ~, ts, wave] = plx_waves(filename, channel, unit);
        waves{f,channel,unit} = wave;
        ts_all{f,channel,unit} = ts;
        ets_all{f,channel,unit} = event_ts;
        %-- raster construction
        for i=1:event_n
            raster{f,channel,unit,i}=(ts(find(ts>=event_ts(i)-0.001*pre_bin & ts<event_ts(i)+0.001*post_bin))-event_ts(i))*1000; % (sec)            
        end    
    end 
end
ch_all = unique([vertcat(ch_list{:}),vertcat(unit_list{:})],'rows');

for u=1:size(ch_all,1)
    channel=ch_all(u,1);
    unit=ch_all(u,2);
%-- prepare variables for SingleUnit object, call computation codes
    site = [sub,'_',r_site([1,5,7,12])]; % abbreviation
    [A,D] = Channel_locations(site, channel);
    area = {D,A};
    name = sprintf('ch%d_u%d',channel,unit);
    
    waveform = waves(:,channel,unit);
    spike_data = ts_all(:,channel,unit);    
    raw_data = [];
    event = ets_all(:,channel,unit);
    parameter = Trial_all;
    rasters = reshape(raster(:,channel,unit,:),size(files,1),event_n);        
    psth = [];
    
    pref_d = [];
    responsiveness = [];
    low_rate = [];
    excit_or_inhib = [];

%--  create object
    U_name = [site,'_',name];
    eval(sprintf('%s = SingleUnit(site,area,name,waveform,spike_data,raw_data,event,parameter,rasters,psth,pref_d,responsiveness,low_rate,excit_or_inhib);',U_name))
    %-- calculate dpsth & update to the object
    eval(sprintf('%s = SUpsth_1dspe(%s);',U_name,U_name))  
    %-- replacing analysis step 2 - compute prefer_digit responsiveness low_rate excit_or_inhib
    eval(sprintf('%s = SUresponsiveness(%s);',U_name,U_name))
    %-- save results into .mat files
    eval(sprintf('save(fullfile(obj_save_loc,U_name),''%s'')',U_name))
    %-- prepare for RecordingSite object construction
    U_names{u} = U_name;
end


%% RecordingSite object construction
for u=1:size(ch_all,1)
    eval(sprintf('units{u,1} = %s;',U_names{u}))
end
eval(sprintf('%s = RecordingSite(sub,r_site,units);',abrv_site))
RS_save_loc = '../results';
eval(sprintf('save(RS_save_loc,''%s'')',abrv_site))