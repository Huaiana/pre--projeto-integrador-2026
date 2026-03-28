CREATE TABLE categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
); 
CREATE INDEX idx_categoria_nome ON categoria(nome);


CREATE TABLE metodo_pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE fornecedor (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_empresa VARCHAR(150) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);
CREATE INDEX idx_forn_cnpj ON fornecedor(cnpj);
CREATE INDEX idx_forn_nome_empresa ON fornecedor(nome_empresa);

CREATE TABLE usuario (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    genero VARCHAR(20),
    idade INT,
    endereco VARCHAR(255),
    senha VARCHAR(255),
    instagram VARCHAR(100)
);
CREATE INDEX idx_usuario_nome ON usuario(nome);
CREATE INDEX idx_usuario_email ON usuario(email);
 
CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefone VARCHAR(20),
    genero VARCHAR(20),
    idade INT,
    cargo VARCHAR(100),
    login VARCHAR(50) UNIQUE,
    senha VARCHAR(255) 
);
CREATE INDEX idx_func_nome ON funcionario(nome);
CREATE INDEX idx_func_cargo ON funcionario(cargo);
CREATE INDEX idx_func_email ON funcionario(email);

CREATE TABLE produto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(150) NOT NULL,
    tamanho VARCHAR(50),
    cor VARCHAR(50),
    codigo_barras VARCHAR(50) UNIQUE,
    valor_custo DECIMAL(10,2),
    valor_venda DECIMAL(10,2),
    estoque_atual INT DEFAULT 0,
    categoria_id INTEGER,
    fornecedor_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id)
);
CREATE INDEX idx_prod_nome ON produto(nome);
CREATE INDEX idx_prod_categoria_id ON produto(categoria_id);
CREATE INDEX idx_prod_fornecedor_id ON produto(fornecedor_id);


CREATE TABLE pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER,
    funcionario_id INTEGER,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total_pedido DECIMAL(10,2) DEFAULT 0.00,
    status_pedido VARCHAR(50) DEFAULT 'Pendente',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionario(id)
);
CREATE INDEX idx_ped_usuario_id ON pedido(usuario_id);
CREATE INDEX idx_ped_funcionario_id ON pedido(funcionario_id);
CREATE INDEX idx_ped_data_pedido ON pedido(data_pedido);


CREATE TABLE item_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER,
    produto_id INTEGER,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2),
    data_hora DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id),
    FOREIGN KEY (produto_id) REFERENCES produto(id)
);
CREATE INDEX idx_item_pedido_id ON item_pedido(pedido_id);
CREATE INDEX idx_item_produto_id ON item_pedido(produto_id);

CREATE TABLE pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER,
    metodo_id INTEGER,
    valor_pago DECIMAL(10,2),
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_transacao VARCHAR(50),
    FOREIGN KEY (pedido_id) REFERENCES pedido(id),
    FOREIGN KEY (metodo_id) REFERENCES metodo_pagamento(id)
);
CREATE INDEX idx_pag_pedido_id ON pagamento(pedido_id);
CREATE INDEX idx_pag_status_transacao ON pagamento(status_transacao);


CREATE TABLE estoque (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produto_id INTEGER,
  quantidade_movimentada INT NOT NULL,
  tipo_movimentacao VARCHAR(10),
  CHECK(tipo_movimentacao IN ('E','S')),
  data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (produto_id) REFERENCES produto(id)
  );
  
CREATE INDEX idx_estoque_produto ON estoque(produto_id);
  
CREATE TRIGGER atualizar_estoque_entrada
AFTER INSERT ON estoque
WHEN NEW.tipo_movimentacao = 'E'
BEGIN
   UPDATE produto
   SET estoque_atual = estoque_atual + NEW.quantidade_movimentada
   WHERE id = NEW.produto_id;
END;

CREATE TRIGGER atualizar_estoque_saida
AFTER INSERT ON estoque
WHEN NEW.tipo_movimentacao = 'S'
BEGIN
   UPDATE produto
   SET estoque_atual = estoque_atual - NEW.quantidade_movimentada
   WHERE id = NEW.produto_id;
