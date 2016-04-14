class NetworkPackage {
  private int data[];
  private int DATA_SIZE = 11;
  
  public NetworkPackage() {
    data = new int[DATA_SIZE];
  }
  
  public void setData(byte[] buffer) {
    if (buffer == null || buffer.length != sizeExpected()) {
      println("Incorrect size of input byte array");
      return;
    } else {
      ByteToInt(data, buffer, buffer.length);
    }
  }
  public void setValues(int[] values) {
     if (values == null || values.length != DATA_SIZE) {
      println("Incorrect size of input data array");
      return;
    } else {
      //Make deep copy
      for (int i = 0; i < values.length; ++i) {
        data[i] = values[i];
      }
    }
  }
  
  public int[] getValues() {
    int values[] = new int[DATA_SIZE];
    //Make deep copy
    for (int i = 0; i < values.length; ++i) {
      values[i] = data[i];
    }
    return values;
  }
  
  public int sizeExpected() {
    //Since in java int's are 4 byte's long
    return DATA_SIZE * 4;
  }
  
  private byte[] getData() {
    byte buffer[] = new byte[sizeExpected()];
    IntToByte(buffer, data, DATA_SIZE);
    return buffer;
  }
  
  public void print() {
    String s = "C: ";
    for (int i = 0; i < data.length; ++i) {
      s += data[i] + " ";
    }
    println(s);
  }
  
  private int IntToByte(byte arrayDst[], int arrayOrg[], int maxOrg) {
    int indexDst;
    //Since in Java int's are 4 bytes length
    int maxDst = maxOrg * 4;
        
    //Validate the inputs
    if (arrayDst == null) {
      return 0; 
    }
    if (arrayOrg == null) {
      return 0;    
    }
    if (arrayDst.length < maxDst) {
      return 0;
    }
    if (arrayOrg.length < maxOrg) {
      return 0;
    }
        
    //Make conversion
    indexDst = 0;
    for (int i = 0; i < maxOrg; i++) {
      // Copy an int, byte to byte.
      arrayDst[indexDst] = byte(arrayOrg[i]);
      indexDst++;
      arrayDst[indexDst] = byte(arrayOrg[i] >> 8);
      indexDst++;
      arrayDst[indexDst] = byte(arrayOrg[i] >> 16);
      indexDst++;
      arrayDst[indexDst] = byte(arrayOrg[i] >> 24);
      indexDst++;
    }
    //Return number of byte's copied
    return indexDst;
  }
  
  private int ByteToInt(int arrayDst[], byte arrayOrg[], int maxOrg) {
  
    int maxDst = maxOrg / 4;
        
    //Validate the input
    if (arrayDst == null) {
      return 0;
    }
    if (arrayOrg == null) {
      return 0;
    }
    if (arrayDst.length < maxDst) {
      return 0;
    }
    if (arrayOrg.length < maxOrg) {
      return 0;
    }

    // Make the conversion
    int indexOrg = 0;
    int byteValue;
    for (int i = 0; i < maxDst; i++) {
      arrayDst[i] = 0;
      //
      byteValue = 0x000000FF & arrayOrg[indexOrg];
      arrayDst[i] = arrayDst[i] | byteValue;
      indexOrg++;
      //
      byteValue = 0x000000FF & arrayOrg[indexOrg];
      arrayDst[i] = arrayDst[i] | (byteValue << 8);
      indexOrg++;
      //
      byteValue = 0x000000FF & arrayOrg[indexOrg];
      arrayDst[i] = arrayDst[i] | (byteValue << 16);
      indexOrg++;
      //
      byteValue = 0x000000FF & arrayOrg[indexOrg];
      arrayDst[i] = arrayDst[i] | (byteValue << 24);
      indexOrg++;
    }
        
    //Return the number of int's copied
    return maxDst;
  }
}
