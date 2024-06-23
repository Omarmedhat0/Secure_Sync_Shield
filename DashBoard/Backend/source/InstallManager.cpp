#include <QProcess>
#include <QDebug>
#include "../headers/InstallManager.h"

InstallManager::InstallManager(QObject *parent)
    : QObject(parent), m_installStatus(0)
{
    connect(&m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &InstallManager::processFinished);
}

void InstallManager::installNow()
{
    qDebug() << "Installing update...";
    QStringList args;
    args << "python3" << "/home/MainSoc/Securityscripts/InstallScript.py";
    m_process.start("sudo", args); // Use sudo if required for installation script
    if (!m_process.waitForStarted() || !m_process.waitForFinished(4000)) {
        qDebug() << "Failed to execute install script.";
        setInstallStatus(-1);
        return;
    }

    QByteArray result = m_process.readAllStandardOutput();
    QString resultStr = QString(result).trimmed();
    bool ok;
    int installationSuccess = resultStr.toInt(&ok);
    if (!ok || installationSuccess != 1) {
        qDebug() << "Installation failed or script did not return success.";
        setInstallStatus(-1);
        return;
    }

    setInstallStatus(1);
}

int InstallManager::installStatus() const
{
    return m_installStatus;
}

void InstallManager::processFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Installation process finished with code" << exitCode << "and status" << exitStatus;
    if (exitStatus == QProcess::NormalExit) {
        qDebug() << "Installation process finished successfully.";
    } else {
        qDebug() << "Installation process finished with errors.";
        setInstallStatus(-1);
    }
}

