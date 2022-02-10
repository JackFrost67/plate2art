load("../handcrafted_features_extractor/HandCraftedFeaturesPaintings.mat");

%% create model for searching knn
ex_searcher_trained = ExhaustiveSearcher(featuresVector(1:2000, :), 'distance', 'cosine');