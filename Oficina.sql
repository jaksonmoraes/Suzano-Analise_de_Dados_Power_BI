create database if not exists Oficina;
use Oficina;

create table PessoaFisica(
	id int not null auto_increment primary key,
    cpf char(11) not null,
    nome varchar(15),
    sobrenome varchar(30)
);

create table PessoaJuridica(
	id int not null auto_increment primary key,
    cnpj char(15) not null,
    razao_social varchar(255) not null
);

create table Pessoa (
	id int not null auto_increment,
    endereco varchar(255) not null,
    pessoa_fisica int,
    pessoa_juridica int,
    primary key(id),
    constraint fk_pessoa_pessoa_fisica foreign key(pessoa_fisica)references PessoaFisica(id),
    constraint fk_pessoa_pessoa_juridica foreign key(pessoa_juridica)references PessoaJuridica(id)
);

create table Veiculo (
	id int not null auto_increment,
    marca char(15),
    modelo char(20),
    placa char(7),
    id_pessoa int not null,
    primary key (id),
    constraint pk_veiculo_pessoa foreign key(id_pessoa) references Pessoa(id)
);

create table OrdemServico (
  id INT NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  tipo_servico VARCHAR(45) NOT NULL,
  autorizacao_cliente TINYINT NOT NULL,
  status VARCHAR(45) NOT NULL,
  idPessoa INT NOT NULL,
  PRIMARY KEY (id, idPessoa),
  INDEX fk_OrdemServico_Pessoa1_idx (idPessoa ASC) VISIBLE,
  CONSTRAINT fk_ordem_servico_pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

create table Mecanico (
  id INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  endereco VARCHAR(255) NOT NULL,
  especialidade VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
  );
  
create table PrazoServico (
  id_mecanico INT NOT NULL,
  idOrdemServico INT NOT NULL,
  data_emissao_os VARCHAR(45) NOT NULL,
  data_entrega_veiculo VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_mecanico, idOrdemServico),
  constraint fk_prazo_servico_mecanico foreign key (id_mecanico) references Mecanico(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_prazo_servico_ordem_servico FOREIGN KEY (idOrdemServico) references OrdemServico(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

create table Pagamento (
	id int not null auto_increment,
    dinheiro decimal(10, 2),
    cartao decimal(10, 2),
    validade_cartao char(5),
    pix decimal(10, 2),
    id_pessoa int not null,
    primary key(id),
    constraint fk_pagamento_pessoa foreign key(id_pessoa) references Pessoa(id)
);

create table PagamentoOrdemServico (
  id INT NOT NULL,
  idOrdemServico INT NOT NULL,
  valor FLOAT NOT NULL,
  PRIMARY KEY (id, idOrdemServico),
  INDEX fk_Pagamento_has_OrdemServico_OrdemServico1_idx (idOrdemServico ASC) VISIBLE,
  INDEX fk_Pagamento_has_OrdemServico_Pagamento1_idx (id ASC) VISIBLE,
  CONSTRAINT fk_pagamento_OrdemServico foreign key(id) REFERENCES Pagamento(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_pagamento_OrdemServico_OrdemServico1 foreign key(idOrdemServico) REFERENCES OrdemServico (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

create table Peca (
  id INT NOT NULL,
  nome_peca VARCHAR(45) NOT NULL,
  valor FLOAT NOT NULL,
  PRIMARY KEY (id)
);

create table OrdemServicoPeca (
  idOrdemServico INT NOT NULL,
  idPeca INT NOT NULL,
  PRIMARY KEY (idOrdemServico, idPeca),
  INDEX fk_OrdemServico_has_Peca_Peca1_idx (idPeca ASC) VISIBLE,
  INDEX fk_OrdemServico_has_Peca_OrdemServico1_idx (idOrdemServico ASC) VISIBLE,
  CONSTRAINT fk_ordem_servico_peca_peca foreign key(idOrdemServico) references OrdemServico(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ordem_servico_peca foreign key(idPeca) references Peca(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);