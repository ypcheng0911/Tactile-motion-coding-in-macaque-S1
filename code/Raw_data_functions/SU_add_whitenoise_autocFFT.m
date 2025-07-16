
clear
close all
clc

load('../data/Processed.mat','BA_sus_resp_3b','BA_sus_resp_a1','BA_sus_resp_a2','a1_names','a2_names','b3_names')
coding_opt = 'max'; % more, max

reps = 5000;
wts = 1;
%-- Tested parameters:
%-- reps=[100 200 500 1000 5000 10000];
%-- wts=[0.1 0.25 0.5 0.75 1];

for rrr=1:length(reps)
    for www=1:length(wts)
        rep = reps(rrr); % 500;    100 200 500
        wt = wts(www); % 1;         0.1 0.25 0.5 0.75 1
        %-- 3b
        units = BAread(BA_sus_resp_3b,'units');
        for u = 1:length(units)
            obj = units(u);
            pass = [];
            STF_coding = [];
            AveragePower = {};
            F0 = [];
            Fmax = [];
            pks_freq = {};
            OI = [];
            for i=1:5
                for j=1:3
                    [pass(i,j) STF_coding(i,j),~,~,AveragePower{i,j},~,F0(i,j),Fmax(i,j),pks_freq{i,j},OI(i,j)] = SU_add_noise_autocFFT(obj,i,j,'n','n',coding_opt,rep,wt);
                    pass_3b{u} = pass;
                    Coding_3b{u} = STF_coding;
                    AP_3b{u} = AveragePower;
                    F0_3b{u} = F0;
                    Fmax_3b{u} = Fmax;
                    pks_freq_3b{u} = pks_freq;
                    OI_3b{u} = OI;
                end
            end
        end
        %-- a1
        units = BAread(BA_sus_resp_a1,'units');
        for u = 1:length(units)
            obj = units(u);
            pass = [];
            STF_coding = [];
            AveragePower = {};
            F0 = [];
            Fmax = [];
            pks_freq = {};
            OI = [];
            for i=1:5
                for j=1:3
                    [pass(i,j) STF_coding(i,j),~,~,AveragePower{i,j},~,F0(i,j),Fmax(i,j),pks_freq{i,j},OI(i,j)] = SU_add_noise_autocFFT(obj,i,j,'n','n',coding_opt,rep,wt);
                    pass_a1{u} = pass;
                    Coding_a1{u} = STF_coding;
                    AP_a1{u} = AveragePower;
                    F0_a1{u} = F0;
                    Fmax_a1{u} = Fmax;
                    pks_freq_a1{u} = pks_freq;
                    OI_a1{u} = OI;
                end
            end
        end
        %-- a2
        units = BAread(BA_sus_resp_a2,'units');
        for u = 1:length(units)
            obj = units(u);
            pass = [];
            STF_coding = [];
            AveragePower = {};
            F0 = [];
            Fmax = [];
            pks_freq = {};
            OI = [];
            for i=1:5
                for j=1:3
                    [pass(i,j) STF_coding(i,j),~,~,AveragePower{i,j},~,F0(i,j),Fmax(i,j),pks_freq{i,j},OI(i,j)] = SU_add_noise_autocFFT(obj,i,j,'n','n',coding_opt,rep,wt);
                    pass_a2{u} = pass;
                    Coding_a2{u} = STF_coding;
                    AP_a2{u} = AveragePower;
                    F0_a2{u} = F0;
                    Fmax_a2{u} = Fmax;
                    pks_freq_a2{u} = pks_freq;
                    OI_a2{u} = OI;
                end
            end
        end
        %-- any peak pass threshold
        P_summary_3b = cellfun(@(x) sum(x(:)),pass_3b);
        P_summary_a1 = cellfun(@(x) sum(x(:)),pass_a1);
        P_summary_a2 = cellfun(@(x) sum(x(:)),pass_a2);
        P_num_3b = sum(P_summary_3b>0);
        P_num_a1 = sum(P_summary_a1>0);
        P_num_a2 = sum(P_summary_a2>0);
        [p_pass,~,x2_pass] = chisq_test([round(P_num_3b/55*100) 100-round(P_num_3b/55*100);round(P_num_a1/58*100) 100-round(P_num_a1/58*100);round(P_num_a2/45*100) 100-round(P_num_a2/45*100)]);
        %-- maximum (or any) peak pass threshold & equal to STF
        C_summary_3b = cellfun(@(x) sum(x(:)),Coding_3b);
        C_summary_a1 = cellfun(@(x) sum(x(:)),Coding_a1);
        C_summary_a2 = cellfun(@(x) sum(x(:)),Coding_a2);
        C_num_3b = sum(C_summary_3b>0);
        C_num_a1 = sum(C_summary_a1>0);
        C_num_a2 = sum(C_summary_a2>0);
        [p_coding,~,x2_coding] = chisq_test([round(C_num_3b/55*100) 100-round(C_num_3b/55*100);round(C_num_a1/58*100) 100-round(C_num_a1/58*100);round(C_num_a2/45*100) 100-round(C_num_a2/45*100)]);
        
%         save(['../results/WN_auto_FFT_result_',coding_opt,'_',num2str(rep),'_',num2str(wt),'_',date])
        save('../results/Processed_core_data_reproduced')
        clearvars -except rrr www reps wts BA_sus_resp_3b BA_sus_resp_a1 BA_sus_resp_a2 a1_names a2_names b3_names coding_opt
        
    end
end
