clc;
clear all;
close all;

message=randi([0,1],1,1000000);  %OK

QPSK_BER=[];

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
for x_dB= 0:1:10
   error=0;  
   epoch=0;  
   error_count=0;
  
    while (error_count<=200)
        S=2;                            %(sum(symbol.^2))/length(symbol)
        N=S*10^(-0.1*x_dB);
        noise =sqrt(N/2)*randn(1,length(symbol)) + 1i*(sqrt(N/2)*randn(1,length(symbol)));      % ���� ����
        symbol_noise=symbol+noise;
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
         error=nnz(error_bit);       %error_bit ��Ŀ��� 0�� �ƴ� ������ ������ ���� 
         error_count = error_count+error;
         epoch = epoch+1;
        
    end
     QPSK_BER = [QPSK_BER error_count/(epoch*length(message))];
end

x=0:1:10;         %�׷��� �׸���
semilogy(x,QPSK_BER);


        