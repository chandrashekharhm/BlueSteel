//
//  ViewController.swift
//  BlueSteelProto
//
//  Created by Schultz, Thomas C on 3/1/16.
//  Copyright © 2016 Smoosh Studio, LLC. All rights reserved.
//

import UIKit
import BlueSteel

struct componentVersionStruct {
	var component: String
	var build: String
}

struct ipStruct {
	var ip: String
}

extension ipStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroUnionValue(1, Box<AvroValue>(self.ip.toAvro()))
	}
}

extension componentVersionStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroRecordValue([
			"component"		: self.component.toAvro(),
			"build"			: self.build.toAvro()
			])
	}
}

struct uiEventStruct {
	var deviceTimestamp: Int64 = 0
	var serviceTimestamp: Int64 = 0
	var deviceId: String
	var componentVersion: componentVersionStruct
	var ip: ipStruct
}

extension uiEventStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroRecordValue([
			"deviceTimestamp"	: self.deviceTimestamp.toAvro(),
			"serviceTimestamp"	: self.serviceTimestamp.toAvro(),
			"deviceId"			: self.deviceId.toAvro(),
			"componentVersion"	: self.componentVersion.toAvro(),
			"ip"				: self.ip.toAvro()
			])
	}
}


/*
{"name": "deviceVersion",
	"type": ["null", {"type": "array", "items": {
	"name": "componentVersion",
	"type": "record",
	"fields": [
	{"name": "component", "type": "string"},
	{"name": "build", "type": "string"},
	{"name": "otherDetail", "type": ["null", {"type": "map", "values": "string"}]}
	]
	}}]
*/

class ViewController: UIViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			
			// Get Schema Path from Bundle
			let schemaPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "avsc")! as String
			
			// Load JSON Schema from Bundle
			let jsonSchema = try String(contentsOfFile: schemaPath, usedEncoding: nil)
			print(jsonSchema)
			
			// Create Avro Schema
			let schema = Schema(jsonSchema)

			// Create UIEvent Swift Struct
			let uiEvt = uiEventStruct(deviceTimestamp: 25, serviceTimestamp: 77, deviceId: "mydeviceid", componentVersion: componentVersionStruct(component: "mycomponent", build: "mybuild"), ip: ipStruct(ip: "192.168.0.1"))
			
			// Cast UIEvent to Avro Types
			print (uiEvt.toAvro())
			
			// Serialize UIEvent to Byte Array
			var serialized: [UInt8] = uiEvt.toAvro().encode(schema)!
			
			print("serialized uiEvent: \(serialized)")

			let deserialized = AvroValue(schema: schema, withBytes: serialized)
			print("deserialized uiEvent: \(deserialized)")
			
			
		} catch let error as NSError {
			print("Error loading JSON Schema: \(error)")
		}
		
		/*
		let rawBytes: [UInt8] = [0x6, 0x66, 0x6f, 0x6f]
		let avro = AvroValue(schema: schema, withBytes: rawBytes)
	

		if let avroString = avro.string {
			print(avroString) // Prints "foo"
		}
		
		if let serialized = avro.encode(schema) {
			print(serialized) // Prints [6, 102, 111, 111]
		}
*/
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

