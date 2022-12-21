/*** Criação do banco de dados BibliotecaUniv ***/
CREATE DATABASE BibliotecaUniv;

/*** Utilização do banco de dados BibliotecaUniv ***/
use BibliotecaUniv;

/*** Criação da Tabela Autor ***/
create table Autor(
	cod_autor							int				not null ,
    nome								varchar(45)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento					date			not null,
    constraint pk_autor					primary key (cod_autor)
);

/*** Criação da Tabela Livro ***/
create table Livro(
	ISBN								int				not null,
    editora								varchar(45)		not null,
    /* Verificar se o default eh assim mesmo */
    numero_da_edicao					int				default 1,
    titulo								varchar(45)		not null,
    classificacao_por_assunto			varchar(45)		not null,
    constraint pk_ISBN					primary key (ISBN),
    constraint ck_numero_da_edicao		check(numero_da_edicao > 0)
    constraint ck_ISBN_livro			check(ISBN_livro > 0)
);

/*** Criação da Tabela Exemplar ***/
create table Exemplar(
	cod_exemplar						int				not null,
    quantidade							int				not null,
    ISBN_livro							int				not null,
    constraint pk_exemplar				primary key (cod_exemplar,ISBN_livro),
    /* se o relacionamento é identificador entao essa fk nao deveria compor a pk?*/
    constraint fk_livro_exemplar		foreign key (ISBN_livro) references Livro (ISBN)
    
);

/*** Criação da Tabela Escrito_por ***/
create table Escrito_por(
	cod_autor							int				not null,
    ISBN_livro							int				not null,
    constraint fk_cod_autor				foreign key (cod_autor) references Autor (cod_autor),
    constraint fk_livro_escrito_por		foreign key (ISBN_livro) references Livro (ISBN),
    constraint pk_escrito_por			primary key (cod_autor,ISBN_livro)
    
);

/*** Criação da Tabela Usuário ***/
create table Usuario(
	matricula							int			not null,
    nome								varchar(45)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento					date			not null,
    rua									varchar(45)		not null,
    UF									char(2)			not null,
    CEP									varchar(15)		not null,
    cidade								varchar(45)		not null,
    bairro								varchar(45)		not null,
    numero								varchar(15)		not null,
    foto								longblob		not null,
    /* tem q colocar a constraint de nao poder ser data passados*/
    data_de_validade					date			not null,
    qr_code								longblob		not null,
    genero								char(1)			null,
    /*
    constraint uk_qr_code			unique (qr_code),
    constraint uk_foto 				unique (foto),
    */
    constraint pk_usuario				primary key (matricula),
    /* Verificar se a checagens estão corretas */
    constraint ck_data_de_nascimento	check(data_de_nascimento < sysdate()),
    constraint ck_data_de_validade		check(data_de_validade > sysdate())
);

/*** Criação da Tabela Email ***/
create table Email(
	email								varchar(45)		not null,
    matricula_usuario					int 			not null,
    constraint fk_usuario_email			foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_email					primary key (matricula_usuario,email)
);

/*** Criação da Tabela Telefone ***/
create table Telefone(
	telefone							varchar(45)		not null,
    matricula_usuario					int 			not null,
    constraint fk_usuario_telefone		foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_telefone				primary key (matricula_usuario,telefone)
);

/*** Criação da Tabela Funcionario ***/
create table Funcionario(
	cpf 								char(11)		not null,
    nome								varchar(45)		not null,
    telefone							varchar(20)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento					date			not null,
    rua									varchar(45)		not null,
    uf									varchar(2)		not null,
	cep									varchar(15)		not null,
    cidade								varchar(45)		not null,
    bairro								varchar(45)		not null,
    numero								varchar(15)		not null,
    login_atendente						varchar(45)		null,
    senha_atendente						varchar(45)		null,
    tipo								varchar(45)		null,
    cpf_responsavel_cadastro			char(11)		null,
    constraint pk_funcionario 			primary key (cpf),
    constraint fk_atendente_responsavel	foreign key (cpf_responsavel_cadastro) references Funcionario(cpf),
    constraint uk_login					unique (login_atendente)
    
    
    /* Não sei se essa fk esta correta, essa é a parte do auto relacionamento 
    constraint fk_cadastrado_por	foreign key (cpf_responsavel_cadastro) references Funcionario (cpf)
    */
);

/*** Criação da Tabela Atendente ***/
/* Solução Anterior
create table Atendente(
	login							varchar(45)		not null,
    senha							varchar(45)		not null,
    cpf_funcionario					int				not null,
    constraint	fk_funcionario_cpf	foreign key (cpf_responsavel_cadastro) references Funcionario (cpf),
    constraint 	pk_atendente		primary key (cpf_funcionario),
    constraint	uk_login			unique (login)
);
*/

