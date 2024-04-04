WITH
    FiltroData
    AS
    (
        SELECT '2023-01-01' AS DataInicial, DATEADD(DAY, -1, GETDATE()) AS DataFinal
    )

-- Consulta de ocorrências
    SELECT
        CONCAT(T.NUMOCORRENCIA, '-', CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103)) AS IDOCORRENCIA,
        T.NUMOCORRENCIA,
        CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103) AS DATAOCORRENCIA,
        O.TIPOOCORRENCIA AS SUBTIPOOCORRENCIA,
        O.DESCROCORRENCIA,
        C.ORIGEM,
        CONVERT(VARCHAR(12), T.HORAOCORRENCIA, 108) AS HORAOCORRENCIA,
        T.KM AS KM,
        T.KMCOMP AS MT,
        R.SIGLARODOVIA AS RODOVIA,
        S.SENTIDO,
        L.LOCALRODOVIA,
        T.LATITUDE,
        T.LONGITUDE,
        REPLACE(REPLACE( REPLACE( CAST( (
    SELECT
            OBS.OBSERVACAO AS [OBSERVACAO]
        FROM
            TABOCORRENCIASOBS OBS
        WHERE
        OBS.NUMOCORRENCIA = T.NUMOCORRENCIA
            AND OBS.DATAOCORRENCIA = T.DATAOCORRENCIA
        ORDER BY
        OBS.NUMOBSERVACAO
        FOR XML PATH('') ) AS VARCHAR(MAX) ),
        ' ',
        '; '),
        ' ',
        '; '),
        ' ',
        '; ') AS OBSERVACAO
    FROM
        TABOCORRENCIAS T
        LEFT JOIN TAUXTIPOSOCORRENCIAS O
        ON T.CODTIPOOCORRENCIA = O.CODTIPOOCORRENCIA
        LEFT JOIN TAUXORIGEMCHAMADO C
        ON C.CODORIGEM = T.CODORIGEM
        LEFT JOIN TAUXRODOVIAS R
        ON R.CODRODOVIA = T.CODRODOVIA
        LEFT JOIN TAUXSENTIDOS S
        ON S.CODSENTIDO = T.CODSENTIDO
        LEFT JOIN TAUXLOCAIS L
        ON L.CODLOCAL = T.CODLOCAL
    WHERE
    T.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)

UNION ALL

    -- Consulta de providências
    SELECT
        CONCAT(T.NUMOCORRENCIA, '-', CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103)) AS IDOCORRENCIA,
        T.NUMOCORRENCIA,
        CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103) AS DATAOCORRENCIA,
        J.PROVIDENCIA
    FROM
        TABOCORRENCIAS T
        INNER JOIN TABPROVIDENCIASTOMADAS P ON P.NUMOCORRENCIA = T.NUMOCORRENCIA AND P.DATAOCORRENCIA = T.DATAOCORRENCIA
        INNER JOIN TAUXTIPOSPROVIDENCIAS J
        ON J.CODPROVIDENCIA = P.CODPROVIDENCIA
    WHERE
    T.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)

UNION ALL

    -- Consulta de acidentes
    SELECT
        CONCAT(T.NUMOCORRENCIA,
    '-',
    CONVERT(VARCHAR(12),
    T.DATAOCORRENCIA,
    103)) AS IDOCORRENCIA,
        T.NUMOCORRENCIA,
        CONVERT(VARCHAR(12),
    T.DATAOCORRENCIA,
    103) AS DATAOCORRENCIA,
        O.TIPOOCORRENCIA AS SUBTIPOOCORRENCIA,
        AC.TIPOACIDENTE,
        AC.RELCLASS AS CLASSE,
        CP.CAUSAPROVAVEL,
        CM.CONDICAOMETEOROLOGICA,
        CV.CONDICAOVISIBILIDADE,
        PP.DESCRICAO AS PERFILPISTA
    FROM
        TABOCORRENCIAS T
        LEFT JOIN TABACIDENTES A
        ON A.NUMOCORRENCIA = T.NUMOCORRENCIA
            AND A.DATAOCORRENCIA = T.DATAOCORRENCIA
        LEFT JOIN TAUXTIPOSOCORRENCIAS O
        ON T.CODTIPOOCORRENCIA = O.CODTIPOOCORRENCIA
        LEFT JOIN TAUXTIPOSACIDENTES AC
        ON AC.CODTIPOACIDENTE = A.CODTIPOACIDENTE
        LEFT JOIN TAUXCAUSASPROVAVEIS CP
        ON CP.CODCAUSAPROVAVEL = A.CODCAUSAPROVAVEL
        LEFT JOIN TAUXCONDICOESMETEOROLOGICAS CM
        ON CM.CODCONDICAOMET = A.CODCONDICAOMET
        LEFT JOIN TAUXCONDICOESVISIBILIDADE CV
        ON CV.CODCONDICAOVIS = A.CODCONDICAOVIS
        LEFT JOIN TAUXANIMAISPERFILPISTA PP
        ON PP.CODPERFILPISTA = A.PERFILPISTA
    WHERE
    T.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)

