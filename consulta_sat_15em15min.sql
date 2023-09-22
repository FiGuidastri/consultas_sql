/*
Consulta para extrair dados do SAT de 15 em 15 minutos
Autor: Filipe Guidastri
Data: 21/09/2023
Servidor: 10.0.1.36
Banco:0888801_Radar
*/

SELECT
    Data,
    Hora,
    SUM(COALESCE(CASE WHEN Tipo = 'Passeio' THEN PassagensNorte ELSE 0 END, 0)) as PassagensNortePasseio,
    SUM(COALESCE(CASE WHEN Tipo = 'Passeio' THEN PassagensSul ELSE 0 END, 0)) as PassagensSulPasseio,
    SUM(COALESCE(CASE WHEN Tipo = 'Passeio' THEN PassagensLeste ELSE 0 END, 0)) as PassagensLestePasseio,
    SUM(COALESCE(CASE WHEN Tipo = 'Passeio' THEN PassagensOeste ELSE 0 END, 0)) as PassagensOestePasseio,
    SUM(COALESCE(CASE WHEN Tipo = 'Comercial' THEN PassagensNorte ELSE 0 END, 0)) as PassagensNorteComercial,
    SUM(COALESCE(CASE WHEN Tipo = 'Comercial' THEN PassagensSul ELSE 0 END, 0)) as PassagensSulComercial,
    SUM(COALESCE(CASE WHEN Tipo = 'Comercial' THEN PassagensLeste ELSE 0 END, 0)) as PassagensLesteComercial,
    SUM(COALESCE(CASE WHEN Tipo = 'Comercial' THEN PassagensOeste ELSE 0 END, 0)) as PassagensOesteComercial,
    AVG(COALESCE(CASE WHEN Tipo = 'Passeio' THEN VelMediaOeste ELSE 0 END, 0)) as VelMediaOestePasseio,
    AVG(COALESCE(CASE WHEN Tipo = 'Passeio' THEN VelMediaLeste ELSE 0 END, 0)) as VelMediaLestePasseio,
    AVG(COALESCE(CASE WHEN Tipo = 'Passeio' THEN VelMediaNorte ELSE 0 END, 0)) as VelMediaNortePasseio,
    AVG(COALESCE(CASE WHEN Tipo = 'Passeio' THEN VelMediaSul ELSE 0 END, 0)) as VelMediaSulPasseio,
    AVG(COALESCE(CASE WHEN Tipo = 'Comercial' THEN VelMediaOeste ELSE 0 END, 0)) as VelMediaOesteComercial,
    AVG(COALESCE(CASE WHEN Tipo = 'Comercial' THEN VelMediaLeste ELSE 0 END, 0)) as VelMediaLesteComercial,
    AVG(COALESCE(CASE WHEN Tipo = 'Comercial' THEN VelMediaNorte ELSE 0 END, 0)) as VelMediaNorteComercial,
    AVG(COALESCE(CASE WHEN Tipo = 'Comercial' THEN VelMediaSul ELSE 0 END, 0)) as VelMediaSulComercial

FROM (
    SELECT
        CONVERT(varchar(10), T.trf_dtt_DataHora, 120) as Data,
        CONVERT(varchar(8), DATEADD(MINUTE, (DATEDIFF(MINUTE, '00:00:00', T.trf_dtt_DataHora) / 15) * 15, '00:00:00'), 108) as Hora,
        CASE
            WHEN T.trf_dcm_Tmn < 2 THEN 'Moto'
            WHEN T.trf_dcm_Tmn >= 2 AND T.trf_dcm_Tmn <= 6.49 THEN 'Passeio'
            ELSE 'Comercial'
        END as Tipo,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Norte' THEN 1 ELSE 0 END, 0) as PassagensNorte,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Sul' THEN 1 ELSE 0 END, 0) as PassagensSul,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Leste' THEN 1 ELSE 0 END, 0) as PassagensLeste,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Oeste' THEN 1 ELSE 0 END, 0) as PassagensOeste,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Oeste' THEN T.trf_dcm_VlcAfr1 ELSE 0 END, 0) as VelMediaOeste,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Norte' THEN T.trf_dcm_VlcAfr1 ELSE 0 END, 0) as VelMediaNorte,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Sul' THEN T.trf_dcm_VlcAfr1 ELSE 0 END, 0) as VelMediaSul,
        COALESCE(CASE WHEN S.snt_vch_Dsc = 'Leste' THEN T.trf_dcm_VlcAfr1 ELSE 0 END, 0) as VelMediaLeste
    FROM
        tbl_Trf T
        JOIN tbl_Eqp E ON T.eqp_itg_ID = E.eqp_itg_ID
        JOIN tbl_Faixa F ON (F.eqp_itg_ID = E.eqp_itg_ID AND F.fxa_tyi_Faixa = T.trf_tyi_Faixa AND F.fxa_tyi_FaixaDch = T.trf_tyi_FaixaDch)
        JOIN tbl_Snt S ON F.snt_tyi_ID = S.snt_tyi_ID
    WHERE
        E.eqp_vch_CdgCln = 'SAT23'
        AND T.trf_dtt_DataHora BETWEEN '2023-07-07' AND '2023-09-20'
) AS Subquery
WHERE
    Tipo IN ('Passeio', 'Comercial')
GROUP BY
    Data,
    Hora
ORDER BY
    Data,
    Hora;
