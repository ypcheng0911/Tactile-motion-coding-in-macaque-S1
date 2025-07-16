function TF = TF_spe_sp(spe,sp)
% calculate Temporal Frequency for 1dspe data
spe_set = [20,40,80,160,320];   % mm/s
sp_set = [1,2,4];               % mm
TF = spe_set(spe)/sp_set(sp);   % 1/s
end