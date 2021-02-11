clear all;

x=-8:4:12;
LineWidth = 1;
lim_y = 1E-8;
result_a = [];
result_b = [];
result_c = [];
result_d = [];
result_e = [];
result_f = [];
result_g = [];
result_h = [];
result_i = [];
result_serial_8 = [];
result_serial_16 = [];

a = load(fullfile(pwd, '\result\ISDIC_8x8_Grouping_1_ordering_2.mat'));
b = load(fullfile(pwd, '\result\ISDIC_8x8_Grouping_2_ordering_2.mat'));
c = load(fullfile(pwd, '\result\ISDIC_8x8_Grouping_4_ordering_2.mat'));
d = load(fullfile(pwd, '\result\ISDIC_8x8_Grouping_8_ordering_2.mat'));
serial_8 = load(fullfile(pwd, '\result\ISDIC_8x8.mat'));
MMSE_8x8 = load(fullfile(pwd, '\result\QPSK_new_meta_MMSE.mat'));

e = load(fullfile(pwd, '\result\ISDIC_16x16_Grouping_1_ordering_2.mat'));
f = load(fullfile(pwd, '\result\ISDIC_16x16_Grouping_2_ordering_2.mat'));
g = load(fullfile(pwd, '\result\ISDIC_16x16_Grouping_4_ordering_2.mat'));
h = load(fullfile(pwd, '\result\ISDIC_16x16_Grouping_8_ordering_2.mat'));
i = load(fullfile(pwd, '\result\ISDIC_16x16_Grouping_16_ordering_2.mat'));
serial_16 = load(fullfile(pwd, '\result\ISDIC_16x16.mat'));

for z = 5:5:30
    result_a = [result_a a.result(1,z)];
    result_b = [result_b b.result(1,z)];
    result_c = [result_c c.result(1,z)];
    result_d = [result_d d.result(1,z)];
    result_serial_8 = [result_serial_8 serial_8.result(1,z)];
end
MMSE_8x8.MMSE_result8x8(:,7)=[];
MMSE_8x8.MMSE_result16x16(:,6:8)=[];
for z = 5:5:25
    result_serial_16 = [result_serial_16 serial_16.result(1,z)];
    result_f = [result_f f.result(1,z)];
    result_e = [result_e e.result(1,z)];
    result_g = [result_g g.result(1,z)];
    result_h = [result_h h.result(1,z)];
end

% result_e = [result_e 0 0];
% result_f = [result_f 0 0 0];
% result_serial_16 = [result_serial_16 0 0 0];
for z = 5:5:25 
    result_i = [result_i i.result(1,z)];
end

figure(1);
semilogy(x,result_a); hold on;
semilogy(x,result_b); hold on;
semilogy(x,result_c); hold on;
semilogy(x,result_d); hold on;
semilogy(x,result_serial_8); hold on;
semilogy(x,MMSE_8x8.MMSE_result8x8); hold on;

ylabel('BER ---->');
xlabel('SNR ---->');
title('ISDIC Serial 8x8');

legend({'Grouping 1','Grouping 2','Grouping 4','Grouping 8','ISDIC serial','MMSE'},'Location','southwest')

x=-8:4:8;
figure(2);
semilogy(x,result_e); hold on;
semilogy(x,result_f); hold on;
semilogy(x,result_g); hold on;
semilogy(x,result_h); hold on;
semilogy(x,result_i); hold on;
semilogy(x,result_serial_16); hold on;
semilogy(x,MMSE_8x8.MMSE_result16x16); hold on;
ylabel('BER ---->');
xlabel('SNR ---->');
title('ISDIC Serial 16x16');

legend({'Grouping 1','Grouping 2','Grouping 4','Grouping 8','Grouping 16','ISDIC serial','MMSE'},'Location','southwest')
