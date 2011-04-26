function [p,e] = pe_calc(y, ord)
%permutation entropy calculation
% usage: [p,e] = calc_pe(y, ord) 
% inputs:
%       y : input signal
%       ord: embedding order
% outputs:
%       p : 
%       e : entropy 
%
% From: http://www.nbb.cornell.edu/neurobio/land/PROJECTS/Complexity/index.html

sd = std(y);
y = (y-mean(y))/sd;
ly = length(y);

permlist = perms(1:ord);
c(1:length(permlist))=0;
    
for j=1:ly-ord
    [a,iv]=sort(y(j:j+ord-1));
    for jj=1:length(permlist)
        if (abs(permlist(jj,:)-iv))==0
            c(jj) = c(jj) + 1 ;
        end
    end
end

p = max(1/ly,c/(ly-ord));
e = -sum(p .* log(p))/(ord-1);

