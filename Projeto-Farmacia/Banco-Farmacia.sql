-- Recriar o banco (cuidado em produção)
DROP DATABASE IF EXISTS farmacia_db;
CREATE DATABASE farmacia_db;
USE farmacia_db;

-- Tabela de usuários (admin ou vendedor)
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  nivel ENUM('admin', 'vendedor') NOT NULL
);

-- Tabela de clientes
CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  telefone VARCHAR(20),
  endereco TEXT
);

-- Tabela de produtos (medicamentos, cosméticos, higiene etc.)
CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  fabricante VARCHAR(100),
  validade DATE,
  preco DECIMAL(10,2) NOT NULL,
  quantidade_estoque INT DEFAULT 0,
  tipo ENUM('medicamento', 'cosmetico', 'higiene', 'outro') DEFAULT 'outro',
  tarja ENUM('vermelha', 'preta', 'isenta') DEFAULT 'isenta',
  exige_receita BOOLEAN DEFAULT FALSE,
  descricao TEXT
);

-- Tabela de vendas (presenciais e online)
CREATE TABLE vendas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_funcionario INT,
  data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) NOT NULL,
  tipo ENUM('presencial', 'online') DEFAULT 'presencial',
  status ENUM('pendente', 'em preparo', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
  endereco_entrega TEXT,
  forma_pagamento VARCHAR(50),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE SET NULL,
  FOREIGN KEY (id_funcionario) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Itens de cada venda (referência à tabela produtos)
CREATE TABLE itens_venda (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_venda INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_venda) REFERENCES vendas(id) ON DELETE CASCADE,
  FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

-- Carrinho do cliente (opcional: pode ser salvo localmente)
CREATE TABLE carrinho (
  id_cliente INT,
  id_produto INT,
  quantidade INT DEFAULT 1,
  PRIMARY KEY (id_cliente, id_produto),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE,
  FOREIGN KEY (id_produto) REFERENCES produtos(id)
);
