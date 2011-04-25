%chamada do acoustic
function [snr_mes,deviation] = call_snr(arquivo);


ArquivoTemp = num2hex(rand);
ArquivoTemp2 = [ArquivoTemp '2'];
ArquivoTemp3 = [ArquivoTemp '3'];



	command = [ '!acoustic -i ' arquivo ' -o ' ArquivoTemp2 ' -c ' ...
                            ArquivoTemp3 ' -n 1 | grep snr > ' ...
                            ArquivoTemp ] 
                    
eval(command); 

fid = fopen(ArquivoTemp);
file = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
lines = file{1};
Linha = lines{1, :};
[a b snr_mes deviation] = strread(Linha, '%s %s %f %f', 'delimiter',' ');
         
                    command = ['!rm ' ArquivoTemp ' ' ArquivoTemp2 ...
                               '.stt ' ArquivoTemp3];
eval(command); 