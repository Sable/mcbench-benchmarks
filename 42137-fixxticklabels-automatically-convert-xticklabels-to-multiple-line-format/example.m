figure;

bar(rand(1,4));
set(gca,'XTickLabel',{'Really very very long text', ...
                      'One more long long long text', ...
                      'Short one','Long long long text again'});
fix_xticklabels();

figure;

bar(rand(1,4));
set(gca,'XTickLabel',{'Really very very long text', ...
                      'One more long long long text', ...
                      'Short one','Long long long text again'});
fix_xticklabels(gca,0.1,{'FontSize',16});
