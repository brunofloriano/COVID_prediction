function mediamovel = mediamovel(dados)

dias = 7;
ndados = length(dados);

mediamovel = movmean(dados,[dias-1 0]);

end
