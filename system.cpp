/*!
 * \file system.cpp
 * \brief Файл реализации класса System
 */

#include "system.h"

/*!
 * \brief Производит базовую инициализацию объекта
 */
System::System(QObject *parent) : QObject(parent)
{
}

/*!
 * \brief Устанавливает статус питания и инициализирует блоки
 *
 * Логика работы:
 * 1. При включении (s=1):
 *    - Активирует блоки 1 и 2
 *    - Оставляет блок 3 неактивным (симуляция ошибки)
 * 2. При выключении (s=0):
 *    - Деактивирует все блоки
 * 3. Отправляет сигналы о статусе каждого блока
 * 4. Отправляет сигнал об изменении питания
 */
void System::power(uint s)
{
    uint b1 = 0, b2 = 0, b3 = 0;

    if (s == 1) {
        b1 = b2 = 1;
        b3 = 0; // Симуляция ошибки инициализации блока 3
    }

    emit blockStatusChanged(0, b1);
    emit blockStatusChanged(1, b2);
    emit blockStatusChanged(2, b3);
    emit powerStatusChanged(s);

    qDebug() << "System power status has changed: " << (s ? "on" : "off");
}

/*!
 * \brief Устанавливает направление потока и уведомляет об изменении
 *
 * Отправляет сигнал об изменении направления потока и
 * логирует изменение в консоль
 */
void System::airFlowDirection(uint d)
{
    emit airFlowDirectionChanged(d);
    qDebug() << "Air flow direction has changed: " << (d ? "inflow" : "outflow");
}
