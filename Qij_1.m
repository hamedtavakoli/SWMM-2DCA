function [ Q ] = Qij_1( H1,H2,h1,h2,n,d1,d2 )
%
%   
Q = (-1) * sign(H1-H2) * ((d1 * abs(((h1+h2)./2)).^(5/3))./n).*sqrt(abs(H1-H2)./d2);

end

