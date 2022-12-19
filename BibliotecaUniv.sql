/*** Criação do banco de dados BibliotecaUniv ***/
CREATE DATABASE BibliotecaUniv;

/*** Utilização do banco de dados BibliotecaUniv ***/
use BibliotecaUniv;


/*** Criação da Tabela Autor ***/
create table Autor(
	cod_autor						int				not null ,
    nome							varchar(45)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento				date			not null,
    constraint pk_autor				primary key (cod_autor)
);

/*** Criação da Tabela Livro ***/
create table Livro(
	ISBN							int				not null,
    editora							varchar(45)		not null,
    /* Verificar se o default eh assim mesmo */
    numero_da_edicao				int				default 1,
    titulo							varchar(45)		not null,
    classificacao_por_assunto		varchar(45)		not null,
    constraint pk_ISBN				primary key (ISBN),
    constraint ck_numero_da_edicao	check(numero_da_edicao > 0)
);

/*** Criação da Tabela Exemplar ***/
create table Exemplar(
	cod_exemplar					int				not null,
    quantidade						int				not null,
    ISBN_livro						int				not null,
    constraint pk_exemplar			primary key (cod_exemplar,ISBN_livro),
    /* se o relacionamento é identificador entao essa fk nao deveria compor a pk?*/
    constraint fk_livro_exemplar		foreign key (ISBN_livro) references Livro (ISBN)
);

/*** Criação da Tabela Escrito_por ***/
create table Escrito_por(
	cod_autor						int				not null,
    ISBN_livro						int				not null,
    constraint fk_cod_autor			foreign key (cod_autor) references Autor (cod_autor),
    constraint fk_livro_escrito_por	foreign key (ISBN_livro) references Livro (ISBN),
    constraint pk_escrito_por		primary key (cod_autor,ISBN_livro)
    
);


/*** Criação da Tabela Usuário ***/
create table Usuario(
	matricula						int				not null,
    nome							varchar(45)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento				date			not null,
    rua								varchar(45)		not null,
    UF								char(2)			not null,
    CEP								varchar(15)		not null,
    cidade							varchar(45)		not null,
    bairro							varchar(45)		not null,
    numero							varchar(15)		not null,
    foto							longblob		not null,
    /* tem q colocar a constraint de nao poder ser data passados*/
    data_de_validade				date			not null,
    qr_code							longblob		not null,
    genero							char(1)			null,
    /*
    constraint uk_qr_code			unique (qr_code),
    constraint uk_foto 				unique (foto),
    */
    constraint pk_usuario			primary key (matricula),
    /* Verificar se a checagens estão corretas */
    constraint ck_data_de_nascimento	check(data_de_nascimento < sysdate()),
    constraint ck_data_de_validade		check(data_de_validade > sysdate())
);

/*** Criação da Tabela Email ***/
create table Email(
	email							varchar(45)		not null,
    matricula_usuario				int 			not null,
    constraint fk_usuario_email	foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_email				primary key (matricula_usuario,email)
);

/*** Criação da Tabela Telefone ***/
create table Telefone(
	telefone						varchar(45)		not null,
    matricula_usuario				int 			not null,
    constraint fk_usuario_telefone	foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_telefone			primary key (matricula_usuario,telefone)
);

/*** Criação da Tabela Funcionario ***/
create table Funcionario(
	cpf 							char(11)		not null,
    nome							varchar(45)		not null,
    telefone						varchar(20)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento				date			not null,
    rua								varchar(45)		not null,
    uf								varchar(2)		not null,
	cep								varchar(15)		not null,
    cidade							varchar(45)		not null,
    bairro							varchar(45)		not null,
    numero							varchar(15)		not null,
    /* duvida de qual nome dar e qual o atributo colocar e se realmente deve ser opcional*/
    cpf_responsavel_cadastro		int				null,
    constraint pk_funcionario 		primary key (cpf)
    /* Não sei se essa fk esta correta, essa é a parte do auto relacionamento 
    constraint fk_cadastrado_por	foreign key (cpf_responsavel_cadastro) references Funcionario (cpf)
    */
);


/*** Criação da Tabela Atendente ***/
create table Atendente(
	login							varchar(45)		not null,
    senha							varchar(45)		not null,
    cpf_funcionario					int				not null,
    constraint	fk_funcionario_cpf	foreign key (cpf_responsavel_cadastro) references Funcionario (cpf),
    constraint 	pk_atendente		primary key (cpf_funcionario),
    constraint	uk_login			unique (login)
);




