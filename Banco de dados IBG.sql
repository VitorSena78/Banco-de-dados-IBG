CREATE TABLE Especialidade (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  fichas INT UNSIGNED DEFAULT 0, -- novas fichas do dia, controladas via trigger
  atendimentos_restantes_hoje INT UNSIGNED DEFAULT 0, -- para impressão, controlado via Java
  atendimentos_totais_hoje INT UNSIGNED DEFAULT 0, -- valor original do dia
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

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
  pa_x_mmhg VARCHAR(20) NULL,
  fc_bpm FLOAT NULL,
  fr_ibpm FLOAT NULL,
  temperatura_c FLOAT NULL,
  hgt_mgld FLOAT NULL,
  spo2 FLOAT NULL,
  peso FLOAT NULL,
  altura FLOAT NULL,
  imc FLOAT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  sync_status ENUM('PENDING', 'SYNCED', 'CONFLICT') DEFAULT 'PENDING',
  last_sync_at TIMESTAMP NULL,
  device_id VARCHAR(100) NULL,
  local_id VARCHAR(100) NULL, -- Para IDs temporários do app
  PRIMARY KEY(id)
);

CREATE TABLE Paciente_has_Especialidade (
  Paciente_id INTEGER UNSIGNED NOT NULL,
  Especialidade_id INTEGER UNSIGNED NOT NULL,
  data_atendimento DATE NULL DEFAULT (CURRENT_DATE),
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY(Paciente_id, Especialidade_id),
  INDEX Paciente_has_Especialidade_FKIndex1(Paciente_id),
  INDEX Paciente_has_Especialidade_FKIndex2(Especialidade_id),
  FOREIGN KEY(Paciente_id)
    REFERENCES Paciente(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(Especialidade_id)
    REFERENCES Especialidade(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);
