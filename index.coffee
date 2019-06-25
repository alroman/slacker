tj = require('@mapbox/togeojson')
fs = require('fs')
https = require('https')
geolib = require('geolib')

DOMParser = require('xmldom').DOMParser

file = fs.createWriteStream("restaurants.kml")

url = "https://www.google.com/maps/d/kml?mid=1NdKpUI5QAXWc27o92B9i-TZoaGw&forcekml=1"

request = https.get url, (response) ->
    response.pipe(file)

    file.on('finish', () ->
        file.close() #;  // close() is async, call cb after close completes.
        
        # Get current location
        # https.get 'https://ipinfo.io', (res) ->
        #     res.setEncoding('utf8')
        #     res.on 'data', (chunk) ->
                # location = JSON.parse chunk
                # console.log location


        kml = new DOMParser().parseFromString fs.readFileSync('restaurants.kml', 'utf8')
        converted = tj.kml(kml)
        # console.log JSON.stringify converted.features, null, 2
        list = converted.features
        rand_location = list[Math.floor(Math.random() * list.length)]

        # Print name
        console.log rand_location.properties.name

        # Print location URL
        [a, b] = rand_location.geometry.coordinates
        console.log "https://www.google.com/maps/search/?api=1&query=#{b},#{a}"
        # console.log rand_location

        # [longitude, latitude ] = location.loc.split ','
        distance = geolib.getDistance(
            { latitude: 34.1544339, longitude: -118.0825655 },
            { latitude: b, longitude: a }
        )

        console.log "Approximately " distance * 0.000621371 + " miles away from office..."

    )

