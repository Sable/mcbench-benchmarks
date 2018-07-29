function area = roc(fileName,varargin)
%
% RECEIVER-OPERATING CHARACTERISTICS (ROC) CURVE
%
%	Receiver-Operating Characteristics (ROC) curve and the area
%	under the curve is returned for one or more experiments on the
%	same dataset.
%
%	area = roc(fileName,exp)
%
%		fileName: The name of the output file. It is an image
%		exp: a structure representing an experiment with three fields
%			- exp.name: a string specifying the experiment name
%			- exp.positive_n: the number of positive samples in the experiment
%			- exp.likelihoods: likelihoods of each sample where the first
%				exp.positive_n number of likelihoods belongs to the positive
%				samples while others belong to the negative samples.
%		area: a 1x1-dimensional cell array of the area under the roc curve.
%
%	The function works for unlimited number of experiments. Therefore, the followings
%	are all possible.
%
%	area = roc(fileName,exp1,exp2)
%		fileName: the same as above.
%		exp1: the same as exp given above.
%		exp2: another experiment result on the same dataset.
%		area: a 1x2-dimensional cell array of the area under the roc curves.
%
%	Similarly,
%	area = roc(fileName,exp1,exp2,...,expN) is also possible.
%
%	Example:
%		x.name = 'experiment-1';
%		x.positive_n = 500;
%		x.likelihoods = rand(1,1000);
%		y.name = 'experiment-2';
%		y.positive_n = 500;
%		y.likelihoods = rand(1,1000);
%		area = roc('sample_compare.jpg',x,y);
%
% Bug Reporting: Please contact the author for bug reporting and comments.
%
% Cuneyt Mertayak
% email: cuneyt.mertayak@gmail.com
% version: 1.0
% date: 03/09/2008
%

colors='bgrcmyke';
types='.ox+*sw';
exp_n = nargin-1;	% number of experiments

handle=figure; hold on; title('RECIEVER-OPERATING CHARACTERISTICS (ROC) CURVE'); 
xlabel('FALSE POSITIVE RATIO'); ylabel('TRUE POSITIVE RATIO'); axis([-0.01 1.00001 -0.0001 1.00001]);
leg_names = cell(1,exp_n); %leg_names{nargin} = '';

area = cell(1,exp_n);

for i=1:1:exp_n		% for all experiments
	scolor=colors(mod(i,size(colors,2))); stype=types(mod(i,size(types,2)));
	leg_names{i} = varargin{i}.name;
	likelihoods = varargin{i}.likelihoods;
	temp = sort(likelihoods, find(size(likelihoods) == max(size(likelihoods)),1), 'descend');

	nb_total = max(size(temp));
	nb_pos = varargin{i}.positive_n;
	nb_neg = nb_total - nb_pos;

	prob_true_pos = zeros(1,nb_pos + nb_neg+1);

	for j=1:1:max(size(temp))	% for all thresholds
		thr=temp(j);
		prob_true_pos(j+1) = sum(likelihoods(1:nb_pos) >= thr) / nb_pos;
		prob_false_pos(j+1) = sum(likelihoods((nb_pos+1):end) >= thr) / nb_neg;
	end
	form = sprintf('-%c%c', scolor, stype);
	plot(prob_false_pos, prob_true_pos, form);
    area{1,i} = sum((prob_false_pos(2:end)-prob_false_pos(1:end-1)).*...
                    (prob_true_pos(2:end)+prob_true_pos(1:end-1))/2);
end
legend(leg_names,'Location','SouthEast');

fprintf('SAVING FILE %s\n',fileName);

saveas(handle,fileName);
hold off;