END;

INSERT INTO categoria (id, nome, descricao)
VALUES
(1,'Camiseta','camiseta simples'),
(2,'Calça','calça de alfaiataria'),
(3,'Calçado','calçado preto'),
(4,'Casaco','casaco de veludo'),
(5,'Bermuda','bermuda floral'),
(6,'Acessório','acessório prata');

SELECT * FROM categoria;

INSERT INTO metodo_pagamento (id,nome) VALUES
(1,'Cartão de Crédito'),
(2,'PIX'),
(3,'Dinheiro');

SELECT * FROM metodo_pagamento;

INSERT INTO fornecedor ( id, nome_empresa, cnpj, endereco, telefone, email)
VALUES
(1, 'Fornecedor XYZ', '12.345.678/0001-01', 'Rua Benjamin Constant, 34', '13999999999', 'fornecedorxyz@email.com'),
(2, 'Jeans Brasil', '23.456.789/0001-02', 'Rua das Flores, 123', '13988888888', 'jeansbrasil@email.com'),
(3, 'Sports Max', '34.567.890/0001-03', 'Av. Santos Dumont, 45', '13977777777', 'sportsmax@email.com'),
(4, 'Couro Real', '45.678.901/0001-04', 'Rua Brasil, 100', '13966666666', 'couroreal@email.com'),
(5, 'Moda Verão', '56.789.012/0001-05', 'Rua Bahia, 89', '13955555555', 'modaverao@email.com'),
(6, 'Estilo Masculino', '67.890.123/0001-06', 'Av. Dom Pedro, 210', '13944444444', 'estilomasculino@email.com'),
(7, 'Classic Wear', '78.901.234/0001-07', 'Rua Pará, 67', '13933333333', 'classicwear@email.com'),
(8, 'Fashion Kids', '89.012.345/0001-08', 'Rua São Paulo, 400', '13922222222', 'fashionkids@email.com'),
(9, 'Inverno Quente', '90.123.456/0001-09', 'Av. Atlântica, 150', '13911111111', 'invernoquente@email.com'),
(10, 'Acessórios & Cia', '01.234.567/0001-10', 'Praça 14 Bis', '13997863546', 'acessoriosecia@email.com');

SELECT * FROM fornecedor;

INSERT INTO usuario ( id, nome, email, telefone, genero, idade, endereco, senha, instagram)
VALUES
(1, 'murilo', 'murilo@gmail.com', '13999999999', 'masculino', 20, 'rua beijamin constant n34', 'mu123', '@mu_cavalcante'),
(2, 'joao', 'joao@gmail.com', '13988888888', 'masculino', 19, 'rua das flores 120', 'joao123', '@joaosilva'),
(3, 'ana', 'ana@gmail.com', '13977777777', 'feminino', 22, 'av santos dumont 45', 'ana123', '@anacosta'),
(4, 'carlos', 'carlos@gmail.com', '13966666666', 'masculino', 25, 'rua brasil 300', 'carlos123', '@carlosoliveira'),
(5, 'mariana', 'mariana@gmail.com', '13955555555', 'feminino', 20, 'rua bahia 89', 'mari123', '@marisantos'),
(6, 'lucas', 'lucas@gmail.com', '13944444444', 'masculino', 23, 'av dom pedro 210', 'lucas123', '@lucasferreira'),
(7, 'beatriz', 'beatriz@gmail.com', '13933333333', 'feminino', 21, 'rua para 67', 'bia123', '@beatrizlima'),
(8, 'rafael', 'rafael@gmail.com', '13922222222', 'masculino', 24, 'rua sao paulo 400', 'rafa123', '@rafaelrocha'),
(9, 'juliana', 'juliana@gmail.com', '13911111111', 'feminino', 26, 'av atlântica 150', 'ju123', '@julianamoraes'),
(10, 'victor' , 'victorpergentino@gmail.com', '13997863546', 'masculino', 19, 'praca 14 bis' , 'victor123' , '@pergentino');

