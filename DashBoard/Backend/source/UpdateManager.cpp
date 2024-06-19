#include <QProcess>
#include <QDebug>
#include "../headers/UpdateManager.h"

UpdateManager::UpdateManager(QObject *parent)
    : QObject(parent), m_checkStatus(0)
{
    connect(&m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &UpdateManager::processFinished);
}

void UpdateManager::checkForUpdate()
{
    qDebug() << "Checking for update...";
    QString scriptPath = "/home/karim/ITI/Scripts/scriptts/check_for_update.py"; // Update with your Python script path
    QStringList args;
    args << scriptPath;
    m_process.start("python3", args);
    if (!m_process.waitForStarted() || !m_process.waitForFinished()) {
        qDebug() << "Failed to execute update check script.";
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
    qDebug() << "Process finished with code" << exitCode << "and status" << exitStatus;
    if (exitStatus == QProcess::NormalExit) {
        qDebug() << "Process finished successfully.";
    } else {
        qDebug() << "Process finished with errors.";
        setCheckStatus(-1);
    }
}
