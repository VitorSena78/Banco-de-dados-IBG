CREATE TABLE Paciente (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  data_nascimento DATE NULL,
  idade INTEGER UNSIGNED NULL,
  nome_da_mae VARCHAR(255) NULL,
  cpf VARCHAR(45) NULL,
  sus VARCHAR(45) NULL,
  telefone VARCHAR(45) NULL,
  endereço TEXT NULL,
  pa_x_mmhg FLOAT NULL,
  fc_bpm FLOAT NULL,
  fr_ibpm FLOAT NULL,
  temperatura_c FLOAT NULL,
  hgt_mgld FLOAT NULL,
  spo2 FLOAT NULL,
  peso FLOAT NULL,
  altura FLOAT NULL,
  imc FLOAT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE Especialidade (
  idEspecialidade INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  PRIMARY KEY(idEspecialidade)
);

CREATE TABLE Paciente_has_Especialidade (
  Paciente_id INTEGER UNSIGNED NOT NULL,
  Especialidade_idEspecialidade INTEGER UNSIGNED NOT NULL,
  data_atendimento DATE NULL,
  PRIMARY KEY(Paciente_id, Especialidade_idEspecialidade),
  INDEX Paciente_has_Especialidade_FKIndex1(Paciente_id),
  INDEX Paciente_has_Especialidade_FKIndex2(Especialidade_idEspecialidade),
  FOREIGN KEY(Paciente_id)
    REFERENCES Paciente(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(Especialidade_idEspecialidade)
    REFERENCES Especialidade(idEspecialidade)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);


