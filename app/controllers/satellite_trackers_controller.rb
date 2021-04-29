require 'uri'
require 'net/http'
require 'json'
require 'haversine'

class SatelliteTrackersController < ApplicationController
    def index
        originLatitude = params[:originLatitude]
        originLongitude = params[:originLongitude]
        number = params[:number]

        satellites = callSpaceXSatellites()
        
        satellitesWithLocation = filterByLocationNotNULL(satellites)
        
        satWithDistance = addDistanceFromCoordinates(satellitesWithLocation, originLatitude.to_i, originLongitude.to_i)

        render json: satWithDistance
    end

private
    def callSpaceXSatellites
        uri = URI('https://api.spacexdata.com/v4/starlink')
        res = Net::HTTP.get_response(uri)
        body = res.body if res.is_a?(Net::HTTPSuccess)
        return JSON.parse(body, object_class: OpenStruct) 
    end

    def filterByLocationNotNULL(satellites)
        return satellites.select {|satellite| satellite["longitude"] } 
    end

    def getDistanceInMeters(firstLat, firstLon, secondLat, secondLon)
        distance = Haversine.distance(firstLat, firstLon, secondLat, secondLon)
        return distance.to_meters
    end

    def addDistanceFromCoordinates(satellites, originLatitude, originLongitude)
        arrayWithDistance = []
        satellites.each do |satellite|
            satLatitude = satellite["latitude"]
            satLongitude = satellite["longitude"]
            satellite["distanceWithOrigin"] = getDistanceInMeters(satLatitude, satLongitude, originLatitude, originLongitude)
            arrayWithDistance.push(satellite)
        end
        return arrayWithDistance
    end
end
