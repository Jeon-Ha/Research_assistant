clc;
clear all;
close all;

message=randi([0,1],1,1000000);  %OK

QAM_16 = [];

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
% ��Ʈ 10�� ������� ��ȣ ���� S�� 1�� ��.
QAM_16_symbol = QAM_16_symbol ./ sqrt(10);


% ====demodulation====  
for x_dB= 0:1:10
   error=0;  
   epoch=0;  
   error_count=0;
  
    while (error_count<=200)
        S=(sum(QAM_16_symbol.^2)/16);
        N=S*10^(-0.1*x_dB);
        noise =sqrt(N/2)*randn(1,length(QAM_16_symbol)) + 1i*(sqrt(N/2)*randn(1,length(QAM_16_symbol)));      % ���� ����
        QAM_16_symbol_noise = QAM_16_symbol + noise;        %noise �߰�
        
        % error count, nnz, epoch plus 1
        error_bit=message-bit_demo;
        error=nnz(error_bit);       %error_bit ��Ŀ��� 0�� �ƴ� ������ ������ ���� 
        error_count = error_count+error;
        epoch = epoch+1;
        
    end
     QAM_16 = [QAM_16 error_count/(epoch*length(message))];
end

x=0:1:10;         %�׷��� �׸���
semilogy(x, QAM_16);


% matlab���� �Լ��� ���� �ؿ� ��� ��(����)

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

% �Ÿ� ���ϱ�
function symbol_demo = distance_measure(symbol)
point = [-3+3i -3+1i -3-1i -3-3i -1+3i -1+1i -1-1i -1-3i 1+3i 1+1i 1-1i 1-3i 3+3i 3+1i 3-1i 3-3i];

symbol_real = real(symbol);
symbol_imag = imag(symbol);

point_to_point = zeros(1, length(point));

for i=1:1:length(point)
    point_to_point(1, i) = sqrt((symbol_real - real(point(1, i)))^2 + (symbol_imag - imag(point(1, i)))^2);
end

distance = min(point_to_point);
[x, y] = find(point_to_point == distance);
symbol_demo = point(1, y);
end