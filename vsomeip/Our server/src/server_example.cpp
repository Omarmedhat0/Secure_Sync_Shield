#include <chrono>  // Include chrono for sleep
#include <cstdlib> // Include for system calls
#include <fstream> // Include for file checking
#include <iomanip>
#include <iostream>
#include <sstream>
#include <thread>
#include <vsomeip/vsomeip.hpp>

#ifdef USE_EXPERIMENTAL_FILESYSTEM
#include <experimental/filesystem>
namespace fs = std::experimental::filesystem;
#else
#include <filesystem>
namespace fs = std::filesystem;
#endif

#define SAMPLE_SERVICE_ID 0x1234
#define SAMPLE_INSTANCE_ID 0x5678
#define SAMPLE_EVENTGROUP_ID 0x4465
#define SAMPLE_EVENT_ID 0x8778

#define checkForUpdate_METHOD_ID 0x0421
#define flashTheUpdate_METHOD_ID 0x0422 // Define a new method ID for installation
#define chipId_METHOD_ID 0x0423
#define BLVer_METHOD_ID 0x0424

std::shared_ptr<vsomeip::payload> payload;
std::shared_ptr<vsomeip::application> app;

/**********************************************/
unsigned char notifyFlag = 0;
/**********************************************/

const vsomeip::byte_t its_data[] = { 0x10 };
const std::string newDecRelPath =
    "/home/shaher/SSS/updates/DecryptedRelease.bin"; // Specify the path to the New decrypted release file
const std::string allInOnePath = "/home/shaher/SSS/parser/AllInOne.txt"; // Specify the path to the AllInOne file

void run_checker_script() { std::system("python3 /home/shaher/SSS/Securityscripts/checker.py"); }

void run_chipIdGetter() { std::system("python3 /home/shaher/SSS/parser/chipId.py"); }

void run_versionGetter() { std::system("python3 /home/shaher/SSS/parser/version.py"); }

void run_flashingCommand() { std::system("python3 /home/shaher/SSS/parser/flashing.py"); }

