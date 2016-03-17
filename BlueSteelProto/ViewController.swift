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

struct ipAddress {
	var ip: String
}

struct contentAttributionIDStruct {
	var contentAttributionID: String
}

extension ipAddress : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroUnionValue(1, Box<AvroValue>(self.ip.toAvro()))							// make sure value serialized
	}
}

extension contentAttributionIDStruct : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroUnionValue(1, Box<AvroValue>(self.contentAttributionID.toAvro()))			// make sure value serialized
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

struct uiEvent {
	var deviceTimestamp: Int64 = 0
	var serviceTimestamp: Int64 = 0
	var deviceId: String
	var accountId: String
	var profileId: String
	var sessionId: String
	var componentVersion: componentVersionStruct
	var deviceType: String
	var ip: ipAddress
	var timeZone: String
	var contentAttributionID: contentAttributionIDStruct
	var uiType: String
	var uiAction: String
	var sourcescreen: String
}

extension uiEvent : AvroValueConvertible {
	func toAvro() -> AvroValue {
		return AvroValue.AvroRecordValue([
			"deviceTimestamp"		: self.deviceTimestamp.toAvro(),
			"serviceTimestamp"		: self.serviceTimestamp.toAvro(),
			"deviceId"				: self.deviceId.toAvro(),
			"accountId"				: self.accountId.toAvro(),
			"profileId"				: self.profileId.toAvro(),
			"sessionId"				: self.sessionId.toAvro(),
			"componentVersion"		: self.componentVersion.toAvro(),		// proof, add union
			"deviceType"			: self.deviceType.toAvro(),
			"ip"					: self.ip.toAvro(),
			"timeZone"				: self.timeZone.toAvro(),
			"contentAttributionID"	: self.contentAttributionID.toAvro(),
			"uiType"				: self.uiType.toAvro(),
			"uiAction"				: self.uiAction.toAvro(),
			"sourcescreen"			: self.sourcescreen.toAvro()
			])
	}
}


class ViewController: UIViewController {
	
	func jsonToNSData(json: AnyObject) -> NSData?{
		do {
			return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
		} catch let myJSONError {
			print(myJSONError)
		}
		return nil;
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			
			// Get Schema Path from Bundle
			let schemaPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "avsc")! as String
			
			// Load JSON Schema from Bundle
			let jsonSchema = try String(contentsOfFile: schemaPath, encoding: NSUTF8StringEncoding)
			print(jsonSchema)
			
			// Create Avro Schema
			let schema = Schema(jsonSchema)
			print(schema)

			// Get UIEvent JSON Path from Bundle
			let jsonPath = NSBundle.mainBundle().pathForResource("UIEvent", ofType: "json")! as String
			
			// Load JSON from Bundle
			let json = try String(contentsOfFile: jsonPath, encoding: NSUTF8StringEncoding)
			print(json)
			
			// Deserialize JSON to AvroValue
//			let avro = AvroValue(stringLiteral: json)
//			let avro = AvroValue(jsonSchema: jsonSchema, withBytes: Array(json.utf8))
			let avro = AvroValue(jsonSchema: jsonSchema, withData: json.dataUsingEncoding(NSUTF8StringEncoding)!)
					
			print(avro)
			
			// Load Binary from Bundle
			
			// Create UIEvent Swift Struct
/*
			let rawBytes: [UInt8] = [0x6, 0x66, 0x6f, 0x6f]
			let avro = AvroValue(schema: schema, withBytes: rawBytes)
*/
			
/*			let uiEvt = uiEvent(
										deviceTimestamp: 25,
										serviceTimestamp: 77,
										deviceId: "MyDeviceID",
										accountId: "MYAccountID",
										profileId: "MYProfileID",
										sessionId: "MYSessionID",
										componentVersion:  componentVersionStruct(component: "MYComponent", build: "MyBuild"),
										deviceType: "MyDeviceType",
										ip: ipAddress(ip: "192.168.0.1"),
										timeZone: "PST",
										contentAttributionID: contentAttributionIDStruct(contentAttributionID: "MYcontentAttributionIDStruct"),
										uiType: "MyUIType",
										uiAction: "MyUIAction",
										sourcescreen: "MySourceScreen"
									)
			
			// Cast UIEvent to Avro Types
			print (uiEvt.toAvro())
			
			// Serialize UIEvent to Byte Array
			let serialized: [UInt8] = uiEvt.toAvro().encode(schema)!
			print("\nSerialized uiEvent: \(serialized) \n")

			// Deserialize Byte Array to AvroValue
			let deserialized = AvroValue(schema: schema, withBytes: serialized)
			print("\nDeserialized uiEvent: \(deserialized) \n")
			
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

