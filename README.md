# 🚗 Oficina Mecânica - Banco de Dados SQL

## 📋 Descrição do Projeto

Este projeto implementa um **banco de dados relacional** para uma oficina mecânica, permitindo gerenciar:

- ✅ Clientes (pessoa física e jurídica)
- ✅ Veículos
- ✅ Ordens de Serviço (OS)
- ✅ Serviços e Peças
- ✅ Equipes de Mecânicos
- ✅ Itens executados em cada OS

## 🗂️ Estrutura do Banco de Dados

### Tabelas Principais
- `Cliente` - Dados dos clientes
- `Veiculo` - Veículos associados aos clientes
- `OrdemServico` - OS geradas para cada veículo
- `Servico` - Catálogo de serviços oferecidos
- `Peca` - Catálogo de peças
- `Equipe` - Equipes de trabalho
- `Mecanico` - Funcionários
- `Item_Servico` - Serviços realizados em cada OS
- `Item_Peca` - Peças utilizadas em cada OS

### Relacionamentos Principais
- Um **Cliente** pode ter vários **Veículos**
- Um **Veículo** pode ter várias **OS**
- Uma **OS** tem uma **Equipe** responsável
- Uma **Equipe** tem vários **Mecânicos**
- Uma **OS** pode ter vários **Serviços** e **Peças**

## Autor
Kailayni Janez
