function [] = saver( question, num, offset )
    path = '../report/res/';
    
    for i = 1:num
        figure(i);
        %set(gcf,'units','inches','position',[0,0,6.5,4.2+1*(i==1)])
        saveas(gcf,sprintf('%sfig_%d_%d',path,question,i+offset),'epsc');
    end
end
