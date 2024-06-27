#include "BackEnd.h"

//SERVICES
#define DIAGNOSIS_SERVICE_ID 0x1234

//INSTANCES
#define DIAGNOSIS_INSTANCE_ID 0x5678


//Methods
#define M_CHECK_FOR_UPDATE_ID 0x0421
#define M_INSTALL_NEW_APP_ID 0x0422
//Events
#define DIAGNOSIS_EVENTGROUP_ID 0x4465
#define E_NEW_UPDATE_ID 0x8778


SomeIpClient::SomeIpClient(QObject *parent)
    : QObject(parent), is_available_(false) {
    app_ = vsomeip::runtime::get()->create_application("Hello");
    app_->init();
    app_->register_availability_handler(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID,
                                        std::bind(&SomeIpClient::onAvailability, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));
    // app_->register_message_handler(vsomeip::ANY_SERVICE, vsomeip::ANY_INSTANCE, vsomeip::ANY_METHOD,
    //                                std::bind(&SomeIpClient::onMessage, this, std::placeholders::_1));
    app_->request_service(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID);

    sender_thread_ = std::thread([this](){
        app_->start();
    });

    run_thread_ = std::thread([this](){
        run();
    });
    run_thread_.detach();
}

SomeIpClient::~SomeIpClient() {
    app_->stop();
    if (sender_thread_.joinable()) {
        sender_thread_.join();
    }
}

//request one for update checking
void SomeIpClient::checkForUpdate() {
    std::shared_ptr<vsomeip::message> request = vsomeip::runtime::get()->create_request();
    request->set_service(DIAGNOSIS_SERVICE_ID);
    request->set_instance(DIAGNOSIS_INSTANCE_ID);
    request->set_method(M_CHECK_FOR_UPDATE_ID);

    std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
    std::vector<vsomeip::byte_t> its_payload_data(10, 0);
    its_payload->set_data(its_payload_data);
    request->set_payload(its_payload);
    app_->send(request);
}


//request two
void SomeIpClient::installUpdate() {
    sendInstallRequest();
}

//request Two private function
void SomeIpClient::sendInstallRequest() {
    std::shared_ptr<vsomeip::message> request = vsomeip::runtime::get()->create_request();
    request->set_service(DIAGNOSIS_SERVICE_ID);
    request->set_instance(DIAGNOSIS_INSTANCE_ID);
    request->set_method(M_INSTALL_NEW_APP_ID);

    std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
    std::vector<vsomeip::byte_t> its_payload_data;
    std::string install_request_msg = "Install update.hex";
    for (char c : install_request_msg) {
        its_payload_data.push_back(static_cast<vsomeip::byte_t>(c));
    }
    its_payload->set_data(its_payload_data);
    request->set_payload(its_payload);
    app_->send(request);
}


//SomeIp Main Function
void SomeIpClient::run() {
    std::unique_lock<std::mutex> lock(mutex_);
    while (!is_available_) {
        condition_.wait(lock);
    }

    // app_->request_event(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, E_NEW_UPDATE_ID);


    std::set<vsomeip::eventgroup_t> its_groups;
    its_groups.insert(DIAGNOSIS_EVENTGROUP_ID);
    app_->request_event(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, E_NEW_UPDATE_ID, its_groups);
    app_->subscribe(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, DIAGNOSIS_EVENTGROUP_ID);



    //registering the handler for Notification
    app_->register_message_handler(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, E_NEW_UPDATE_ID,
                                   std::bind(&SomeIpClient::Update_Notification, this, std::placeholders::_1));
    //registering the handler for Update Response
    app_->register_message_handler(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, M_CHECK_FOR_UPDATE_ID,
                                   std::bind(&SomeIpClient::Update_Response, this, std::placeholders::_1));
    //registering the handler for install Done
    app_->register_message_handler(DIAGNOSIS_SERVICE_ID, DIAGNOSIS_INSTANCE_ID, M_INSTALL_NEW_APP_ID,
                                   std::bind(&SomeIpClient::Install_Response, this, std::placeholders::_1));

}


void SomeIpClient::Update_Notification(const std::shared_ptr<vsomeip::message> &_response) {
    std::cout<<"New Update Notification"<<std::endl;
    emit updateAvailable("Update Available N");
}

void SomeIpClient::Update_Response(const std::shared_ptr<vsomeip::message> &_response) {
    std::cout<<"New Update Response"<<std::endl;
    emit updateAvailable("Update Available R");
}

void SomeIpClient::Install_Response(const std::shared_ptr<vsomeip::message> &_response) {
    std::cout<<"Installation Done Response"<<std::endl;
    emit installResponse("Installation done :)");
}

void SomeIpClient::onAvailability(vsomeip::service_t _service, vsomeip::instance_t _instance, bool _is_available) {
    std::cout << "ana hena\n";
    std::lock_guard<std::mutex> lock(mutex_);
    is_available_ = _is_available;
    if (is_available_) {
        condition_.notify_one();
    }
    std::cout << "CLIENT: Service [" << std::setw(4) << std::setfill('0') << std::hex << _service << "." << _instance
              << "] is " << (_is_available ? "available." : "NOT available.") << std::endl;
}
