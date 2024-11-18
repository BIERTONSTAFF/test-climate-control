#ifndef SYSTEM_H
#define SYSTEM_H

/*!
 * \file system.h
 * \brief Заголовочный файл класса System для управления кондиционирования
 */

#include <QObject>
#include <QDebug>

/*!
 * \class System
 * \brief Класс для управления системой кондиционирования
 */
class System : public QObject
{
    Q_OBJECT

public:
    /*!
     * \brief Конструктор класса System
     * \param parent Родительский QObject
     */
    System(QObject *parent = nullptr);

public slots:
    /*!
     * \brief Управляет питанием системы
     * \param s Статус питания (0 - выкл, 1 - вкл)
     */
    void power(uint);

    /*!
     * \brief Управляет направлением воздушного потока
     * \param d Направление потока (0 - отток, 1 - приток)
     */
    void airFlowDirection(uint);

signals:
    /*!
     * \brief Сигнал об изменении статуса питания
     * \param s Новый статус питания
     */
    void powerStatusChanged(uint s);

    /*!
     * \brief Сигнал об изменении направления потока
     * \param d Новое направление потока
     */
    void airFlowDirectionChanged(uint d);

    /*!
     * \brief Сигнал об изменении температуры
     * \param t Новое значение температуры
     */
    void temperatureChanged(double t);

    /*!
     * \brief Сигнал об изменении влажности
     * \param h Новое значение влажности
     */
    void humidityChanged(uint h);

    /*!
     * \brief Сигнал об изменении давления
     * \param p Новое значение давления
     */
    void pressureChanged(double p);

    /*!
     * \brief Сигнал об изменении статуса блока
     * \param b Номер блока
     * \param s Статус блока
     */
    void blockStatusChanged(uint b, uint s);
};

#endif // SYSTEM_H