/*** Criação da Tabela Empréstimo ***/
create table Emprestimo(
	matricula_usuario					int				not null,
    cpf_funcionario						char(11)		null,
    cod_exemplar						int				not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_emprestimo					date			not null,
    /* tem q colocar a constraint de nao poder ser data passada*/
    data_de_devolucao					date			not null,
    constraint fk_usuario_matricula		foreign key (matricula_usuario) references Usuario (matricula),
    constraint fk_cod_exemplar			foreign key (cod_exemplar) references Exemplar (cod_exemplar),
    constraint fk_cpf_funcionario		foreign key (cpf_funcionario) references Funcionario (cpf),
    constraint ck_data_de_emprestimo	check(data_de_emprestimo <= sysdate()),
    constraint ck_data_de_devolucao		check(data_de_devolucao > sysdate()),
	constraint pk_emprestimo			primary key (matricula_usuario,cod_exemplar,data_de_emprestimo)
    /* Como fazer o constraint de check de data */
);




/* Inserindo informações na tabela autor */
insert into Autor(cod_autor,nome, data_de_nascimento)
values(1,'Eva Heller', '1948-08-08'), /*psicologia das cores*/
(2, 'Andrew Stuart Tanenbaum', '1944-03-16'),/* Sistemas Operativos Modernos*/
(3, 'Charles Duhigg', '1974-06-06'), /*o poder do hábito*/
(4, 'Stephen Hawking', '1942-01-08'), /*uma breve história do tempo*/
(5, 'Karl Marx', '1818-05-05'); /* O capital*/

select * from Autor;

/* Inserindo informações na tabela livro*/
insert into Livro(ISBN, editora, numero_da_edicao, titulo, classificacao_por_assunto)
values(1, 'Pearson' , 4, 'Sistemas Operativos Modernos', 'tecnologia'),
(2, 'olhares', 4, 'Psicologia das cores', 'designer' ),
(3, 'objetiva', 2, 'O poder do hábito', 'psicologia'),
(4, 'intrinsace', 13, 'Uma Breve História do Tempo', 'física'),
(5, 'Veneta', null, 'O capital','sociologia' ),
(6, 'Pearson', 1, 'O senhor dos aneis', 'Fantasia'),
(7, 'Rocco', 1, 'Harry Potter e a preda filosonal', 'Fantasia'),
(8, 'Veneta', 5 , 'Jogos Vorazes', 'Ficcao'),
(9, 'Rocco', 4, 'O pequeno Principe', 'Fantasia'),
(10, 'Presença', 1,'Cartas de amor aos mortos', 'Tecnologia');
select * from Livro;

/* Inserindo informações na tabela Exemplar*/
insert into Exemplar(cod_exemplar, quantidade, ISBN_livro)
values(02946, 20, 1), /*Psicologia das cores*/
(01298, 10, 1),/*Sistemas Operativos Modernos*/
(68460, 40, 2),/*O poder do hábito*/
(47420, 21, 3), /*Uma breve história do tempo*/ 
(07213, 13, 4);/*O capital*/
select * from Exemplar;

/* Inserindo informações na tabela Escrito_por*/
insert into Escrito_por(cod_autor, ISBN_livro)
values(1, 1), /*Psicologia das cores*/
(2, 2),/*Sistemas Operativos Modernos*/
(3, 3),/*O poder do hábito*/
(4, 4),/*Uma breve história do tempo*/ 
(5, 5);/*O capital*/
select * from Escrito_por;

/* Inserindo informações na tabela Usuario */
insert into Usuario(matricula, nome, data_de_nascimento, rua, UF, CEP, cidade, bairro, numero, foto, data_de_validade, qr_code)
values(2022001, 'Vanessa Silva', '2000-10-31', 'Avenida Coremas','PB', '58013-430', 'João Pessoa','Centro','561' , load_file('/var/lib/mysql-files/imagem.png'), '2024-12-31', load_file('/var/lib/mysql-files/imagem.png')),
(2022002, 'Rita Clara', '2001-11-06', 'Rua Comerciário Antônio Manoel de Sousa','PB', '58071-585', 'João Pessoa','Cristo Redentor','20' , load_file('/var/lib/mysql-files/imagem.png'), '2022-12-31', load_file('/var/lib/mysql-files/imagem.png')),
(2022003, 'Laís Epifanio Machado', '2002-10-10', 'Rua Osvaldo Travassos Campos','PB', '58080-540', 'João Pessoa','Ernani Sátiro','16' , load_file('/var/lib/mysql-files/imagem.png'), '2023-12-31', load_file('/var/lib/mysql-files/imagem.png')),
(2022004, 'Cleiton Bernadino', '2001-11-08', 'Conjunto Jacinto Medeiros','PB', '58026-080', 'João Pessoa','Treze de Maio','120' , load_file('/var/lib/mysql-files/imagem.png'), '2022-12-31', load_file('/var/lib/mysql-files/imagem.png')),
(2022005, 'Raimundo de Moraes', '2004-03-23', 'Rua Guadalupe','PB', '58079-806', 'João Pessoa','Grotão', '777', load_file('/var/lib/mysql-files/imagem.png'), '2024-12-31', load_file('/var/lib/mysql-files/imagem.png'));
select * from Usuario;
/* 
select load_file('/var/lib/mysql-files/imagem.png');
select @@GLOBAL.secure_file_priv;
/*

/*Inserindo informações na tabela email*/
insert into Email(email, matricula_usuario)
values('Silva.Vanessa@academico.ifpb.edu.br', 2022001),
('Silva.Rita@academico.ifpb.edu.br', 2022002),
('Lais.Machado@academico.ifpb.edu.br', 2022003),
('Cleiton.Bernadito@academico.ifpb.edu.br', 2022004),
('Mores.Santos@academico.ifpb.edu.br', 2022005);
select * from Email;

