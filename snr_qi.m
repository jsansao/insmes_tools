function [snr_qi,t] = snr_qi( x ,fs ) 
% Implementação de SNR de Qi, Qi et al. (1999)
% sinal gerado pela filtragem inversa em curto prazo ; 
% ruído pela filtragem inversa de longo prazo.


janela1 = floor(20e-3 * fs) ; 
janela2 =  floor(2.5e-3* fs) ; 

M1 = 14;
M2 = 3; 

N_x = length(x); 



s_total = [ ];
n_total = [ ];

for I = 1 : janela1 : (N_x )
	  x_analise = x(I:(I+janela1-1));
	  A = arcov(x_analise, M1);
	  s_analise = filter(A,1,x_analise);
	  s_total = [ s_total s_analise];
end


N_s = length(s_total); 
for I = 1 : janela2 : (N_s )
I
	  s_analise = s_total(I:(I+janela2-1));
	  A = arcov(s_total, M2);
	  n_analise = filter(A,1,s_analise);
%	  n_total = [ n_total n_analise];
end




whos s_total
whos x
whos n_total

snr_qi = 0;
t= 0;


