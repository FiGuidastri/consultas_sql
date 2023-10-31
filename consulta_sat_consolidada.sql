/*
Consulta para extrair dados do SAT passagens únicas
Autor: Filipe Guidastri
Data: 31/10/2023
Servidor: 10.0.1.36
Banco:0888801_Radar
*/

SELECT
    COUNT(T.trf_big_ID) as QTD_Passagens,
	CONVERT(varchar(12), T.trf_dtt_DataHora, 23) as Data,
	T.trf_tyi_Cls as Classe,
	T.trf_tyi_Faixa as Faixa,
	S.snt_vch_Dsc as Sentido,
	E.eqp_vch_CdgCln as Eqp,
	CASE 
		WHEN T.trf_dcm_Tmn < 2 THEN 'Moto' 
		WHEN T.trf_dcm_Tmn >= 2 AND T.trf_dcm_Tmn <= 6.49 THEN  'Passeio'	
		ELSE 'Comercial'
		END Tipo

FROM
	tbl_Trf T
	JOIN tbl_Eqp E ON T.eqp_itg_ID = E.eqp_itg_ID
	JOIN tbl_Faixa F ON (F.eqp_itg_ID = E.eqp_itg_ID AND F.fxa_tyi_Faixa = T.trf_tyi_Faixa AND F.fxa_tyi_FaixaDch = T.trf_tyi_FaixaDch)
	JOIN tbl_Snt S ON F.snt_tyi_ID = S.snt_tyi_ID

WHERE
	T.trf_dtt_DataHora BETWEEN '2023-01-01' and DATEADD(DAY, -1, GETDATE())
GROUP BY
	CONVERT(varchar(12), T.trf_dtt_DataHora, 23), T.trf_tyi_Cls, T.trf_tyi_Faixa, S.snt_vch_Dsc, E.eqp_vch_CdgCln, T.trf_dcm_Tmn

ORDER BY
	Data, Eqp, Tipo
