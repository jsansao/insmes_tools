function [y_cpps,t] = cpps ( x ,fs ) 

passo = round(2e-3 * fs) ; 
frames = 150;
bins = 3;
janela = round(2 * 20e-3 * fs) ; 

N_x = length(x); 

N_x / passo 

J=0;
K=0;
% projeto dos filtros:

eixo_t = (0:janela-1)/fs;

y_cpp_temp = [];

cepstra_acum = zeros(frames,janela);



for I = 1 : passo : (N_x - janela)
  J = J+1;
  K = K+1;
  x_analise = x(I:(I+janela-1));
  cepstra = calculo_cepstra(x_analise);

  cepstra_in = real(cepstra)';

  
  cepstra_acum(K,:) = cepstra_in;
  if (K == frames)
    K = 0; 
  end

cepstrum_medio = mean(cepstra_acum)';

  y_cpp_temp(J) =    calculo_cpp(cepstrum_medio,eixo_t, bins);
  t(J) = J * passo;
  end



%plot(t,y_cpp_temp);
y_cpps = [ y_cpp_temp ];


function  cepstra = calculo_cepstra(x)
N = length(x);

x_fft = fft(x .* hamming(N));
x_fft_dB = 20 * log10 (abs(x_fft));
x_cepstrum = 20*log10(real(ifft(x_fft_dB)));

cepstra = x_cepstrum;


function y_cpp = calculo_cpp(x_cepstra,eixo_t,bins) 



%x_cepstrum_media_med = medfilt1(x_cepstra,bins);
B = ones(1,bins)/bins; 
x_cepstrum_media_med = filter(B,1,x_cepstra);



[trecho_t,indice_t] = find(eixo_t>1e-3); inicio_t = indice_t(1);

eixo_x  = eixo_t(inicio_t:round(end/2));
eixo_y = x_cepstrum_media_med(inicio_t:round(end/2))';


P = polyfit(eixo_x,eixo_y,1);

plot(eixo_x,eixo_y, eixo_x, P(2) + P(1) * eixo_x);
%pause;

[ValorMax, IndiceMax] = max(eixo_y);

y_cpp = ValorMax - (P(2) + P(1) * eixo_x(IndiceMax));

