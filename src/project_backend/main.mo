// Nombre: Ramses Alejandro lopez Anceno
// Pais: Mexico
// Experiencia: Nuevo aprendiz en motoko, 6 años de experiencia en otros lenguajes (WEB, moviles)
import Debug "mo:base/Debug";

actor Name {
	/* stable var name : Text = "";
	stable var age : Nat8 = 0;
	stable var counter : Int = 0; */
	stable var data : (Text, Nat8) = ("", 0);

	/* public query func getFalse() : async Bool {
		let falso : Bool = false;
		let _character : Char = 'a';
		falso;
	}; */

	public func dataUser(nombre : Text, edad : Nat8) : async (Text, Nat8) {
		let user : (Text, Nat8) = (nombre, edad);
		data := user;
		data
	};

	public func areYouOld(edad : Nat8) : async Bool {
		if(edad > 18) {
			Debug.print("Eres mayor de edad");
			true
		} else {
			Debug.print("Eres menor de edad");
			false
		};
	};

	public func getItem(index : Nat) : async Text {
		let arreglo : [Text] = ["Hola", "Adios", "que tal"];

		let greeting : Text = arreglo[0] # " " # arreglo[2];
		Debug.print(greeting);
		return arreglo[index];
	}

	/* public func increaseCounter() {
		// counter := counter + 1;
		counter += 1;
	};

	public func decreaseCounter() : async Int {
		counter -= 1;
		return counter;
	};

	public query func getCounter() : async Int {
		// return counter;
		counter
	};

	public query func getName() : async Text {
		return name;
	};

	public func setName(nombre : Text) {
		name := nombre;
	}; */
};
