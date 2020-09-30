function [u, v] = rit_MyLucasKanade(im1, im2, windowSize, ind, G, dG);
%Lucas Kanade algorithm without pyramidal extension

[fx, fy, ft] = rit_myComputeDerivatives(im1, im2, G, dG );
%%
halfWindow = floor(windowSize/2);   

% if nargin==4
% size(ind,1)
    for ii = 1:size(ind,1),
        
          curFx = fx(ind(ii,1)-halfWindow:ind(ii,1)+halfWindow, ind(ii,2)-halfWindow:ind(ii,2)+halfWindow);
          curFy = fy(ind(ii,1)-halfWindow:ind(ii,1)+halfWindow,ind(ii,2)-halfWindow:ind(ii,2)+halfWindow);
          curFt = ft(ind(ii,1)-halfWindow:ind(ii,1)+halfWindow, ind(ii,2)-halfWindow:ind(ii,2)+halfWindow);
      
          curFx = curFx(:);
          curFy = curFy(:);
          curFt = curFt(:);
      
           A = [sum(curFx.^2), sum(curFx.*curFy);...
                  sum(curFx.*curFy),  sum(curFy.^2)]; 

            b = [sum(curFt.*curFx); sum(curFt.*curFy)]; 
       
            U = A\b;

             u(ii,1) = U(1);
            v(ii,1) = U(2);        
    end        
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fx, fy, ft] =rit_myComputeDerivatives(im1, im2, G, dG );
%ComputeDerivatives	Compute horizontal, vertical and time derivative
%							between two gray-level images.



% smoothen and take derivative
fy = conv2( im1, dG'*G, 'same');
fx = conv2( im1, G'*dG, 'same'); 
ft = conv2( im1, G'*G, 'same') - conv2( im2, G'*G, 'same');






