void on_message(const std::shared_ptr<vsomeip::message>& _request)
{
    std::shared_ptr<vsomeip::payload> its_payload = _request->get_payload();
    vsomeip::length_t l = its_payload->get_length();

    // Check if the request is for installation
    if(_request->get_method() == flashTheUpdate_METHOD_ID) {
        std::cout << "INSTALLING..." << std::endl;

        // run_second_script();

        std::this_thread::sleep_for(std::chrono::seconds(5)); // Mock installation period

        bool is_file_empty = false;

        while(!is_file_empty) {
            // Check if the file is now empty
            std::ifstream file(newDecRelPath, std::ios::binary | std::ios::ate);
            is_file_empty = file.tellg() == 0;
            file.close();
        }

        if(is_file_empty) {
            // Create response
            std::shared_ptr<vsomeip::message> its_response = vsomeip::runtime::get()->create_response(_request);
            its_payload = vsomeip::runtime::get()->create_payload();
            std::vector<vsomeip::byte_t> its_payload_data;
            std::string install_msg = "Installation done";
            for(char c : install_msg) {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>(c));
            }
            // notifyFlag = 0;
            std::cout << "INSTALLATION DONE :)" << std::endl;
            its_payload->set_data(its_payload_data);
            its_response->set_payload(its_payload);
            app->send(its_response);
        } else {
            /* Do Nothing */
        }
    } else if(_request->get_method() == checkForUpdate_METHOD_ID) {
        // Run the script that checks if there is an update
        run_checker_script();
        // Create response
        std::shared_ptr<vsomeip::message> its_response = vsomeip::runtime::get()->create_response(_request);
        std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
        std::vector<vsomeip::byte_t> its_payload_data;

        // Read the file content
        std::ifstream file(allInOnePath);
        if(file.is_open()) {
            char file_content;
            file >> file_content;
            file.close();

            // Check the content of the file and set payload data accordingly
            if(file_content == '1') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('1'));
            } else if(file_content == '0') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('0'));
            } else {
                std::cerr << "Unexpected file content: " << file_content << std::endl;
                return;
            }
        } else {
            std::cerr << "Unable to open file: " << allInOnePath << std::endl;
            return;
        }

        std::cout << "File content processed and payload set." << std::endl;
        its_payload->set_data(its_payload_data);
        its_response->set_payload(its_payload);
        app->send(its_response);
    } else if(_request->get_method() == chipId_METHOD_ID) {
        // Run the script thatdets the chip ID
        //run_chipIdGetter();
        // Create response
        std::shared_ptr<vsomeip::message> its_response = vsomeip::runtime::get()->create_response(_request);
        std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
        std::vector<vsomeip::byte_t> its_payload_data;

        // Read the file content
        std::ifstream file(allInOnePath);
        if(file.is_open()) {
            char file_content;
            file >> file_content;
            file.close();

            // Check the content of the file and set payload data accordingly
            if(file_content == '1') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('1'));
            } else if(file_content == '0') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('0'));
            } else {
                std::cerr << "Unexpected file content: " << file_content << std::endl;
                return;
            }
        } else {
            std::cerr << "Unable to open file: " << allInOnePath << std::endl;
            return;
        }

        std::cout << "File content processed and payload set." << std::endl;
        its_payload->set_data(its_payload_data);
        its_response->set_payload(its_payload);
        app->send(its_response);
    } else if(_request->get_method() == BLVer_METHOD_ID) {
        // Run the script that gets the Bootloader version
        run_versionGetter();
        // Create response
        std::shared_ptr<vsomeip::message> its_response = vsomeip::runtime::get()->create_response(_request);
        std::shared_ptr<vsomeip::payload> its_payload = vsomeip::runtime::get()->create_payload();
        std::vector<vsomeip::byte_t> its_payload_data;

        // Read the file content
        std::ifstream file(allInOnePath);
        if(file.is_open()) {
            char file_content;
            file >> file_content;
            file.close();

            // Check the content of the file and set payload data accordingly
            if(file_content == '1') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('1'));
            } else if(file_content == '0') {
                its_payload_data.push_back(static_cast<vsomeip::byte_t>('0'));
            } else {
                std::cerr << "Unexpected file content: " << file_content << std::endl;
                return;
            }
        } else {
            std::cerr << "Unable to open file: " << allInOnePath << std::endl;
            return;
        }

        std::cout << "File content processed and payload set." << std::endl;
        its_payload->set_data(its_payload_data);
        its_response->set_payload(its_payload);
        app->send(its_response);
    }
}

int main()
{
    app = vsomeip::runtime::get()->create_application("World");
    app->init();

    payload = vsomeip::runtime::get()->create_payload();
    payload->set_data(its_data, sizeof(its_data));

    std::set<vsomeip::eventgroup_t> its_groups;
    its_groups.insert(SAMPLE_EVENTGROUP_ID);
    app->offer_event(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, SAMPLE_EVENT_ID, its_groups);

    // run_download_script();

    // Notify clients only if "new_release_dec.hex" contains data
    std::thread notifier([&]() {
        while(notifyFlag == 0) {
            std::ifstream file(newDecRelPath, std::ios::binary | std::ios::ate);
            bool is_file_non_empty = file.tellg() > 0;
            file.close();

            if(is_file_non_empty && (notifyFlag == 0)) {
                std::cout << "NOTIFYING THE GUI SOC WITH THE UPDATE" << std::endl;
                app->notify(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, SAMPLE_EVENT_ID, payload);
                std::this_thread::sleep_for(std::chrono::seconds(1)); // Delay between notifications
                notifyFlag = 1;
            } else {
                std::this_thread::sleep_for(std::chrono::milliseconds(100)); // Check file existence more frequently
            }
        }
    });

    app->register_message_handler(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, checkForUpdate_METHOD_ID, on_message);
    app->register_message_handler(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, flashTheUpdate_METHOD_ID, on_message);
    app->register_message_handler(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, chipId_METHOD_ID, on_message);
    app->register_message_handler(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID, BLVer_METHOD_ID, on_message);

    app->offer_service(SAMPLE_SERVICE_ID, SAMPLE_INSTANCE_ID);
    app->start();
    notifier.join(); // Join the notifier thread to keep it running
}

