
clear all;
close all;

message = [0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 0 1 0 0 0 1 0 1 0 1 1 0 0 1 1 1 1 0 0 0 1 0 0 1 1 0 1 0 1 0 1 1 1 1 0 0 1 1 0 1 1 1 1 0 1 1 1 1];

QAM_16 = [];

QAM_16_symbol = zeros(1,length(message)/4);
temp = zeros(1, 4);
% symbol constellation(심벌 성상도)는 Notion에 올려놓았음 참고 바람(gray code 활용한 constellation임) % ====symbolization====
k = 1;

% for i=1:1:length(message)
%     temp(1, k) = message(1, i);
%     if k == 4
%         k = 1;
%         QAM_16_symbol(1, i/4) = binary_to_complex_number(temp);
%     else
%         k = k + 1;
%     end
% end
% QAM_16_symbol = QAM_16_symbol ./ sqrt(10);
point = [-3+3i -3+1i -3-1i -3-3i -1+3i -1+1i -1-1i -1-3i 1+3i 1+1i 1-1i 1-3i 3+3i 3+1i 3-1i 3-3i];
point = point / sqrt(10);
S = sum(abs(point.^2))/16;                           %(sum(symbol.^2))/16


% % ====demodulation====  
% for x_dB= 0:1:10
%    error=0;  
%    epoch=0;  
%    error_count=0;
%   
%     while (error_count<=200)
%         S=2;                            %(sum(symbol.^2))/16
%         N=S*10^(-0.1*x_dB);
%         noise =sqrt(N/2)*randn(1,length(symbol)) + 1i*(sqrt(N/2)*randn(1,length(symbol)));      % 잡음 생성
% 
%         % error count, nnz, epoch plus 1
%         error_bit=message-bit_demo;
%         error=nnz(error_bit);       %error_bit 행렬에서 0이 아닌 원소의 개수를 센다 
%         error_count = error_count+error;
%         epoch = epoch+1;
%         
%     end
%      QAM_16 = [QAM_16 error_count/(epoch*length(message))];
% end
% 
% x=0:1:10;         %그래프 그리기
% semilogy(x, QAM_16);


% matlab에서 함수는 제일 밑에 써야 함(문법)

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

% 이진수를 십진수로(Binary to Decimal) 바꾸는 함수