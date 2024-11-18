#ifndef SETTINGS_H
#define SETTINGS_H

/*!
 * \file settings.h
 * \brief Заголовочный файл класса Settings для управления настройками приложения
 */

#include <QObject>
#include <QDomDocument>
#include <QDomElement>
#include <QFile>
#include <QIODevice>
#include <QDir>
#include <QByteArray>
#include <QDebug>

/*!
 * \class Settings
 * \brief Класс для сохранения и загрузки пользовательских настроек
 */
class Settings : public QObject
{
    Q_OBJECT

private:
    /*!
     * \brief Путь к файлу настроек
     *
     * Хранит полный путь к XML-файлу, в котором сохраняются/загружаются настройки
     */
    QString settingsPath;

public:
    /*!
     * \brief Конструктор класса Settings
     * \param parent Родительский QObject
     * \param settingsPath Путь к файлу настроек
     */
    explicit Settings(QObject *parent = nullptr, QString settingsPath = nullptr);

public slots:
    /*!
     * \brief Сохраняет текущие настройки
     * \param currentTUnit Текущая единица измерения температуры
     * \param currentPUnit Текущая единица измерения давления
     * \param isDarkTheme Флаг темной темы оформления
     */
    void save(int, int, bool);

    /*!
     * \brief Загружает сохраненные настройки
     */
    void load();

signals:
    /*!
     * \brief Сигнал о загрузке настроек
     * \param currentTUnit Единица измерения температуры
     * \param currentPUnit Единица измерения давления
     * \param isDarkTheme Флаг темной темы
     */
    void loaded(int currentTUnit, int currentPUnit, bool isDarkTheme);
};

#endif // SETTINGS_H
