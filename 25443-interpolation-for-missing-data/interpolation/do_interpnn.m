xgood = x(z >= 0);
ygood = y(z >= 0);
zgood = z(z >= 0);
xbad = x(z < 0);
ybad = y(z < 0);
P = size(xbad, 1);
zbad = zeros(P, 1);
for p = 1:P
    zbad(p) = nninter(xgood, ygood, zgood, xbad(p), ybad(p));
    %fprintf('%d/%d: %f %f %f\n', p, P, xbad(p), ybad(p), zbad(p));
end
plot3(xgood, ygood, zgood, 'b.', xbad, ybad, zbad, 'r.');
xnew = [xgood; xbad]; ynew = [ygood; ybad]; znew = [zgood; zbad];
Im = make_image(xnew, ynew, znew);
ImOld = make_image(x, y, z);
figure(1); imagesc(ImOld); colormap jet; colorbar
figure(2); imagesc(Im   ); colormap jet; colorbar