SELECT * FROM 
					(SELECT 
							DISTINCT T.trf_big_ID AS ID,
							T.trf_chr_Placa AS Placa,
							CONVERT(varchar(12),T.trf_dtt_DataHora, 23) AS Data,
							CONVERT(varchar(12),T.trf_dtt_DataHora, 108) AS Hora,
							trf_dcm_VlcAfr1 AS VelMedia,
							trf_dcm_Tmn AS Comprimento,
							trf_tyi_Cls AS Classe,
							E.eqp_vch_CdgCln AS Equipamento,
							T.trf_tyi_Faixa AS Faixa,
							S.snt_vch_Dsc AS Sentido,
							CONCAT ('Km',' ',F.fxa_sml_Klm, '+', F.fxa_sml_Mts,' ','m') AS Localizacao,
							CASE E.eqp_vch_CdgCln
											WHEN 'RD001' THEN 'P1 - Avai'
											WHEN 'RD002' THEN 'P2 - Pirajui'
											WHEN 'RD003' THEN 'P3 - Promissao'
											WHEN 'SPL1692' THEN 'P8 - Castilho'
											WHEN 'SPL1714' THEN 'P4 - Glicerio'
											WHEN 'SPL1725' THEN 'P5 - Rubiacea'
											WHEN 'SPL1791' THEN 'P6 - Lavinia'
											WHEN 'SPL1798' THEN 'P7 - Guaraçaí'
											WHEN 'SPL1940' THEN 'P1 - Avai'
											WHEN 'SPL1950' THEN 'P2 - Pirajui'
											WHEN 'SPL1951' THEN 'P3 - Promissao'
											WHEN 'RD3319'	THEN 'Graal - Bauru'
											ELSE 'Radar'
										END Observacao,
							CASE 
											WHEN T.trf_dcm_Tmn< 2 THEN 'Moto' 
											WHEN T.trf_dcm_Tmn >= 2 AND T.trf_dcm_Tmn<=6.49 THEN  'Auto'	
											ELSE 'Comercial'
										END Tipo
		
							FROM tbl_Trf T
											JOIN tbl_Eqp E ON  T.eqp_itg_ID = E.eqp_itg_ID

											JOIN tbl_Faixa F ON (F.eqp_itg_ID = E.eqp_itg_ID AND F.fxa_tyi_Faixa = T.trf_tyi_Faixa AND F.fxa_tyi_FaixaDch=T.trf_tyi_FaixaDch)

											JOIN tbl_RadarEnd Re ON F.ren_itg_ID= Re.ren_itg_ID 

											JOIN tbl_Snt S ON F.snt_tyi_ID = S.snt_tyi_ID
    								
						)V

			  WHERE Data BETWEEN '20231001' AND '20231007'