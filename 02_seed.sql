-- ===========================================
-- ARQUIVO: 02_seed.sql
-- DESCRIÇÃO: Inserção de dados de teste para a oficina mecânica
-- AUTOR: Kailayni Rodrigues Janez
-- DATA: 2025-01-22
-- ===========================================

USE oficina_mecanica;

-- Inserção de clientes
INSERT INTO Cliente (nome, tipoPessoa, documento, telefone, endereco) VALUES
('João Silva', 'F', '12345678900', '11999998888', 'Rua A, 100, São Paulo - SP'),
('Maria Oliveira', 'F', '98765432100', '11988887777', 'Rua B, 200, São Paulo - SP'),
('Oficina Matriz Ltda', 'J', '11223344000155', '1133334444', 'Av. Central, 500, São Paulo - SP'),
('Carlos Santos', 'F', '45678912300', '11977776666', 'Rua C, 300, São Paulo - SP');

-- Inserção de veículos
INSERT INTO Veiculo (placa, modelo, marca, ano, idCliente) VALUES
('ABC1D23', 'Civic', 'Honda', 2020, 1),
('XYZ9E87', 'Uno', 'Fiat', 2015, 2),
('JKL0F45', 'Corolla', 'Toyota', 2022, 3),
('MNO3G67', 'Gol', 'Volkswagen', 2018, 4),
('PQR8H90', 'Onix', 'Chevrolet', 2021, 1);

-- Inserção de serviços (catálogo)
INSERT INTO Servico (descricao, valorReferencia) VALUES
('Troca de óleo', 120.00),
('Alinhamento e balanceamento', 150.00),
('Revisão completa', 350.00),
('Troca de pastilhas de freio', 180.00),
('Troca de correia dentada', 450.00),
('Diagnóstico eletrônico', 200.00);

-- Inserção de peças
INSERT INTO Peca (nome, valorUnitario, estoque) VALUES
('Filtro de óleo', 35.00, 10),
('Óleo 5W30 (1L)', 45.00, 20),
('Pastilha de freio dianteira', 120.00, 5),
('Pastilha de freio traseira', 110.00, 8),
('Correia dentada', 250.00, 3),
('Vela de ignição', 25.00, 15),
('Filtro de ar', 40.00, 12);

-- Inserção de equipes
INSERT INTO Equipe (nomeEquipe) VALUES 
('Manutenção Leve'), 
('Suspensão e Freios'),
('Motor e Transmissão'),
('Elétrica e Diagnóstico');

-- Inserção de mecânicos
INSERT INTO Mecanico (nome, especialidade, salario, turno) VALUES
('Carlos Mecânico', 'Motor', 3500.00, 'Diurno'),
('Roberto Freios', 'Freios', 3800.00, 'Diurno'),
('André Alinhamento', 'Suspensão', 3200.00, 'Noturno'),
('Fernando Elétrica', 'Elétrica', 4000.00, 'Diurno'),
('Ricardo Motor', 'Motor', 4200.00, 'Noturno');

-- Inserção de mecânicos nas equipes
INSERT INTO Mecanico_Equipe VALUES
(1, 1, '2024-01-01'),
(1, 3, '2024-03-10'),
(2, 2, '2024-01-01'),
(3, 2, '2024-02-15'),
(4, 4, '2024-01-01'),
(5, 3, '2024-01-01');

-- Inserção de ordens de serviço
INSERT INTO OrdemServico (dataEmissao, dataConclusao, status, idVeiculo) VALUES
('2025-01-10', '2025-01-12', 'Concluída', 1),
('2025-01-15', NULL, 'Em Andamento', 2),
('2025-01-18', NULL, 'Aberta', 3),
('2025-01-05', '2025-01-08', 'Concluída', 4),
('2025-01-20', NULL, 'Aberta', 5);

-- Inserção de OS -> Equipe
INSERT INTO OS_Equipe VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 2), 
(5, 4);

-- Inserção de itens de serviço
INSERT INTO Item_Servico (idOS, idServico, quantidade, valorUnitario) VALUES
(1, 1, 1, 120.00),
(1, 2, 1, 150.00),
(2, 4, 1, 180.00),
(3, 3, 1, 350.00),
(3, 5, 1, 450.00),
(4, 1, 1, 120.00),
(4, 2, 1, 150.00),
(5, 6, 1, 200.00);

-- Inserção de itens de peça
INSERT INTO Item_Peca (idOS, idPeca, quantidade, valorUnitario) VALUES
(1, 1, 1, 35.00),
(1, 2, 4, 45.00),
(2, 3, 2, 120.00),
(3, 5, 1, 250.00),
(3, 6, 4, 25.00),
(4, 1, 1, 35.00),
(4, 2, 3, 45.00),
(5, 7, 1, 40.00);

-- Atualização dos valores totais das OS
UPDATE OrdemServico os
SET valorTotal = (
    SELECT COALESCE(SUM(quantidade * valorUnitario), 0) 
    FROM Item_Servico WHERE idOS = os.idOS
) + (
    SELECT COALESCE(SUM(quantidade * valorUnitario), 0) 
    FROM Item_Peca WHERE idOS = os.idOS
);

-- Exibir mensagem de sucesso
SELECT 'Dados inseridos com sucesso!' AS Mensagem;
SELECT 'Ordens de Serviço:' AS Info;
SELECT idOS, valorTotal, status FROM OrdemServico;
