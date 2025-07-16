load('../data/Processed_core_data.mat')

% Choose the unit
units = BAread(BA_sus_resp_a1,'units'); % 3b, a1, a2
unit_to_plot = 52;

%% Generate the figure
obj = units(unit_to_plot);
spe = 3;
sp = 2;

autocorr(obj,spe,sp,'pref','y','y');
subplot(211)
xlim([0 500])
subplot(212)
hold off
SU_add_noise_autocFFT(obj,spe,sp,'n','y','max',5000,1,'n','y');
saveas(gcf,'../results/Fig1IJ.png')