load('../data/Processed_core_data.mat')

saveloc = '../results';

% Choose the unit
units = BAread(BA_sus_resp_3b,'units'); % 3b, a1, a2
for unit_to_plot = 1:length(units)
    
    % Generate the figure
    obj = units(unit_to_plot);
    
    SU_Raster_3balls(obj,'pref');
    saveas(gcf,fullfile(saveloc,['3b_u',num2str(unit_to_plot),'.jpg']))
    close
end

units = BAread(BA_sus_resp_a1,'units'); % 3b, a1, a2
for unit_to_plot = 1:length(units)
    
    % Generate the figure
    obj = units(unit_to_plot);
    
    SU_Raster_3balls(obj,'pref');
    saveas(gcf,fullfile(saveloc,['a1_u',num2str(unit_to_plot),'.jpg']))
    close
end

units = BAread(BA_sus_resp_a2,'units'); % 3b, a1, a2
for unit_to_plot = 1:length(units)
    
    % Generate the figure
    obj = units(unit_to_plot);
    
    SU_Raster_3balls(obj,'pref');
    saveas(gcf,fullfile(saveloc,['a2_u',num2str(unit_to_plot),'.jpg']))
    close
end