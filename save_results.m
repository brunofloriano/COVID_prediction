function savefolderlocal = save_results()

save_folder = 'results\';
save_mainname = 'covidbr ';

clocktime = clock;
time_now = [num2str(clocktime(1)) '-' num2str(clocktime(2)) '-' num2str(clocktime(3)) '-' num2str(clocktime(4)) '-' num2str(clocktime(5))];
savefolderlocal = [save_folder '\' save_mainname time_now];
save_file = [savefolderlocal '\' save_mainname  time_now '.mat'];

mkdir(savefolderlocal);
save(save_file);
saveas(gcf,[savefolderlocal '\' save_mainname  time_now '.jpg']);

end