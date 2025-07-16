switch ba
    case '3b'
        C_summary = C_summary_3b;
        pks_freq = pks_freq_3b;
        switch ba_size_opt
            case 'all'
                ba_size = 55;
            case 'coding'
                ba_size = sum(C_summary>0);
        end
    case 'a1'
        ba = '1';
        C_summary = C_summary_a1;
        pks_freq = pks_freq_a1;
        switch ba_size_opt
            case 'all'
                ba_size = 58;
            case 'coding'
                ba_size = sum(C_summary>0);
        end
    case 'a2'
        ba = '2';
        C_summary = C_summary_a2;
        pks_freq = pks_freq_a2;
        switch ba_size_opt
            case 'all'
                ba_size = 45;
            case 'coding'
                ba_size = sum(C_summary>0);
        end
end
% clims = [0 80];

load('../data/MyColormaps.mat')
x = [20 10 5;40 20 10;80 40 20;160 80 40;320 160 80];
collect_NSH = zeros(7,1);
STF_one_eighth = zeros(7,1);
STF_one_fourth = zeros(7,1);
STF_half = zeros(7,1);
STF_one = zeros(7,1);
STF_two = zeros(7,1);
STF_threemore = zeros(7,1);
STF_three = zeros(7,1);
STF_four = zeros(7,1);
STF_five = zeros(7,1);
STF_six = zeros(7,1);
STF_seven = zeros(7,1);
STF_eight = zeros(7,1);
STF_nine = zeros(7,1);
STF_ten = zeros(7,1);


for u = 1:length(C_summary)
    n_pks{u} = cellfun(@(x) length(x),pks_freq{u});
    
    pks_F = pks_freq{u};
    harmonic_n = cell(5,3);
    resi_sig = cell(5,3);
    for i=1:5
        for j=1:3
            STF = TF_spe_sp(i,j);
            [~,~,iib] = intersect(STF,[5 10 20 40 80 160 320]);
            
            %-- use STF/2 to find harmonics
            harmonic_n_temp = round(pks_F{i,j}/(x(i,j)/2));  % nX harmonic
            harmonic_n{i,j} = harmonic_n_temp/2;
            
            residual{i,j} = mod(pks_F{i,j},x(i,j)/2);  % use STF/2 to find harmonics
            resi_sig_r{i,j} = residual{i,j} <= 2.5;
            resi_sig_l{i,j} = x(i,j)/2-residual{i,j} <= 2.5;
            resi_sig{i,j} = (resi_sig_r{i,j} + resi_sig_l{i,j} > 0);
            
            sig_harmonics{i,j} = harmonic_n{i,j}.*resi_sig{i,j};
            %-- include 0.5*STF, n*STF
            sh = sig_harmonics{i,j};
            N_sig_harnomics(i,j) = length(sh(sh==0.5)) + length(mod(sh(sh~=0),1)==0);
            
            STF_sig_harmonics{iib,j} = sh;
        end
    end
    STF_harmonics{u} = sig_harmonics;
    N_sig_harnomics_ba{u} = N_sig_harnomics;
    
    one_eighth_stf = sum(cellfun(@(x) sum(x==0.125),STF_sig_harmonics)>=1,2);
    one_fourth_stf = sum(cellfun(@(x) sum(x==0.25),STF_sig_harmonics)>=1,2);
    half_stf = sum(cellfun(@(x) sum(x==0.5),STF_sig_harmonics)>=1,2);
    one_stf = sum(cellfun(@(x) sum(x==1),STF_sig_harmonics)>=1,2);
    two_stf = sum(cellfun(@(x) sum(x==2),STF_sig_harmonics)>=1,2);
    three_stf = sum(cellfun(@(x) sum(x==3),STF_sig_harmonics)>=1,2);
    four_stf = sum(cellfun(@(x) sum(x==4),STF_sig_harmonics)>=1,2);
    five_stf = sum(cellfun(@(x) sum(x==5),STF_sig_harmonics)>=1,2);
    six_stf = sum(cellfun(@(x) sum(x==6),STF_sig_harmonics)>=1,2);
    seven_stf = sum(cellfun(@(x) sum(x==7),STF_sig_harmonics)>=1,2);
    eight_stf = sum(cellfun(@(x) sum(x==8),STF_sig_harmonics)>=1,2);
    nine_stf = sum(cellfun(@(x) sum(x==9),STF_sig_harmonics)>=1,2);
    ten_stf = sum(cellfun(@(x) sum(x==10),STF_sig_harmonics)>=1,2);
    
    
    STF_one_eighth = STF_one_eighth + one_eighth_stf;
    STF_one_fourth = STF_one_fourth + one_fourth_stf;
    STF_half = STF_half + half_stf;
    STF_one = STF_one + one_stf;
    STF_two = STF_two + two_stf;
    STF_three = STF_three + three_stf;
    STF_four = STF_four + four_stf;
    STF_five = STF_five + five_stf;
    STF_six = STF_six + six_stf;
    STF_seven = STF_seven + seven_stf;
    STF_eight = STF_eight + eight_stf;
    STF_nine = STF_nine + nine_stf;
    STF_ten = STF_ten + ten_stf;
end


stack = [STF_one_eighth(:) STF_one_fourth(:) STF_half(:) ...
    STF_one(:) STF_two(:) STF_three(:) STF_four(:) STF_five(:) ...
    STF_six(:) STF_seven(:) STF_eight(:) STF_nine(:) STF_ten(:)];
stack_p = stack./([1;2;3;3;3;2;1]*ba_size)*100;
if max(max(stack_p)) > 50
    clims = [0  100];
else
    clims = [0  50];
end

ytck = {'5','10','20','40','80','160','320'};
figure
imagesc(stack_p,clims)
set(gca,'tickdir','out','yticklabel',ytck,'xtick',1:13,'xticklabel',{'1/8X','1/4X','1/2X','1X','2X','3X','4X','5X','6X','7X','8X','9X','10X'})
set(gca,'fontsize',18,'linewidth',3)
xlabel('significant components (fold of F0)')
ylabel('F0 (Hz)')
ccc = colorbar;
ccc.Label.String = 'percent (%)';
colormap(mymap)
box off
title(['area ',ba,' (n = ',num2str(ba_size),')'],'fontsize',24)
set(gcf,'name',['Fig 6B - ',ba,' - TF'])

clearvars STF_sig_harmonics