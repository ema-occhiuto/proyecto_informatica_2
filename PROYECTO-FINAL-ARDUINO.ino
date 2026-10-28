class Sensor {//Class padre de sensor
  protected:
    float valor;
    String magnitud;

  public:
    Sensor(String magnitud) {//inicializamos 
      this->magnitud = magnitud;
      valor = 0;
    }

    float leerMedicion() {
      return valor;
     
    }
  String obtenerMagnitud(){
    return magnitud;
    }
};


class SensorUltrasonico:public Sensor{//Sensor ultrasonico
  private:
  int pinTrig;//OUTPUT,emite las ondas de sonido
  int pinEcho;//INPUT,este recibe las ondas de sonido
  
  
  public:
  SensorUltrasonico(int trig,int echo):Sensor("centimetros"){//constructor del ultrasonico, que ademas utiliza el constructor de senor
    pinTrig=trig;
    pinEcho=echo;
}
  void iniciar(){
    pinMode(pinTrig,OUTPUT);
    pinMode(pinEcho,INPUT);
  }
    void generarMedicion(){
      
    digitalWrite(pinTrig,LOW);
    delayMicroseconds(2);//Una millonesima de segundo
      
    digitalWrite(pinTrig,HIGH);
    delayMicroseconds(10);
    digitalWrite(pinTrig,LOW);
      
    long duracion=pulseIn(pinEcho,HIGH,30000UL);//Mide cto tiempo permanece una senal en estado high
     
      if(duracion==0){
        valor=-1;
      }
      else{
        valor=duracion*0.0343/2.0;//calculamos la distancia de duracion
      }
    }
};




class Led{//class para el manejo del led

private:
int pin;

public:

Led(int pin){
  this->pin=pin;//constructor del led
}

void iniciar(){
  pinMode(pin,OUTPUT);
}

void encender(){
  digitalWrite(pin,HIGH);//encendido del led
}

void apagar(){
  digitalWrite(pin,LOW);//apagado del led
}
};











void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}
