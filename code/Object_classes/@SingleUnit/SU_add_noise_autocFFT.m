% Demonstration of the effect of amplitude noise, frequency noise, and
% phase noise on the ensemble averaging of a sine waveform signal. Shows
% that (a) ensemble averaging reduces the white noise in the signal but not
% the frequency or phase noise; (b) ensemble averaging the Fourier
% transform has the same effect as ensemble averaging the signal itself;
% and (c) the effect of phase noise is reduced if the power spectra are
% ensemble averaged.

% load .mat file saved from autocorrelogram_calculation_new20210610.m

%=== testing
% function [threshold,pass_cri,coding,Averagey,Averagefft,AveragePower,signalmatrix,F0,Fmax,pks_freq,OI] = SU_add_noise_autocFFT(obj,spe,sp,plot_ny,psd_p,coding_opt,rep,wt)
function [pass_cri,coding,Averagey,Averagefft,AveragePower,signalmatrix,F0,Fmax,pks_freq,OI,...
    power_each_trial] = SU_add_noise_autocFFT(obj,spe,sp,plot_ny,psd_p,coding_opt,rep,wt,psd_p_ind,leg_opt)
% coding_opt = 'max';
% psd_p = 'y';
% plot_ny = 'n';
if nargin < 9
    psd_p_ind = 'n';
    leg_opt = 'n';
end

UnitName = [SUread(obj,'site'),'_',SUread(obj,'name')];
ba = SUread(obj,'area');
switch ba{2}
    case 1
        load('../data/Processed.mat','a1_names','auto_mean_a1')
        
        u_idx = find(cellfun(@(x) strcmp(UnitName,x),a1_names)==1);
        auto_mean = auto_mean_a1{u_idx};
    case 2
        load('../data/Processed.mat','a2_names','auto_mean_a2')
        
        u_idx = find(cellfun(@(x) strcmp(UnitName,x),a2_names)==1);
        auto_mean = auto_mean_a2{u_idx};
    case 3
        load('../data/Processed.mat','b3_names','auto_mean_3b')
        
        u_idx = find(cellfun(@(x) strcmp(UnitName,x),b3_names)==1);
        auto_mean = auto_mean_3b{u_idx};
end
auto_input_t = auto_mean{spe,sp}(1002:end); % right half of the autocorrelogram
auto_input = auto_input_t - smooth(auto_input_t,300)'; % detrend, sm300
sy = auto_input;
%--------------------------------------------------------------------------
Amplitude=1;
%---  10, 25, 50, 75% 100%(now); white noise weighing
wt;
WhiteNoise=max(sy).*wt; % Point-to-point changes in the amplitude of each signal
% FreqNoise=0; % Signal-to-signal changes in the frequency of the sine wave
% PhaseNoise=0; % Signal-to-signal changes in the phase of the sine wave
NumSignals= rep; % Number of signal averaged
%^^ 100, 200, 500 ......
%--------------------------------------------------------------------------
sumy=0;
sumfft=0;
sumpower=0;
ifftsumpower=0;
% clear signalmatrix
signalmatrix = zeros(NumSignals,length(sy));
x = 1:length(sy);
%-- FFT
L = length(sy);
Fs = 1000;
nfft = 1024;
f = Fs*(0:(nfft/2))/nfft;
for n=1:NumSignals
    y=Amplitude.*sy;
    noisyy=y+WhiteNoise.*randn(size(sy));
    sumy=sumy+noisyy;
%-- FFT algorithm
    ffty = []; P2 =[]; P1 =[]; 
    ffty = fft(noisyy,nfft);
%     ffty = fft(noisyy);
    P2 = (1/(Fs*nfft))*abs(ffty).^2;  % PSD
    P1 = P2(1:nfft/2+1);
    P1(2:end-1) = 2*P1(2:end-1);    
%     sumfft=sumfft+fft(noisyy);
    sumfft=sumfft+ffty;
    ifftsumpower=ifftsumpower+real(sqrt(fft(noisyy) .* conj(fft(noisyy))));
    sumpower=sumpower+P1;
    signalmatrix(n,:)=noisyy;
    power_each_trial{n} = P1;
end
Averagey=sumy./NumSignals;
Averagefft=sumfft./NumSignals;
AveragePower=sumpower./NumSignals;
ifftAveragePower=ifftsumpower./NumSignals;
% OI
tar_freq = TF_spe_sp(spe,sp);
idx = find( f>=tar_freq-2.5 & f<tar_freq+2.5);  % 2.5; 3
OI = sum(AveragePower(idx))/sum(AveragePower(f>3 & f<=330))*100;
%--------------------------------------------------------------------------
if strcmp(plot_ny,'y')
    figure
    subplot(4,1,1)
    plot(x,Averagey,x,sy,'-.')
    title('Ensemble averaged signals (Dotted line is original noiseless signal)')
    subplot(4,1,2)
    plot(1:1024,ifft(Averagefft),x,sy,'-.')
    xlim([0 1000])
