function Alamouti_QPSK_BER = Vector_Demodulation(Tx_count, Rx_count)
Alamouti_QPSK_BER = [];
%QPSK_SER = [];
for x_dB= 0:5:60 
   epoch=0;  
   error_count_BER=0;
%    error_count_SER=0;
  
    while (1)
        symbol_length = 2;      % 1�� �ɹ��� ��Ʈ ����
        message = randi([0,1],1,symbol_length * 2);  % �޽��� / �˶�Ƽ���� �ɹ� 2���� �ʿ��ϹǷ� ���ϱ� 2 ��
        S=2;                            %(sum(symbol.^2))/length(symbol)
        M=2;                            % symbol�� ��Ʈ ��
        N=S*10^(-0.1*x_dB)*2;
        Error_Limit = 1e-6;
        
        k = 1:2:length(message);
        symbol = (2*message(k)-1 + 1i*(2*message(k)-1));
        
        symbol_noise = Channel_maker_Alamouti(N,Tx_count, Rx_count, symbol);
        
%         if(type == 1)
%             symbol_noise = Noise_maker_MRC(N, RX_count, symbol);
%         elseif(type == 2)
%             symbol_noise = Noise_maker_EGC(N, RX_count, symbol);
%         elseif(type == 3)
%             symbol_noise = Noise_maker_SC(N, RX_count, symbol);
%         end

        
        
        bit_demo = zeros(1,length(message));
        bit_demo(1,1) = real(symbol_noise(1,1))>0;
        bit_demo(1,2) = imag(symbol_noise(1,1))>0;
        bit_demo(1,3) = real(symbol_noise(2,1))>0;
        bit_demo(1,4) = imag(symbol_noise(2,1))>0;
        
%      for j=1:1:length(symbol_noise) 
%                         
%         if(real(symbol_noise(j))<0 && imag(symbol_noise(j))<0)
%                symbol_demo(j) = -1-1i;
%          elseif(real(symbol_noise(j))<0 && imag(symbol_noise(j))>0)
%                symbol_demo(j) = -1+1i;
%          elseif(real(symbol_noise(j))>0 && imag(symbol_noise(j))<0)
%                symbol_demo(j) = 1-1i;
%          else
%                symbol_demo(j) = 1+1i;
%          end
%      end    
    
%      error_symbol=symbol-symbol_demo;
%      error_SER=nnz(error_symbol);
%      error_count_SER = error_count_SER+error_SER;
         
         
%     bit_demo=zeros(1,length(message)); %������ �ɹ� ��Ʈ��
%     k = 1;
%     for j=1:1:(length(symbol_demo))
%        if(symbol_demo(j) == -1-1i)
%            bit_demo(1,k) = 0;
%            k = k + 1;
%            bit_demo(1,k) = 0;
%            k = k + 1;
%        elseif(symbol_demo(j) == -1+1i)
%            bit_demo(1,k) = 0;
%            k = k + 1;
%            bit_demo(1,k) = 1;
%            k = k + 1;
%        elseif(symbol_demo(j) == 1-1i)
%            bit_demo(1,k) = 1;
%            k = k + 1;
%            bit_demo(1,k) = 0;
%            k = k + 1;   
%        else
%            bit_demo(1,k) = 1;
%            k = k + 1;
%            bit_demo(1,k) = 1;
%            k = k + 1;
%        end
%     end
         error_bit=message-bit_demo;
         error_BER=nnz(error_bit);       
         error_count_BER = error_count_BER+error_BER;
         if  Error_Limit > error_count_BER/(epoch*length(message))
             break;
         end
         fprintf("Tx ���� : %d / Rx ���� : %d / Alamouti / epoch : %d / BER : %e \n",Tx_count, Rx_count, epoch,  error_count_BER/(epoch*length(message)));
         epoch = epoch+1;
        
    end
    
    fprintf("Tx ���� : %d / Rx ���� : %d / Alamouti / dB : %d / BER : %e \n",Tx_count, Rx_count, x_dB,  error_count_BER/(epoch*length(message)));
%     if (type == 1)
%         fprintf("Tx ���� : %d / Rx ���� : %d / MRC / dB : %d / BER : %e \n",Tx_count, RX_count, x_dB,  error_count_BER/(epoch*length(message)));
%     elseif (type == 2)
%         fprintf("Rx ���� : %d / EGC / dB : %d / BER : %e \n", RX_count, x_dB,  error_count_BER/(epoch*length(message)));
%     elseif (type == 3)
%         fprintf("Rx ���� : %d / SC / dB : %d / BER : %e \n", RX_count, x_dB,  error_count_BER/(epoch*length(message)));
%     end
    
    Alamouti_QPSK_BER = [Alamouti_QPSK_BER error_count_BER/(epoch*length(message))];
    %QPSK_SER = [QPSK_SER error_count_SER/(epoch*length(message))];
end
end