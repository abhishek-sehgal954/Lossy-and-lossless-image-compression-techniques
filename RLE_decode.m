% Run Length Encoder
function decoded = RLE_decode(input,length)
count=0 ;
a=[] ;
for i=1:size(input,1)
    if(isequal(input(i,:),zeros(1,2))==0)
      if(input(i,1) ~=0)
        a=horzcat(a,zeros(1,input(i,1)));
        a=horzcat(a,input(i,2)) ;
        count=count+input(i,1)+1 ;
      else
          a=horzcat(a,input(i,2)) ;
          count=count+1 ;
      end
    else
     c=zeros(1,length-count) ;
     a=horzcat(a,c) ;
       break
    end
end
decoded=a ;                                                                                                      
end

