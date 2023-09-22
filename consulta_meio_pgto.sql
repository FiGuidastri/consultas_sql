SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
	t.CategoriaClassificada AS Categoria,
	t.EixosClassificados AS Eixos,  
	SUM(t.TotalVeiculo) AS Transacoes,
	t.ValorNominal,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido,
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
	AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2023-09-19' AND '2023-09-19'
GROUP BY
	CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
	t.CategoriaClassificada,
	t.EixosClassificados,
	L.DESCRICAO,
	t.ValorNominal,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5),
	o.Descricao,
	o.Praca

UNION ALL

SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
	t.CategoriaClassificada AS Categoria,
	EixosCorrigidos AS Eixos,  
	SUM(t.TotalVeiculo) AS Transacoes,
	SUM(t.ValorNominalCorrigido) AS ValorNominalCorrigido,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido,
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
	AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2023-09-19' AND '2023-09-19'
GROUP BY
	CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
	t.CategoriaClassificada,
	EixosCorrigidos,
	L.DESCRICAO,
	t.Cobranca,
	SUBSTRING(CONCAT(o.Descricao, ''), 4, 5),
	o.Descricao,
	o.Praca
