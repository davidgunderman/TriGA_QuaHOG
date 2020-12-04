cctr=0;
bbNodes=find(CFLAG)
for i=1:length(bbNodes)
    bNodes=NODE(IEN(:,bbNodes(i)),:);
    side10 = [1 4 5 2; 2 6 7 3;3 8 9 1 ];
    ictr=0;
    for side=1:3
        ss=evalNURBS(bNodes(side10(side,:),:),[0 0 0 0 1 1 1 1],0:.1:1);
        if any(abs(ss(:,1).^2+ss(:,2).^2-1)>1e-3)
            ictr=ictr+1;
            cctr=cctr+1;
        end
    end
end