--Задание 1:
--Вывести таблицу, которая содержит список поставок с датой первого прибытия на склад.

SELECT
    sl.Supply_id,
    MIN(sl.Status_moment) AS First_Arrival_Date
FROM
    supply_log sl
WHERE
    sl.Status_id = 200 -- Прибыла
GROUP BY
    sl.Supply_id
ORDER BY
    sl.Supply_id;
    
Задание 2:
--Посчитать количество поставок на складах с текущим статусом «Прибыла» при условии, что планируемая дата прибытия поставки равна сегодняшней дате. В результирующую таблицу вывести только те склады, на которых таких поставок более 300.

SELECT
    w.Name AS Warehouse_name,
    COUNT(DISTINCT s.ID) AS Supply_quantity
FROM
    supply s
JOIN
    warehouse w ON s.Warehouse_id = w.ID
WHERE
    s.ID IN (
        SELECT DISTINCT
            sl.Supply_id
        FROM
            supply_log sl
        WHERE
            sl.Status_id = 200
            AND CAST(sl.Planned_arrival AS DATE) = CAST(GETDATE() AS DATE)
    )
GROUP BY
    w.Name
HAVING
    COUNT(DISTINCT s.ID) > 300;

--Задание 3:
--Вывести информацию о всех поставках с текущим статусом и временем прибытия. Если по поставке еще нет данных в таблице supply_log, то проставьте в поле Status_id число 1000, а поля status_moment и planned_arrival оставьте пустыми.

SELECT
    s.ID AS Supply_id,
    COALESCE(sl.Status_id, 1000) AS Status_id,
    sl.Status_moment,
    sl.Planned_arrival
FROM
    supply s
LEFT JOIN
    (
        SELECT
            Supply_id,
            Status_id,
            MAX(Status_moment) AS Status_moment,
            Planned_arrival
        FROM
            supply_log
        GROUP BY
            Supply_id, Status_id, Planned_arrival
    ) sl ON s.ID = sl.Supply_id
ORDER BY
    s.ID, sl.Status_moment;
    
--Задание 4:
--Вывести уникальный список ID поставок и складов, у которых был проставлен статус 200 за вчерашний день.

SELECT DISTINCT
    s.ID AS Supply_id,
    s.Warehouse_id
FROM
    supply s
JOIN
    supply_log sl ON s.ID = sl.Supply_id
WHERE
    sl.Status_id = 200 -- Прибыла
    AND CAST(sl.Status_moment AS DATE) = CAST(GETDATE() - 1 AS DATE);