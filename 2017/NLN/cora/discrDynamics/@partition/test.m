function test(obj)
% Purpose:  reset segment nr
% Pre:      partition object
% Post:     partition object
% Built:    16.06.09,MA

%one dimesnional case
oneDimField=partition([0,10],5);

i2s(oneDimField,3)

s2i(oneDimField,[2])
s2i(oneDimField,[3,4,9])

%two dimesnional case
twoDimField=partition([0,10; -3,3],[5;10]);

i2s(twoDimField,30)

s2i(twoDimField,[2,8])
s2i(twoDimField,[2,8;1,6;10,5])
sub2ind([5,10],2,8)
sub2ind([5,10],1,6)

%three dimesnional case
threeDimField=partition([0,10; -3,3; 0,1],[5;10;3]);

i2s(threeDimField,100)
[row,col,col2]=ind2sub([5,10,3],100)

s2i(threeDimField,[2,8,2])
s2i(threeDimField,[2,8,2;1,10,1;-1,3,3])
sub2ind([5,10,3],2,8,2)
sub2ind([5,10,3],1,10,1)
