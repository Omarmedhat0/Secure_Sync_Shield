#ifndef INSTALLMANAGER_H
#define INSTALLMANAGER_H

#include <QObject>
#include <QProcess>

class InstallManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int installStatus READ installStatus WRITE setInstallStatus NOTIFY installStatusChanged)

public:
    explicit InstallManager(QObject *parent = nullptr);

    Q_INVOKABLE void installNow();

    int installStatus() const;
    void setInstallStatus(int status);

signals:
    void installStatusChanged();

private slots:
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    QProcess m_process;
    int m_installStatus;

    // Remote host details
    QString m_remoteHost;  // IP or hostname of the remote machine
    QString m_remoteUser;  // SSH username
    QString m_remoteScriptPath;  // Path to the Python script on the remote machine
};

#endif // INSTALLMANAGER_H
