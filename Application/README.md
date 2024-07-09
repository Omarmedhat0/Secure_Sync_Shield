# Secure_Sync_Shield_-SSS-

# Obstacle Avoidance Car

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Hardware Components](#hardware-components)
- [Pin Configuration](#pin-configuration)
- [Files](#files)
  - [File 1: Initial Application](#file-1-initial-application)
  - [File 2: Updated Application](#file-2-updated-application)
- [Software Overview](#software-overview)
  - [Initialization](#initialization)
  - [Main Loop](#main-loop)
  - [Ultrasonic Sensor Handling](#ultrasonic-sensor-handling)
  - [Touch Sensor Handling](#touch-sensor-handling)
  - [LED and Buzzer Control](#led-and-buzzer-control)
  - [Motor Control](#motor-control)
  - [Servo Motor Control](#servo-motor-control)
## Description
This project is an implementation of an obstacle avoidance car using an STM32 microcontroller. The car can detect obstacles in its path using an ultrasonic sensor and will take actions to avoid them. It can also respond to a touch sensor, control LEDs, a buzzer, motors, and a servo for more complex interactions.

## Features
- **Obstacle Detection:** Uses an ultrasonic sensor to measure the distance to obstacles.
- **Touch Sensor:** Responds to touch inputs.
- **Motor Control:** Controls four motors to drive the car.
- **LED Indicators:** Uses multiple LEDs to indicate the state of the car.
- **Buzzer:** Alerts when an obstacle is detected.
- **Servo Motor Control:** Adjusts the angle of a servo motor.

## Hardware Components
- STM32 microcontroller
- Ultrasonic sensor (HC-SR04)
- Touch sensor
- 4 DC motors
- 8 LEDs
- Buzzer
- Servo motor

## Pin Configuration
- **Ultrasonic Sensor:**
  - Trigger Pin: PB13
  - Echo Pin: PC14
- **Motors:**
  - Motor 1: PA0
  - Motor 2: PA4
  - Motor 3: PA2
  - Motor 4: PA3
- **LEDs:**
  - LED 1: PB0
  - LED 2: PB3
  - LED 3: PB4
  - LED 4: PB5
  - LED 5: PB7
  - LED 6: PB8
  - LED 7: PB9
  - LED 8: PB10
- **Buzzer:** PB2
- **Servo Motor:** PA5
- **Touch Sensor:** PA1

## Files
There are two main application files for this project:

### File 1: Initial Application
The initial application was designed to move the car forward only. It included basic functionality for controlling the motors to drive the car in a straight line.

### File 2: Updated Application
The updated application includes the following features:
- **Obstacle Detection:** Uses an ultrasonic sensor to detect obstacles and stop the car when an obstacle is detected within a certain distance.
- **Touch Sensor:** Responds to touch inputs to control the car's state.
- **LED Indicators:** Uses multiple LEDs to indicate the state of the car, such as obstacle detected or car moving.
- **Buzzer:** Sounds an alert when an obstacle is detected.
- **Servo Motor Control:** Adjusts the servo motor angle to simulate different actions or behaviors of the car.

## Software Overview

#### Initialization
The initialization function `HAL_Init()` is used to reset all peripherals, initialize the Flash interface, and the Systick. Various peripherals including GPIO, TIM, and UART are initialized.

#### Main Loop
The main loop continuously checks for sensor inputs and updates the car's state accordingly. If an obstacle is detected within 25 cm, the car will stop and the buzzer will sound. The car will also light up the corresponding LEDs and move the servo motor to predefined angles.

#### Ultrasonic Sensor Handling
The ultrasonic sensor is used to measure distance by sending a pulse and measuring the time it takes for the echo to return. The distance is calculated and compared to a threshold to determine if an obstacle is present.

#### Touch Sensor Handling
When the touch sensor is activated, the car will check the distance using the ultrasonic sensor and take actions to avoid obstacles if necessary.

#### LED and Buzzer Control
LEDs are used to indicate the state of the car. The buzzer is activated when an obstacle is detected within a certain range.

#### Motor Control
The motors are controlled to move the car forward, backward, or stop based on the sensor inputs.

#### Servo Motor Control
The servo motor angle is adjusted to simulate different actions or behaviors of the car.
