DELIMITER $$

CREATE TRIGGER trg_decrementar_fichas
AFTER INSERT ON Paciente_has_Especialidade
FOR EACH ROW
BEGIN
  UPDATE Especialidade
  SET fichas = IF(fichas > 0, fichas - 1, 0)
  WHERE id = NEW.Especialidade_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_incrementar_fichas
AFTER DELETE ON Paciente_has_Especialidade
FOR EACH ROW
BEGIN
  UPDATE Especialidade
  SET fichas = fichas + 1
  WHERE id = OLD.Especialidade_id;
END$$

DELIMITER ;
