load('../data/Processed_core_data.mat','Fmax_3b','Fmax_a1','Fmax_a2','F0_3b','F0_a1','F0_a2','pks_freq_3b','pks_freq_a1','pks_freq_a2')

TF_m = [20 10 5; 40 20 10; 80 40 20; 160 80 40; 320 160 80];
SP_m = [20 20 20; 40 40 40; 80 80 80; 160 160 160; 320 320 320];

%%% Fmax
for i = 1:length(Fmax_3b)
    TF_res = Fmax_3b{i} - TF_m;
    SP_res = Fmax_3b{i} - SP_m;
    TF_coding_3b{i} = abs(TF_res) <= 2.5;
    SP_coding_3b{i} = abs(SP_res) <= 2.5;
end
for i = 1:length(Fmax_a1)
    TF_res = Fmax_a1{i} - TF_m;
    SP_res = Fmax_a1{i} - SP_m;
    TF_coding_a1{i} = abs(TF_res) <= 2.5;
    SP_coding_a1{i} = abs(SP_res) <= 2.5;
end
for i = 1:length(Fmax_a2)
    TF_res = Fmax_a2{i} - TF_m;
    SP_res = Fmax_a2{i} - SP_m;
    TF_coding_a2{i} = abs(TF_res) <= 2.5;
    SP_coding_a2{i} = abs(SP_res) <= 2.5;
end

Coding_summary_3b(1,:) = cellfun(@(x) sum(x(:)),SP_coding_3b); % Speed coding
Coding_summary_3b(2,:) = cellfun(@(x) sum(x(:)),TF_coding_3b); % Temporal frequency coding

Coding_summary_a1(1,:) = cellfun(@(x) sum(x(:)),SP_coding_a1); % Speed coding
Coding_summary_a1(2,:) = cellfun(@(x) sum(x(:)),TF_coding_a1); % Temporal frequency coding

Coding_summary_a2(1,:) = cellfun(@(x) sum(x(:)),SP_coding_a2); % Speed coding
Coding_summary_a2(2,:) = cellfun(@(x) sum(x(:)),TF_coding_a2); % Temporal frequency coding


%%% TF coding figure
C_summary_3b = Coding_summary_3b(2,:);
C_summary_a1 = Coding_summary_a1(2,:);
C_summary_a2 = Coding_summary_a2(2,:);
%% Fig 6B
%  Figure 6B counts the peaks in the periodogram, so it's unrelative to F0 nor Fmax.  
%  Only the periodicity of peaks at a fixed interval of (1)TF or (2)Speed matters.

%-- TF coding plot
ba = '3b';
ba_size_opt = 'all';
plot_fig6B_TF
Proportions_in_3b = stack_p;
clearvars stack_p
saveas(gcf,'../results/Fig6B_3b.png')

ba = 'a1';
plot_fig6B_TF
Proportions_in_a1 = stack_p;
clearvars stack_p
saveas(gcf,'../results/Fig6B_a1.png')

ba = 'a2';
plot_fig6B_TF
Proportions_in_a2 = stack_p;
clearvars stack_p
saveas(gcf,'../results/Fig6B_a2.png')
