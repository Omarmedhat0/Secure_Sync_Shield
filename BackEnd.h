#ifndef SOMEIPCLIENT_H
#define SOMEIPCLIENT_H

#include <QObject>
#include <vsomeip/vsomeip.hpp>
#include <thread>
#include <condition_variable>
#include <iostream>
#include <iomanip>
class SomeIpClient : public QObject {
    Q_OBJECT
public:
    explicit SomeIpClient(QObject *parent = nullptr);
    ~SomeIpClient();
    /**************************************************************************************/
    /*                                       Requests                                     */
    /**************************************************************************************/
    Q_INVOKABLE void checkForUpdate();
    Q_INVOKABLE void installUpdate();
    // Q_INVOKABLE void chipID();
    /**************************************************************************************/
    /*                                       GUI Signals                                  */
    /**************************************************************************************/
signals:
    void updateAvailable(const QString &response);
    void installResponse(const QString &response);
    void eventReceived(const QString &event);

private:
    void run();

    /**************************************************************************************/
    /*                                SomeIP General Functions                            */
    /**************************************************************************************/

    void onAvailability(vsomeip::service_t _service, vsomeip::instance_t _instance, bool _is_available);


    /**************************************************************************************/
    /*                     Diagnosis Responses and Notifications                          */
    /**************************************************************************************/
    void Update_Notification(const std::shared_ptr<vsomeip::message> &_response);
    void Update_Response(const std::shared_ptr<vsomeip::message> &_response);
    void Install_Response(const std::shared_ptr<vsomeip::message> &_response);
    /**************************************************************************************/
    /*                                Private Functions                                   */
    /**************************************************************************************/
    void sendInstallRequest();

    /**************************************************************************************/
    /*                                Process Synchro                                     */
    /**************************************************************************************/
    std::shared_ptr<vsomeip::application> app_;
    std::thread sender_thread_;
    std::thread run_thread_;

    std::mutex mutex_;
    std::condition_variable condition_;
    bool is_available_;
};

#endif // SOMEIPCLIENT_H
