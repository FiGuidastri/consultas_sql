select 
	CONVERT(VARCHAR(12), T.Data, 103) as DataPassagem, --tratamento de data
	t.Praca,
	t.Categoria,
	t.Tipo,
	t.Receita,
	t.fluxo,
	t.EixoEq,
	t.Sentido
from 
	TRAFEGO_REALIZADO t
where 
	Data between '20160301' and '20231231'
