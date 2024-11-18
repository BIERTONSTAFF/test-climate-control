/*!
 * \file system.cpp
 * \brief Файл реализации класса System
 */

#include "system.h"

/*!
 * \brief Конструктор класса System
 * \param parent Родительский QObject
 *
 * Инициализирует объект System
 */
System::System(QObject *parent) : QObject(parent)
{
}

/*!
 * \brief Управляет питанием системы
 * \param s Статус питания (0 - выключено, 1 - включено)
 *
 * Устанавливает статус питания системы и отправляет сигнал powerStatusChanged
 */
void System::power(uint s)
{
    // Set system power
    emit powerStatusChanged(s);

    qDebug() << "System power status has changed: " << (s ? "on" : "off");
}

/*!
 * \brief Управляет направлением воздушного потока
 * \param d Направление потока (0 - отток, 1 - приток)
 *
 * Устанавливает направление воздушного потока и отправляет сигнал airFlowDirectionChanged
 */
void System::airFlowDirection(uint d)
{
    // Set system air flow direction
    emit airFlowDirectionChanged(d);

    qDebug() << "Air flow direction has changed: " << (d ? "inflow" : "outflow");
}
