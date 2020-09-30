function out = rit_ImageNorm( x, meze )
%
% out = ImageNorm( x [,meze] )
%
% 	Pro jeden vstupni parametr, funkce provede normalizaci 
% matice (vektoru) x.
% 	Druhy vstupni parametr je vektor [a b], ktery rika do 
% jakeho intervalu se maji hodnoty matice x transformovat.
% 	Musi platit, ze a<b !!!
%
% 	Radim Kolar 31.8.1999   9:20 
%

if nargin==1, % normalizace od 0 do 1   
   
   maxi = max( max( x ) );
	mini = min( min( x ) );
	out = (x-mini)/(maxi-mini);
   
elseif nargin==2, % normalizace od meze(1) do meze(2)
   
   maxi = max( max( x ) );
   mini = min( min( x ) );
   if maxi==mini, 
      out = zeros( size(x) );
   else   
      out = (x-mini)/(maxi-mini);
   end   
   
   if meze(1)<0 & meze(2)>0, % pro kladnou a zapornou mez
	   out = ( meze(2) - meze(1) )*out;      
      out = out - abs(meze(1));
      
   elseif meze(1)>=0 & meze(2)>0, % pro kladne meze
       out = ( meze(2) - meze(1) )*out;      
      out = out + abs(meze(1));
      
   elseif meze(1)<0 & meze(2)<0, % pro zaporne meze
	   out = ( abs(meze(1)) - abs(meze(2)) )*out;      
      out = out - abs(meze(1));      
      
   end % if

end % if 

clear maxi mini
