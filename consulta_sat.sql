/*
Consulta para extrair dados do SAT passagens únicas
Autor: Filipe Guidastri
Data: 21/09/2023
Servidor: 10.0.1.36
Banco:0888801_Radar
*/

SELECT
	T.trf_big_ID as ID,
	CONVERT(varchar(12), T.trf_dtt_DataHora, 23) as Data,
	CONVERT(varchar(12), T.trf_dtt_DataHora, 108) as Hora,
	T.trf_dcm_VlcAfr1 as VelMedia,
	T.trf_dcm_Tmn as Comprimento,
	T.trf_tyi_Cls as Classe,
	T.trf_tyi_Faixa as Faixa,
	S.snt_vch_Dsc as Sentido,
	E.eqp_vch_CdgCln as Eqp,
	CASE 
		WHEN T.trf_dcm_Tmn< 2 THEN 'Moto' 
		WHEN T.trf_dcm_Tmn >= 2 AND T.trf_dcm_Tmn<=6.49 THEN  'Passeio'	
		ELSE 'Comercial'
		END Tipo
		


FROM
	tbl_Trf T
		JOIN tbl_Eqp E ON T.eqp_itg_ID = E.eqp_itg_ID
		JOIN tbl_Faixa F ON (F.eqp_itg_ID = E.eqp_itg_ID AND F.fxa_tyi_Faixa = T.trf_tyi_Faixa AND F.fxa_tyi_FaixaDch = T.trf_tyi_FaixaDch)
		JOIN tbl_Snt S ON F.snt_tyi_ID = S.snt_tyi_ID

WHERE
	E.eqp_vch_CdgCln = 'SAT23'
	and
	T.trf_dtt_DataHora BETWEEN '2023-07-07' and '2023-09-20'

ORDER BY
	Data
