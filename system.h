/*!
 * \file system.h
 * \brief Заголовочный файл класса System для управления кондиционирования
 */

/*!
 * \class System
 * \brief Класс для управления системой кондиционирования
 */

/*!
 * \fn void power(uint)
 * \brief Управляет питанием системы
 * \param s Статус питания (0 - выкл, 1 - вкл)
 */

/*!
 * \fn void airFlowDirection(uint)
 * \brief Управляет направлением воздушного потока
 * \param d Направление потока (0 - отток, 1 - приток)
 */

/*!
 * \fn void powerStatusChanged(uint s)
 * \brief Сигнал об изменении статуса питания
 * \param s Новый статус питания
 */

/*!
 * \fn void airFlowDirectionChanged(uint d)
 * \brief Сигнал об изменении направления воздушного потока
 * \param d Новое направление потока
 */

/*!
 * \fn void temperatureChanged(double t)
 * \brief Сигнал об изменении температуры
 * \param t Новое значение температуры
 */

/*!
 * \fn void humidityChanged(uint h)
 * \brief Сигнал об изменении влажности
 * \param h Новое значение влажности
 */

/*!
 * \fn void pressureChanged(double p)
 * \brief Сигнал об изменении давления
 * \param p Новое значение давления
 */

#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>
#include <QDebug>

class System : public QObject
{
    Q_OBJECT

public:
    System(QObject *parent = nullptr);

public slots:
    void power(uint);
    void airFlowDirection(uint);

signals:
    void powerStatusChanged(uint s);
    void airFlowDirectionChanged(uint d);
    void temperatureChanged(double t);
    void humidityChanged(uint h);
    void pressureChanged(double p);
};

#endif // SYSTEM_H
