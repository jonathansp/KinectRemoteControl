//Infrared code from DTV device ONIX4000.

public class IRData
{ 
  private Hashtable<String, Hashtable> _devices = new  Hashtable<String, Hashtable>();
  public Hashtable getDeviceCodes(String name)
  {
    return _devices.get(name);
  }

  private void setupDevices()
  {
    Hashtable<String, String> _control = new  Hashtable<String, String>();      
    _control.put("0", "0000 006C 0022 0002 0157 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0618 0157 0056 0016 0E70");
    _control.put("1", "0000 006C 0022 0002 0157 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0015 0016 061B 0157 0056 0016 0E72");
    _control.put("2", "0000 006C 0022 0002 0156 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0015 0016 0617 0156 0056 0016 0E6D");
    _control.put("3", "0000 006D 0022 0002 0155 00AB 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 0615 0155 0056 0016 0E64");     
    _control.put("4", "0000 006C 0022 0002 0156 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 061B 0156 0056 0016 0E71");
    _control.put("5", "0000 006C 0022 0002 0156 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 0616 0156 0056 0016 0E6B");
    _control.put("6", "0000 006C 0022 0002 0157 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 061B 0157 0056 0016 0E72");
    _control.put("7", "0000 006D 0022 0002 0156 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0015 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 0618 0156 0056 0016 0E6B");
    _control.put("8", "0000 006C 0022 0002 0157 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 0617 0157 0056 0016 0E6E");
    _control.put("9", "0000 006C 0022 0002 0157 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0015 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 061C 0157 0056 0016 0E73");     
    _control.put("+Vol", "0000 006D 0022 0002 0155 00AB 0016 003F 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 003F 0016 0015 0016 003F 0016 003F 0016 003F 0016 003F 0016 003F 0016 003F 0016 003F 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 003F 0016 003F 0016 0015 0016 003F 0016 003F 0016 003F 0016 003F 0016 003F 0016 0015 0016 0015 0016 060E 0155 0055 0016 0E58");
    _control.put("-Vol", "0000 006D 0022 0002 0156 00AC 0016 0040 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0015 0016 0040 0016 0040 0016 0015 0016 0015 0016 0040 0016 0040 0016 0015 0016 0615 0156 0056 0016 0E69");     
    _devices.put("Onix4000", _control);
  }

  public IRData()
  {
    this.setupDevices();
  }
}
