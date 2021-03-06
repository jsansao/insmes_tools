function [snr_mes,deviation] = call_shimmer(arquivo);


ArquivoTemp = num2hex(rand);
ArquivoTemp2 = [ArquivoTemp '2'];
ArquivoTemp3 = [ArquivoTemp '3'];



command = [ '!acoustic -i ' arquivo ' -o ' ArquivoTemp2 ' -c ' ...
                            ArquivoTemp3 ' -n 1 | grep shimmerRMS > ' ...
                            ArquivoTemp ] ;
command                    
eval(command); 

fid = fopen(ArquivoTemp);
file = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
lines = file{1};
Linha = lines{1, :};
[a b snr_mes_s deviation_s] = strread(Linha, '%s %s %s %s', 'delimiter',' ');
         
snr_mes = str2num(snr_mes_s{:});
deviation = str2num(deviation_s{:});

command = ['!rm ' ArquivoTemp ' ' ArquivoTemp2 ...
                               '.stt ' ArquivoTemp3];
eval(command);