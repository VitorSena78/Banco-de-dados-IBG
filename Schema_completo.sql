-- Schema completo para o Sistema de Gerenciamento de Clínica Médica
-- Baseado no schema original com melhorias para suporte a workflow e autenticação

CREATE DATABASE IF NOT EXISTS ibg_clinica;
USE ibg_clinica;

-- Tabela de Usuários (para autenticação e controle de acesso)
CREATE TABLE usuarios (
  id              INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome            VARCHAR(255) NOT NULL,
  email           VARCHAR(255) NOT NULL,
  senha           VARCHAR(255) NOT NULL,
  role            ENUM('ADMIN', 'RECEPCIONISTA', 'ENFERMEIRA', 'MEDICO') NOT NULL,
  ativo           BOOLEAN NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX email_UNIQUE (email ASC)
);

-- Tabela de Especialidades
CREATE TABLE especialidades (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  fichas INT UNSIGNED DEFAULT 0,
  atendimentos_restantes_hoje INT UNSIGNED DEFAULT 0,
  atendimentos_totais_hoje INT UNSIGNED DEFAULT 0,
  triagem_obrigatoria BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX nome_UNIQUE (nome ASC)
);

-- Tabela de associação Usuário-Especialidade (many-to-many para médicos)
CREATE TABLE usuario_has_especialidade (
  usuario_id       INTEGER UNSIGNED NOT NULL,
  especialidade_id INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY (usuario_id, especialidade_id),
  CONSTRAINT fk_usuario_esp_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT fk_usuario_esp_especialidade
    FOREIGN KEY (especialidade_id) REFERENCES especialidades(id)
    ON DELETE CASCADE ON UPDATE NO ACTION
);

-- Tabela de Pacientes
CREATE TABLE pacientes (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  data_nascimento DATE NULL,
  idade INTEGER UNSIGNED NULL,
  nome_da_mae VARCHAR(255) NULL,
  cpf VARCHAR(45) NULL,
  sus VARCHAR(45) NULL,
  telefone VARCHAR(45) NULL,
  endereco TEXT NULL,
  sync_status ENUM('CONFLICT','ERROR','PENDING','SYNCED') NOT NULL DEFAULT 'PENDING',
  last_sync_at TIMESTAMP NULL,
  device_id VARCHAR(100) NULL,
  local_id VARCHAR(100) NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE INDEX cpf_UNIQUE (cpf ASC),
  UNIQUE INDEX sus_UNIQUE (sus ASC)
);

