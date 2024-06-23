#include <QProcess>
#include <QDebug>
#include "../headers/UpdateManager.h"

UpdateManager::UpdateManager(QObject *parent)
    : QObject(parent), m_checkStatus(0)
{
    connect(&m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &UpdateManager::processFinished);
    connect(&m_installProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &UpdateManager::installProcessFinished);

    // Initialize remote host details
    m_remoteHost = "192.168.2.1";
    m_remoteUser = "MainSoc";
    m_remoteScriptPath = "/home/MainSoc/Securityscripts/DownloadScript.py";
    m_remoteInstallScriptPath = "/home/MainSoc/Securityscripts/InstallScript.py";
}

void UpdateManager::checkForUpdate()
{
    qDebug() << "Checking for update...";
    QStringList args;
    args << m_remoteUser + "@" + m_remoteHost << "python3" << m_remoteScriptPath;
    m_process.start("ssh", args);
    if (!m_process.waitForStarted() || !m_process.waitForFinished()) {
        qDebug() << "Failed to execute update check script on remote machine.";
        setCheckStatus(-1);
        return;
    }

    QByteArray result = m_process.readAllStandardOutput();
    QString resultStr = QString(result).trimmed();
    bool ok;
    int updateAvailable = resultStr.toInt(&ok);
    if (!ok) {
        qDebug() << "Failed to parse update check result.";
        setCheckStatus(-1);
        return;
    }

    setCheckStatus(updateAvailable);
}

void UpdateManager::installUpdate()
{
    qDebug() << "Installing update...";
    QStringList args;
    args << m_remoteUser + "@" + m_remoteHost << "python3" << m_remoteInstallScriptPath;
    m_installProcess.start("ssh", args);
    if (!m_installProcess.waitForStarted() || !m_installProcess.waitForFinished()) {
        qDebug() << "Failed to execute install script on remote machine.";
        emit installFinished(false);
        return;
    }

    QByteArray result = m_installProcess.readAllStandardOutput();
    QString resultStr = QString(result).trimmed();
    bool ok;
    int installResult = resultStr.toInt(&ok);
    if (!ok || installResult != 1) {
        qDebug() << "Failed to install update.";
        emit installFinished(false);
        return;
    }

    qDebug() << "Update installed successfully.";
    emit installFinished(true);
}

int UpdateManager::checkStatus() const
{
    return m_checkStatus;
}

void UpdateManager::setCheckStatus(int status)
{
    if (m_checkStatus != status) {
        m_checkStatus = status;
        emit checkStatusChanged();
    }
}

void UpdateManager::processFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Update check process finished with code" << exitCode << "and status" << exitStatus;
    if (exitStatus == QProcess::NormalExit) {
        qDebug() << "Update check process finished successfully.";
    } else {
        qDebug() << "Update check process finished with errors.";
        setCheckStatus(-1);
    }
}

void UpdateManager::installProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Install process finished with code" << exitCode << "and status" << exitStatus;
    if (exitStatus == QProcess::NormalExit) {
        qDebug() << "Install process finished successfully.";
        emit installFinished(true);
    } else {
        qDebug() << "Install process finished with errors.";
        emit installFinished(false);
    }
}
