%clc;
clear all;
close all;
tic

message=randi([0,1],1,1000000);  %OK

QPSK_BER=[];
QPSK_SER=[];

symbol=zeros(1,length(message)/2);      

%====symbolization====    OK
k = 1;
for j = 1:2:(length(message)-1)

    if(message(j) == 0 && message(j+1) == 0)
       symbol(k) = -1-1i;
       k = k+1;
    elseif(message(j) == 0 && message(j+1) == 1)
       symbol(k) = -1+1i;
       k = k+1;
    elseif(message(j) == 1 && message(j+1) == 0)
       symbol(k) = 1-1i;
       k = k+1;
    else
      symbol(k) = 1+1i;
      k = k+1;
    end
    
end


%====demodulation====
RX_count = 2;
QPSK_BER = Demodulation(message, symbol);
RX_count = 3;
QPSK_BER = Demodulation(message, symbol);
RX_count = 4;
QPSK_BER = Demodulation(message, symbol);


% % ���� ����(Research_assistant)�� �̵� -> mat_Rayleigh ���� �̵� -> ����
% cd ..
% cd mat_Rayleigh
% save('QPSK_Rayleigh_SNR.mat', 'QPSK_BER', 'QPSK_SER', '-append');
% 
% % ���� ����(Research_assistant)�� �̵� -> 'Rayleigh fading Channel' ���� �̵�
% cd ..
% cd 'Rayleigh fading Channel'
% 
% disp(mfilename('Class'))

toc

function result = Noise_maker_MRC(N, RX_count, symbol)
noise =sqrt(N/2)*randn(RX_count,length(symbol)) + 1i*(sqrt(N/2)*randn(RX_count,length(symbol)));      %���� ����
h = sqrt(0.5) * [randn(RX_count,length(symbol)) + 1i*randn(RX_count,length(symbol))];       % Rayleigh channel
symbol = transpose(symbol);

h_c = conj(h);      % h �ӷ����Ҽ� ����
symbol_h = symbol.*h;
symbol_noise=symbol_h+noise;


symbol_noise = symbol_noise .* h_c;
symbol_noise = symbol_noise ./ (h .* h_c);
end

function result = Noise_maker_EGC(N, RX_count, symbol)
noise =sqrt(N/2)*randn(RX_count,length(symbol)) + 1i*(sqrt(N/2)*randn(RX_count,length(symbol)));      %���� ����
h = sqrt(0.5) * [randn(RX_count,length(symbol)) + 1i*randn(RX_count,length(symbol))];       % Rayleigh channel
symbol = transpose(symbol);

h_c = conj(h);      % h �ӷ����Ҽ� ����
symbol_h = symbol.*h;
symbol_noise=symbol_h+noise;


symbol_noise = symbol_noise .* h_c;
symbol_noise = symbol_noise ./ (h .* h_c);
end

function result = Noise_maker_SC(N, RX_count, symbol)
noise =sqrt(N/2)*randn(RX_count,length(symbol)) + 1i*(sqrt(N/2)*randn(RX_count,length(symbol)));      %���� ����
h = sqrt(0.5) * [randn(RX_count,length(symbol)) + 1i*randn(RX_count,length(symbol))];       % Rayleigh channel
symbol = transpose(symbol);

h_c = conj(h);      % h �ӷ����Ҽ� ����
symbol_h = symbol.*h;
symbol_noise=symbol_h+noise;


symbol_noise = symbol_noise .* h_c;
symbol_noise = symbol_noise ./ (h .* h_c);
end


function QPSK_BER = Demodulation(message, symbol,RX_count)
QPSK_BER = [];
%QPSK_SER = [];
for x_dB= 0:5:40

   error_BER=0;  
   epoch=0;  
   error_count_BER=0;
   error_count_SER=0;
  
    while (error_count_BER<=1000)
        S=2;                            %(sum(symbol.^2))/length(symbol)
        M=2;                            % symbol�� ��Ʈ ��
        N=S*10^(-0.1*x_dB);
        
        symbol_noise = Noise_maker(N, RX_count, symbol);
        
        
        symbol_demo = zeros(1,length(symbol_noise));
     for j=1:1:length(symbol_noise) 
                        
        if(symbol_noise(j)<0 && imag(symbol_noise(j))<0)
               symbol_demo(j) = -1-1i;
         elseif(symbol_noise(j)<0 &&imag(symbol_noise(j))>0)
               symbol_demo(j) = -1+1i;
         elseif(symbol_noise(j)>0 &&imag(symbol_noise(j))<0)
               symbol_demo(j) = 1-1i;
         else
               symbol_demo(j) = 1+1i;
         end
     end    
    
     error_symbol=symbol-symbol_demo;
     error_SER=nnz(error_symbol);
     error_count_SER = error_count_SER+error_SER;
         
         
    bit_demo=zeros(1,length(message)); %������ �ɹ� ��Ʈ��
    k = 1;
    for j=1:1:(length(symbol_demo))
       if(symbol_demo(j) == -1-1i)
           bit_demo(1,k) = 0;
           k = k + 1;
           bit_demo(1,k) = 0;
           k = k + 1;
       elseif(symbol_demo(j) == -1+1i)
           bit_demo(1,k) = 0;
           k = k + 1;
           bit_demo(1,k) = 1;
           k = k + 1;
       elseif(symbol_demo(j) == 1-1i)
           bit_demo(1,k) = 1;
           k = k + 1;
           bit_demo(1,k) = 0;
           k = k + 1;   
       else
           bit_demo(1,k) = 1;
           k = k + 1;
           bit_demo(1,k) = 1;
           k = k + 1;
       end
    end
         error_bit=message-bit_demo;
         error_BER=nnz(error_bit);       %error_bit ��Ŀ���? 0�� �ƴ� ������ ������ ���� 
         error_count_BER = error_count_BER+error_BER;
         epoch = epoch+1;
        
    end
     QPSK_BER = [QPSK_BER error_count_BER/(epoch*length(message))];
     %QPSK_SER = [QPSK_SER error_count_SER/(epoch*length(message))];
end
end

        