%     plot(x,ifft(Averagefft,length(x)),x,sy,'-.')
    title('Inverse Fourier transform of ensemble averaged Fourier transforms')
    subplot(4,1,3)
%     plot(x,AveragePower)
    plot(x,ifft(ifftAveragePower),x,sy,'-.')
%     plot(x,ifft(AveragePower,length(x)),x,sy,'-.')
    axis([min(x) max(x) min(sy) max(sy)])
    title('Inverse Fourier transform of ensemble averaged power spectra')
%     PowerSum=sum(ifft(AveragePower));
%     PowerMean=mean(ifft(AveragePower));    
    %--- 
    subplot(4,1,4)
    TA = AveragePower;
    plot(f,TA)
%     TA = AveragePower(1:length(AveragePower)/2+1);
%     plot(TA)
    hold on
    line([0 length(TA)],[mean(TA)+5*std(TA) mean(TA)+5*std(TA)],'color','r','linestyle','--')
    title('FFT power spectrum')
    xlim([0 500])
end
if strcmp(psd_p,'y')
%     TA = AveragePower;
%     plot(f,TA)
% %     TA = AveragePower(1:length(AveragePower)/2+1);
% %     plot(TA)
%     hold on
%     line([0 length(TA)],[mean(TA)+5*std(TA) mean(TA)+5*std(TA)],'color','r','linestyle','--')
    
%     findpeaks(AveragePower,'minpeakprominence',5*std(AveragePower(f>3)))
    if strcmp(psd_p_ind,'y')
        figure
    end
    AP_band = AveragePower(min(find(f>0)):max(find(f<=330)));
    f_band = f(min(find(f>0)):max(find(f<=330)));
    plot(f_band,AP_band,'linewidth',1.5)
%     plot(f_band,10*log10(AP_band))  % dB
    hold on
    line([0 330],[mean(AP_band)+5*std(AP_band) mean(AP_band)+5*std(AP_band)],'color','r','linestyle','--')
    
%     line([0 330],[mean(AP_band)+5*std(AP_band) mean(AP_band)+5*std(AP_band)],'color','r','linestyle','--','linewidth',1.5)
    
    
    
%     line([0 330],10*log10([mean(AP_band)+5*std(AP_band) mean(AP_band)+5*std(AP_band)]),'color','r','linestyle','--')   % dB
%     findpeaks(AP_band,f(min(find(f>3)):max(find(f<=330))),'minpeakprominence',5*std(AP_band))
    
    xlim([0 330])
    
    if strcmp(leg_opt,'y')
%         findpeaks(AP_band,f_band,'minpeakprominence',5*std(AP_band(f_band>3)));

        [pks,locs] = findpeaks(AP_band,'minpeakprominence',5*std(AP_band(f_band>3)));
        pks_freq = f_band(locs);
        F0 = min(pks_freq(pks_freq>3));  % now called F_first 
        Fmax = pks_freq(find(pks==max(pks)));
        TF = TF_spe_sp(spe,sp);
        
        x_max = max(get(gca,'xlim'));
        y_max = max(get(gca,'ylim'));
        text(x_max*0.8,y_max*0.9,{['F_0: ',num2str(TF),'Hz'],['F_f_i_r_s_t: ',num2str(round(F0,2)),'Hz'],['F_m_a_x: ',num2str(round(Fmax,2)),'Hz']})
        ylabel('power spectrum density (1/Hz)')
        xlabel('frequency (Hz)')
        grid off
        box off
        title('FFT power spectrum')
    end
    set(gca,'tickdir','out','box','off')
end
AP_band = AveragePower(min(find(f>3)):max(find(f<=330)));
f_band = f(min(find(f>3)):max(find(f<=330)));
pass_cri = sum(AP_band > mean(AP_band) + 5*std(AP_band))>0;
threshold = mean(AP_band)+5*std(AP_band);
if pass_cri
%     [pks,locs] = findpeaks(AveragePower,'minpeakprominence',5*std(AveragePower(f>3)));
%     [pks,locs] = findpeaks(AP_band,'minpeakprominence',5*std(AP_band));
    
    locs = find(AP_band >= mean(AP_band)+5*std(AP_band));
    pks = AP_band(locs);
    pks_freq = f_band(locs);
    F0 = min(pks_freq);    
    TF = TF_spe_sp(spe,sp);
    
    
    if isempty(F0)
        F0 = nan;
        Fmax = nan;
        coding = 0;
    else
        Fmax = pks_freq(find(pks==max(pks)));
        switch coding_opt
            case 'only'
                coding = abs(F0-TF)<=2.5;
            case 'more'
                coding = sum(abs(pks_freq-TF)<=2.5)>0;
            case 'max'
                coding = abs(Fmax-TF)<=2.5;
        end
    end
else
    coding = 0;
    F0 = nan;
    Fmax = nan;
    pks_freq = [];
end
end