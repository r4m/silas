/*
 * Copyright (c) 2010, Department of Information Engineering, University of Padova.
 * All rights reserved.
 *
 * This file is part of Silas.
 *
 * Silas is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * Silas is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Silas.  If not, see <http://www.gnu.org/licenses/>.
 *
 * ===================================================================================
 */  
	
/**
 * 
 * Header file.
 *
 * @date 01/11/2010 22:54
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */ 

#ifndef TMOTE_COMM_H
#define TMOTE_COMM_H

enum
{
  RSSI_OFFSET = -35,      // !!!Empiric!!! [dBm]
  QUEUE_SIZE = 100,       // Dimension of the FIFO stack

  TIMER_SEND = 50,    // Clock for the [ms]
  MAX_PKG = 5,        // Maximum number of packet to send
  CHANNEL_RADIO = 6,  // Radio channel
  POWER_RADIO = 31,   // Power of the radio CC2420 [dBm] 
 
  AM_VOLTAGE_MSG = 0x19,      
  AM_TEMPERATURE_MSG = 0x21,      
  AM_HUMIDITY_MSG = 0x23,
  AM_TSR_MSG = 0x29,      
  AM_PAR_MSG = 0x25,      
  AM_SERIAL_NUMBER_MSG = 0x27,      

  AM_REQUEST_MSG = 0xAE, 
};

enum
{
  VOLTAGE_REQ = AM_VOLTAGE_MSG,      
  TEMPERATURE_REQ = AM_TEMPERATURE_MSG,      
  HUMIDITY_REQ = AM_HUMIDITY_MSG,      
  TSR_REQ = AM_TSR_MSG,
  PAR_REQ = AM_PAR_MSG,      
  SERIAL_NUMBER_REQ = AM_SERIAL_NUMBER_MSG,      
  RADIO_REQ = 0x66,     
} request;

typedef nx_struct voltage_msg 
{
  nx_uint16_t voltage;       // [V] Voltage
} voltage_msg_t;

typedef nx_struct temperature_msg 
{
  nx_uint16_t temperature;   // [C] Temperature
} temperature_msg_t;

typedef nx_struct humidity_msg 
{
  nx_uint16_t humidity;      // [%RH] Umidity 
} humidity_msg_t;

typedef nx_struct par_msg 
{
  nx_uint16_t par;         // [Lux] PAR
} par_msg_t;

typedef nx_struct tsr_msg 
{
  nx_uint16_t tsr;         // [Lux] TAR
} tsr_msg_t;

typedef nx_struct serial_number_msg 
{
  nx_uint16_t id;         // ID of the sensor
} id_msg_t;

typedef nx_struct request_msg 
{
  nx_uint8_t request;         // ID of the sensor
} request_msg_t;

typedef nx_struct p2p_msg
{
  nx_uint16_t id;   // ID of the sensor
  nx_uint16_t counter;  // ID of the sent packet [n-th]
} p2p_msg_t;

typedef nx_struct radio_msg 
{
  nx_int16_t  rssi;           // RSSI [dBm] received signal strength indicator
  nx_int16_t  rss;            // RSS [dBm] received signal strength
  nx_int16_t  lqi;            // LQI [dBm] link quality indicator
  nx_uint8_t  channel;        // Transmission frequency 
  nx_uint8_t  power;          // Transmission power [dBm] 
} radio_msg_t;

#endif
