/* 
 * USB-UIRTJ is a Java wrapper for the USB-UIRT native dll provided by Jon Rhees.
 * The project also includes a User Interface to transmit and capture signals from the UIRT device.
 * http://sourceforge.net/projects/uirt-j/
 */

import util.*; //java wrapper for USBUIRT

public class IRDevice
{
  private Hashtable irCodes;
  private int IRInactivityWaitTime = 6;
  private int repeatCount = 1;
  private IRData irData = new IRData();

  public IRDevice(String name)
  {   
    this.irCodes = irData.getDeviceCodes(name);
    if (this.irCodes == null)
      println("Device not found: " + name);

    this.setupUSBUIRT();
  }

  private void testDeviceAndData()
  {
    try
    {
      USBUIRT.open();
      USBUIRT.UIRTInfo info = USBUIRT.getUIRTInfo();
      println("Testing device: " + info.toString());
      USBUIRT.close();     

      print("Testing codes: ");
      for (int i = 0; i < 10; i++)
      {
        if (this.irCodes.get(Integer.toString(i)) == null)
        {  
          println("Error - Missing required " + Integer.toString(i) + " IRCode");
          exit();
        }
      }

      if (this.irCodes.get("+Vol") == null || this.irCodes.get("-Vol") == null)
      {  
        println("Error - Missing required IRCode (Vol)");
        exit();
      }
      println("OK. Sending test IRCode (-Vol)...");
      this.transmit("-Vol");
    }
    catch (Exception e)
    {
      println(e);
      exit();
    }
  }

  public void transmit(String data)
  {
    Object code = this.irCodes.get(data);
    if (code == null)
    {
      print("IRDevice transmit error: Invalid code for " + data);
    }
    else
    {
      try
      {
        int r = repeatCount;
        if (code.toString() == "+Vol" || code.toString() == "-Vol")
          r = 3;

        USBUIRT.open();
        USBUIRT.transmitIR(code.toString(), USBUIRT.PRONTO, r, IRInactivityWaitTime);        
        USBUIRT.close();
      }
      catch (Exception e)
      {
        println(e);
        exit();
      }
    }
  }

  private void setupUSBUIRT()
  {
    try
    {
      USBUIRT.open();
      USBUIRT.UIRTConfig config = USBUIRT.getUIRTConfig();        
      config.setLedRX(true);
      config.setLedTX(true);
      config.setLegacyRX(true);
      USBUIRT.setUIRTConfig(config);
      USBUIRT.close(); 
      this.testDeviceAndData();
    }
    catch (Exception e)
    {
      println(e);
    }
  }
}

