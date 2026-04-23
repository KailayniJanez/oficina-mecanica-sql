-- ===========================================
-- ARQUIVO: 03_queries.sql
-- DESCRIÇÃO: Consultas SQL complexas para análise da oficina mecânica
-- AUTOR: Kalilayni Rodrigues Janez
-- DATA: 2025-01-22
-- ===========================================

USE oficina_mecanica;

-- ===========================================
-- QUERY 1: SELECT simples + WHERE + ORDER BY
-- PERGUNTA: Liste todas as peças com estoque abaixo de 10 unidades, 
-- ordenadas por valor unitário decrescente.
-- ===========================================

SELECT 
    nome AS Peça,
    valorUnitario AS 'Valor Unitário (R$)',
    estoque AS 'Quantidade em Estoque'
FROM Peca
WHERE estoque < 10
ORDER BY valorUnitario DESC;

-- ===========================================
-- QUERY 2: Atributo derivado + junção
-- PERGUNTA: Mostre o nome do cliente, placa do veículo, e o número 
-- de dias que a OS levou para ser concluída (quando concluída).
-- ===========================================

SELECT 
    c.nome AS Cliente,
    v.placa AS Placa,
    v.modelo AS Modelo,
    os.dataEmissao AS 'Data Emissão',
    os.dataConclusao AS 'Data Conclusão',
    DATEDIFF(os.dataConclusao, os.dataEmissao) AS 'Dias para Conclusão'
FROM OrdemServico os
JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
JOIN Cliente c ON v.idCliente = c.idCliente
WHERE os.status = 'Concluída'
ORDER BY 'Dias para Conclusão';

-- ===========================================
-- QUERY 3: Junção múltipla + HAVING + GROUP BY
-- PERGUNTA: Quais clientes gastaram mais de R$ 600 no total em OS? 
-- Exibir nome do cliente e total gasto.
-- ===========================================

SELECT 
    c.nome AS Cliente,
    COUNT(os.idOS) AS 'Quantidade de OS',
    SUM(os.valorTotal) AS 'Total Gasto (R$)'
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.idCliente
JOIN OrdemServico os ON v.idVeiculo = os.idVeiculo
GROUP BY c.idCliente, c.nome
HAVING SUM(os.valorTotal) > 600
ORDER BY 'Total Gasto (R$)' DESC;

-- ===========================================
-- QUERY 4: Junção complexa com visão de serviços e peças por OS
-- PERGUNTA: Exibir cada OS com detalhes: veículo, equipe responsável, 
-- valor total, e quantos mecânicos diferentes atuaram na equipe.
-- ===========================================

SELECT 
    os.idOS AS 'OS Nº',
    v.placa AS Placa,
    v.modelo AS Modelo,
    e.nomeEquipe AS Equipe,
    os.valorTotal AS 'Valor Total (R$)',
    os.status AS Status,
    COUNT(DISTINCT me.idMecanico) AS 'Qtd Mecânicos na Equipe'
FROM OrdemServico os
JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
JOIN OS_Equipe ose ON os.idOS = ose.idOS
JOIN Equipe e ON ose.idEquipe = e.idEquipe
LEFT JOIN Mecanico_Equipe me ON e.idEquipe = me.idEquipe
GROUP BY os.idOS, v.placa, v.modelo, e.nomeEquipe, os.valorTotal, os.status
ORDER BY os.valorTotal DESC;

-- ===========================================
-- QUERY 5: Filtro com WHERE + junção + ORDER BY
-- PERGUNTA: Liste as OS "Em Andamento" ou "Aberta", com o nome do 
-- cliente, data de emissão e equipe responsável.
-- ===========================================

SELECT 
    os.idOS AS 'OS Nº',
    c.nome AS Cliente,
    v.placa AS Placa,
    os.dataEmissao AS 'Data Emissão',
    e.nomeEquipe AS 'Equipe Responsável',
    os.status AS Status
