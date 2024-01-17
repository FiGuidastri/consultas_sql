SELECT
	R.Prefixo as Recurso,
	CONVERT(VARCHAR(12), T.DataMarcacao, 103) as Data,
	RO.SiglaRodovia as Rodovia,
	T.KM as KM,
	T.MT,
	S.Sentido,
	T.Velocidade as Velocidade,
	T.OBSPOSICAO

FROM 

	TabRecursosPerc T
	LEFT JOIN TauxRecursos R on R.CodRecurso = T.CodRecurso
	LEFT JOIN TAuxRodovias RO on RO.CodRodovia = T.CodRodovia
	LEFT JOIN TAuxSentidos S on S.CodSentido = T.CodSentido

WHERE DataMarcacao BETWEEN '2024-01-01' and '2024-01-17'
