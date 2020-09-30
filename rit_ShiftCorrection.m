function out = rit_ShiftCorrection(im, r_x, c_x )

[nr,nc] = size( im );

out = zeros( nr, nc );

if -c_x<0
    od_c_mov = c_x+1;
    do_c_mov = nc;
    c_pridat_dozadu = abs(c_x);
    c_pridat_dopredu = 0;    
%     od_c_ref = 1;
%     do_c_ref = nc-c_x;
elseif -c_x>0
%     od_c_ref = -c_x;
%     do_c_ref = nc;
    od_c_mov = 1;
    do_c_mov = nc+c_x;
    c_pridat_dopredu = abs( c_x );
    c_pridat_dozadu = 0;
else
    od_c_ref = 1;
    do_c_ref = nc;
    od_c_mov = 1;
    do_c_mov = nc;    
    c_pridat_dopredu = 0;
    c_pridat_dozadu = 0;     
end

if -r_x<0
    od_r_mov = r_x+1;
    do_r_mov = nr;
    r_pridat_dozadu = abs(r_x);
    r_pridat_dopredu = 0;
%     od_r_ref = 1;
%     do_r_ref = nr-r_x;
elseif -r_x>0
%     od_r_ref = -r_x;
%     do_r_ref = nr;
    od_r_mov = 1;
    do_r_mov = nr+r_x;
    r_pridat_dopredu = abs( r_x );    
    r_pridat_dozadu = 0;        
else
    od_r_ref = 1;
    do_r_ref = nr;
    od_r_mov = 1;
    do_r_mov = nr;
    r_pridat_dopredu = 0;
    r_pridat_dozadu = 0; 
end

out(r_pridat_dopredu+1 : end-r_pridat_dozadu, c_pridat_dopredu+1 : end-c_pridat_dozadu ) = im(od_r_mov:do_r_mov, od_c_mov:do_c_mov);
