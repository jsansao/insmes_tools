function [y,t]  = pitchamp(x,fs)

inicio_busca = round(3.3e-3 * fs) 
fim_busca = round(16.7e-3 * fs) 

Rp = 3;
Rs = 40;
M = 22+3;


wc1 = 4.5e3/(fs/2);
[N, Wn] = buttord(wc1, 1.2*wc1, Rp, Rs);
[B_lp,A_lp] = butter(N,Wn); 
x_lp = filtfilt(B_lp,A_lp,x);
%  freqz(B_lp,A_lp,512);
%pause;
%  A = lpc(x_lp(:,1),M);

 A = lpc(x(:,1),M);
resi = filter(A,1,x_lp(:,1));
%reconst = filter(1,A,resi);


janela = round(fs*100e-3); 


K = 0; 
for J = 1 : janela : (length(x_lp(:,1))-janela)
  K = K + 1;
  t(K) = (K) * janela;
%  A = lpc(x_lp(J:J+janela,1),M);
%  resi = filter(A,1,x_lp(J:J+janela,1));
  r_resi = xcorr(resi(J:J+janela), 'coeff');
  r_resi_oneside= 10 * r_resi(janela+1:end) / max(r_resi);

  t =  (0:janela)/fs; 
  
  %plot(t(1:300), r_resi_oneside(1:300));
%plot( r_resi_oneside);
 % pause;

  l_masc = size(r_resi_oneside);
  mascara_busca = zeros(1,l_masc(1));
  trecho =inicio_busca:fim_busca ;
  mascara_busca(inicio_busca:fim_busca) = ones(1,1+fim_busca-inicio_busca);

  r_resi_oneside_busca = r_resi_oneside .* mascara_busca';

  [pico, posicao_pico] = max(r_resi_oneside_busca);
  pico
  1/t(posicao_pico)
  y(K) = pico;

end


