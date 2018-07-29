c = [5 4 1 2 3 4  3 0 0 1 0 1 0 0 0 7 7 1 1 0 7 5 4 5 4 5 0 6 5 4 1 3 4 4 4 4 6];
plot_chain_code(c)
hold
plot_fourier_approx(c, 10, 100, 0, 'r');
