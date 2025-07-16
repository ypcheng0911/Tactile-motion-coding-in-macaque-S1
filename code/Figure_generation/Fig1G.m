load('../data/Processed_core_data.mat')

% Choose the unit
units = BAread(BA_sus_resp_a1,'units'); % 3b, a1, a2
unit_to_plot = 52;

%% Generate the figure
obj = units(unit_to_plot);
SU_Raster_3balls(obj,'pref');
saveas(gcf,'../results/Fig1G.png')