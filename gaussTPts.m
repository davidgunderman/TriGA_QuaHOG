function [pts,W] = gaussTPts(pts)
    [x, w] = GaussLegendreQuad1D(pts,0,1);
    xx=zeros(pts,pts);
    w2=zeros(pts,pts);
    for i=1:pts
        [xx(i,:), ww]=GaussLegendreQuad1D(pts,0,1-x(i));
        w2(i,:)=w(i)*ww;
    end
    s=repmat(x,pts,1);
    t=xx;
    ss=s(:); tt=t(:);
    pts=[ss,tt];
    W=w2(:);
end