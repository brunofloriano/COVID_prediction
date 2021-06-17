function data = datacollect()

%ndata = 422;
ndata = 443;

%datatable = readtable('covidbr.csv');
datatable = readtable('covidbr10-05-21.csv');
datatablebr = datatable(1:ndata,:);

t = 1:ndata;

casos = table2array(datatablebr(t,12))';
obitos = table2array(datatablebr(t,14))';

%data = obitos;
data = mediamovel(obitos);