/*** Criação da Tabela Empréstimo ***/
create table Emprestimo(
	matricula_usuario				int				not null,
    cpf_funcionario					int				null,
    cod_exemplar					int				not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_emprestimo				date			not null,
    /* tem q colocar a constraint de nao poder ser data passada*/
    data_de_devolucao				date			not null,
    constraint fk_usuario_matricula	foreign key (matricula_usuario) references Usuario (matricula),
    constraint fk_cod_exemplar		foreign key (cod_exemplar) references Exemplar (cod_exemplar),
    constraint fk_cpf_funcionario	foreign key (cpf_funcionario) references Funcionario (cpf),
    constraint pk_emprestimo		primary key (matricula_usuario,cod_exemplar,data_de_emprestimo)
    /* Como fazer o constraint de check de data */
);

/* Inserindo informações na tabela autor */
insert into Autor(nome, data_de_nascimento)
values(1,'Eva Heller', '1948-08-08'), /*psicologia das cores*/
(2, 'Andrew Stuart Tanenbaum', '1944-03-16'),/* Sistemas Operativos Modernos*/
(3, 'Charles Duhigg', '1974'), /*o poder do hábito*/
(4, 'Stephen Hawking', '1942-01-08'), /*uma breve história do tempo*/
(5, 'Karl Marx', '1818-05-05'); /* O capital*/

/* Inserindo informações na tabela livro*/
insert into Livro(ISBN, editora, numero_da_edicao, titulo, classificacao_por_assunto)
values('978-3-17-418129-1', 'Pearson' , 4, 'Sistemas Operativos Modernos', 'tecnologia');
/* Inseridos sem a edição*/
insert into Livro(ISBN, editora, titulo, classificacao_por_assunto)
values(518-6-16-148750-0, 'olhares', 'Psicologia das cores', 'designer' ),
(759-3-15-475129-1, 'objetiva', 'O poder do hábito', 'psicologia'),
(083-3-93-473459-0, 'intrinsace', 'Uma Breve História do Tempo', 'física'),
(453-4-23-203453-0, 'Veneta', 'O capital','sociologia' );

/* Inserindo informações na tabela Exemplar*/
insert into Livro(cod_exemplar, quantidade, ISBN_livro)
values(02946, 20, 518-6-16-148750-0), /*Psicologia das cores*/
(01298, 10, 978-3-17-418129-1),/*Sistemas Operativos Modernos*/
(68460, 40, 759-3-15-475129-1),/*O poder do hábito*/
(47420, 21, 083-3-93-473459-0), /*Uma breve história do tempo*/ 
(07213, 13, 453-4-23-203453-0);/*O capital*/

/* Inserindo informações na tabela Escrito_por*/
insert into Escrito_por(cod_autor, ISBN_livro)
values(1, 02946), /*Psicologia das cores*/
(2, 01298),/*Sistemas Operativos Modernos*/
(3, 68460),/*O poder do hábito*/
(4, 47420), /*Uma breve história do tempo*/ 
(5, 07213);/*O capital*/

/* Inserindo informações na tabela Usuario */
insert into Usuario(matricula, nome, data_de_nascimento, rua, UF, CEP, cidade, bairro, numero, foto, data_de_validade, qr_code)
values(20221370059, 'Vanessa Silva', 2000-09-31, 'Avenida Coremas','PB', 58013-430, 'João Pessoa','Centro',561 , load_file('imagem.png'), 2024-12-31, load_file('imagem.png')),
(20221370086, 'Rita Clara', 2001-11-0, 'Rua Comerciário Antônio Manoel de Sousa','PB', 58071-585, 'João Pessoa','Cristo Redentor',20 , load_file('imagem.png'), 2022-12-31, load_file('imagem.png')),
(20221370077, 'Laís Epifanio Machado', 2002-10-10, 'Rua Osvaldo Travassos Campos','PB', 58080-540, 'João Pessoa','Ernani Sátiro',16 , load_file('imagem.png'), 2023-12-31, load_file('imagem.png')),
(20221370029, 'Cleiton Bernadino', 2001-11-08, 'Conjunto Jacinto Medeiros','PB', 58026-080, 'João Pessoa','Treze de Maio',120 , load_file('imagem.png'), 2022-12-31, load_file('imagem.png')),
(20221370002, 'Raimundo de Moraes', 2004-03-23, 'Rua Guadalupe','PB', 58079-806, 'João Pessoa','Grotão', 777, load_file('imagem.png'), 2024-12-31, load_file('imagem.png'));