UNION ALL

    -- Consulta de vitimas
    SELECT
        CONCAT(V.NUMOCORRENCIA, '-', CONVERT(VARCHAR(12), V.DATAOCORRENCIA, 103)) AS IDOCORRENCIA,
        V.NUMOCORRENCIA,
        CONVERT(VARCHAR(12), V.DATAOCORRENCIA, 103) AS DATAOCORRENCIA,
        NUMVEICULO,
        NUMVITIMA,
        V.CODCONDICAO,
        CASE V.CODCONDICAO
        WHEN -1 THEN 'Não informado'
        WHEN 0 THEN 'Aparentemente Ileso'
        WHEN 1 THEN 'Leve'
        WHEN 2 THEN 'Moderado'
        WHEN 5 THEN 'Grave'
        WHEN 7 THEN 'Óbito'
        WHEN 8 THEN 'PCR-Reanimação'
        WHEN 9 THEN 'Morte Evidente'
    END AS CONDICAO,
        V.IDADE,
        V.SEXO,
        POSICOES,
        IIF(V.SUSPEITAETILISMO = 0, 'NÃO', 'SIM') AS SUSPEITAETILISMO

    FROM
        TABVITIMAS V
    OUTER APPLY (
        SELECT STUFF((
                SELECT '; ' + P.DESCRPOSICAO
            FROM TAUXVITPOSICOES P
            WHERE P.CODTIPOPOSICAO = V.POSICAOORIGINAL
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),
            1, 2, '') AS POSICOES
    ) X
    WHERE
    V.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)

UNION ALL

    -- Consulta de veículos envolvidos
    SELECT
        V.NUMOCORRENCIA,
        CONVERT(VARCHAR(12), V.DATAOCORRENCIA, 103) AS DATAOCORRENCIA,
        V.NUMVEICULO,
        T.TIPOVEICULO,
        V.TOTALDEEIXOS
    FROM
        TABVEICULOSENVOLVIDOS V
        LEFT JOIN TAUXTIPOSVEICULOS T ON V.CODTIPOVEICULO = T.CODTIPOVEICULO
    WHERE
    V.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)

UNION ALL

    -- Consulta de recursos
    SELECT
        CONCAT(T.NUMOCORRENCIA, '-', CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103)) AS IDOCORRENCIA,
        T.NUMOCORRENCIA,
        CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103) AS DATAOCORRENCIA,
        A.PREFIXO AS RECURSOACIONADO,
        TA.TIPOATENDIMENTO,
        CONVERT(VARCHAR(8), R.HORAACIONAMENTO, 108) AS HORAACIONAMENTO,
        CONVERT(VARCHAR(8), R.HORACHEGADA, 108) AS HORACHEGADA
    FROM
        TABOCORRENCIAS T
        LEFT JOIN TABRECURSOSACIONADOS R
        ON R.NUMOCORRENCIA = T.NUMOCORRENCIA
            AND R.DATAOCORRENCIA = T.DATAOCORRENCIA
        LEFT JOIN TAUXRECURSOS A
        ON A.CODRECURSO = R.CODRECURSO
        LEFT JOIN TAuxTiposAtendimentos TA
        ON TA.CODTIPOATENDIMENTO = R.CODTIPOAT
    WHERE
    T.DATAOCORRENCIA BETWEEN (SELECT DataInicial
    FROM FiltroData) AND (SELECT DataFinal
    FROM FiltroData)
ORDER BY
    DATAOCORRENCIA,
    NUMOCORRENCIA,
    HORAACIONAMENTO;