SELECT * FROM usuario;

INSERT INTO funcionario ( id, nome, email, telefone, genero, idade, cargo, login, senha)
VALUES
(1, 'Ricardo Almeida', 'ricardo@pro.com', '11911112222', 'Masculino', 30, 'Proprietario', 'ricardo.proprietario', 'RiUs123'),
(2, 'Fernanda Souza', 'fernanda@empresa.com', '11922223333', 'Feminino', 25, 'Vendedora', 'fernanda.vendas', 'fefê2024'),
(3, 'Bruno Rocha', 'bruno@empresa.com', '11955556666', 'Masculino', 35, 'Vendedor', 'bruno.vendas', 'bruno88'),
(4, 'Camila Alves', 'camila@empresa.com', '11966667777', 'Feminino', 27, 'Caixa', 'camila.caixa', 'cami77'),
(5, 'Diego Ferreira', 'diego@empresa.com', '11977778888', 'Masculino', 24, 'Assistente', 'diego.admin', 'diego10'),
(6, 'Gabriel Melo', 'gabriel@empresa.com', '11999990000', 'Masculino', 21, 'Estoquista', 'gabriel.estoque', 'gab123'),
(7, 'Larissa Mendes', 'larissa@empresa.com', '11900001111', 'Feminino', 26, 'Vendedora', 'larissa.vendas', 'lari2024');

SELECT * FROM funcionario;

INSERT INTO produto 
(id,nome,tamanho,cor,codigo_barras,valor_custo,valor_venda,estoque_atual,categoria_id,fornecedor_id)
VALUES

(1,'Camisa de Botão','M','Verde','001012340987',90,150,10,1,1),
(2,'Calça Jeans Slim','42','Azul Escuro','001012340988',45,129.90,15,2,2),
(3,'Tênis Esportivo','40','Preto','001012340989',85.50,199,10,3,3),
(4,'Jaqueta de Couro','G','Marrom','001012340990',120,350,5,4,4),
(5,'Bermuda Sarja','44','Bege','001012340991',35.20,89.90,25,5,5),
(6,'Bermuda Floral','M','Estampado','001012340992',55,145,12,5,6),
(7,'Camisa Polo','GG','Azul Marinho','001012340993',28,79.90,30,1,7),
(8,'Calça Linho','46','Bege','001012340994',40,110,8,2,8),
(9,'Blusa de Lã','M','Cinza','001012340995',65.40,159.90,20,4,9),
(10,'Cinto de Couro','U','Preto','001012340996',15,45,50,6,10);

SELECT * FROM produto;

INSERT INTO pedido (id, usuario_id, funcionario_id, valor_total_pedido, status_pedido)
VALUES
(1,1,2,150,'Pago'),
(2,2,3,129.90,'Pendente'),
(3,3,2,199,'Pago'),
(4,4,3,350,'Pendente'),
(5,5,2,179.80,'Estornado'),
(6,1,2,145,'Pago'),
(7,2,3,239.70,'Pago'),
(8,3,2,110,'Pago'),
(9,4,3,159.90,'Pago'),
(10,5,2,90,'Pago');

SELECT * FROM pedido;

INSERT into item_pedido ( id, pedido_id, produto_id, quantidade, valor_unitario, data_hora)
VALUES
(1, 1, 1, 1, 100.00, '2026-02-10 10:30:00'),
(2, 2, 2, 1, 129.90, '2026-01-30 11:15:00'),
(3, 3, 3, 1, 199.00, '2026-01-24 14:00:00'),
(4, 4, 4, 1, 350.00, '2026-02-12 09:45:00'),
(5, 5, 5, 2, 179.80, '2026-03-21 15:20:00'),
(6, 6, 6, 1, 145.00, '2026-02-22 10:00:00'),
(7, 7, 7, 3, 239.70, '2026-01-08 16:30:00'),
(8, 8, 8, 1, 110.00, '2026-02-16 11:10:00'),
(9, 9, 9, 1, 159.90, '2026-03-07 13:45:00'),
(10, 10, 10, 2, 90.00, '2026-03-02 17:00:00');

