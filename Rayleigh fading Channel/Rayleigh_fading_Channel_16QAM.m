%clc;
clear all;
close all;
tic
message=randi([0,1],1,1000000);  %OK

QAM_16_BER = [];
QAM_16_SER = [];

QAM_16_symbol = zeros(1,length(message)/4);
temp = zeros(1, 4);
% symbol constellation(�ɹ� ����)�� Notion�� �÷������� ���� �ٶ�(gray code Ȱ���� constellation��) % ====symbolization====
k = 1;

% ====symbolization====  
for i=1:1:length(message)
    temp(1, k) = message(1, i);
    if k == 4
        k = 1;
        QAM_16_symbol(1, i/4) = binary_to_complex_number(temp);
    else
        k = k + 1;
    end
end
% ��Ʈ 10�� �������? ��ȣ ���� S�� 1�� ��.
QAM_16_symbol = QAM_16_symbol / sqrt(10);


% ====demodulation====  
for x_dB= 0:5:40
   error_BER=0;  
   epoch=0;  
   error_count_BER=0;
   error_count_SER=0;

    while (error_count_BER<=1000)
        %S = (sum(QAM_16_symbol.^2)/16);
        S=1;
        M = 4; % symbol �� bit �� 
        N=S*10^(-0.1*x_dB);
        noise = sqrt(N/2)*randn(1,length(QAM_16_symbol)) + 1i*(sqrt(N/2)*randn(1,length(QAM_16_symbol)));      % ���� ����
        h = sqrt(0.5) * [randn(1,length(QAM_16_symbol)) + 1i*randn(1,length(QAM_16_symbol))];       % Rayleigh channel
        h_c = conj(h);      % h �ӷ����Ҽ� ����
        QAM_16_symbol_h = QAM_16_symbol .* h;
        QAM_16_symbol_noise = QAM_16_symbol_h + noise;        %noise �߰�
        QAM_16_symbol_demo = zeros(1, length(QAM_16_symbol_noise));
        
        QAM_16_symbol_noise = QAM_16_symbol_noise .* h_c;
        QAM_16_symbol_noise = QAM_16_symbol_noise ./ (h .* h_c);
        
        % Deomodulation Symbol
        for i=1:1:length(QAM_16_symbol_noise)
            QAM_16_symbol_demo(1, i) = distance_measure(QAM_16_symbol_noise(1, i));
        end
        
        % SER ����
        error_bit_SER = QAM_16_symbol - QAM_16_symbol_demo;
        error_SER = nnz(error_bit_SER);       
        error_count_SER = error_count_SER + error_SER;
        
        % Demodulation Symbol to bit
        QAM_16_bit_demo = demo_symbol_to_bit(QAM_16_symbol_demo);
        
        % BER ���� : error count, nnz, epoch plus 1
        error_bit_BER = message - QAM_16_bit_demo;
        error_BER = nnz(error_bit_BER);       %error_bit ��Ŀ���? 0�� �ƴ� ������ ������ ���� 
        error_count_BER = error_count_BER + error_BER;
        epoch = epoch + 1;
        
        
    end
     QAM_16_BER = [QAM_16_BER error_count_BER/(epoch*length(message))];
     QAM_16_SER = [QAM_16_SER error_count_SER/(epoch*length(message))];
end

x=0:5:40;         %�׷��� �׸���
axis([-3 12 0 10^-5]);
subplot(2,1,1);
semilogy(x,QAM_16_BER);
subplot(2,1,2);
semilogy(x,QAM_16_SER);

% ���� ����(Research_assistant)�� �̵� -> mat_Rayleigh ���� �̵� -> ����
cd ..
cd mat_Rayleigh
save('QAM_16_Rayleigh_EbN0.mat', 'QAM_16_BER', 'QAM_16_SER', '-append');

% ���� ����(Research_assistant)�� �̵� -> 'Rayleigh fading Channel' ���� �̵�
cd ..
cd 'Rayleigh fading Channel'

disp(mfilename('Class'))

toc

% matlab���� �Լ��� ���� �ؿ� ���? ��(����)

% ���󵵿� ���� symbolization
function comp_number = binary_to_complex_number(binary)
comp = ones(1, 4);
if binary(1) == 0
    comp(1) = binary(1) - 1;
end

if binary(2) == 0
    comp(2) = 3;
end

if binary(3) == 0
    comp(3) = 1;
else
    comp(3) = -1;
end

if binary(4) == 0
    comp(4) = 3;
end

comp_number = (comp(1) * comp(2)) + (comp(3) * comp(4) * 1i);
end

% �Ÿ� ���ϱ�, �ɹ� ������
function symbol_demo = distance_measure(symbol)
point = [-3+3i -3+1i -3-1i -3-3i -1+3i -1+1i -1-1i -1-3i 1+3i 1+1i 1-1i 1-3i 3+3i 3+1i 3-1i 3-3i];
point = point / sqrt(10);

symbol_real = real(symbol);
symbol_imag = imag(symbol);

point_to_point = zeros(1, length(point));

for i=1:1:length(point)
    point_to_point(1, i) = sqrt((symbol_real - real(point(1, i)))^2 + (symbol_imag - imag(point(1, i)))^2); %sqrt((symbol_real - real(point(1, i))).^2 + (symbol_imag - imag(point(1, i))).^2);
end

distance = min(point_to_point);
[x, y] = find(point_to_point == distance);
symbol_demo = point(1, y);
end

% �ɹ��� ��Ʈ�� �ٲٴ� �Լ�
function bit_demo = demo_symbol_to_bit(symbol)
symbol_real = real(symbol);
symbol_imag = imag(symbol);

bit_demo = zeros(1, length(symbol)*4);
k = 1;
for i=1:4:(length(symbol)*4)
    if symbol_real(1, k) < 0
        bit_demo(1, i) = 0;
    else
        bit_demo(1, i) = 1;
    end

    if abs(symbol_real(1, k)) > (2/sqrt(10))
        bit_demo(1, i + 1) = 0;
    else
        bit_demo(1, i + 1) = 1;
    end

    if symbol_imag(1, k) > 0
        bit_demo(1, i + 2) = 0;
    else
        bit_demo(1, i + 2) = 1;
    end

    if abs(symbol_imag(1, k)) > (2/sqrt(10))
        bit_demo(1, i + 3) = 0;
    else
        bit_demo(1, i + 3) = 1;
    end
    k = k + 1;
end

end
