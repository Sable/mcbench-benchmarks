function doy = convert_to_doy (epoch)
    doy = mydatedoy(epoch);
end

%!test
%! epoch = 1;
%! doy = mydatedoy(epoch);
%! doy2 = convert_to_doy(epoch);
%! myassert(doy2, doy)

