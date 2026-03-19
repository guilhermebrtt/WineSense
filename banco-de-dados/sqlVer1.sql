-- Banco de dados wineSense
CREATE DATABASE wineSense;
USE wineSense;

-- Tabela empresa para guardar os dados da empresa cliente do sistema
CREATE TABLE empresa(
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	email VARCHAR(60) UNIQUE,
	telefone VARCHAR(20),
	endereco VARCHAR(50)
);

-- Tabela usuário que vai guardar os dados de acesso do usuário que vai acessar o banco/ dashboard
CREATE TABLE usuario(
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(40) NOT NULL,
	sobrenome VARCHAR(40) NOT NULL,
	email VARCHAR(60) NOT NULL UNIQUE,
	telefone VARCHAR(20),
	senha VARCHAR(20) NOT NULL,
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE uva(
	idUva INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(20),
	tempMinima INT,
	tempMaxima INT
);

-- Tabela para guardar os dados dos tipos de vinho produzidos pela empresa
CREATE TABLE vinho(
	idVinho INT PRIMARY KEY AUTO_INCREMENT,
	fkUva INT, 
	FOREIGN KEY (fkUva) REFERENCES uva(idUva),
	tipoVinho VARCHAR(20) NOT NULL,
	tempMinima INT,
	tempMaxima INT,
	CONSTRAINT cTipo CHECK (tipoVinho IN('Branco', 'Tinto'))
);

-- Tabela para guardar os dados do sensor, como em que tanque ele está localizado na empresa contratante
CREATE TABLE sensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
	tanqueLocalizado VARCHAR(20) NOT NULL,
	codSensor INT NOT NULL,
	tempAtual DECIMAL (4,1),
	condicao VARCHAR(20),
	CONSTRAINT condicaoC CHECK(condicao IN ('Funcionando', 'Defeituoso'))
);

CREATE TABLE tanque(
	idTanque INT PRIMARY KEY AUTO_INCREMENT,
    codTanque VARCHAR(30) NOT NULL,
    localTanque VARCHAR (50),
    tempMedia DECIMAL(3,1),
    fkSensor INT,
	FOREIGN KEY (fkSensor) REFERENCES sensor (idSensor),
    fkVinho INT,
    FOREIGN KEY (fkVinho) REFERENCES vinho (idVinho),
    fkEmpresa INT, 
	FOREIGN KEY (fkEmpresa) REFERENCES empresa (idEmpresa)
);

-- Tabela para armazenar os registros feitos pelo sensor
CREATE TABLE registro(
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
	temperatura DECIMAL(5, 2) NOT NULL,
    fkSensor INT,
    FOREIGN KEY (fkSensor) REFERENCES sensor (idSensor), 
    fkTanque INT,
    FOREIGN KEY (fkTanque) REFERENCES tanque (idTanque) 
);

-- INSERTS 
INSERT INTO empresa(nome, email, telefone, endereco) VALUES
('Wine', 'wine@gmail.com', '5511987614523', 'Rua do Vinho 567, São Paulo');
INSERT INTO empresa(nome, email, telefone, endereco) VALUES
('Reservado', 'reservado@gmail.com', '5511977014235','Rua da Uva 5547, Ribeirão Preto');

INSERT INTO usuario(nome, sobrenome, email, telefone, senha, fkEmpresa) VALUES
('Carolina', 'Soares', 'carol.soares@gmail.com', '5511993114452', '123456',1);
INSERT INTO usuario(nome, sobrenome, email, telefone, senha, fkEmpresa) VALUES
('Julia', 'Araripe', 'julia.araripe@gmail.com', '5511993116682', '123555',2);

INSERT INTO uva(nome, tempMinima, tempMaxima) VALUES
('Malbec', 12, 16);
INSERT INTO uva(nome, tempMinima, tempMaxima) VALUES
('Cabernet', 10, 15);

INSERT INTO vinho(fkUva, tipoVinho, tempMinima, tempMaxima) VALUES
(1, 'Tinto', 12, 16);
INSERT INTO vinho(fkUva, tipoVinho, tempMinima, tempMaxima) VALUES
(2, 'Tinto', 14, 20);

INSERT INTO sensor (tanqueLocalizado,codSensor,tempAtual,condicao) VALUES
('Tanque A24', '004', 23, 'Funcionando');
INSERT INTO sensor (tanqueLocalizado,codSensor,tempAtual,condicao) VALUES
('Tanque A24', '014', 20, 'Funcionando');

INSERT INTO tanque(codTanque,localTanque,tempMedia,fkSensor ,fkVinho,fkEmpresa) VALUES
('001', 'Rua do vinho 554', '20', '2', '1', '2');
INSERT INTO tanque(codTanque,localTanque,tempMedia,fkSensor ,fkVinho,fkEmpresa) VALUES
('002', 'Rua da uva 54', '14', '1', '2', '1');

INSERT INTO registro(temperatura,fkSensor,fkTanque) VALUES 
(14.5,'2','1');
INSERT INTO registro(temperatura,fkSensor,fkTanque) VALUES 
(10.5,'1','2');

-- SELECTS 

-- Ver temperatura registrada por sensor, Base de gráficos em tempo real
SELECT s.idSensor, s.codSensor, r.temperatura, r.data_hora
FROM sensor s
INNER JOIN registro r 
ON s.idSensor = r.fkSensor;

-- selecionar tipo de vinho 
SELECT 
    fkUva AS 'Uva',
    CASE 
        WHEN tipoVinho = 'Tinto' THEN 'Vinho Tinto'
        WHEN tipoVinho = 'Branco' THEN 'Vinho Branco'
    END AS 'Categoria'
FROM vinho;

-- Detectar temperatura fora do ideal
SELECT idRegistro as 'registro', tanqueLocalizado as 'tanque', data_hora as 'momento',
	CASE 
	WHEN r.temperatura BETWEEN v.tempMinima AND v.tempMaxima 
	THEN 'Ideal'
	ELSE 'Alerta'
	END AS status
	FROM registro r
	INNER JOIN sensor s ON r.fkSensor = s.idSensor
	INNER JOIN tanque t ON r.fkTanque = t.idTanque
	INNER JOIN vinho v ON t.fkVinho = v.idVinho
	INNER JOIN empresa e ON t.fkEmpresa = e.idEmpresa;
;

-- Qual empresa é dona de cada tanque
SELECT t.codTanque, e.nome AS empresa
FROM tanque t
INNER JOIN empresa e 
ON t.fkEmpresa = e.idEmpresa;

-- Monitoramento geral da fermentação
SELECT e.nome AS empresa, t.codTanque, v.tipoVinho, s.codSensor, r.temperatura, v.tempMinima, v.tempMaxima, r.data_hora
FROM registro r
INNER JOIN sensor s ON r.fkSensor = s.idSensor
INNER JOIN tanque t ON r.fkTanque = t.idTanque
INNER JOIN vinho v ON t.fkVinho = v.idVinho
INNER JOIN empresa e ON t.fkEmpresa = e.idEmpresa;

-- Relacionar vinho com o tipo de uva
SELECT v.tipoVinho, u.nome AS uva, u.tempMinima, u.tempMaxima
FROM vinho v
INNER JOIN uva u 
ON v.fkUva = u.idUva;