-- Tabela de Atendimentos (workflow principal)
CREATE TABLE atendimentos (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  paciente_id INTEGER UNSIGNED NOT NULL,
  especialidade_id INTEGER UNSIGNED NOT NULL,
  status ENUM('AGUARDANDO_TRIAGEM', 'EM_TRIAGEM', 'AGUARDANDO_CONSULTA', 'EM_CONSULTA', 'FINALIZADO', 'CANCELADO') NOT NULL DEFAULT 'AGUARDANDO_TRIAGEM',
  data_atendimento DATE NOT NULL DEFAULT (CURRENT_DATE),
  
  -- Dados de Triagem (enfermeira)
  pa_x_mmhg VARCHAR(20) NULL,
  fc_bpm FLOAT NULL,
  fr_ibpm FLOAT NULL,
  temperatura_c FLOAT NULL,
  hgt_mgld FLOAT NULL,
  spo2 FLOAT NULL,
  peso FLOAT NULL,
  altura FLOAT NULL,
  imc FLOAT NULL,
  observacoes_enfermagem TEXT NULL,
  enfermeira_id INTEGER UNSIGNED NULL,
  triagem_realizada_em TIMESTAMP NULL,
  
  -- Dados da Consulta (médico)
  avaliacao_medica TEXT NULL,
  diagnostico TEXT NULL,
  condutas TEXT NULL,
  observacoes_medicas TEXT NULL,
  medico_id INTEGER UNSIGNED NULL,
  consulta_realizada_em TIMESTAMP NULL,
  
  -- Quem registrou
  recepcionista_id INTEGER UNSIGNED NULL,
  
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (id),
  INDEX idx_paciente_id (paciente_id ASC),
  INDEX idx_especialidade_id (especialidade_id ASC),
  INDEX idx_status (status ASC),
  INDEX idx_data_atendimento (data_atendimento ASC),
  
  CONSTRAINT fk_atendimento_paciente
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_atendimento_especialidade
    FOREIGN KEY (especialidade_id) REFERENCES especialidades(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_atendimento_enfermeira
    FOREIGN KEY (enfermeira_id) REFERENCES usuarios(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_atendimento_medico
    FOREIGN KEY (medico_id) REFERENCES usuarios(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_atendimento_recepcionista
    FOREIGN KEY (recepcionista_id) REFERENCES usuarios(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabela de Auditoria
CREATE TABLE auditoria (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id INTEGER UNSIGNED NULL,
  acao VARCHAR(255) NOT NULL,
  entidade VARCHAR(100) NOT NULL,
  entidade_id INTEGER UNSIGNED NULL,
  valores_antigos JSON NULL,
  valores_novos JSON NULL,
  ip VARCHAR(45) NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_auditoria_entidade (entidade, entidade_id ASC),
  INDEX idx_auditoria_usuario (usuario_id ASC),
  INDEX idx_auditoria_created_at (created_at ASC),
  CONSTRAINT fk_auditoria_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabela de associação Paciente-Especialidade (many-to-many)
CREATE TABLE paciente_has_especialidade (
  paciente_id INTEGER UNSIGNED NOT NULL,
  especialidade_id INTEGER UNSIGNED NOT NULL,
  data_atendimento DATE NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (paciente_id, especialidade_id),
  INDEX idx_paciente_has_especialidade_especialidade (especialidade_id ASC),
  CONSTRAINT fk_paciente_has_especialidade_paciente
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_paciente_has_especialidade_especialidade
    FOREIGN KEY (especialidade_id) REFERENCES especialidades(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Trigger para decrementar fichas ao criar atendimento
DELIMITER //
CREATE TRIGGER trg_decrementar_fichas
AFTER INSERT ON atendimentos
FOR EACH ROW
BEGIN
    UPDATE especialidades
    SET fichas = GREATEST(fichas - 1, 0),
        atendimentos_restantes_hoje = GREATEST(atendimentos_restantes_hoje - 1, 0)
    WHERE id = NEW.especialidade_id;
END;
//

-- Trigger para incrementar fichas ao cancelar atendimento
CREATE TRIGGER trg_incrementar_fichas
AFTER UPDATE ON atendimentos
FOR EACH ROW
BEGIN
    IF NEW.status = 'CANCELADO' AND OLD.status != 'CANCELADO' THEN
        UPDATE especialidades
        SET fichas = fichas + 1,
            atendimentos_restantes_hoje = atendimentos_restantes_hoje + 1
        WHERE id = NEW.especialidade_id;
    END IF;
END;
//

DELIMITER ;

-- Inserir usuário admin padrão (senha: admin123)
INSERT INTO usuarios (nome, email, senha, role) VALUES 
('Administrador', 'admin@clinica.com', '$2b$10$4LDCBPhxkylUzup4zKQD0OoVJKXle8u3jze6Kcdfdm140TXgy9aKm', 'ADMIN');

-- Inserir especialidades
-- Inserir usuário recepcionista padrão (senha: recepcionista123)
INSERT INTO usuarios (nome, email, senha, role) VALUES 
('Recepcionista', 'recepcionista@clinica.com', '$2b$10$wxbj.myfQ0YKPjDMHP4RZ.hFgcQSSiwu8P7s.o5Xa4/0rtWQEsUVm', 'RECEPCIONISTA');

-- Inserir especialidades
INSERT INTO especialidades (nome, fichas, atendimentos_restantes_hoje, atendimentos_totais_hoje, triagem_obrigatoria) VALUES
('Cardiologia', 20, 20, 20, TRUE),
('Clínico Geral', 20, 20, 20, TRUE),
('Ginecologia', 20, 20, 20, TRUE),
('Endocrinologia', 20, 20, 20, TRUE),
('Psicologia', 20, 20, 20, FALSE),
('Enfermagem', 50, 50, 50, FALSE),
('Dentista', 20, 20, 20, FALSE),
('Terapeuta', 20, 20, 20, FALSE),
('Nutricionista', 20, 20, 20, FALSE);
