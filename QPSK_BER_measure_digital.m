clc;
clear all;
close all;

message=randi([0,1],1,1000000);

BER=[];
symbol=message;               %�ɺ�ȭ

for j = 1:2:(length(message)-2)
    if(message(j) == 0 && message(j+1) == 0)
        symbol(j) =-1;
        symbol(j+1) = -1i;
    elseif(message(j) == 0 && message(j+1) == 1)
        symbol(j) = -1;
        symbol(j+1) = 1i;
    elseif(message(j) == 1 && message(j+1) == 0)
        symbol(j) = 1;
        symbol(j+1) = -1i;
    elseif(message(j) == 1 && message(j+1) == 1)
        symbol(j) = 1;
        symbol(j+1) = 1i;
    end
end


for x_dB= 0:1:10
    epoch=0;
    error=0;
    error_count=0;
    S=1;                            %(sum(symbol.^2))/length(symbol)
    N=S*10^(-0.1*x_dB);
    
    while error_count<=200
        noise =sqrt(N/2)*randn(1,length(symbol)) + 1i*sqrt(N/2)*randn(1,length(symbol));      % ���� ����
        symbol_noise=symbol+noise;
        symbol_demo = zeros(1,length(symbol_noise));
        
        for j=1:2:length(message)                   %���� �ɹ� ����
           if(symbol_noise(j)<0 && symbol_noise(j+1)<0)
               symbol_demo(j) = -1;
               symbol_demo(j+1) = -1i;
           elseif(symbol_noise(j)<0 && symbol_noise(j+1)>0)
               symbol_demo(j) = -1;
               symbol_demo(j+1) = 1i;
           elseif(symbol_noise(j)>0 && symbol_noise(j+1)<0)
               symbol_demo(j) = 1;
              symbol_demo(j+1) = -1i;
           elseif(symbol_noise(j)>0 && symbol_noise(j+1)>0)
               symbol_demo(j) = 1;
               symbol_demo(j+1) = 1i;
           end
           
        end
        
        symbol_bit=zeros(1,length(symbol_noise));                   %������ �ɹ� ��Ʈ��
        for j=1:2:(length(message)-2)
           if(symbol_demo(j) == -1 &&symbol_demo(j+1)==-1i)
               symbol_bit(j) = 0;
               symbol_bit(j+1) = 0;
           elseif(symbol_demo(j) == -1 &&symbol_demo(j+1)==1i)
               symbol_bit(j) = 0;
               symbol_bit(j+1) = 1;
           elseif(symbol_demo(j) == 1 &&symbol_demo(j+1)==-1i)
               symbol_bit(j) = 1;
               symbol_bit(j+1) = 0;
           elseif(symbol_demo(j) == 1 &&symbol_demo(j+1)==1i)
               symbol_bit(j) = 1;
               symbol_bit(j+1) = 1;
           end
        end
        
        error_bit=message-symbol_bit;
        error=nnz(error_bit)       %error_bit ��Ŀ��� 0�� �ƴ� ������ ������ ����
        error_count=error_count+error;
        
    end
    epoch = epoch+1;
    BER= [BER error_count/(epoch*length(message))]
end

x=0:1:10;         %�׷��� �׸���
semilogy(x,BER);


        