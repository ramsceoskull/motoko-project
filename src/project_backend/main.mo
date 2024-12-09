import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor {
	var articles = HashMap.HashMap<Text, Values>(0, Text.equal, Text.hash);

	type DataRequired = {
		title : Text;
		url : Text;
	};

	type Values = {
		date : Int;
		html : Text;
	};

	type TransformContext = {
		function : shared query TransformArgs -> async HttpResponse;
		context : Blob;
	};

	type HttpArgs = {
		url : Text;
		max_response_bytes : ?Nat64;
		headers : [{name : Text; value : Text}];
		body : ?[Nat8];
		method : {#get};
		transform : ?TransformContext;
	};

	type HttpResponse = {
		status : Nat;
		headers : [{name : Text; value : Text}];
		body : [Nat8];
	};

	type TransformArgs = {
		response : HttpResponse;
		context : Blob;
	};

	type IC = actor {
		http_request : HttpArgs -> async HttpResponse;
	};

	public func addArticle(props : DataRequired) : async Text {
		let response : HttpResponse = await proxy(props.url);
		let html : Text = await decode(response.body);
		let date = Time.now();

		articles.put(props.title, {date; html});
		"Tu articulo fue agregado para ver mas tarde.";
	};

	public func generateArticle() : async Text {
		let response : HttpResponse = await proxy("https://en.wikipedia.org/wiki/Special:Random");
		let url : Text = await getURL(response.headers);
		url;
	};

	public func findArticle(account : Text) : async Text {
		if(articles.get(account) != null) {
			"El articulo ya se encuentra en tu lista de ver mas tarde.";
		} else {
			"No nos fue posible encontrar el articulo solicitado.";
		};
	};

	public func getAllArticles() : async [Text] {
		Debug.print("Actualmente tenemos " # Nat.toText(articles.size()) # " articulo(s) en el sistema.");
		return Iter.toArray<Text>(articles.keys());
	};

	private func proxy(url : Text) : async HttpResponse {
		let transform_context : TransformContext = {
			function = transform;
			context = Blob.fromArray([]);
		};

		let request : HttpArgs = {
			url = url;
			max_response_bytes = null;
			headers = [];
			body = null;
			method = #get;
			transform = ?transform_context;
		};

		Cycles.add<system>(220_000_000_000);
		let ic : IC = actor ("aaaaa-aa");
		let response : HttpResponse = await ic.http_request(request);
		response;
	};

	public query func transform(raw : TransformArgs) : async HttpResponse {
		let transformed : HttpResponse = {
			status = raw.response.status;
			body = raw.response.body;
			headers = raw.response.headers;
		};
		transformed;
	};

	private func decode(body : [Nat8]) : async Text {
		let text_decoded : ?Text = Text.decodeUtf8(Blob.fromArray(body));

		let html : Text = switch (text_decoded) {
			case (null) {
				"";
			};
			case (?Text) {
				Text;
			};
		};
		html;
	};

	private func getURL(headers: [{name : Text; value : Text}]) : async Text {
		for (header in headers.vals()) {
			if (header.name == "location") {
				return header.value;
			}
		};
		"";
	};
};
