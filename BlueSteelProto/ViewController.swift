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

struct componentVersionStruct {
	var component: String
	var build: String
}

struct serviceTimestampStruct {
	var val: Int64
}


/*
extension serviceTimestampStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroUnionValue(1, Box<AvroValue>(self.val.toAvro()))							// make sure value serialized
	}
}
*/

struct uiEvent {
	var deviceTimestamp: Int64
	var serviceTimestamp: Int64
	var test: Int64
}

extension uiEvent : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroRecordValue([
			"deviceTimestamp"		: self.deviceTimestamp.toAvro(),
			"serviceTimestamp"		: self.serviceTimestamp.toAvro(),
			"test"					: self.serviceTimestamp.toAvro()
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
				deviceTimestamp: 44, serviceTimestamp: 55, test: 66
			)
			
			// Cast UIEvent to Avro Types
			print (uiEvt.toAvro())
			
			// Serialize UIEvent to Byte Array
			var serialized: [UInt8] = uiEvt.toAvro().encode(schema)!
			print("\nSerialized uiEvent: \(serialized) \n")

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

