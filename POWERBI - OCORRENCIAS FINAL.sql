SELECT
	CONCAT(T.NUMOCORRENCIA,	'-'	CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 103)) AS IDOCORRENCIA,
	T.NUMOCORRENCIA,  
	CONVERT(VARCHAR(12), T.DATAOCORRENCIA, 	103) AS DATAOCORRENCIA,
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
		OBS.NUMOBSERVACAO FOR XML PATH('') ) AS VARCHAR(MAX) ),
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
		T.DATAOCORRENCIA BETWEEN '2023-01-01'
		AND DATEADD(DAY,
		-1,
		GETDATE())
	ORDER BY
		DATAOCORRENCIA,
		NUMOCORRENCIA