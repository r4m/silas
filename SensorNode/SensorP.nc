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
 * This is the application of the sensor measurements acquisition
 *
 * @date 05/10/2010 11:07
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 */

module SensorP
{
	uses
	{
		interface Leds;
		interface Boot;

		interface SplitControl as AMCtrlSerial;
		interface AMSend as AMSendSerialV;
		interface AMSend as AMSendSerialT;
		interface AMSend as AMSendSerialH;
		interface AMSend as AMSendSerialPAR;
		interface AMSend as AMSendSerialTSR;
		interface AMSend as AMSendSerialI;
		interface Receive as ReceiveSerialREQ;

		interface Read<uint16_t> as Voltage;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as PAR;
		interface Read<uint16_t> as TSR;
	}
}


implementation
{
	message_t packet;
	bool lockedSerial;

	voltage_msg_t vm;
	temperature_msg_t tm;
	humidity_msg_t hm;
	par_msg_t am;
	tsr_msg_t sm;

	task void sendSerialV();
	task void sendSerialT();
	task void sendSerialH();
	task void sendSerialPAR();
	task void sendSerialTSR();
	task void sendSerialI();

	/******************************* Init *****************************/

	event void Boot.booted()
	{
		call Leds.set(000);

		call AMCtrlSerial.start();
		
		lockedSerial = FALSE;
	}

	event void AMCtrlSerial.startDone(error_t err)
	{
		if (err == SUCCESS)
			{ }
			else { call AMCtrlSerial.start(); }
	}

	event void AMCtrlSerial.stopDone(error_t err){}

	/******************************* Sensors *****************************/

	event void Voltage.readDone(error_t result, uint16_t data)
	{
		if (result == SUCCESS) vm.voltage = data;
		else vm.voltage = 0xFFFF;
		post sendSerialV();
	}

	event void Temperature.readDone(error_t result, uint16_t data)
	{
		if (result == SUCCESS) tm.temperature = data;
		else tm.temperature = 0xFFFF;
		post sendSerialT();
	}

	event void Humidity.readDone(error_t result, uint16_t data)
	{
		if (result == SUCCESS) hm.humidity = data;
		else hm.humidity = 0xFFFF;
		post sendSerialH();
	}

	event void PAR.readDone(error_t result, uint16_t data)
	{
		if (result == SUCCESS) am.par = data;
		else am.par = 0xFFFF;
		post sendSerialPAR();
	}

	event void TSR.readDone(error_t result, uint16_t data)
	{
		if (result == SUCCESS) sm.tsr = data;
		else sm.tsr = 0xFFFF;
		post sendSerialTSR();
	}

	/******************************* Serial *****************************/

	task void sendSerialV()
	{
		if(lockedSerial){}
		else
		{
			voltage_msg_t toSend = vm;
			voltage_msg_t* rvm = (voltage_msg_t*)call AMSendSerialV.getPayload(&packet, sizeof(voltage_msg_t));
			if (rvm == NULL) {return;}

			atomic {rvm->voltage = toSend.voltage;}

			if (call AMSendSerialV.send(AM_BROADCAST_ADDR, &packet, sizeof(voltage_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialV.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	task void sendSerialT()
	{
		if(lockedSerial){}
		else
		{
			temperature_msg_t toSend = tm;
			temperature_msg_t* rtm = (temperature_msg_t*)call AMSendSerialT.getPayload(&packet, sizeof(temperature_msg_t));
			if (rtm == NULL) {return;}

			atomic {rtm->temperature = toSend.temperature;}

			if (call AMSendSerialT.send(AM_BROADCAST_ADDR, &packet, sizeof(temperature_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialT.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	task void sendSerialH()
	{
		if(lockedSerial){}
		else
		{
			humidity_msg_t toSend = hm;
			humidity_msg_t* rhm = (humidity_msg_t*)call AMSendSerialH.getPayload(&packet, sizeof(humidity_msg_t));
			if (rhm == NULL) {return;}

			atomic {rhm->humidity = toSend.humidity;}

			if (call AMSendSerialH.send(AM_BROADCAST_ADDR, &packet, sizeof(humidity_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialH.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	task void sendSerialPAR()
	{
		if(lockedSerial){}
		else
		{
			par_msg_t toSend = am;
			par_msg_t* ram = (par_msg_t*)call AMSendSerialPAR.getPayload(&packet, sizeof(par_msg_t));
			if (ram == NULL) {return;}

			atomic {ram->par = toSend.par;}

			if (call AMSendSerialPAR.send(AM_BROADCAST_ADDR, &packet, sizeof(par_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialPAR.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	task void sendSerialTSR()
	{
		if(lockedSerial){}
		else
		{
			tsr_msg_t toSend = sm;
			tsr_msg_t* rsm = (tsr_msg_t*)call AMSendSerialTSR.getPayload(&packet, sizeof(tsr_msg_t));
			if (rsm == NULL) {return;}

			atomic {rsm->tsr = toSend.tsr;}

			if (call AMSendSerialTSR.send(AM_BROADCAST_ADDR, &packet, sizeof(tsr_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialTSR.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	task void sendSerialI()
	{
		if(lockedSerial){}
		else
		{
			id_msg_t* rsnm = (id_msg_t*)call AMSendSerialI.getPayload(&packet, sizeof(id_msg_t));
			if (rsnm == NULL) {return;}

			atomic {rsnm->id = TOS_NODE_ID;}

			if (call AMSendSerialI.send(AM_BROADCAST_ADDR, &packet, sizeof(id_msg_t)) == SUCCESS)
			{
				lockedSerial = TRUE;
			}
		}
	}

	event void AMSendSerialI.sendDone(message_t* msg, error_t error)
	{
		if (&packet == msg)
		{
			lockedSerial = FALSE;
			call Leds.led0Toggle();
		}
	}

	event message_t* ReceiveSerialREQ.receive(message_t* bufPtr,
		void* payload, uint8_t len)
	{
		if (len != sizeof(request_msg_t)) {return bufPtr;					call Leds.set(101);}
		else
		{
			request_msg_t* rcm = (request_msg_t*)payload;
			call Leds.set(111);
			switch(rcm->request)
			{			
				case VOLTAGE_REQ:
					call Leds.led1Toggle();
					call Voltage.read();
				break;
				case TEMPERATURE_REQ:
					call Temperature.read();
					call Leds.led1Toggle();
				break;
				case HUMIDITY_REQ:
					call Leds.led1Toggle();
					call Humidity.read();
				break;	
				case PAR_REQ:
					call PAR.read();
					call Leds.led1Toggle();
				break;
				case TSR_REQ:
					call TSR.read();
					call Leds.led1Toggle();
				break;
				case SERIAL_NUMBER_REQ:
					post sendSerialI();
					call Leds.led1Toggle();
				break;
			}
			return bufPtr;
		}
	}
}
