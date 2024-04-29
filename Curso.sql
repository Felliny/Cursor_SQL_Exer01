create database Curso
go
use Curso

drop database Curso

create table curso (
	codigo		int			not null,
	nome		varchar(40)	not null,
	duracao		int			not null
	primary key(codigo)
)
go
create table disciplina (
	codigo			int			not null,
	nome			varchar(40)	not null,
	carga_horaria	int			not null
	primary key (codigo)
)
go
create table disciplina_curso (
	codigo_disciplina	int		not null,
	codigo_curso		int		not null,
	foreign	key (codigo_curso) references curso(codigo),
	foreign key (codigo_disciplina) references disciplina(codigo)
)



insert into disciplina 
values
	(0, 'banco de dados', 200),
	(1, 'Redes', 120),
	(2, 'gestao', 200)

insert into curso
values
	(0, 'ADS', 500),
	(1, 'COMEX', 400)


insert into disciplina_curso
values
	(0, 0),
	(1, 0),
	(2, 1)

-- Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor, monte uma
-- tabela de saída com as informações do curso que é parâmetro de entrada.
-- (Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)  

create function fn_disciplina()
returns @tabela table (
	codigo_disciplina			int,
	nome_disciplina				varchar(40),
	carga_horaria_disciplina	int,
	nome_curso					varchar(40)
)
as
begin
	declare @codigo_disc		int,
			@nome_disciplina	varchar(40),
			@carga_hora			int,
			@nome_curso			varchar(40)
	declare c cursor for
		select d.codigo, d.nome, d.carga_horaria, c.nome 
		from curso c, disciplina d, disciplina_curso dc
		where c.codigo = dc.codigo_curso and d.codigo = dc.codigo_disciplina
	open c
	fetch next from c
		into @codigo_disc, @nome_disciplina, @carga_hora, @nome_curso
	while @@FETCH_STATUS = 0
	begin
		insert into @tabela values
		(@codigo_disc, @nome_disciplina, @carga_hora, @nome_curso)
		
		fetch next from c into @codigo_disc, @nome_disciplina, @carga_hora, @nome_curso
	end
	close c
	deallocate c
	return
end

select * from fn_disciplina()
