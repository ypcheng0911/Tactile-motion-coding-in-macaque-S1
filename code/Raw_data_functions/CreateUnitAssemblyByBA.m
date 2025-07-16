clear
close all
clc

%--- load SU objects
cd('../data')
SU_collector
AllUnits = who;
%% raw, categorized by brain regions
for i = 1:length(AllUnits)
    eval(sprintf('A_temp = SUread(%s,''area'');',AllUnits{i}))
    A(i) = A_temp{2}; % {depth, area}
end
%--- brain area segregation
idx_a1 = find(A==1);
for i = 1:length(idx_a1)
    eval(sprintf('units_a1(i) = %s;',AllUnits{idx_a1(i)}))
end
idx_a2 = find(A==2);
for i = 1:length(idx_a2)
    eval(sprintf('units_a2(i) = %s;',AllUnits{idx_a2(i)}))
end
idx_3b = find(A==3);
for i = 1:length(idx_3b)
    eval(sprintf('units_3b(i) = %s;',AllUnits{idx_3b(i)}))
end
BA_a1 = BrainArea('Brodmann area 1',units_a1);
BA_a2 = BrainArea('Brodmann area 2',units_a2);
BA_3b = BrainArea('Brodmann area 3b',units_3b);
idx_other = find(A==4);
%% categorization (isolating unit index)
for i = 1:length(AllUnits)
    eval(sprintf('pref_d{i} = SUread(%s,''pref_d'');',AllUnits{i}))         % {1st D, 2nd D, pref_idx}
    eval(sprintf('resp{i} = SUread(%s,''responsiveness'');',AllUnits{i}))   % (D, ON SUS OFF VIB)
    eval(sprintf('lr{i} = SUread(%s,''low_rate'');',AllUnits{i}))           % (D)
    eval(sprintf('ei{i} = SUread(%s,''excit_or_inhib'');',AllUnits{i}))     % (D)
end
for i = 1:length(AllUnits)
%--- combinations
    opt_ON_resp(i) = resp{i}(pref_d{i}{3},1); 
    opt_SUS_resp(i) = resp{i}(pref_d{i}{3},2);
    opt_OFF_resp(i) = resp{i}(pref_d{i}{3},3);
    opt_lr(i,:) = lr{i}(pref_d{i}{3},:);
    opt_ei(i) = ei{i}(pref_d{i}{3});
end
opt_resp = (opt_ON_resp + opt_SUS_resp + opt_OFF_resp) > 0;
opt_resp_nlr = opt_resp - opt_resp.* (sum(opt_lr,2)==4)';  % 4 means FR less than 5 Hz at baseline, ON, SUS, OFF resopnse periods
opt_SUS_nlr = opt_SUS_resp - opt_SUS_resp.* (sum(opt_lr,2)==4)';
%--- resp, resp non-low-rate, sus only (not outside of a1, a2 or 3b)
opt_resp_nother=opt_resp; opt_resp_nother(idx_other)=0;
opt_resp_nlr_nother=opt_resp_nlr; opt_resp_nlr_nother(idx_other)=0;
opt_SUS_nlr_nother=opt_SUS_nlr; opt_SUS_nlr_nother(idx_other)=0;
%--- resp, non-low-rate
opt_nlr_a1 = opt_resp_nlr_nother(idx_a1);
opt_nlr_a2 = opt_resp_nlr_nother(idx_a2);
opt_nlr_3b = opt_resp_nlr_nother(idx_3b);
%--- sus only, non-low-rate
opt_SUS_nlr_nother_a1 = opt_SUS_nlr_nother(idx_a1);
opt_SUS_nlr_nother_a2 = opt_SUS_nlr_nother(idx_a2);
opt_SUS_nlr_nother_3b = opt_SUS_nlr_nother(idx_3b);
%--- a1 unit assembly
n_sus = 1;
n_resp = 1;
for i = 1:length(idx_a1)
    if opt_SUS_nlr_nother_a1(i) == 1
        eval(sprintf('units_sus_resp_a1(n_sus) = %s;',AllUnits{idx_a1(i)}))
        n_sus = n_sus+1;
    end
    if opt_nlr_a1(i) == 1
        eval(sprintf('units_resp_a1(n_resp) = %s;',AllUnits{idx_a1(i)}))
        n_resp = n_resp+1;
    end
end
%--- a2 unit assembly
n_sus = 1;
n_resp = 1;
for i = 1:length(idx_a2)
    if opt_SUS_nlr_nother_a2(i) == 1
        eval(sprintf('units_sus_resp_a2(n_sus) = %s;',AllUnits{idx_a2(i)}))
        n_sus = n_sus+1;
    end
    if opt_nlr_a2(i) == 1
        eval(sprintf('units_resp_a2(n_resp) = %s;',AllUnits{idx_a2(i)}))
        n_resp = n_resp+1;
    end
end
%--- 3b unit assembly
n_sus = 1;
n_resp = 1;
for i = 1:length(idx_3b)
    if opt_SUS_nlr_nother_3b(i) == 1
        eval(sprintf('units_sus_resp_3b(n_sus) = %s;',AllUnits{idx_3b(i)}))
        n_sus = n_sus+1;
    end
    if opt_nlr_3b(i) == 1
        eval(sprintf('units_resp_3b(n_resp) = %s;',AllUnits{idx_3b(i)}))
        n_resp = n_resp+1;
    end
end
%--- BA construction (resp)
BA_resp_a1 = BrainArea('ON/SUS/OFF responsive units (exclude low-rate units), Brodmann area 1',units_resp_a1);
BA_resp_a2 = BrainArea('ON/SUS/OFF responsive units (exclude low-rate units), Brodmann area 2',units_resp_a2);
BA_resp_3b = BrainArea('ON/SUS/OFF responsive units (exclude low-rate units), Brodmann area 3b',units_resp_3b);
%--- BA construction (SUS only)
BA_sus_resp_a1 = BrainArea('SUS responsive units (exclude low-rate units), Brodmann area 1',units_sus_resp_a1);
BA_sus_resp_a2 = BrainArea('SUS responsive units (exclude low-rate units), Brodmann area 2',units_sus_resp_a2);
BA_sus_resp_3b = BrainArea('SUS responsive units (exclude low-rate units), Brodmann area 3b',units_sus_resp_3b);
%% Data storage
cd('../results')
%--- raw data, according to brain areas
save('BA_a1.mat','BA_a1')
save('BA_a2.mat','BA_a2')
save('BA_3b.mat','BA_3b')
%--- responsive units (no low-rate ones), according to brain areas
save('BA_resp_a1.mat','BA_resp_a1')
save('BA_resp_a2.mat','BA_resp_a2')
save('BA_resp_3b.mat','BA_resp_3b')
%--- SUS responsive units only (no low-rate ones), according to brain areas
save('BA_sus_resp_a1.mat','BA_sus_resp_a1')
save('BA_sus_resp_a2.mat','BA_sus_resp_a2')
save('BA_sus_resp_3b.mat','BA_sus_resp_3b')