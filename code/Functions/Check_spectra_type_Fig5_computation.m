load('../data/WN_auto_FFT_result_max_5000_1.mat')

Fs = 1000;
nfft = 1024;
f = Fs*(0:(nfft/2))/nfft;
freqrange = 2:338; % for 0 < freq < 330Hz

clearvars Type_3b Type_a1 Type_a2 Type_by_unit_3b Type_by_unit_a1 Type_by_unit_a2
region = '3b';
for su = 1:55
    for spe=1:5
        for sp=1:3
            eval(sprintf('AP_band = AP_%s{su}{spe,sp}(freqrange);',region))
            threshold = mean(AP_band)+5*std(AP_band);
            [pks,locs] = findpeaks(AP_band,'MinPeakProminence',threshold*0.2);
            
            [max_val,max_loc] = max(AP_band);
            Fmax = f(max_loc);
            nonmax_pks_freq = f(setdiff(locs,max_loc,'stable'));
            nonmax_pks_val = setdiff(pks,max_val,'stable');
            TF = TF_spe_sp(spe,sp);
            TF_harmonics = [TF/8,TF/4,TF/2,2*TF,3*TF,4*TF,5*TF,6*TF,7*TF,8*TF,9*TF,10*TF];
            
            %-- Categorize the spectra into 4 types
            isType_1 = false; isType_2 = false; isType_3 = false; isType_4 = false; isType_5 = false;
            if max_val>threshold && ~isempty(pks)
                % Whether Fmax == TF
                isType_1_2 = abs(Fmax-TF)<3;
                if isType_1_2==1
                    % How many detected peaks
                    if length(pks)==1
                        % if only one peak then type 2
                        isType_2 = true;
                    else
                        % if more than one peak, are they at the harmonic freqs
                        clearvars match_har
                        for i=1:length(nonmax_pks_freq)
                            match_har(i) = sum(abs(nonmax_pks_freq(i)-TF_harmonics)<3)>0;
                        end
                        if sum(match_har)==0
                            % if none then type 2
                            isType_2 = true;
                        else
                            % whether the peak power is decreasing
                            if issorted(flip(nonmax_pks_val))
                                % if yes then type 1
                                isType_1 = true;
                            else
                                % if no then type 5 (Fmax=TF, multiple peaks, not decreasing)
                                isType_5 = true;
                            end
                        end
                    end
                else
                    Fmax_at_har = sum(abs(Fmax-TF_harmonics)<3);
                    % if Fmax at one of the harmonics then type 3
                    isType_3 = Fmax_at_har>0;
                    % if not then type 4
                    isType_4 = ~isType_3;
                end
            else
                isType_4 = true;
            end
            Type_3b{su,spe,sp} = [isType_1,isType_2,isType_3,isType_4,isType_5];
            Type_by_unit_3b(spe,sp,su) = find([isType_1,isType_2,isType_3,isType_4,isType_5]==1);
        end
    end
end
%-- Verification figure
figure; plot(f(freqrange),AP_band); hold on;line([0 330],[mean(AP_band)+5*std(AP_band) mean(AP_band)+5*std(AP_band)],'color','r','linestyle','--');



region = 'a1';
for su = 1:58
    for spe=1:5
        for sp=1:3
            eval(sprintf('AP_band = AP_%s{su}{spe,sp}(freqrange);',region))
            threshold = mean(AP_band)+5*std(AP_band);
            [pks,locs] = findpeaks(AP_band,'MinPeakProminence',threshold*0.2);
            
            [max_val,max_loc] = max(AP_band);
            Fmax = f(max_loc);
            nonmax_pks_freq = f(setdiff(locs,max_loc,'stable'));
            nonmax_pks_val = setdiff(pks,max_val,'stable');
            TF = TF_spe_sp(spe,sp);
            TF_harmonics = [TF/8,TF/4,TF/2,2*TF,3*TF,4*TF,5*TF,6*TF,7*TF,8*TF,9*TF,10*TF];
            
            %-- Categorize the spectra into 4 types
            isType_1 = false; isType_2 = false; isType_3 = false; isType_4 = false; isType_5 = false;
            if max_val>threshold && ~isempty(pks)
                % Whether Fmax == TF
                isType_1_2 = abs(Fmax-TF)<3;
                if isType_1_2==1
                    % How many detected peaks
                    if length(pks)==1
                        % if only one peak then type 2
                        isType_2 = true;
                    else
                        % if more than one peak, are they at the harmonic freqs
                        clearvars match_har
                        for i=1:length(nonmax_pks_freq)
                            match_har(i) = sum(abs(nonmax_pks_freq(i)-TF_harmonics)<3)>0;
                        end
                        if sum(match_har)==0
                            % if none then type 2
                            isType_2 = true;
                        else
                            % whether the peak power is decreasing
                            if issorted(flip(nonmax_pks_val))
                                % if yes then type 1
                                isType_1 = true;
                            else
                                % if no then type 5 (Fmax=TF, multiple peaks, not decreasing)
                                isType_5 = true;
                            end
                        end
                    end
                else
                    Fmax_at_har = sum(abs(Fmax-TF_harmonics)<3);
                    % if Fmax at one of the harmonics then type 3
                    isType_3 = Fmax_at_har>0;
                    % if not then type 4
                    isType_4 = ~isType_3;
                end
            else
                isType_4 = true;
            end
            Type_a1{su,spe,sp} = [isType_1,isType_2,isType_3,isType_4,isType_5];
            Type_by_unit_a1(spe,sp,su) = find([isType_1,isType_2,isType_3,isType_4,isType_5]==1);
        end
    end
