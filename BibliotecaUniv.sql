/*** Criação do banco de dados BibliotecaUniv ***/
CREATE DATABASE BibliotecaUniv;

/*** Utilização do banco de dados BibliotecaUniv ***/
use BibliotecaUniv;



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
    constraint pk_funcionario 		primary key (cpf),
    /* Não sei se essa fk esta correta, essa é a parte do auto relacionamento */
    constraint fk_cadastrado_por	foreign key (responsavel_cadastro) references Funcionario (cpf)
);


/*** Criação da Tabela Atendente ***/
create table Atendente(
	login							varchar(45)		not null,
    senha							varchar(45)		not null,
    cpf_funcionario					int				not null,
    constraint	fk_funcionario_cpf	foreign key (cpf_funcionario) references Funcionario (cpf),
    constraint 	pk_atendente		primary key (cpf_funcionario),
    constraint	uk_login			unique (login)
);

/*** Criação da Tabela Autor ***/
create table Autor(
	cod_autor						int				not null,
    nome							varchar(45)		not null,
    /* tem q colocar a constraint de nao poder ser data futura*/
    data_de_nascimento				date			not null,
    constraint pk_autor				primary key (cod_autor)
);

/*** Criação da Tabela Email ***/
create table Email(
	email							varchar(45)		not null,
    matricula_usuario				int 			not null,
    constraint fk_usuario_matricula	foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_email				primary key (matricula_usuario,email)
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

/*** Criação da Tabela Telefone ***/
create table Telefone(
	telefone						varchar(45)		not null,
    matricula_usuario				int 			not null,
    constraint fk_usuario_matricula	foreign key (matricula_usuario) references Usuario (matricula),
    constraint pk_telefone			primary key (matricula_usuario,telefone)
);

/*** Criação da Tabela Exemplar ***/
create table Exemplar(
	cod_exemplar					int				not null,
    quantidade						int				not null,
    ISBN_livro						int				not null,
    constraint pk_exemplar			primary key (cod_exemplar),
    /* se o relacionamento é identificador entao essa fk nao deveria compor a pk?*/
    constraint fk_livro_ISBN		foreign key (ISBN_livro) references Livro (ISBN)
);

/*** Criação da Tabela Escrito_por ***/
create table Escrito_por(
	cod_autor						int				not null,
    ISBN_livro						int				not null,
    constraint fk_cod_autor			foreign key (cod_autor) references Autor (cod_autor),
    constraint fk_livro_ISBN		foreign key (ISBN_livro) references Livro (ISBN),
    constraint pk_escrito_por		primary key (cod_autor,ISBN_livro)
    
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

/*** Criação da Tabela Livro ***/
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
    constraint uk_qr_code			unique (qr_code),
    constraint uk_foto 				unique (foto),
    constraint pk_usuario			primary key (matricula),
    /* Verificar se a checagens estão corretas */
    constraint ck_data_de_nascimento	check(data_de_nascimento < current_date()),
    constraint ck_data_de_validade		check(data_de_validade > current_date())
);