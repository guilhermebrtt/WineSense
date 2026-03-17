-- Banco de dados wineSense
CREATE DATABASE wineSense;
USE wineSense;

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

-- Tabela empresa para guardar os dados da empresa cliente do sistema
CREATE TABLE empresa(
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	email VARCHAR(60) UNIQUE,
	telefone VARCHAR(20),
	nomePais VARCHAR(50),
	nomeEstado VARCHAR(40),
	nomeCidade VARCHAR(80),
	nomeRua VARCHAR(50),
	numeroRua INT
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

CREATE TABLE uva(
	idUva INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(20),
	tempMinima INT,
	tempMaxima INT
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

INSERT INTO empresa(nome, email, telefone, nomePais, nomeEstado, nomeCidade, nomeRua, numeroRua) VALUES
('Wine', 'wine@gmail.com', '5511987614523', 'Brasil', 'São Paulo', 'Campinas', 'Rua do Vinho', 567);
INSERT INTO empresa(nome, email, telefone, nomePais, nomeEstado, nomeCidade, nomeRua, numeroRua) VALUES
('Reservado', 'reservado@gmail.com', '5511977014235', 'Brasil', 'São Paulo', 'Ribeirão Preto', 'Rua da Uva', 5547);

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

SELECT * FROM vinho WHERE tipoVinho = 'Tinto';

SELECT * FROM empresa WHERE nomeEstado = 'São Paulo';

SELECT 
    fkUva AS 'Uva',
    CASE 
        WHEN tipoVinho = 'Tinto' THEN 'Vinho Tinto'
        WHEN tipoVinho = 'Branco' THEN 'Vinho Branco'
    END AS 'Categoria'
FROM vinho;

SELECT data_hora, temperatura 
FROM registro 
ORDER BY data_hora DESC;

SELECT 
    u.nome AS Nome_Usuario,
    e.nome AS Nome_Empresa
FROM empresa e
JOIN usuario u ON e.idEmpresa = u.fkEmpresa;






