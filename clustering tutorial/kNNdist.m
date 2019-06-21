function [d, idx]= kNNdist(pos,dist,k)
%calculates the distance to the k nearest neighbor and its index using a k-D tree

tree = KDTreeSearcher(pos(:,1:3));

