function [y_rpk,t] = rpk ( x ,fs ) 

passo = round(10e-3 * fs) ; 
janela = round(30e-3 * fs) ;

inicio_busca = round(3.3e-3 * fs) 
fim_busca = round(16.7e-3 * fs) 

 
N_x = length(x); 

N_x / passo 

J=0;

% projeto dos filtros:

fc1 = 2.5e3; fc2 = 3.5e3;
wc1 = fc1/(fs/2)
wc2 = fc2/(fs/2);
Rp = 3;
Rs = 40;

[N, Wn] = buttord([wc1 wc2], [0.9*wc1 1.1*wc2], Rp, Rs);

[B_bp,A_bp] = butter(N,Wn); 


[N, Wn] = buttord(wc1, 0.7*wc1, Rp, Rs);

[B_hp,A_hp] = butter(N,Wn,'high'); 

x_bp = filtfilt(B_bp,A_bp,x);
x_hp = filtfilt(B_hp,A_hp,x);


eixo_t = (0:janela)/fs;

y_cpp_temp = [];
y_cpp_hp = [];
y_cpp_bp = [];

for I = janela : passo : (N_x - janela)
	  x_analise = x(I:(I+janela));
	  r_xx = xcorr(x_analise);

	  J = J+1;

	  t(J) = J * passo;
	  r_xx_oneside = r_xx(round(end/2):end);

	  l_masc = size(r_xx_oneside);

	  mascara_busca = zeros(1,l_masc(1));
	  trecho =inicio_busca:fim_busca ;
	  mascara_busca(inicio_busca:fim_busca) = ones(1,1+fim_busca-inicio_busca);

	  r_xx_oneside_busca = r_xx_oneside .* mascara_busca';
	  
	  [pico, atraso_max] = max(r_xx_oneside_busca);



	  x_analise_delay = x((I-atraso_max):(I+janela-atraso_max));

	  r = corrcoef(x_analise_delay, x_analise);

	  y_rpk(J) = r(1,2);
	  


end



