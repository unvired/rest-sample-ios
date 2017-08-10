//	Generated using Unvired Modeller - Build R-4.000.0100

import UIKit

// This class is part of the BE "WEATHER".
@objc(WEATHER_HEADER)
class WEATHER_HEADER: DataStructure {

	// Table Name
	static let TABLE_NAME = "WEATHER_HEADER"
	
		// City
	static let CITY = "CITY"

	// Weather
	static let WEATHER_DESC = "WEATHER_DESC"

	// Temperature
	static let TEMPERATURE = "TEMPERATURE"

	// Humidity
	static let HUMIDITY = "HUMIDITY"


	
	// The Initializer
	override init() {
		super.init(WEATHER_HEADER.TABLE_NAME, isHeader: true)
	}

		var CITY: String? {
		get {
			return getField(WEATHER_HEADER.CITY) as? String
		}
		set (value) {
			setField(WEATHER_HEADER.CITY, value: value)
		}
	}

	var WEATHER_DESC: String? {
		get {
			return getField(WEATHER_HEADER.WEATHER_DESC) as? String
		}
		set (value) {
			setField(WEATHER_HEADER.WEATHER_DESC, value: value)
		}
	}

	var TEMPERATURE: String? {
		get {
			return getField(WEATHER_HEADER.TEMPERATURE) as? String
		}
		set (value) {
			setField(WEATHER_HEADER.TEMPERATURE, value: value)
		}
	}

	var HUMIDITY: String? {
		get {
			return getField(WEATHER_HEADER.HUMIDITY) as? String
		}
		set (value) {
			setField(WEATHER_HEADER.HUMIDITY, value: value)
		}
	}


}