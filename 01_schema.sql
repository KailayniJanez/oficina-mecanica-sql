-- ===========================================
-- ARQUIVO: 01_schema.sql
-- DESCRIÇÃO: Criação do banco de dados e tabelas da oficina mecânica
-- AUTOR: Kailayni Rodrigues Janez
-- DATA: 2025-01-22
-- ===========================================

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipoPessoa ENUM('F', 'J') NOT NULL,
    documento VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    endereco VARCHAR(200)
);

-- Tabela Veiculo
CREATE TABLE Veiculo (
    idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    idCliente INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Servico (catálogo)
CREATE TABLE Servico (
    idServico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL,
    valorReferencia DECIMAL(10,2) NOT NULL
);

-- Tabela Peca
CREATE TABLE Peca (
    idPeca INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    valorUnitario DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

-- Tabela Equipe
CREATE TABLE Equipe (
    idEquipe INT PRIMARY KEY AUTO_INCREMENT,
    nomeEquipe VARCHAR(50) NOT NULL
);

-- Tabela Mecanico
CREATE TABLE Mecanico (
    idMecanico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50),
    salario DECIMAL(10,2),
    turno VARCHAR(20)
);

-- Tabela associativa Mecanico_Equipe
CREATE TABLE Mecanico_Equipe (
    idMecanico INT,
    idEquipe INT,
    dataInicio DATE NOT NULL,
    PRIMARY KEY (idMecanico, idEquipe, dataInicio),
    FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela OrdemServico
CREATE TABLE OrdemServico (
    idOS INT PRIMARY KEY AUTO_INCREMENT,
    dataEmissao DATE NOT NULL,
    dataConclusao DATE,
    valorTotal DECIMAL(10,2) DEFAULT 0,
    status ENUM('Aberta', 'Em Andamento', 'Concluída', 'Cancelada') DEFAULT 'Aberta',
    idVeiculo INT NOT NULL,
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
);

-- Tabela OS_Equipe (cada OS tem uma equipe responsável)
CREATE TABLE OS_Equipe (
    idOS INT,
    idEquipe INT,
    PRIMARY KEY (idOS, idEquipe),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela Item_Servico (serviços executados na OS)
CREATE TABLE Item_Servico (
    idItemServico INT PRIMARY KEY AUTO_INCREMENT,
    idOS INT NOT NULL,
    idServico INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valorUnitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- Tabela Item_Peca (peças utilizadas na OS)
CREATE TABLE Item_Peca (
    idItemPeca INT PRIMARY KEY AUTO_INCREMENT,
    idOS INT NOT NULL,
    idPeca INT NOT NULL,
    quantidade INT NOT NULL,
    valorUnitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);

-- Exibir mensagem de sucesso
SELECT 'Esquema criado com sucesso!' AS Mensagem;