SELECT * FROM item_pedido;

INSERT INTO pagamento
(id,pedido_id,metodo_id,valor_pago,status_transacao)
VALUES
(1,1,2,100,'Aprovado'),
(2,2,1,129.90,'Aprovado'),
(3,3,2,199,'Aprovado'),
(4,4,1,350,'Aprovado'),
(5,5,3,179.80,'Aprovado');

SELECT * FROM pagamento;
    
INSERT INTO estoque
(produto_id,quantidade_movimentada,tipo_movimentacao)
 VALUES
(2,15,'E');

INSERT INTO estoque
(produto_id,quantidade_movimentada,tipo_movimentacao)
VALUES
(10,50,'E');

INSERT INTO estoque
(produto_id, quanidade_movimentada, tipo_movimentacao)
VALUES
(1, 2, 'S');
    
SELECT * FROM estoque;  
SELECT id, nome, estoque_atual FROM produto;

-- Ex 1: Pedidos pendentes
SELECT * FROM pedido WHERE status_pedido = 'Pendente';

-- Ex 2: Pedidos acima de 100
SELECT id, valor_total_pedido, status_pedido FROM pedido WHERE valor_total_pedido > 100;

-- Ex 3: Itens de um pedido específico
SELECT * FROM item_pedido WHERE pedido_id = 1;

-- Ex 4: Pedidos de um usuário específico
SELECT * FROM pedido WHERE usuario_id = 1;

-- Ex 5: Filtro por data
SELECT * FROM pedido WHERE data_pedido BETWEEN '2026-01-01' AND '2026-12-31';

SELECT nome,estoque_atual FROM produto WHERE estoque_atual < 10;

SELECT SUM(estoque_atual * valor_custo) AS valor_patrimonial FROM produto;

-- Ex 6 a 9: Atualizações de Status e Valores
UPDATE pedido SET status_pedido = 'Entregue' WHERE id = 1;

UPDATE pedido SET valor_total_pedido = 950.00 WHERE id = 2;

UPDATE pedido SET status_pedido = 'Retirada' WHERE id = 3;

UPDATE pedido SET status_pedido = 'Cancelado' WHERE status_pedido = 'Pendente';

-- Ex 10 e 11: Atualização em Itens
UPDATE item_pedido SET quantidade = 3 WHERE pedido_id = 1 AND produto_id = 1;

UPDATE item_pedido SET valor_unitario = valor_unitario * 0.85 WHERE pedido_id = 5;

-- Ex 12: Relacionamento Produto e Categoria
SELECT produto.nome AS Produto, categoria.nome AS Categoria
FROM produto
JOIN categoria ON produto.categoria_id = categoria.id;

-- Ex 13: Relacionamento Pedido e Usuário
SELECT usuario.nome, pedido.id, pedido.valor_total_pedido
FROM pedido
JOIN usuario ON pedido.usuario_id = usuario.id;

-- Ex 14: Relacionamento Itens e Produto
SELECT produto.nome, item_pedido.quantidade
FROM item_pedido
JOIN produto ON item_pedido.produto_id = produto.id;

-- Ex 15: Relacionamento Produto e Fornecedor
SELECT produto.nome, fornecedor.nome_empresa
FROM produto
JOIN fornecedor ON produto.fornecedor_id = fornecedor.id;

-- Ex 16: Relacionamento Completo (Usuário, Pedido e Pagamento)
SELECT usuario.nome, pedido.id, pagamento.status_transacao
FROM pedido
JOIN usuario ON pedido.usuario_id = usuario.id
JOIN pagamento ON pagamento.pedido_id = pedido.id;

SELECT p.nome AS Produto, e.tipo_movimentacao AS Operacao, e.quantidade_movimentada AS Qtd, e.data_movimentacao AS DATA
FROM estoque e
JOIN produto p ON e.produto_id = p.id;