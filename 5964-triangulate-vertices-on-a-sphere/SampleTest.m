%%	Author:  Tianli Yu	https://netfiles.uiuc.edu/tyu/www/tianli/
%%	Date:	Monday Aug. 01 2005  11:58 pm
%%
%%  SampleTest: This is a sample script to test the TriangulateSpherePoints.m
%%

	VertexM = rand(800, 3) - 0.5;
	VNormV = (sum(VertexM .^ 2, 2)) .^ .5;
	VertexM = VertexM ./ repmat(VNormV, 1, 3);
	FacetM = TriangulateSpherePoints(VertexM);
	figure;
	patch('vertices', VertexM, 'faces', FacetM, 'FaceColor', [1, 1, 0], 'EdgeColor', [1 .2 .2]);
	axis equal;
