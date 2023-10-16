DECLARE @DataAtual DATE = CAST(GETDATE() AS DATE);

-- Primeira parte da consulta
SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
    o.Praca AS IdPraca,
    t.CategoriaClassificada AS Categoria,
    L.DESCRICAO AS MeioPGTO,
    SUM(t.TotalVeiculo) AS Transacoes,
    t.ValorNominal,
    t.Cobranca,
    SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido
FROM Transacao T
LEFT JOIN Origem O ON T.IdOrigem = O.IdOrigem
LEFT JOIN CodigoMensagem CM ON T.CodigoCV = CM.CodigoCV
LEFT JOIN TransacaoDetalhe td ON td.IdTransacao = T.IdTransacao
LEFT JOIN MEIOPAGAMENTO L ON TD.IdMeioPagamento = L.IdMeioPagamento
INNER JOIN SgCfgCobrancaMeioPagamento CB ON CB.IdCobranca = T.Cobranca
WHERE 
    t.Cobranca IN ('1', '6') 
    AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2023-01-01' AND DATEADD(DAY, -1, @DataAtual)
GROUP BY
    CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
    o.Praca,
    t.CategoriaClassificada,
    L.DESCRICAO,
    t.ValorNominal,
    t.Cobranca,
    SUBSTRING(CONCAT(o.Descricao, ''), 4, 5)

UNION ALL

-- Segunda parte da consulta
SELECT CONVERT(VARCHAR(10), t.DataOcorrencia, 103) AS DataPassagem,
    o.Praca AS IdPraca,
    t.CategoriaClassificada AS Categoria,
    L.DESCRICAO AS MeioPGTO,
    SUM(t.TotalVeiculo) AS Transacoes,
    SUM(t.ValorNominalCorrigido) AS ValorNominalCorrigido,
    t.Cobranca,
    SUBSTRING(CONCAT(o.Descricao, ''), 4, 5) AS Sentido
FROM CorrecaoTransacao T
LEFT JOIN Origem O ON T.IdOrigem = O.IdOrigem
LEFT JOIN CodigoMensagem CM ON T.CodigoCV = CM.CodigoCV
LEFT JOIN CorrecaoTransacaoDetalhe td ON td.IdTransacao = T.IdTransacao
LEFT JOIN MEIOPAGAMENTO L ON TD.IdMeioPagamento = L.IdMeioPagamento
INNER JOIN SgCfgCobrancaMeioPagamento CB ON CB.IdCobranca = T.Cobranca
WHERE 
    t.Cobranca IN ('1', '3', '6') 
    AND t.IdAcaoCorrecao <> '4'
    AND CAST(t.DataOcorrencia AS DATE) BETWEEN '2023-01-01' AND DATEADD(DAY, -1, @DataAtual)
GROUP BY
    CONVERT(VARCHAR(10), t.DataOcorrencia, 103),
    o.Praca,
    t.CategoriaClassificada,
    L.DESCRICAO,
    t.Cobranca,
    SUBSTRING(CONCAT(o.Descricao, ''), 4, 5)
