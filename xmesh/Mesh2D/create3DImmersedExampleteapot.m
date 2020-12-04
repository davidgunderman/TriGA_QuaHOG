load('teapot_trims.mat','teapot','teapotTrims','teapotindices','teapotorientations','teapotpln','plntrims');
teapot{33}=teapotpln;

colors = [.3 0 .7;
          .5 .1 .5;
          .7 .2 .3;
          0 .3 .7;
          .1 .5 .5;
          .2 .7 .3;
          .7 0 .7
          .5 .5 .1];
      ord=3;
stparts=[12,16,20,24,28,32];
 for ii=1:length(teapotTrims)
    color = colors(ii<=stparts,:);
    color=color(1,:);
    numCurves=length(teapotTrims{ii});
    if numCurves>0
       DD=teapotTrims{ii};
        clear curvs;
        for i=1:numCurves
%            pltpoints=dC_eval_3d(teapot{ii},[DD{i}(:,1), DD{i}(:,2)]);
%            hh=scatter3(pltpoints(:,1),pltpoints(:,2),pltpoints(:,3));
            tDS=[DD{i}(1:(2^9):end,1:2);];
            if mod(size(DD{i},1),2^12)~=1
                tDS=[tDS; DD{i}(end,1:2);];
            end
            tDS(1,tDS(1,:)>(1-1e-3))=1;
            tDS(1,tDS(1,:)<(1e-3))=0;
            tDS(end,tDS(end,:)>(1-1e-3))=1;
            tDS(end,tDS(end,:)<(1e-3))=0;
            if teapotorientations{ii}(i)==-1
                tDS=flipud(tDS);
            end
            curvs{i}=fitBernsteins(tDS,ord);
        end
%         if ii==6
%             curvs{1}=rorientP(curvs{1});
%         end
        Allcurvs=pieceTogetherCurves(curvs,ord,1e-10,0);
        nwcurvs=ratcvs(Allcurvs);
        nwteapot=teapot(ii);
        nwteapot{1}(4,:,:)=ones(size(teapot{ii},2),size(teapot{ii},3));
%         visBezElTrim(nwteapot,{nwcurvs},0,color);
%         hold on;
%     else
    end
        nwteapot=teapot(ii);
        nwteapot{1}(4,:,:)=ones(size(teapot{ii},2),size(teapot{ii},3));
        visBezEl(nwteapot,6,0,color);
        hold on
 end
 
% newcurvs=ratcvs(plntrims);
teapot{33}(4,:,:)=ones(2,2);
% visBezElTrim(teapot(33),{newcurvs},0,[0 .7 .3])
visBezEl(teapot(33),4,0,[0 .7 .3]);

hh=get(gca,'Children')
for i=1:length(hh)
if strcmp(hh(i).Type,'surface') || strcmp(hh(i).Type,'patch')
set(hh(i),'FaceLighting','gouraud')
end
end
light('Position',[-3 -3 10],'Style','local')



 function newcurvs= ratcvs(curvs)
    newcurvs=zeros(size(curvs,1)*3/2,size(curvs,2));
    newcurvs(1:3:end,:)=curvs(1:2:end,:);
    newcurvs(2:3:end,:)=curvs(2:2:end,:);
    newcurvs(3:3:end,:)=1;
end
