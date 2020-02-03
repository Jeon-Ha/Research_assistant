clc;
clear all;
close all;

message=randi([0,1],1,1000000);
BPSK_BER=[];
BPSK_SER=[];

symbol=message;               %�ɺ�ȭ
for i = 1:1:length(message)
    if(message(1,i)==0)
        symbol(1,i)=symbol(1,i)-1;
    end
end

for x_dB= 0:1:10
    epoch=0;
    error=0;
    error_count_BER=0;
    error_count_SER=0;
    S=1;                            %(sum(symbol.^2))/length(symbol)
    N=S*10^(-0.1*x_dB);
    
    while error_count_BER<=200
        noise =sqrt(N/2)*randn(1,length(symbol));      % ���� ����
        symbol_noise=symbol+noise;
        symbol_demo = zeros(1,length(symbol_noise));
        
        for j=1:1:length(message)                   %���� �ɹ� ����
            if(symbol_noise(1,j)>=0)
                symbol_demo(1,j) = 1;
            else
                symbol_demo(1,j)= -1;
            end
        end
        
        error_symbol = symbol - symbol_demo;
        error_SER = nnz(error_symbol);
        error_count_SER = error_count_SER + error_SER;
        
        symbol_bit=zeros(1,length(symbol_noise));                   %������ �ɹ� ��Ʈ��
        for j=1:1:length(message)
            if(symbol_demo(1,j)==-1)
                symbol_bit(1,j)=0;
            else
                symbol_bit(1,j)=1;
            end
        end
        
        error_bit=message-symbol_bit;
        error_BER=nnz(error_bit);       %error_bit ��Ŀ��� 0�� �ƴ� ������ ������ ����
        error_count_BER=error_count_BER+error_BER;
        epoch = epoch+1;
    end
    
    BPSK_BER = [BPSK_BER error_count_BER/(epoch*length(message))];
    BPSK_SER = [BPSK_SER error_count_SER/(epoch*length(message))];
end

x=0:1:10;         %�׷��� �׸���
subplot(2,1,1);
semilogy(x,BPSK_BER);
subplot(2,1,2);
semilogy(x,BPSK_SER);

        
