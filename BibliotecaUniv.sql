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
values(20221370059, 'Vanessa Silva', '2000-09-31', 'Avenida Coremas','PB', '58013-430', 'João Pessoa','Centro','561' , load_file('imagem.png'), '2024-12-31', load_file('imagem.png')),
(20221370086, 'Rita Clara', '2001-11-08', 'Rua Comerciário Antônio Manoel de Sousa','PB', '58071-585', 'João Pessoa','Cristo Redentor','201' , load_file('imagem.png'), '2022-12-31', load_file('imagem.png')),
(20221370077, 'Laís Epifanio Machado', '2002-10-10', 'Rua Osvaldo Travassos Campos','PB', '58080-540', 'João Pessoa','Ernani Sátiro','16' , load_file('imagem.png'), '2023-12-31', load_file('imagem.png')),
(20221370029, 'Cleiton Bernadino', '2001-11-08', 'Conjunto Jacinto Medeiros','PB', '58026-080', 'João Pessoa','Treze de Maio','120' , load_file('imagem.png'), '2022-12-31', load_file('imagem.png')),
(20221370002, 'Raimundo de Moraes', '2004-03-23', 'Rua Guadalupe','PB', '58079-806', 'João Pessoa','Grotão','777' , load_file('imagem.png'), '2024-12-31', load_file('imagem.png'));






/*** Criação da Tabela Usuário ***/









/*** Criação da Tabela Usuário ***/
