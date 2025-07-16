function obj = BrainArea(name,units)

% BrainArea class constructor
% This class could also be used for saving units with shared
% characteristics (e.g. ON responsive, within 3b, speed sensitive etc.).
obj.name = name;
% for i = 1:size(units,1)
%     obj.unit(i) = units{i};
% end
obj.units = units;
obj = class(obj,'BrainArea'); 
end