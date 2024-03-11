/*
Consulta: Todas as passagens de pedágios com placas registradas entre 2016 e 2022
Autor: Raphael Bertodo
Editor: Filipe Guidastri
Servidor: 10.0.2.11
Banco: VR00_VIARONDON
*/

SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
	DATEPART(HOUR, t.DataOcorrencia) AS HoraPassagem,
	t.CategoriaClassificada AS Categoria,
	t.EixosClassificados AS Eixos,  
	SUM(t.TotalVeiculo) AS Transacoes,
	t.ValorNominal,
	t.Cobranca,
	t.PlacaOperador,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido,
	o.Descricao AS Pista,
	o.Praca AS IdPraca,
	L.DESCRICAO AS MeioPGTO
FROM Transacao T
LEFT JOIN Origem O ON T.IdOrigem = O.IdOrigem
LEFT JOIN CodigoMensagem CM ON T.CodigoCV = CM.CodigoCV
LEFT JOIN TransacaoDetalhe td ON td.IdTransacao = T.IdTransacao
LEFT JOIN MEIOPAGAMENTO L ON TD.IdMeioPagamento = L.IdMeioPagamento
INNER JOIN SgCfgCobrancaMeioPagamento CB ON CB.IdCobranca = T.Cobranca
WHERE 
	t.Cobranca IN ('1', '6') 
	AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY
	t.PlacaOperador,
	t.CategoriaClassificada,
	t.EixosClassificados,
	CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
	DATEPART(HOUR, t.DataOcorrencia),
	t.ValorNominal,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5),
	o.Descricao,
	o.Praca,
	L.DESCRICAO
HAVING LEN(t.PlacaOperador) = 7

UNION ALL

SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
	DATEPART(HOUR, t.DataOcorrencia) AS HoraPassagem,
	t.CategoriaClassificada AS Categoria,
	EixosCorrigidos AS Eixos,  
	SUM(t.TotalVeiculo) AS Transacoes,
	t.ValorNominalCorrigido,
	t.Cobranca,
	t.PlacaOperador,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido,
	o.Descricao AS Pista,
	o.Praca AS IdPraca,
	L.DESCRICAO AS MeioPGTO
FROM CorrecaoTransacao T
LEFT JOIN Origem O ON T.IdOrigem = O.IdOrigem
LEFT JOIN CodigoMensagem CM ON T.CodigoCV = CM.CodigoCV
LEFT JOIN CorrecaoTransacaoDetalhe td ON td.IdTransacao = T.IdTransacao
LEFT JOIN MEIOPAGAMENTO L ON TD.IdMeioPagamento = L.IdMeioPagamento
INNER JOIN SgCfgCobrancaMeioPagamento CB ON CB.IdCobranca = T.Cobranca
WHERE 
	t.Cobranca IN ('1', '3', '6') 
	AND t.IdAcaoCorrecao <> '4'
	AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY
	t.PlacaOperador,
	t.CategoriaClassificada,
	EixosCorrigidos,
	CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
	DATEPART(HOUR, t.DataOcorrencia),
	t.ValorNominalCorrigido,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5),
	o.Descricao,
	o.Praca,
	L.DESCRICAO
HAVING LEN(t.PlacaOperador) = 7;
