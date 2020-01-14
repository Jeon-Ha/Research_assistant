clc;
clear all;
close all;

message=randi([0,1],1,1000000);

BER=[];
symbol=message;               %�ɺ�ȭ

for i = 1:2:(length(message)-2)
    if(message(i) == 0 && message(i+1) == 0)
        symbol(i) =-1;
        symbol(i+1) = -1*j;
    elseif(message(i) == 0 && message(i+1) == 1)
        symbol(i) = -1;
        symbol(i+1) = 1*j;
    elseif(message(i) == 1 && message(i+1) == 0)
        symbol(i) = 1;
        symbol(i+1) = -1*j;
    elseif(message(i) == 1 && message(i+1) == 1)
        symbol(i) = 1;
        symbol(i+1) = 1*j;
    end
end


for x_dB= 0:1:10
    epoch=0;
    error=0;
    error_count=0;
    S=1;                            %(sum(symbol.^2))/length(symbol)
    N=S*10^(-0.1*x_dB);
    
    while error_count<=200
        noise =sqrt(N/2)*randn(1,length(symbol)) + i*sqrt(N/2)*randn(1,length(symbol));      % ���� ����
        symbol_noise=symbol+noise;
        symbol_demo = zeros(1,length(symbol_noise));
        
        for j=1:1:length(message)-2                   %���� �ɹ� ����
            for k = 2:2:length(message)
            if(symbol_noise(1,j) <0 && symbol_noise(1,k) <0)
                symbol_demo(j) = -1;
                symbol_demo(k) = -1*i;
            elseif(symbol_noise(1,j)<0 && symbol_noise(1,k) >0)
                symbol_demo(j) = -1;
                symbol_demo(k) = 1*i;
            elseif(symbol_noise(1,j)>0 && symbol_noise(1,k)<0)
                symbol_demo(j) = 1;
                symbol_demo(k) = -1*i;
            elseif(symbol_noise(1,j)>0 && symbol_noise(1,k) >0)
                symbol_demo(j) = 1;
                symbol_demo(k) = 1*i;

            end
         
        end
        end
        
        symbol_bit=zeros(1,length(symbol_noise));                   %������ �ɹ� ��Ʈ��
        for j=1:2:(length(message)-2)
            for k = 2:2:length(message)
            if(symbol_demo(1,j)==-1 && symbol_noise(1,k) ==-1*i)
                symbol_demo(j) = 0;
                symbol_demo(k) = 0;
            elseif(symbol_demo(1,j)==-1 && symbol_noise(1,k) ==1*i)
                symbol_demo(j) = 0;
                symbol_demo(k) = 1;
            elseif(symbol_demo(1,j)==1 && symbol_noise(1,k) ==-1*i)
                symbol_demo(j) = 1;
                symbol_demo(k) = 0;
            elseif(symbol_demo(1,j)==1 && symbol_noise(1,k) ==1*i)
                symbol_demo(j) = 1;
                symbol_demo(k) = 1;
      
                end
            end
        end
        
        error_bit=message-symbol_bit;
        error=nnz(error_bit)       %error_bit ��Ŀ��� 0�� �ƴ� ������ ������ ����
        error_count=error_count+error;
        epoch = epoch+1;
    end
    
    BER= [BER error_count/(epoch*length(message))]
end

x=0:1:10;         %�׷��� �׸���
semilogy(x,BER);


        