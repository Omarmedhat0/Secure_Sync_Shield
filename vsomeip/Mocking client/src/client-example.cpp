#include <iomanip>
#include <iostream>
#include <sstream>
#include <condition_variable>
#include <thread>
#include <vsomeip/vsomeip.hpp>

#define SAMPLE_SERVICE_ID 0x1234
#define SAMPLE_INSTANCE_ID 0x5678
#define SAMPLE_EVENTGROUP_ID 0x4465
#define SAMPLE_EVENT_ID 0x8778

#define checkForUpdate_METHOD_ID 0x0421
#define flashTheUpdate_METHOD_ID 0x0422 // Define a new method ID for installation
#define chipId_METHOD_ID 0x0423
#define BLVer_METHOD_ID 0x0424

std::shared_ptr<vsomeip::application> app;
std::mutex mutex;
std::condition_variable condition;
bool is_availble = false;

void send_install_request() {
    std::shared_ptr<vsomeip::message> request = vsomeip::runtime::get()->create_request();
    request->set_service(SAMPLE_SERVICE_ID);
    request->set_instance(SAMPLE_INSTANCE_ID);
    request->set_method(flashTheUpdate_METHOD_ID);

    std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
    std::vector<vsomeip::byte_t> its_payload_data;
    std::string install_request_msg = "Install update.hex";
    for (char c : install_request_msg) {
        its_payload_data.push_back(static_cast<vsomeip::byte_t>(c));
    }
    its_payload->set_data(its_payload_data);
    request->set_payload(its_payload);
    app->send(request);
}

void run() {
    std::unique_lock<std::mutex> its_lock(mutex);

    while (!is_availble) {
        condition.wait(its_lock);
    }

    std::cout << "from start of Run function" << std::endl;

    std::set<vsomeip::eventgroup_t> its_groups;
    its_groups.insert(SAMPLE_EVENTGROUP_ID);
    app->request_event(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, SAMPLE_EVENT_ID, its_groups);
    app->subscribe(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, SAMPLE_EVENTGROUP_ID);

    std::shared_ptr<vsomeip::message> request = vsomeip::runtime::get()->create_request();
    request->set_service(SAMPLE_SERVICE_ID);
    request->set_instance(SAMPLE_INSTANCE_ID);
    request->set_method(chipId_METHOD_ID);

    std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
    std::vector<vsomeip::byte_t> its_payload_data;
    for (vsomeip::byte_t i = 0; i < 10; i++) {
        its_payload_data.push_back(i % 256);
    }
    its_payload->set_data(its_payload_data);
    request->set_payload(its_payload);
    app->send(request);
    std::cout << "from end of Run function" << std::endl;
}

void on_message(const std::shared_ptr<vsomeip::message> &_response) {

    if (_response->get_service() == SAMPLE_SERVICE_ID &&
        _response->get_instance() == SAMPLE_INSTANCE_ID &&
        _response->get_method() == SAMPLE_EVENT_ID) {
        // Notify received, send install request
        std::cout << "UPDATE AVAILABLE NOTIFICATION" << std::endl;
        std::cout << "INSTALLING..." << std::endl;
        send_install_request();
    } else if (_response->get_service() == SAMPLE_SERVICE_ID &&
               _response->get_instance() == SAMPLE_INSTANCE_ID &&
               _response->get_method() == flashTheUpdate_METHOD_ID) {
        // Installation response received
        std::cout << "INSTALLATION DONE :)" << std::endl;
    } else if (_response->get_service() == SAMPLE_SERVICE_ID &&
               _response->get_instance() == SAMPLE_INSTANCE_ID &&
               _response->get_method() == chipId_METHOD_ID) {
        // Chip ID response received
        auto payload = _response->get_payload();
        auto payload_data = payload->get_data();

            vsomeip::byte_t content = payload_data[0];
            if (content == static_cast<vsomeip::byte_t>('1')) {
                std::cout << "ERROR" << std::endl;
            } else if (content == static_cast<vsomeip::byte_t>('0')) {
                std::cout << "Chip ID is: 0x0423" << std::endl;
            } else {
                std::cerr << "Unexpected payload content: " << content << std::endl;
            }
    } else if (_response->get_service() == SAMPLE_SERVICE_ID &&
               _response->get_instance() == SAMPLE_INSTANCE_ID &&
               _response->get_method() == BLVer_METHOD_ID) {
        // Bootloader version response received
        std::cout << "Bootloader version is: " << std::endl;
    }
}

void on_availability(vsomeip::service_t _service, vsomeip::instance_t _instance, bool _is_available) {
    std::cout << "CLIENT: Service ["
              << std::setw(4) << std::setfill('0') << std::hex << _service << "." << _instance
              << "] is "
              << (_is_available ? "available." : "NOT available.")
              << std::endl;

    if (_is_available) {
        is_availble = true;
        condition.notify_one();
    }
}

int main() {
    app = vsomeip::runtime::get()->create_application("Hello");
    app->init();
    app->register_availability_handler(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, on_availability);
    app->register_message_handler(vsomeip::ANY_SERVICE, vsomeip::ANY_INSTANCE, vsomeip::ANY_METHOD, on_message);
    app->request_service(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID);

    std::thread sender(run);
    app->start();
    sender.join(); // Join the sender thread to keep it running
}

