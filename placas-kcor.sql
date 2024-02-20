SELECT
    V.PlacaVeiculo,
    TV.TipoVeiculo,
    V.ConteudoCarga,
	V.TotalDeEixos,
	V.NumEixosSuspensos,
	V.UsuarioID,
	V.CidadeVeiculo
	
FROM
    TabVeiculosEnvolvidos V
    LEFT JOIN TAuxTiposVeiculos TV ON V.CodTipoVeiculo = TV.CodTipoVeiculo
WHERE 
    V.PlacaVeiculo IS NOT NULL 
    AND V.PlacaVeiculo <> ''
    AND YEAR(V.DataOcorrencia) IN (2022, 2023, 2024);