/* Inserindo informações na tabela telefone*/
insert into Telefone(telefone, matricula_usuario)
values('98854-1234', 2022001),
('94002-8922', 2022002),
('92034-9933', 2022003),
('91234-5678', 2022004),
('98765-4321', 2022005);
select * from Telefone;

/*finalizar os inserts e corrigir os que ricardo fez*/
insert into Funcionario(cpf, nome, telefone, data_de_nascimento, rua, uf, cep,
 cidade, bairro,numero, login_atendente, senha_atendente, tipo, cpf_responsavel_cadastro)
value('10274829351','Caetano Veloso', '98867-1235', '1975-10-05', 'Avenida Coremas','PB', '58013-430', 'João Pessoa','Centro','565' , null, null, null, null),
('15624829361','Alcione', '99357-1251', '1955-11-13', 'Rua Guadalupe','PB', '58079-806', 'João Pessoa','Grotão', '777', null, null, null, '10274829351'),
('12924862965','Renata Costa', '98887-1235', '1975-03-05', 'Rua Comerciário Antônio Manoel de Sousa','PB', '58071-585', 'João Pessoa','Cristo Redentor','18', null, null, null, '10274829351'),
('10252049367','Catarina Rios', '98868-3215', '1985-10-10', 'Conjunto Jacinto Medeiros','PB', '58026-080', 'João Pessoa','Treze de Maio','122', null, null, null, '10274829351'),
('41274829954','Felipe Neto', '98867-1235', '1984-01-11', 'Rua Osvaldo camara Travassos Campos','PB', '58080-540', 'João Pessoa','Ernani Sátiro','19', null, null, null, '10274829351'),
('41274829953','Eliana', '98867-1235', '1984-06-11', 'Rua da areia Travassos Campos','PB', '58080-540', 'João Pessoa','Ernani Sátiro','193', null, null, null, '10274829351'),
('41274829951','Edemberg', '98867-1235', '1994-05-11', 'Rua Osvaldo Travassos Campos','PE', '58080-510', 'Recife','Boa Viagem','21', 'edemberg', '123456', 'atendente', '10274829351');
/*Inserindo informações na tabela de Atendentes*/
select * from Funcionario;


/* tem que corrigir essas tabelas antes de fazer a inserção */
/*Inserindo informações na tabela empréstimo*/
insert into Emprestimo(matricula_usuario, cpf_funcionario, cod_exemplar,data_de_emprestimo, data_de_devolucao)
value(2022001, null,02946, '2022-11-20', '2022-12-21'), /* Vanessa fez um empréstimo livro "Psicologia das cores"*/
(2022002, '15624829361' ,02946, '2022-11-30', '2022-12-30'), /* Rita fez um empréstimo livro "Psicologia das cores"*/
(2022001, '15624829361' ,47420, '2022-11-06', '2022-12-25'), /* Laís fez um empréstimo livro "Uma breve história do tempo"*/
(2022003, '10274829351' ,07213, '2022-11-20', '2022-12-26'), /* Cleiton fez um empréstimo livro "O capital"*/
(2022004, '10274829351' ,01298, '2022-11-28', '2022-12-28'); /* Raimundo fez um empréstimo livro "Sistemas Operativos Modernos"*/
select * from Emprestimo;

select * 
from Emprestimo
where cpf_funcionario is null;

select * 
from Exemplar
where quantidade between 11 and 30;

select cep, count(*) as quantidade
from Funcionario
group by cep
having cep like '58%';

select min(data_de_nascimento)
from Funcionario
where cep like '58080%';

select *
from Autor
order by data_de_nascimento desc;

select *
from Livro
where numero_da_edicao not in (1,4);




 