/*Inserindo informações na tabela email*/
insert into Email(email, matricula_usuario)
values('Silva.Vanessa@academico.ifpb.edu.br', 20221370059),
('Silva.Rita@academico.ifpb.edu.br', 20221370086),
('Lais.Machado@academico.ifpb.edu.br', 20221370077),
('Cleiton.Bernadito@academico.ifpb.edu.br', 20221370029),
('Mores.Santos@academico.ifpb.edu.br', 20221370002);

/* Inserindo informações na tabela telefone*/
insert into Telefone(telefone, matricula_usuario)
values(98854-1234, 20221370059),
(94002-8922, 20221370086),
(92034-9933, 20221370077),
(91234-5678, 20221370029),
(98765-4321, 20221370002);

/*Inserindo informações na tabela empréstimo*/
insert into Empréstimo(matricula_usuario, cpf_funcionario, cod_exemplar,data_de_emprestimo, data_de_devolucao)
value(20221370059, 111111111-11 ,02946, 2022-11-20, 2022-12-20), /* Vanessa fez um empréstimo livro "Psicologia das cores"*/
(20221370086, 111111111-11 ,02946, 2022-11-30, 2022-12-30), /* Rita fez um empréstimo livro "Psicologia das cores"*/
(20221370077, 111111111-11 ,47420, 2022-11-06, 2022-12-06), /* Laís fez um empréstimo livro "Uma breve história do tempo"*/
(20221370029, 111111111-11 ,07213, 2022-11-20, 2022-12-20), /* Cleiton fez um empréstimo livro "O capital"*/
(20221370002, 111111111-11 ,01298, 2022-11-28, 2022-12-28); /* Raimundo fez um empréstimo livro "Sistemas Operativos Modernos"*/

insert into Funcionário(cpf, nome, telefone, data_de_nascimento, rua, uf, cep,
 cidade, bairro,numero, cpf_responsavel_cadastro, login, senha)
value(102748293-51,'Caetano Veloso', 98867-1235, 1975-10-05, 'Avenida Coremas','PB', 58013-430, 'João Pessoa','Centro',565 , 156248293-61, 'CaetanoV', 'whereareyounow123'),
(156248293-61,'Alcione', 99357-1251, 1955-11-13, 'Rua Guadalupe','PB', 58079-806, 'João Pessoa','Grotão', 777, 129248629-65, 20221370008,'Alcione', 'Youmetiradosério33'),
(129248629-65,'Renata Costa', 98887-1235, 1975-03-05, 'Rua Comerciário Antônio Manoel de Sousa','PB', 58071-585, 'João Pessoa','Cristo Redentor',18 , 102748293-51, 'RenataC', '1RenatasóRenata'),
(102520493-67,'Catarina Rios', 98868-3215, 1985-10-10, 'Conjunto Jacinto Medeiros','PB', 58026-080, 'João Pessoa','Treze de Maio',122 , 129248629-65, 'CatarinaR', 'RiozinhoBB56'),
(412748299-54,'Felipe Neto', 98867-1235, 1984-04-11, 'Rua Osvaldo Travassos Campos','PB', 58080-540, 'João Pessoa','Ernani Sátiro',19, 102748293-51, 'FelipeN', 'CriativonoMINEgamemod1');
/*Inserindo informações na tabela de Atendentes*/
insert into Funcionário(cpf, nome, telefone, data_de_nascimento, rua, uf, cep,
 cidade, bairro,numero, cpf_responsavel_cadastro)
 value(410258299-14, 'Clarice Laís', 96485-9274, 1990-04-18, 'Rua Luiz Moreira Gomes', 'PB', 58052-295, 'João Pessoa', 'Água Fria', 32, 102748293-51),
 (180258829-12, 'Anônio Silva', 96301-8874, 1970-05-20, 'Rua Comerciário Ademy Batista da Silva', 'PB', 58076-349, 'João Pessoa', 'Água Fria', 12, 129248629-65),
 (410258299-14, 'Luís Rodrirgues', 91185-8854, 1989-04-30, 'Avenida Presidente Epitácio Pessoa', 'PB', 58030-001, 'João Pessoa', 'Estados', 180, 102748293-51),
 (920263819-67, 'Vanessa da Mata', 96487-9874, 1970-07-18, 'Rua Rio Grande do Sul', 'PB', 58030-021, 'João Pessoa', 'Bairro dos Estados', 32, 412748299-54),
 (900254529-64, 'Ronaldo Luiz', 96485-9274, 1984-10-31, 'Rua Irineu Joffily', 'PB', 58011-110, 'João Pessoa', 'Centro', 100, 156248293-61);
 


/*** Criação da Tabela Usuário ***/









/*** Criação da Tabela Usuário ***/