end


region = 'a2';
for su = 1:45
    for spe=1:5
        for sp=1:3
            eval(sprintf('AP_band = AP_%s{su}{spe,sp}(freqrange);',region))
            threshold = mean(AP_band)+5*std(AP_band);
            [pks,locs] = findpeaks(AP_band,'MinPeakProminence',threshold*0.2);
            
            [max_val,max_loc] = max(AP_band);
            Fmax = f(max_loc);
            nonmax_pks_freq = f(setdiff(locs,max_loc,'stable'));
            nonmax_pks_val = setdiff(pks,max_val,'stable');
            TF = TF_spe_sp(spe,sp);
            TF_harmonics = [TF/8,TF/4,TF/2,2*TF,3*TF,4*TF,5*TF,6*TF,7*TF,8*TF,9*TF,10*TF];
            
            %-- Categorize the spectra into 4 types
            isType_1 = false; isType_2 = false; isType_3 = false; isType_4 = false; isType_5 = false;
            if max_val>threshold && ~isempty(pks)
                % Whether Fmax == TF
                isType_1_2 = abs(Fmax-TF)<3;
                if isType_1_2==1
                    % How many detected peaks
                    if length(pks)==1
                        % if only one peak then type 2
                        isType_2 = true;
                    else
                        % if more than one peak, are they at the harmonic freqs
                        clearvars match_har
                        for i=1:length(nonmax_pks_freq)
                            match_har(i) = sum(abs(nonmax_pks_freq(i)-TF_harmonics)<3)>0;
                        end
                        if sum(match_har)==0
                            % if none then type 2
                            isType_2 = true;
                        else
                            % whether the peak power is decreasing
                            if issorted(flip(nonmax_pks_val))
                                % if yes then type 1
                                isType_1 = true;
                            else
                                % if no then type 5 (Fmax=TF, multiple peaks, not decreasing)
                                isType_5 = true;
                            end
                        end
                    end
                else
                    Fmax_at_har = sum(abs(Fmax-TF_harmonics)<3);
                    % if Fmax at one of the harmonics then type 3
                    isType_3 = Fmax_at_har>0;
                    % if not then type 4
                    isType_4 = ~isType_3;
                end
            else
                isType_4 = true;
            end
            Type_a2{su,spe,sp} = [isType_1,isType_2,isType_3,isType_4,isType_5];
            Type_by_unit_a2(spe,sp,su) = find([isType_1,isType_2,isType_3,isType_4,isType_5]==1);
        end
    end
end

%% Summary, Only include types 1-3 in the main text

%-- Proportions by combinations (among all units)
figure;h_3b = histogram(Type_by_unit_3b);
figure;h_a1 = histogram(Type_by_unit_a1);
figure;h_a2 = histogram(Type_by_unit_a2);
h_3b.Values/(55*15)*100
h_a1.Values/(58*15)*100
h_a2.Values/(45*15)*100

%-- Proportions by each single unit
for i=1:55
contain_type_1(i) = sum(sum(ismember(Type_by_unit_3b(:,:,i),1)))>0;
contain_type_2(i) = sum(sum(ismember(Type_by_unit_3b(:,:,i),2)))>0;
contain_type_3(i) = sum(sum(ismember(Type_by_unit_3b(:,:,i),3)))>0;
contain_type_5(i) = sum(sum(ismember(Type_by_unit_3b(:,:,i),5)))>0;
end
[sum(contain_type_1)/55*100,...
sum(contain_type_2)/55*100,...
sum(contain_type_3)/55*100,...
sum(contain_type_5)/55*100]

for i=1:58
contain_type_1(i) = sum(sum(ismember(Type_by_unit_a1(:,:,i),1)))>0;
contain_type_2(i) = sum(sum(ismember(Type_by_unit_a1(:,:,i),2)))>0;
contain_type_3(i) = sum(sum(ismember(Type_by_unit_a1(:,:,i),3)))>0;
contain_type_5(i) = sum(sum(ismember(Type_by_unit_a1(:,:,i),5)))>0;
end
[sum(contain_type_1)/58*100,...
sum(contain_type_2)/58*100,...
sum(contain_type_3)/58*100,...
sum(contain_type_5)/58*100]

clearvars contain_type_1 contain_type_2 contain_type_3 contain_type_5
for i=1:45
contain_type_1(i) = sum(sum(ismember(Type_by_unit_a2(:,:,i),1)))>0;
contain_type_2(i) = sum(sum(ismember(Type_by_unit_a2(:,:,i),2)))>0;
contain_type_3(i) = sum(sum(ismember(Type_by_unit_a2(:,:,i),3)))>0;
contain_type_5(i) = sum(sum(ismember(Type_by_unit_a2(:,:,i),5)))>0;
end
[sum(contain_type_1)/45*100,...
sum(contain_type_2)/45*100,...
sum(contain_type_3)/45*100,...
sum(contain_type_5)/45*100]