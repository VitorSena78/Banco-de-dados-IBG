DELIMITER $$
CREATE TRIGGER trg_decrementar_fichas
AFTER INSERT ON atendimentos
FOR EACH ROW
BEGIN
  UPDATE especialidades
    SET fichas = GREATEST(fichas - 1, 0),
        atendimentos_restantes_hoje = GREATEST(atendimentos_restantes_hoje - 1, 0)
    WHERE id = NEW.especialidade_id;
END$$

DELIMITER ;


DELIMITER $$
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
END$$

DELIMITER ;
