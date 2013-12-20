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
 * Configuration file of the module SensorP.nc
 *
 * @date 05/10/2010 11:07
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */

#include "../TmoteComm.h"

configuration SensorC
{}
implementation
{
	components MainC, LedsC;
	components SensorP as App;

	components new DemoSensorC() as VoltSensor;
	components new SensirionSht11C() as TempHumiSensor;
	components new HamamatsuS1087ParC() as PARSensor;
	components new HamamatsuS10871TsrC() as TSRSensor;

	components SerialActiveMessageC as SAM;

	components CC2420ControlC;
	components CC2420ActiveMessageC as CC2420AM;

	components ActiveMessageC as AM;

	components new QueueC(radio_msg_t ,QUEUE_SIZE) as QueueP2P;

	App.Boot -> MainC.Boot;
	App.Leds -> LedsC.Leds;

	App.Voltage -> VoltSensor;
	App.Temperature -> TempHumiSensor.Temperature;
	App.Humidity -> TempHumiSensor.Humidity;
	App.PAR -> PARSensor;
	App.TSR -> TSRSensor;

	App.AMCtrlSerial -> SAM;
	App.AMSendSerialV -> SAM.AMSend[AM_VOLTAGE_MSG];
	App.AMSendSerialT -> SAM.AMSend[AM_TEMPERATURE_MSG];
	App.AMSendSerialH -> SAM.AMSend[AM_HUMIDITY_MSG];
	App.AMSendSerialPAR -> SAM.AMSend[AM_PAR_MSG];
	App.AMSendSerialTSR -> SAM.AMSend[AM_TSR_MSG];
	App.AMSendSerialI -> SAM.AMSend[AM_SERIAL_NUMBER_MSG];

	App.ReceiveSerialREQ -> SAM.Receive[AM_REQUEST_MSG];
}
