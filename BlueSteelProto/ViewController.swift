//
//  ViewController.swift
//  BlueSteelProto
//
//  Created by Schultz, Thomas C on 3/1/16.
//  Copyright © 2016 Smoosh Studio, LLC. All rights reserved.
//

import UIKit
import BlueSteel
import BlueSteel.Swift
import SwiftyJSON


/*

struct componentVersionStruct {
var component: String
var build: String
}
*/

struct serviceTimestampStruct {
var val: Int64
}


extension serviceTimestampStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroUnionValue(1, Box<AvroValue>(self.val.toAvro()))							// make sure value serialized
	}
}

struct uiEvent {
	var deviceTimestamp: Int64
	var serviceTimestamp: serviceTimestampStruct
	var deviceId: String
	var accountId: String
	var profileId: String
	var sessionId: String
}


extension uiEvent : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroRecordValue([
			"deviceTimestamp"		: self.deviceTimestamp.toAvro(),
			"serviceTimestamp"		: self.serviceTimestamp.toAvro(),
			"deviceId"				: self.deviceId.toAvro(),
			"accountId"				: self.accountId.toAvro(),
			"profileId"				: self.profileId.toAvro(),
			"sessionId"				: self.sessionId.toAvro()
			])
	}
}

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			
			// Get Schema Path from Bundle
			let schemaPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "avsc")! as String
			
			// Load JSON Schema from Bundle
			let jsonSchema = try String(contentsOfFile: schemaPath, encoding: NSUTF8StringEncoding)
			
			// Create Avro Schema
			let schema = Schema(jsonSchema)
			print(schema)
			
			let uiEvt = uiEvent(
				deviceTimestamp: 1458171126930,
				serviceTimestamp: serviceTimestampStruct(val: 55),
				deviceId: "iOS-Phone-v-AEB53CFE-5DB5-4D8E-A2D8-D6048E1ADD58",
				accountId: "-1",
				profileId: "anon",
				sessionId: "iOS-Phone-v-AEB53CFE-5DB5-4D8E-A2D8-D6048E1ADD58-1458171081"
			)
			
			// Cast UIEvent to Avro Types
			print (uiEvt.toAvro())
			
			// Serialize UIEvent to Byte Array
			var serialized: [UInt8] = uiEvt.toAvro().encode(schema)!
			print("\nSerialized uiEvent: \(serialized) \n")
			
			// Get Documents Path for Simulator
			let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
			print(documentsPath)
			
			// Export Byte Array to a bin file for testing later
			var export = NSData(bytes: serialized, length: serialized.count)
			export.writeToFile(documentsPath + "/testme.bin", atomically: true)

			
			// Get UIEvent JSON Path from Bundle
//			let jsonPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "json")! as String
			
			// Load JSON from Bundle
//			let json = try String(contentsOfFile: jsonPath, encoding: NSUTF8StringEncoding)
//			print(json)
			
			// Deserialize JSON to AvroValue
//			let avro = AvroValue(stringLiteral: json)
//			let avro = AvroValue(jsonSchema: jsonSchema, withBytes: Array(json.utf8))
//			let avro = AvroValue(jsonSchema: jsonSchema, withData: json.dataUsingEncoding(NSUTF8StringEncoding)!)
			
			// Load Binary from Bundle
			// Create UIEvent Swift Struct
/*
			let rawBytes: [UInt8] = [0x6, 0x66, 0x6f, 0x6f]
			let avro = AvroValue(schema: schema, withBytes: rawBytes)
			
			let binPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "bin")! as String
			let data = NSData(contentsOfFile: binPath)
			
			let foo = AvroValue(schema: schema, withData: data!)
			print(foo)

			*/

			
		}
		catch let myError {
			print("caught: \(myError)")
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

