tj = require('@mapbox/togeojson')
fs = require('fs')
http = require('https')

DOMParser = require('xmldom').DOMParser

file = fs.createWriteStream("restaurants.kml")

url = "https://www.google.com/maps/d/kml?mid=1NdKpUI5QAXWc27o92B9i-TZoaGw&forcekml=1"

request = http.get url, (response) ->
    response.pipe(file)
    file.on('finish', () ->
        file.close() #;  // close() is async, call cb after close completes.
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
    )

