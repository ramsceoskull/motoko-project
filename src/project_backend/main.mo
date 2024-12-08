// Nombre: Ramses Alejandro lopez Anceno
// Pais: Mexico
// Experiencia: Nuevo aprendiz en motoko, 6 años de experiencia en otros lenguajes (WEB, moviles)

actor Name {
	var name : Text = "";

	public query func getName() : async Text {
		return name;
	};

	public func setName(nombre : Text) {
		name := nombre;
	};
};