FROM OrdemServico os
JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
JOIN Cliente c ON v.idCliente = c.idCliente
JOIN OS_Equipe ose ON os.idOS = ose.idOS
JOIN Equipe e ON ose.idEquipe = e.idEquipe
WHERE os.status IN ('Aberta', 'Em Andamento')
ORDER BY os.dataEmissao DESC;

-- ===========================================
-- QUERY 6: Expressão derivada + HAVING (agregação)
-- PERGUNTA: Quais serviços foram executados mais de 1 vez no total 
-- (somatória de quantidades) e tiveram faturamento médio acima de R$ 150?
-- ===========================================

SELECT 
    s.descricao AS Serviço,
    SUM(iserv.quantidade) AS 'Total Vezes Executado',
    AVG(iserv.valorUnitario) AS 'Preço Médio por Unidade (R$)',
    SUM(iserv.quantidade * iserv.valorUnitario) AS 'Faturamento Total (R$)'
FROM Item_Servico iserv
JOIN Servico s ON iserv.idServico = s.idServico
GROUP BY s.idServico, s.descricao
HAVING SUM(iserv.quantidade) > 1 AND AVG(iserv.valorUnitario) > 150
ORDER BY 'Faturamento Total (R$)' DESC;

-- ===========================================
-- QUERY 7: Junção entre 5 tabelas com filtro e ordenação
-- PERGUNTA: Mostre todos os itens de peça utilizados, com nome da peça, 
-- placa do veículo, nome do cliente e status da OS, apenas para OS concluídas.
-- ===========================================

SELECT 
    p.nome AS Peça,
    ip.quantidade AS Quantidade,
    ip.valorUnitario AS 'Valor Unitário (R$)',
    (ip.quantidade * ip.valorUnitario) AS 'Subtotal (R$)',
    v.placa AS Placa,
    v.modelo AS Modelo,
    c.nome AS Cliente,
    os.idOS AS 'OS Nº',
    os.status AS Status
FROM Item_Peca ip
JOIN Peca p ON ip.idPeca = p.idPeca
JOIN OrdemServico os ON ip.idOS = os.idOS
JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
JOIN Cliente c ON v.idCliente = c.idCliente
WHERE os.status = 'Concluída'
ORDER BY ip.valorUnitario DESC, c.nome;

-- ===========================================
-- QUERY 8 (BÔNUS): Relatório completo de faturamento por equipe
-- PERGUNTA: Qual o faturamento total gerado por cada equipe?
-- ===========================================

SELECT 
    e.nomeEquipe AS Equipe,
    COUNT(DISTINCT os.idOS) AS 'OS Realizadas',
    SUM(os.valorTotal) AS 'Faturamento Total (R$)',
    AVG(os.valorTotal) AS 'Ticket Médio (R$)',
    ROUND(SUM(os.valorTotal) / COUNT(DISTINCT os.idOS), 2) AS 'Média por OS'
FROM Equipe e
JOIN OS_Equipe ose ON e.idEquipe = ose.idEquipe
JOIN OrdemServico os ON ose.idOS = os.idOS
WHERE os.status = 'Concluída'
GROUP BY e.idEquipe, e.nomeEquipe
ORDER BY 'Faturamento Total (R$)' DESC;

-- ===========================================
-- QUERY 9 (BÔNUS): Mecânicos mais requisitados
-- PERGUNTA: Quais mecânicos participaram de mais OS diferentes?
-- ===========================================

SELECT 
    m.nome AS Mecânico,
    m.especialidade AS Especialidade,
    COUNT(DISTINCT ose.idOS) AS 'OS Participadas',
    COUNT(DISTINCT e.idEquipe) AS 'Equipes Diferentes'
FROM Mecanico m
JOIN Mecanico_Equipe me ON m.idMecanico = me.idMecanico
JOIN Equipe e ON me.idEquipe = e.idEquipe
JOIN OS_Equipe ose ON e.idEquipe = ose.idEquipe
GROUP BY m.idMecanico, m.nome, m.especialidade
ORDER BY 'OS Participadas' DESC
LIMIT 5;

-- Fim das queries
SELECT 'Todas as queries foram executadas com sucesso!' AS Mensagem;
