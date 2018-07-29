function generate_heatmap(data)

% Extract labels
rats = getlabels(data.indexQuality);
ticks = getlabels(data.ticker);

% Initialize matrices
wtmat = zeros(length(ticks),length(rats));
sizemat = wtmat;

% Calculate counts and weights
for i = 1:length(rats)
    subset = data(data.indexQuality == rats{i},{'ticker','marketWeight'});
    for j = 1:length(ticks)
        ind = subset.ticker == ticks{j};
        sizemat(j,i) = sum(ind);
        if sizemat(j,i)>0
            wtmat(j,i) = sum(subset.marketWeight(ind));
        end
    end
end
bndwt = reshape(sum(wtmat, 2),6,4);
bndct = reshape(sum(sizemat, 2),6,4);

% Create heatmap figure
figure('Position',[100 100 900 600],'Renderer','Painters');
subplot(2,2,2);
heatmap(bndwt, [], [], ticks, 'Colormap', 'red', 'useLogColorMap', false, 'Colorbar', true);
title('MarketWeight');

subplot(2,2,4);
heatmap(bndct, [], [], ticks, 'Colorbar', true);
title('Number of bonds');

subplot(1,2,1);
heatmap(wtmat, rats, ticks, sizemat, 'Colorbar', true);
title('Tickers vs Rating');


