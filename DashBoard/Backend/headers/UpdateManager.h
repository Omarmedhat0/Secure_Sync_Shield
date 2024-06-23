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
    Q_INVOKABLE void installUpdate();

    int checkStatus() const;
    void setCheckStatus(int status);

signals:
    void checkStatusChanged();
    void installFinished(bool success);

private slots:
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void installProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    QProcess m_process;
    QProcess m_installProcess;
    int m_checkStatus;

    // Remote host details
    QString m_remoteHost;  // IP or hostname of the remote machine
    QString m_remoteUser;  // SSH username
    QString m_remoteScriptPath;  // Path to the Python script on the remote machine
    QString m_remoteInstallScriptPath;  // Path to the install Python script on the remote machine
};

#endif // UPDATEMANAGER_H
