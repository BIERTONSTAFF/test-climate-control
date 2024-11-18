/*!
 * \file settings.h
 * \brief Заголовочный файл класса Settings для управления настройками приложения
 */

/*!
 * \class Settings
 * \brief Класс для сохранения и загрузки пользовательских настроек
 *
 * Обеспечивает сохранение и загрузку настроек в XML-файл
 */

/*!
 * \fn void save(int, int, bool)
 * \brief Сохраняет текущие настройки в XML-файл
 * \param currentTUnit Текущая единица измерения температуры
 * \param currentPUnit Текущая единица измерения давления
 * \param isDarkTheme Флаг темной темы оформления
 */

/*!
 * \fn void load()
 * \brief Загружает настройки из XML-файла
 */

/*!
 * \fn void loaded(int currentTUnit, int currentPUnit, bool isDarkTheme)
 * \brief Сигнал о загрузке настроек
 * \param currentTUnit Выбранная единица измерения температуры
 * \param currentPUnit Выбранная единица измерения давления
 * \param isDarkTheme Выбранный флаг темной темы
 */

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QDomDocument>
#include <QDomElement>
#include <QFile>
#include <QIODevice>
#include <QDir>
#include <QByteArray>
#include <QDebug>

class Settings : public QObject
{
    Q_OBJECT

private:
    QString settingsPath;

public:
    explicit Settings(QObject *parent = nullptr, QString settingsPath = nullptr);

public slots:
    void save(int, int, bool);
    void load();
signals:
    void loaded(int currentTUnit, int currentPUnit, bool isDarkTheme);
};

#endif // SETTINGS_H
