SELECT 
    CONVERT(VARCHAR(10), CONVERT(DATE, CONVERT(CHAR(8), T.Data, 112)), 103) as DataPassagem, -- Formatação de data
    T.Praca,
    T.Categoria,
    T.Tipo,
    T.Receita,
    T.Fluxo,
    T.EixoEq,
    T.Sentido
FROM 
    TRAFEGO_REALIZADO T
WHERE 
    T.Data BETWEEN 20160301 AND 20231231
