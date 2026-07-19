-- ============================================================
-- LIMPA TODOS OS DADOS E INSERE EXEMPLOS PARA TESTE
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE auditoria;
TRUNCATE TABLE atendimentos;
TRUNCATE TABLE paciente_has_especialidade;
TRUNCATE TABLE usuario_especialidade;
TRUNCATE TABLE pacientes;
TRUNCATE TABLE usuarios;
TRUNCATE TABLE especialidades;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- USUÁRIOS
-- ============================================================
INSERT INTO usuarios (id, nome, email, senha, role, ativo) VALUES
(1, 'Administrador',     'admin@clinica.com',    '$2b$10$kxuK7IawR3..cgOWFiVQ/OFSbLJSQn/73dW8ZEsSVR8TOeQ.1fYUm', 'ADMIN',        1),
(2, 'Recepcionista',     'recepcionista@teste.com', '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'RECEPCIONISTA', 1),
(3, 'Dr. Carlos Silva',  'carlos@clinica.com',   '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'MEDICO',       1),
(4, 'Dra. Ana Oliveira', 'ana@clinica.com',      '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'MEDICO',       1),
(5, 'Dr. Pedro Santos',  'pedro@clinica.com',    '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'MEDICO',       1),
(6, 'Enfermeira Juliana','juliana@clinica.com',  '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'ENFERMEIRA',   1),
(7, 'Enfermeiro Marcos', 'marcos@clinica.com',   '$2b$10$RB8p/W8EynaRDFCHjbgC5ucRCtkF1pyDOkZMIhdUJPKgY1/jdDK7K', 'ENFERMEIRA',   1);

-- ============================================================
-- ESPECIALIDADES
-- ============================================================
INSERT INTO especialidades (id, nome, fichas, atendimentos_restantes_hoje, atendimentos_totais_hoje, triagem_obrigatoria) VALUES
(1, 'Cardiologia',    20, 20, 20, TRUE),
(2, 'Clínico Geral',  20, 20, 20, TRUE),
(3, 'Ginecologia',    20, 20, 20, TRUE),
(4, 'Endocrinologia', 20, 20, 20, TRUE),
(5, 'Psicologia',     20, 20, 20, FALSE),
(6, 'Enfermagem',     50, 50, 50, FALSE),
(7, 'Dentista',       20, 20, 20, FALSE),
(8, 'Terapeuta',      20, 20, 20, FALSE),
(9, 'Nutricionista',  20, 20, 20, FALSE);

-- ============================================================
-- VÍNCULO MÉDICO-ESPECIALIDADE
-- ============================================================
INSERT INTO usuario_especialidade (usuario_id, especialidade_id) VALUES
(3, 1),  -- Dr. Carlos -> Cardiologia
(3, 2),  -- Dr. Carlos -> Clínico Geral
(4, 3),  -- Dra. Ana   -> Ginecologia
(4, 4),  -- Dra. Ana   -> Endocrinologia
(5, 5),  -- Dr. Pedro  -> Psicologia
(5, 8);  -- Dr. Pedro  -> Terapeuta

-- ============================================================
-- PACIENTES
-- ============================================================
INSERT INTO pacientes (id, nome, data_nascimento, idade, nome_da_mae, cpf, sus, telefone, endereco) VALUES
(1, 'João Silva',      '1985-03-15', 41, 'Maria Silva',      '111.111.111-11', '12345678901', '(11) 91111-1111', 'Rua A, 100'),
(2, 'Maria Souza',     '1990-07-22', 36, 'Ana Souza',        '222.222.222-22', '12345678902', '(11) 92222-2222', 'Rua B, 200'),
(3, 'José Santos',     '1978-11-02', 47, 'Teresa Santos',    '333.333.333-33', '12345678903', '(11) 93333-3333', 'Rua C, 300'),
(4, 'Lucia Oliveira',  '2000-01-10', 26, 'Carla Oliveira',   '444.444.444-44', '12345678904', '(11) 94444-4444', 'Rua D, 400'),
(5, 'Fernando Lima',   '1995-05-20', 31, 'Rosa Lima',        '555.555.555-55', '12345678905', '(11) 95555-5555', 'Rua E, 500'),
(6, 'Aline Costa',     '1982-09-08', 43, 'Sonia Costa',      '666.666.666-66', '12345678906', '(11) 96666-6666', 'Rua F, 600'),
(7, 'Rafael Almeida',  '1975-12-30', 50, 'Paula Almeida',    '777.777.777-77', '12345678907', '(11) 97777-7777', 'Rua G, 700'),
(8, 'Camila Rocha',    '1998-04-14', 28, 'Bianca Rocha',     '888.888.888-88', '12345678908', '(11) 98888-8888', 'Rua H, 800'),
(9, 'Thiago Martins',  '1989-06-25', 37, 'Daniela Martins',  '999.999.999-99', '12345678909', '(11) 99999-9999', 'Rua I, 900'),
(10, 'Patricia Dias',  '1992-02-18', 34, 'Luciana Dias',     '000.000.000-00', '12345678910', '(11) 90000-0000', 'Rua J, 1000');

-- ============================================================
-- PACIENTE-ESPECIALIDADE (vínculo cadastrado pela recepção)
-- ============================================================
INSERT INTO paciente_has_especialidade (paciente_id, especialidade_id, data_atendimento) VALUES
(1, 1, CURDATE()),
(1, 2, CURDATE()),
(2, 3, CURDATE()),
(3, 2, CURDATE()),
(4, 4, CURDATE()),
(5, 5, CURDATE()),
(6, 1, CURDATE()),
(7, 3, CURDATE()),
(8, 5, CURDATE()),
(9, 8, CURDATE()),
(10, 9, CURDATE());

-- ============================================================
-- ATENDIMENTOS (fluxo completo)
-- ============================================================

-- Finalizados com consulta
INSERT INTO atendimentos (paciente_id, especialidade_id, status, recepcionista_id,
  pa_x_mmhg, fc_bpm, fr_ibpm, temperatura_c, hgt_mgld, spo2, peso, altura, imc,
  observacoes_enfermagem, enfermeira_id, triagem_realizada_em,
  avaliacao_medica, diagnostico, condutas, observacoes_medicas, medico_id, consulta_realizada_em)
VALUES
(1, 1, 'FINALIZADO', 2,
 '120x80', 72, 16, 36.5, 100, 98, 75, 175, 24.5,
 'Paciente consciente, orientado. PA normal.', 6, NOW() - INTERVAL 2 HOUR,
 'Paciente assintomático, exame físico normal.', 'Hipertensão arterial estágio 1', 'Iniciar Enalapril 10mg/dia. Retorno em 30 dias.', 'Paciente deve monitorar PA em casa.', 3, NOW() - INTERVAL 1 HOUR),

(3, 2, 'FINALIZADO', 2,
 '130x85', 80, 18, 37.0, 110, 97, 82, 172, 27.7,
 'Paciente relata cefaleia ocasional.', 6, NOW() - INTERVAL 3 HOUR,
 'Sinais vitais estáveis.', 'Cefaleia tensional', 'Prescrito Dipirona 500mg 6/6h se dor. Orientado a reduzir estresse.', 'Retorno se piora.', 3, NOW() - INTERVAL 2 HOUR),

(6, 1, 'FINALIZADO', 2,
 '140x90', 88, 20, 36.8, 95, 96, 70, 160, 27.3,
 'PA elevada. Paciente relata tontura.', 7, NOW() - INTERVAL 4 HOUR,
 'ECG normal. PA ainda elevada na consulta.', 'Hipertensão arterial estágio 2', 'Ajustar medicação: Losartana 50mg/dia. Solicitar exames laboratoriais.', 'Retorno em 15 dias com exames.', 3, NOW() - INTERVAL 3 HOUR);

-- Aguardando triagem (recepcionista cadastrou, enfermeira ainda não atendeu)
INSERT INTO atendimentos (paciente_id, especialidade_id, status, recepcionista_id) VALUES
(2, 3, 'AGUARDANDO_TRIAGEM', 2),
(4, 4, 'AGUARDANDO_TRIAGEM', 2),
(7, 3, 'AGUARDANDO_TRIAGEM', 2),
(8, 5, 'AGUARDANDO_TRIAGEM', 2),
(9, 8, 'AGUARDANDO_TRIAGEM', 2),
(10, 9, 'AGUARDANDO_TRIAGEM', 2);

-- Triados, aguardando consulta
INSERT INTO atendimentos (paciente_id, especialidade_id, status, recepcionista_id,
  pa_x_mmhg, fc_bpm, fr_ibpm, temperatura_c, hgt_mgld, spo2, peso, altura, imc,
  observacoes_enfermagem, enfermeira_id, triagem_realizada_em)
VALUES
(5, 5, 'AGUARDANDO_CONSULTA', 2,
 '118x78', 70, 16, 36.4, 90, 99, 68, 165, 25.0,
 'Paciente orientado, relata ansiedade. Sinais vitais normais.', 6, NOW() - INTERVAL 1 HOUR),

(1, 2, 'AGUARDANDO_CONSULTA', 2,
 '122x82', 74, 17, 36.6, 105, 98, 75, 175, 24.5,
 'PA levemente elevada. Sem outras queixas.', 7, NOW() - INTERVAL 30 MINUTE);
