clear all;
close all;
format shortE;
warning('off','all');
tic

% QPSK MMSE ISDIC Serial with Grouping
ordering = 2;
Tx = 8;
Rx = 8;
result = [];
Error_Limit = 10^-5;
checkNumber = 2;            % 몇 번 같을 때 실행할 것인지 결정하는 숫자
max_iteration = 5;
Grouping_initial = 8;
Grouping_count = Tx/Grouping_initial;

fprintf("============ Grouping = %d============ \n", Grouping_initial);

for SNR = 0:4:8
    N = 1*10^(-0.1*SNR);
    error = zeros(1,max_iteration);
    trial = 0;
    final_symbols = zeros(Tx, 5);
    
    while min(error) < 500      
        trial= trial + 1;
        
        %% Making Symbol 
        bit = randi([0,1],Tx,2);
        
        symbol = 2 * bit - 1;
        symbol = (symbol(:,1) + symbol(:,2) * 1j)/sqrt(2);
        
        h = (randn(Rx,Tx) + 1j * randn(Rx,Tx))/sqrt(2);
        noise = (randn(Rx,1) + 1j * randn(Rx,1)) * sqrt(N/2);
        r = h * symbol + noise;
        
        %% Create Vector
        s = zeros(Tx,1);
        v = ones(Tx,1);
        checkSymbol = zeros(Tx, checkNumber);
        checkEscape = 0;
        %escapeTrial = 0;
        
         %% Ordering
        if ordering == 1 
            order = 1:Tx; 
        elseif ordering == 2 
            [~, order] = sort(sum(abs(h).^2),'descend');
        elseif ordering == 3 
            G_mmse = ((h*h'+N * eye(Rx))\h)';
            for i=1:Tx
                ordermean(i) = real(G_mmse(i,:)*h(:,i));
            end
            snr_value = ordermean./(1-ordermean);
            [~, order] = sort(snr_value,'descend');
        end
        
        a_q = [1+1i, 1-1i, -1+1i, -1-1i] / sqrt(2);
        
        %% ISDIC Start
        for iteration=1:5
            
            count = 0;
            Grouping = Grouping_initial;
            
            % loop start  
            for i=1:1:Grouping_count
               h_Dot_s_Sum = 0;
               for j=1:1:Tx
                   h_Dot_s_Sum = h_Dot_s_Sum + h(:,j)*s(j);
               end
               
               for k= (count+1):1:Grouping
                   rParallel(:,:,k) = r - (h_Dot_s_Sum) + (h(:,k) * s(k));
               end
               
               for k= (count+1):1:Grouping
                   D(:,:,k) = v .* eye(Tx);
                   D(k,k,k) = 1;
               end
               
               for k= (count+1):1:Grouping
                   f(:,:,k) = conj(h(:,k).') * inv(h * D(:,:,k) * conj(h.') + N * eye(Rx));
               end
            
               for k= (count+1):1:Grouping
                   b(:,:,k) = real(f(:,:,k) * h(:,k));
               end

%                for k= (count+1):1:Grouping
%                    p(:,:,k) = exp((-1 * abs(f(:,:,k) * rParallel(:,:,k) - a_q * b(:,:,k)).^2 / (b(:,:,k) * (1 - b(:,:,k)) ) ) ); % a_q 없음 추가해야됨
%                 if isnan(p(:,:,k)) 
%                     p(:,:,k) = exp((-1 * abs(f(:,:,k) * rParallel(:,:,k) - a_q * b(:,:,k)).^2 / (b(:,:,k) * (1 - b(:,:,k)) ) ) ) * 10^300;
%                 end
%                end
               for k= (count+1):1:Grouping
                   p(:,:,k) = (-1 * abs(f(:,:,k) * rParallel(:,:,k) - a_q * b(:,:,k)).^2 / (b(:,:,k) * (1 - b(:,:,k)) ) );
                   p(:,:,k) = exp(p(:,:,k) + (700-max(p(:,:,k))));
               end
               
               
%                 o = p == 0;     % p가 0에 너무 가까워졌을 경우 1을 o에 저장
%                 p(o) = p(o) + 10^-300;
                
                for k= (count+1):1:Grouping
                   s(k) = sum(a_q .* p(:,:,k)) / sum(p(:,:,k)); 
                end
                
                for k= (count+1):1:Grouping
                  v(k) = sum(abs(a_q - s(k)).^2 .* p(:,:,k)) / sum(p(:,:,k));
                end
                
                Grouping = Grouping + Grouping_initial;
                count = count + Grouping_initial;

                estimateSymbol = EstimatingX(s);
            end
            
            final_symbols(:, iteration) = estimateSymbol; 
           
%             % check loop
%             checkEscape = 1;
%             checkSymbol(:,checkNumber) = estimateSymbol;
% 
%             for i=1:1:checkNumber - 1
%                 checkEscape = checkEscape * isequal(checkSymbol(:,i), checkSymbol(:,i+1));
%             end
%             checkSymbol(:,1) = [];
%             
%             escapeTrial = escapeTrial+1;
%             if escapeTrial > 5
%                 break
%             end
%             
            % loop end
        end
       
        %% Demodulation
        for iteration=1:max_iteration            
            Demo_result(:,1) = real(final_symbols(:, iteration))>0; 
            Demo_result(:,2) = imag(final_symbols(:, iteration))>0;
            error(iteration) = error(iteration) + sum(abs(bit-Demo_result), 'all');
        end   
%         Demo_symbol = checkSymbol(:,end);
%                 
%         Demo_result(:,1) = real(Demo_symbol)>0; % MRC는 추후 변경하기
%         Demo_result(:,2) = imag(Demo_symbol)>0;
%         
%         % count error
%         error = error + sum(abs(bit-Demo_result), 'all');
        
    end
    
    error = error / (trial * 2 * Tx);
    fprintf("Tx 개수 : %d / Rx 개수 : %d / dB : %d / BER : ", Tx, Rx, SNR);
    fprintf("%g /",  error);
    fprintf("\n");
    if Error_Limit > error
        break;
    end
    result = [result error];
end

%% Save Files
    result.'
[~, currentFileName,~] = fileparts(mfilename('fullpath'));
   
fileName = strcat(pwd,'\result\', 'ISDIC_', string(Tx), 'x', string(Rx), '_Grouping_',string(Grouping_initial), '.mat');


if (exist(fileName, 'file') > 0) 
    save(fileName, 'result', '-append'); 
else
    save(fileName, 'result');
end

toc
% % save mat file
% [~, currentFileName,~] = fileparts(mfilename('fullpath'));
% 
% fileName = strcat(currentFileName, '_', string(Tx), 'x', string(Rx), '.mat');
% % varName = strcat(currentFileName, '_', string(Tx), 'x', string(Rx), '_result');
% QPSK_new_meta_MMSE_ISDIC_Parallel_result_4x4 = result;
% cd mat_folder % 폴더명
% 
% if (exist(fileName, 'file') > 0) 
%     save(fileName, 'QPSK_new_meta_MMSE_ISDIC_Serial_result_4x4', '-append'); 
% else
%     save(fileName, 'QPSK_new_meta_MMSE_ISDIC_Serial_result_4x4');
% end
% 
% cd ..

