function [y,t]  = sfrs(x,fs)

inicio_busca = round(3.3e-3 * fs) 
fim_busca = round(16.7e-3 * fs) 

Rp = 3;
Rs = 40;
M = 22+3;

A = lpc(x(:,1),M);
resi = filter(A,1,x(:,1));
janela = round(fs*100e-3); 


K = 0; 
for J = 1 : janela : (length(x(:,1))-janela)
  K = K + 1;
  t(K) = (K) * janela;
  x_analise = resi(J:(J+janela));

  t =  (0:janela)/fs; 
  
x_fft = fft(x_analise .* hamming(janela+1));

re0 = sum(x_fft .* conj(x_fft));

x_fft_norm = (x_fft .* conj(x_fft)) / re0;

V = log(x_fft_norm);

somaV = exp(mean(V));

SF(K) = 10 * log10(somaV);

end


y = SF;