#ifndef UPDATEMANAGER_H
#define UPDATEMANAGER_H

#include <QObject>
#include <QProcess>

class UpdateManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int checkStatus READ checkStatus WRITE setCheckStatus NOTIFY checkStatusChanged)

public:
    explicit UpdateManager(QObject *parent = nullptr);

    Q_INVOKABLE void checkForUpdate();

    int checkStatus() const;
    void setCheckStatus(int status);

signals:
    void checkStatusChanged();

private slots:
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    QProcess m_process;
    int m_checkStatus;
};

#endif // UPDATEMANAGER_H
