require 'uri'
require 'net/http'

class SatelliteTrackersController < ApplicationController
    def index
        satellites = callSpaceXSatellites()
        render json: satellites
    end
    
    private
    def callSpaceXSatellites
        uri = URI('https://api.spacexdata.com/v4/starlink')
        res = Net::HTTP.get_response(uri)
        body = res.body if res.is_a?(Net::HTTPSuccess)
        return JSON.parse(body, object_class: OpenStruct) 
    end
end
